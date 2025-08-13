Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D59A1A275;
	Wed, 13 Aug 2025 03:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755055867; cv=none; b=NrKQ0RbvNerMzY4WyXWyACAPtVOxQMqtk66zWNoWAFm+mz5V3UxPNc+W0TOT4G0bFcdZta3nuB4A/9I1qw45uKQnMJyex0h0lsS8dHVLG+AvYEKH1vya1gIR29xQJSjQklsFZlfl8058Yl8u+mnLtPmFPOAGFNZa1bqjP4aUVls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755055867; c=relaxed/simple;
	bh=jbg8EAjNvG6NcFk6Z4MVoPL7Yk1Yr29Ba+aBqBRfZco=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gt37cjFOWfpRgp7OiNY6yUJS/L5Pzv0ZB7A6IWE2SJEK3yXTqO2FlqcyYCTuRpQqYdd+5mzhQGIxm5OhZlZwJbZqAY4iYhL+QD6ShB2PJwl4htHVsiyCZWWMaxqD5wYHZnwCP6iFkhC2c7+B5hEim2JXXpVAwdxeu6g7sUnXjWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=y2xIqGXU; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="y2xIqGXU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=F69SVinkRW4mQKvQwHS+h9NDMRp6whJk91M52/9nMOY=; t=1755055863;
	x=1755487863; b=y2xIqGXUcW61LTSQBD2UjxYV/5mc115L+eAblZnc5Oah1qxxFtYAVqvh10Ji5
	28fvWlcyweygpwXQzlcmGilV82k2s5EkymO7auFPqppXQOttkXqGYOfjoAu6B4NLtJch8C86KGSwZ
	FmjrybKux9UGBZqll762tPtcpxIEjCUiPsQQFxtgzFaJfXkGGRwhXLhJRsTOS2qmxuMF5BL+gFART
	jg9TlAjbcG9PMmSE8ld/EWQF5B4tGV65eXMnJZdniWXTKOP5gvP9DbGbAULu5ttdjafpnbLS74NLW
	MOrfsd0D2086styw0IELbhwhF5IVnKjQwDmrZU7ojPtGBtinLQ==;
Received: from [2a02:8108:8984:1d00:a0cf:1912:4be:477f]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
	id 1um2Cb-006efy-0w;
	Wed, 13 Aug 2025 05:31:01 +0200
Message-ID: <a736a48f-4de2-4b93-9f9c-df1925c8b76b@leemhuis.info>
Date: Wed, 13 Aug 2025 05:31:00 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 423/627] perf topdown: Use attribute to see an event
 is a topdown metic or slots
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Ian Rogers <irogers@google.com>,
 Namhyung Kim <namhyung@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20250812173419.303046420@linuxfoundation.org>
 <20250812173435.364948171@linuxfoundation.org>
From: Thorsten Leemhuis <linux@leemhuis.info>
Content-Language: de-DE, en-US
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 n7RI
In-Reply-To: <20250812173435.364948171@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1755055863;55d12621;
X-HE-SMSGID: 1um2Cb-006efy-0w

On 12.08.25 19:31, Greg Kroah-Hartman wrote:
> 6.16-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ian Rogers <irogers@google.com>
> 
> [ Upstream commit 5b546de9cc177936a3ed07d7d46ef072db4fdbab ]
> 
> The string comparisons were overly broad and could fire for the
> incorrect PMU and events. Switch to using the config in the attribute
> then add a perf test to confirm the attribute config values match
> those of parsed events of that name and don't match others. This
> exposed matches for slots events that shouldn't have matched as the
> slots fixed counter event, such as topdown.slots_p.

This caused the following build error for me when building perf
on Fedora x86_64:

arch/x86/tests/topdown.c: In function ‘event_cb’:
arch/x86/tests/topdown.c:53:25: error: implicit declaration of function ‘pr_debug’ [-Wimplicit-function-declaration]
   53 |                         pr_debug("Broken topdown information for '%s'\n", evsel__name(evsel));
      |                         ^~~~~~~~
make[6]: *** [/builddir/build/BUILD/kernel-6.16.1-build/kernel-6.16.1-rc1/linux-6.16.1-0.rc1.200.vanilla.fc42.x86_64/tools/build/Makefile.build:85: arch/x86/tests/topdown.o] Error 1
make[6]: *** Waiting for unfinished jobs....

Reverting fixed the problem. Full log:
https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/stable-rc/fedora-42-x86_64/09405663-stablerc-stablerc-releases/builder-live.log.gz

Ciao, Thorsten

 
> Fixes: fbc798316bef ("perf x86/topdown: Refine helper arch_is_topdown_metrics()")
> Signed-off-by: Ian Rogers <irogers@google.com>
> Link: https://lore.kernel.org/r/20250719030517.1990983-14-irogers@google.com
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/perf/arch/x86/include/arch-tests.h |  4 ++
>  tools/perf/arch/x86/tests/Build          |  1 +
>  tools/perf/arch/x86/tests/arch-tests.c   |  1 +
>  tools/perf/arch/x86/tests/topdown.c      | 76 ++++++++++++++++++++++++
>  tools/perf/arch/x86/util/evsel.c         | 46 ++++----------
>  tools/perf/arch/x86/util/topdown.c       | 31 ++++------
>  tools/perf/arch/x86/util/topdown.h       |  4 ++
>  7 files changed, 108 insertions(+), 55 deletions(-)
>  create mode 100644 tools/perf/arch/x86/tests/topdown.c
> 
> diff --git a/tools/perf/arch/x86/include/arch-tests.h b/tools/perf/arch/x86/include/arch-tests.h
> index 4fd425157d7d..8713e9122d4c 100644
> --- a/tools/perf/arch/x86/include/arch-tests.h
> +++ b/tools/perf/arch/x86/include/arch-tests.h
> @@ -2,6 +2,8 @@
>  #ifndef ARCH_TESTS_H
>  #define ARCH_TESTS_H
>  
> +#include "tests/tests.h"
> +
>  struct test_suite;
>  
>  /* Tests */
> @@ -17,6 +19,8 @@ int test__amd_ibs_via_core_pmu(struct test_suite *test, int subtest);
>  int test__amd_ibs_period(struct test_suite *test, int subtest);
>  int test__hybrid(struct test_suite *test, int subtest);
>  
> +DECLARE_SUITE(x86_topdown);
> +
>  extern struct test_suite *arch_tests[];
>  
>  #endif
> diff --git a/tools/perf/arch/x86/tests/Build b/tools/perf/arch/x86/tests/Build
> index 5e00cbfd2d56..9252a29d31a7 100644
> --- a/tools/perf/arch/x86/tests/Build
> +++ b/tools/perf/arch/x86/tests/Build
> @@ -11,6 +11,7 @@ endif
>  perf-test-$(CONFIG_X86_64) += bp-modify.o
>  perf-test-y += amd-ibs-via-core-pmu.o
>  perf-test-y += amd-ibs-period.o
> +perf-test-y += topdown.o
>  
>  ifdef SHELLCHECK
>    SHELL_TESTS := gen-insn-x86-dat.sh
> diff --git a/tools/perf/arch/x86/tests/arch-tests.c b/tools/perf/arch/x86/tests/arch-tests.c
> index bfee2432515b..29ec1861ccef 100644
> --- a/tools/perf/arch/x86/tests/arch-tests.c
> +++ b/tools/perf/arch/x86/tests/arch-tests.c
> @@ -53,5 +53,6 @@ struct test_suite *arch_tests[] = {
>  	&suite__amd_ibs_via_core_pmu,
>  	&suite__amd_ibs_period,
>  	&suite__hybrid,
> +	&suite__x86_topdown,
>  	NULL,
>  };
> diff --git a/tools/perf/arch/x86/tests/topdown.c b/tools/perf/arch/x86/tests/topdown.c
> new file mode 100644
> index 000000000000..8d0ea7a4bbc1
> --- /dev/null
> +++ b/tools/perf/arch/x86/tests/topdown.c
> @@ -0,0 +1,76 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include "arch-tests.h"
> +#include "../util/topdown.h"
> +#include "evlist.h"
> +#include "parse-events.h"
> +#include "pmu.h"
> +#include "pmus.h"
> +
> +static int event_cb(void *state, struct pmu_event_info *info)
> +{
> +	char buf[256];
> +	struct parse_events_error parse_err;
> +	int *ret = state, err;
> +	struct evlist *evlist = evlist__new();
> +	struct evsel *evsel;
> +
> +	if (!evlist)
> +		return -ENOMEM;
> +
> +	parse_events_error__init(&parse_err);
> +	snprintf(buf, sizeof(buf), "%s/%s/", info->pmu->name, info->name);
> +	err = parse_events(evlist, buf, &parse_err);
> +	if (err) {
> +		parse_events_error__print(&parse_err, buf);
> +		*ret = TEST_FAIL;
> +	}
> +	parse_events_error__exit(&parse_err);
> +	evlist__for_each_entry(evlist, evsel) {
> +		bool fail = false;
> +		bool p_core_pmu = evsel->pmu->type == PERF_TYPE_RAW;
> +		const char *name = evsel__name(evsel);
> +
> +		if (strcasestr(name, "uops_retired.slots") ||
> +		    strcasestr(name, "topdown.backend_bound_slots") ||
> +		    strcasestr(name, "topdown.br_mispredict_slots") ||
> +		    strcasestr(name, "topdown.memory_bound_slots") ||
> +		    strcasestr(name, "topdown.bad_spec_slots") ||
> +		    strcasestr(name, "topdown.slots_p")) {
> +			if (arch_is_topdown_slots(evsel) || arch_is_topdown_metrics(evsel))
> +				fail = true;
> +		} else if (strcasestr(name, "slots")) {
> +			if (arch_is_topdown_slots(evsel) != p_core_pmu ||
> +			    arch_is_topdown_metrics(evsel))
> +				fail = true;
> +		} else if (strcasestr(name, "topdown")) {
> +			if (arch_is_topdown_slots(evsel) ||
> +			    arch_is_topdown_metrics(evsel) != p_core_pmu)
> +				fail = true;
> +		} else if (arch_is_topdown_slots(evsel) || arch_is_topdown_metrics(evsel)) {
> +			fail = true;
> +		}
> +		if (fail) {
> +			pr_debug("Broken topdown information for '%s'\n", evsel__name(evsel));
> +			*ret = TEST_FAIL;
> +		}
> +	}
> +	evlist__delete(evlist);
> +	return 0;
> +}
> +
> +static int test__x86_topdown(struct test_suite *test __maybe_unused, int subtest __maybe_unused)
> +{
> +	int ret = TEST_OK;
> +	struct perf_pmu *pmu = NULL;
> +
> +	if (!topdown_sys_has_perf_metrics())
> +		return TEST_OK;
> +
> +	while ((pmu = perf_pmus__scan_core(pmu)) != NULL) {
> +		if (perf_pmu__for_each_event(pmu, /*skip_duplicate_pmus=*/false, &ret, event_cb))
> +			break;
> +	}
> +	return ret;
> +}
> +
> +DEFINE_SUITE("x86 topdown", x86_topdown);
> diff --git a/tools/perf/arch/x86/util/evsel.c b/tools/perf/arch/x86/util/evsel.c
> index 3dd29ba2c23b..9bc80fff3aa0 100644
> --- a/tools/perf/arch/x86/util/evsel.c
> +++ b/tools/perf/arch/x86/util/evsel.c
> @@ -23,47 +23,25 @@ void arch_evsel__set_sample_weight(struct evsel *evsel)
>  bool evsel__sys_has_perf_metrics(const struct evsel *evsel)
>  {
>  	struct perf_pmu *pmu;
> -	u32 type = evsel->core.attr.type;
>  
> -	/*
> -	 * The PERF_TYPE_RAW type is the core PMU type, e.g., "cpu" PMU
> -	 * on a non-hybrid machine, "cpu_core" PMU on a hybrid machine.
> -	 * The slots event is only available for the core PMU, which
> -	 * supports the perf metrics feature.
> -	 * Checking both the PERF_TYPE_RAW type and the slots event
> -	 * should be good enough to detect the perf metrics feature.
> -	 */
> -again:
> -	switch (type) {
> -	case PERF_TYPE_HARDWARE:
> -	case PERF_TYPE_HW_CACHE:
> -		type = evsel->core.attr.config >> PERF_PMU_TYPE_SHIFT;
> -		if (type)
> -			goto again;
> -		break;
> -	case PERF_TYPE_RAW:
> -		break;
> -	default:
> +	if (!topdown_sys_has_perf_metrics())
>  		return false;
> -	}
> -
> -	pmu = evsel->pmu;
> -	if (pmu && perf_pmu__is_fake(pmu))
> -		pmu = NULL;
>  
> -	if (!pmu) {
> -		while ((pmu = perf_pmus__scan_core(pmu)) != NULL) {
> -			if (pmu->type == PERF_TYPE_RAW)
> -				break;
> -		}
> -	}
> -	return pmu && perf_pmu__have_event(pmu, "slots");
> +	/*
> +	 * The PERF_TYPE_RAW type is the core PMU type, e.g., "cpu" PMU on a
> +	 * non-hybrid machine, "cpu_core" PMU on a hybrid machine.  The
> +	 * topdown_sys_has_perf_metrics checks the slots event is only available
> +	 * for the core PMU, which supports the perf metrics feature. Checking
> +	 * both the PERF_TYPE_RAW type and the slots event should be good enough
> +	 * to detect the perf metrics feature.
> +	 */
> +	pmu = evsel__find_pmu(evsel);
> +	return pmu && pmu->type == PERF_TYPE_RAW;
>  }
>  
>  bool arch_evsel__must_be_in_group(const struct evsel *evsel)
>  {
> -	if (!evsel__sys_has_perf_metrics(evsel) || !evsel->name ||
> -	    strcasestr(evsel->name, "uops_retired.slots"))
> +	if (!evsel__sys_has_perf_metrics(evsel))
>  		return false;
>  
>  	return arch_is_topdown_metrics(evsel) || arch_is_topdown_slots(evsel);
> diff --git a/tools/perf/arch/x86/util/topdown.c b/tools/perf/arch/x86/util/topdown.c
> index d1c654839049..66b231fbf52e 100644
> --- a/tools/perf/arch/x86/util/topdown.c
> +++ b/tools/perf/arch/x86/util/topdown.c
> @@ -1,6 +1,4 @@
>  // SPDX-License-Identifier: GPL-2.0
> -#include "api/fs/fs.h"
> -#include "util/evsel.h"
>  #include "util/evlist.h"
>  #include "util/pmu.h"
>  #include "util/pmus.h"
> @@ -8,6 +6,9 @@
>  #include "topdown.h"
>  #include "evsel.h"
>  
> +// cmask=0, inv=0, pc=0, edge=0, umask=4, event=0
> +#define TOPDOWN_SLOTS		0x0400
> +
>  /* Check whether there is a PMU which supports the perf metrics. */
>  bool topdown_sys_has_perf_metrics(void)
>  {
> @@ -32,31 +33,19 @@ bool topdown_sys_has_perf_metrics(void)
>  	return has_perf_metrics;
>  }
>  
> -#define TOPDOWN_SLOTS		0x0400
>  bool arch_is_topdown_slots(const struct evsel *evsel)
>  {
> -	if (evsel->core.attr.config == TOPDOWN_SLOTS)
> -		return true;
> -
> -	return false;
> +	return evsel->core.attr.type == PERF_TYPE_RAW &&
> +	       evsel->core.attr.config == TOPDOWN_SLOTS &&
> +	       evsel->core.attr.config1 == 0;
>  }
>  
>  bool arch_is_topdown_metrics(const struct evsel *evsel)
>  {
> -	int config = evsel->core.attr.config;
> -	const char *name_from_config;
> -	struct perf_pmu *pmu;
> -
> -	/* All topdown events have an event code of 0. */
> -	if ((config & 0xFF) != 0)
> -		return false;
> -
> -	pmu = evsel__find_pmu(evsel);
> -	if (!pmu || !pmu->is_core)
> -		return false;
> -
> -	name_from_config = perf_pmu__name_from_config(pmu, config);
> -	return name_from_config && strcasestr(name_from_config, "topdown");
> +	// cmask=0, inv=0, pc=0, edge=0, umask=0x80-0x87, event=0
> +	return evsel->core.attr.type == PERF_TYPE_RAW &&
> +		(evsel->core.attr.config & 0xFFFFF8FF) == 0x8000 &&
> +		evsel->core.attr.config1 == 0;
>  }
>  
>  /*
> diff --git a/tools/perf/arch/x86/util/topdown.h b/tools/perf/arch/x86/util/topdown.h
> index 1bae9b1822d7..2349536cf882 100644
> --- a/tools/perf/arch/x86/util/topdown.h
> +++ b/tools/perf/arch/x86/util/topdown.h
> @@ -2,6 +2,10 @@
>  #ifndef _TOPDOWN_H
>  #define _TOPDOWN_H 1
>  
> +#include <stdbool.h>
> +
> +struct evsel;
> +
>  bool topdown_sys_has_perf_metrics(void);
>  bool arch_is_topdown_slots(const struct evsel *evsel);
>  bool arch_is_topdown_metrics(const struct evsel *evsel);

