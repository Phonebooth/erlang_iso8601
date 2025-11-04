-module(iso8601_tests).
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

-define(MN, {0,0,0}). % midnight, as a calendar:time()

parse_fail_test_() ->
    F = fun iso8601:parse/1,
    [{"fails to parse YYYYMM",
      ?_assertError(badarg, F("201212"))}].

parse_year_test_() ->
    F = fun iso8601:parse/1,
    [{"parses YYYY",
      ?_assertMatch({{2012,1,1}, ?MN}, F("2012"))}].

parse_month_test_() ->
    F = fun iso8601:parse/1,
    [{"parses YYYY-MM",
      ?_assertMatch({{2012,12,1}, ?MN}, F("2012-12"))}].

parse_month_day_test_() ->
    F = fun iso8601:parse/1,
    [{"parses YYYYMMDD",
      ?_assertMatch({{2012,12,12}, ?MN}, F("2012-12-12"))},
     {"parses YYYY-MM-DD",
      ?_assertMatch({{2012,12,12}, ?MN}, F("20121212"))}].

parse_week_test_() ->
    F = fun iso8601:parse/1,
    [{"parses 2009W01 as 2008-12-29",
      ?_assertMatch({{2008,12,29}, ?MN}, F("2009W01"))},
     {"parses 2009-W01 as 2008-12-29",
      ?_assertMatch({{2008,12,29}, ?MN}, F("2009-W01"))},
     {"parses 2009W53 as 2010-01-03",
      ?_assertMatch({{2009,12,28}, ?MN}, F("2009W53"))},
     {"parses 2009-W53 as 2010-01-03",
      ?_assertMatch({{2009,12,28}, ?MN}, F("2009-W53"))}].

parse_week_day_test_() ->
    F = fun iso8601:parse/1,
    [{"parses 2009W011 as 2008-12-29",
      ?_assertMatch({{2008,12,29}, ?MN}, F("2009W011"))},
     {"parses 2009-W01-1 as 2008-12-29",
      ?_assertMatch({{2008,12,29}, ?MN}, F("2009-W01-1"))},
     {"parses 2009W537 as 2010-01-03",
      ?_assertMatch({{2010,1,3}, ?MN}, F("2009W537"))},
     {"parses 2009-W53-7 as 2010-01-03",
      ?_assertMatch({{2010,1,3}, ?MN}, F("2009-W53-7"))}].

parse_hour_test_() ->
    F = fun iso8601:parse/1,
    [{"parses YYYYMMDDTHH",
      ?_assertMatch({{2012,2,3},{4,0,0}}, F("20120203T04"))},
     {"parses YYYY-MM-DDTHH",
      ?_assertMatch({{2012,2,3},{4,0,0}}, F("2012-02-03T04"))}].    

parse_fractional_hour_test_() ->
    F = fun iso8601:parse/1,
    [{"parses YYYYMMDDTHH.hh",
      ?_assertMatch({{2012,2,3},{4,15,0}}, F("20120203T04.25"))},
     {"parses YYYY-MM-DDTHH.hh",
      ?_assertMatch({{2012,2,3},{4,15,0}}, F("2012-02-03T04.25"))},
     {"parses YYYYMMDDTHH,hh",
      ?_assertMatch({{2012,2,3},{4,15,0}}, F("20120203T04,25"))},
     {"parses YYYY-MM-DDTHH,hh",
      ?_assertMatch({{2012,2,3},{4,15,0}}, F("2012-02-03T04,25"))}].

parse_minute_test_() ->
    F = fun iso8601:parse/1,
    [{"parses YYYYMMDDTHHMM",
      ?_assertMatch({{2012,2,3},{4,5,0}}, F("20120203T0405"))},
     {"parses YYYY-MM-DDTHH:MM",
      ?_assertMatch({{2012,2,3},{4,5,0}}, F("2012-02-03T04:05"))}].    

parse_fractional_minute_test_() ->
    F = fun iso8601:parse/1,
    [{"parses YYYYMMDDTHHMM.mm",
      ?_assertMatch({{2012,2,3},{4,5,15}}, F("20120203T0405.25"))},
     {"parses YYYY-MM-DDTHHMM.mm",
      ?_assertMatch({{2012,2,3},{4,5,15}}, F("2012-02-03T0405.25"))},
     {"parses YYYYMMDDTHHMM,mm",
      ?_assertMatch({{2012,2,3},{4,5,15}}, F("20120203T0405,25"))},
     {"parses YYYY-MM-DDTHHMM,mm",
      ?_assertMatch({{2012,2,3},{4,5,15}}, F("2012-02-03T0405,25"))}].

parse_second_test_() ->
    F = fun iso8601:parse/1,
    [{"parses YYYYMMDDTHHMMSS",
      ?_assertMatch({{2012,2,3},{4,5,6}}, F("20120203T040506"))},
     {"parses YYYY-MM-DDTHH:MM:SS",
      ?_assertMatch({{2012,2,3},{4,5,6}}, F("2012-02-03T04:05:06"))}].    

parse_fractional_second_test_() ->
    F = fun iso8601:parse/1,
    [{"parses YYYYMMDDTHHMMSS.ss",
      ?_assertMatch({{2012,2,3},{4,5,7}}, F("20120203T040506.50"))},
     {"parses YYYY-MM-DDTHHMMSS.ss",
      ?_assertMatch({{2012,2,3},{4,5,7}}, F("2012-02-03T040506.50"))},
     {"parses YYYYMMDDTHHMMSS,ss",
      ?_assertMatch({{2012,2,3},{4,5,7}}, F("20120203T040506,50"))},
     {"parses YYYY-MM-DDTHHMMSS,ss",
      ?_assertMatch({{2012,2,3},{4,5,7}}, F("2012-02-03T040506,50"))}].

parse_fractional_fail_test_() ->
    F = fun iso8601:parse/1,
    [{"fails to parses multiple decimals", % disallowed by spec
      ?_assertError(badarg, F("20120203T04.25:05.25:06"))}].

parse_offset_test_() ->
    F = fun iso8601:parse/1,
    [{"parses YYYYMMDDTHHMMSS.ssZ",
      ?_assertMatch({{2012,2,3},{4,5,7}}, F("20120203T040506.50Z"))},
     {"parses YYYYMMDDTHHMMSS.ss+0400",
      ?_assertMatch({{2012,2,3},{15,9,7}}, F("20120203T200506.50+0456"))},
     {"parses YYYYMMDDTHHMMSS.ss+0400",
      ?_assertMatch({{2012,2,3},{17,11,7}}, F("20120203T040506.50-1306"))}].

format_test_() ->
    F = fun iso8601:format/1,
    [{"formats Erlang now timestamp",
      ?_assertMatch(<<"2025-11-03T14:08:56Z">>, F({1762,178936,349362}))},
     {"formats Erlang datetime",
      ?_assertMatch(<<"2025-11-03T14:08:56Z">>, F({{2025,11,3},{14,8,56}}))}].

format_local_test_() ->
    F = fun iso8601:format/2,
    [{"formats Erlang now timestamp as Zulu",
      ?_assertMatch(<<"2025-11-03T14:08:56Z">>, F({1762,178936,349362}, "Z"))},
     {"formats Erlang datetime as Zulu",
      ?_assertMatch(<<"2025-11-03T14:08:56Z">>, F({{2025,11,3},{14,8,56}}, "Z"))},
     {"formats Erlang now timestamp with applied offset",
       ?_assertMatch(<<"2025-11-03T09:08:56-05:00">>, F({1762,178936,349362}, -18000))},
     {"formats Erlang datetime with applied offset",
       ?_assertMatch(<<"2025-11-03T09:08:56-05:00">>, F({{2025,11,3},{14,8,56}}, -18000))},
     {"formats Erlang now timestamp with string offset",
       ?_assertMatch(<<"2025-11-03T14:08:56-05:00">>, F({1762,178936,349362}, "-05:00"))},
     {"formats Erlang datetime with string offset",
       ?_assertMatch(<<"2025-11-03T14:08:56-05:00">>, F({{2025,11,3},{14,8,56}}, "-05:00"))}].
    
format_exact_test_() ->
    F = fun iso8601:format_exact/1,
    [{"formats Erlang now timestamp",
      ?_assertMatch(<<"2025-11-03T14:08:56.349362Z">>, F({1762,178936,349362}))},
     {"formats Erlang datetime",
      ?_assertMatch(<<"2025-11-03T14:08:56Z">>, F({{2025,11,3},{14,8,56}}))},
     {"formats Erlang datetime with fractional seconds",
      ?_assertMatch(<<"2025-11-03T14:08:56.349362Z">>, F({{2025,11,3},{14,8,56.349362}}))}].

format_local_exact_test_() ->
    F = fun iso8601:format_exact/2,
    [{"formats Erlang now timestamp as Zulu",
      ?_assertMatch(<<"2025-11-03T14:08:56.349362Z">>, F({1762,178936,349362}, "Z"))},
     {"formats Erlang datetime with as Zulu",
      ?_assertMatch(<<"2025-11-03T14:08:56Z">>, F({{2025,11,3},{14,8,56}}, "Z"))},
     {"formats Erlang datetime with fractional seconds as Zulu",
      ?_assertMatch(<<"2025-11-03T14:08:56.349362Z">>, F({{2025,11,3},{14,8,56.349362}}, "Z"))},
     {"formats Erlang now timestamp with applied offset",
       ?_assertMatch(<<"2025-11-03T09:08:56.349362-05:00">>, F({1762,178936,349362}, -18000))},
     {"formats Erlang datetime with applied offset",
       ?_assertMatch(<<"2025-11-03T09:08:56-05:00">>, F({{2025,11,3},{14,8,56}}, -18000))},
     {"formats Erlang datetime with fractional seconds and applied offset",
       ?_assertMatch(<<"2025-11-03T09:08:56.349362-05:00">>, F({{2025,11,3},{14,8,56.349362}}, -18000))},
     {"formats Erlang now timestamp with string offset",
       ?_assertMatch(<<"2025-11-03T14:08:56.349362-05:00">>, F({1762,178936,349362}, "-05:00"))},
     {"formats Erlang datetime with string offset",
       ?_assertMatch(<<"2025-11-03T14:08:56-05:00">>, F({{2025,11,3},{14,8,56}}, "-05:00"))},
     {"formats Erlang datetime with fractional seconds and string offset",
       ?_assertMatch(<<"2025-11-03T14:08:56.349362-05:00">>, F({{2025,11,3},{14,8,56.349362}}, "-05:00"))}].

parse_test_() ->
    F = fun iso8601:parse/1,
    [
        {"parses",
            ?_assertMatch({{2025,11,3},{14,8,56}}, F(<<"2025-11-03T14:08:56Z">>))},
        {"ignores fractional seconds",
            ?_assertMatch({{2025,11,3},{14,8,56}}, F(<<"2025-11-03T14:08:56.349362Z">>))},
        {"applies offset",
            ?_assertMatch({{2025,11,3},{14,8,56}}, F(<<"2025-11-03T09:08:56-05:00">>))},
        {"applies offset, ignores fractional seconds",
            ?_assertMatch({{2025,11,3},{14,8,56}}, F(<<"2025-11-03T09:08:56.349362-05:00">>))}
    ].
    
parse_local_test_() ->
    F = fun iso8601:parse_local/1,
    [
        {"parses",
            ?_assertMatch({{{2025,11,3},{14,8,56}}, 0}, F(<<"2025-11-03T14:08:56Z">>))},
        {"ignores fractional seconds",
            ?_assertMatch({{{2025,11,3},{14,8,56}}, 0}, F(<<"2025-11-03T14:08:56.349362Z">>))},
        {"applies offset",
            ?_assertMatch({{{2025,11,3},{14,8,56}}, -18000}, F(<<"2025-11-03T09:08:56-05:00">>))},
        {"applies offset, ignores fractional seconds",
            ?_assertMatch({{{2025,11,3},{14,8,56}}, -18000}, F(<<"2025-11-03T09:08:56.349362-05:00">>))}
    ].

parse_exact_test_() ->
    F = fun iso8601:parse_exact/1,
    [
        {"parses",
            ?_assertMatch({{2025,11,3},{14,8,56.0}}, F(<<"2025-11-03T14:08:56Z">>))},
        {"parses fractional seconds",
            ?_assertMatch({{2025,11,3},{14,8,56.349362}}, F(<<"2025-11-03T14:08:56.349362Z">>))},
        {"applies offset",
            ?_assertMatch({{2025,11,3},{14,8,56.0}}, F(<<"2025-11-03T09:08:56-05:00">>))},
        {"applies offset, parses fractional seconds",
            ?_assertMatch({{2025,11,3},{14,8,56.349362}}, F(<<"2025-11-03T09:08:56.349362-05:00">>))}
    ].

parse_local_exact_test_() ->
    F = fun iso8601:parse_local_exact/1,
    [
        {"parses",
            ?_assertMatch({{{2025,11,3},{14,8,56.0}}, 0}, F(<<"2025-11-03T14:08:56Z">>))},
        {"parses fractional seconds",
            ?_assertMatch({{{2025,11,3},{14,8,56.349362}}, 0}, F(<<"2025-11-03T14:08:56.349362Z">>))},
        {"applies offset",
            ?_assertMatch({{{2025,11,3},{14,8,56.0}}, -18000}, F(<<"2025-11-03T09:08:56-05:00">>))},
        {"applies offset, parses fractional seconds",
            ?_assertMatch({{{2025,11,3},{14,8,56.349362}}, -18000}, F(<<"2025-11-03T09:08:56.349362-05:00">>))}
    ].
    
inverses_test_() ->
    [
        {"parse and format",
            ?_assertMatch(<<"2025-11-03T09:08:56.349362-05:00">>, parse_and_format(<<"2025-11-03T09:08:56.349362-05:00">>))},
        {"format and parse",
            ?_assertMatch({{{2025,11,3},{14,8,56.349362}}, -18000}, format_and_parse({{2025,11,3},{14,8,56.349362}}, -18000))}
    ].

parse_and_format(Input) ->
    {UtcExact, OffsetSec} = iso8601:parse_local_exact(Input),
    iso8601:format_exact(UtcExact, OffsetSec).

format_and_parse(Input, OffsetSec) ->
    Fmt = iso8601:format_exact(Input, OffsetSec),
    iso8601:parse_local_exact(Fmt).
