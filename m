Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1707D391822
	for <patches@lists.linux.dev>; Sun, 24 May 2026 14:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779634013; cv=none; b=DoHfZXL00Y6s7xSLlE1pOkn5iIPE1aD7G1pzRmHQbSu2L+ShmdEgNAHvGJu6yA+hzlUjckBZrlyWVo01B1mWpjR1JaAcI9SwzUtsLF+7OfZRO8vvz9piUZMhf/u881v2jTfRMKioG6+7v7YQk2vTpsWR3pePU0qIiS0RLds4flU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779634013; c=relaxed/simple;
	bh=JEZWG6SWAXC3kSsKtJeswOT8sOerhSc4wffC3XsQE5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TqIfKoW2scVBU1HIgekgb1/sanV+q6fjF9DOZiS8MrDgi1BVq7aWdRw71FDlzF5RyaYvKqD5ofm6KUB3rTPFIcPODcCWCK9ayzZcdoY5mIzSVctlmA+z3YLAFgvH8tTRiD6VVQSGzGWt+Nx/iAo0lCENXnvJGs0dSizWy3Dm2ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sTi5XOjb; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sTi5XOjb"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4903d730b1fso27020165e9.2
        for <patches@lists.linux.dev>; Sun, 24 May 2026 07:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779634010; x=1780238810; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A6knduYAQaCV7hHxlTFEjJDyN7v2hRFonwrpL8674II=;
        b=sTi5XOjbDMsODsbwYWU+V6zmNfJ3uXDlbjrRmxmmQs8ybod7mxeWy+mC0w4yv4UZST
         h58avnTrmTLorHrIIqAGW73Lz4DjutiVGZbXiZd02dE0L1i89/mF/KV4w9OV92vLFCz7
         Ixvl1tPreOkcGNRZlbbi1PEbRdBsEkjotJ+qgLPDJLkFu+oTsLHM5EAGng/EC00s2TmX
         l+sgQ6df6syCI0FR20zeuagyG4DmoI1rvUmhul+y06JnIRMxOmajXBZxIQ1+0upwakv2
         yrdQxP0kwos3t/robVmZMYLHxVkZjPzU05osah/ZLSwQL/G9RfJQo+T8hrje7wrBdSut
         Fu/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779634010; x=1780238810;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A6knduYAQaCV7hHxlTFEjJDyN7v2hRFonwrpL8674II=;
        b=S7f21/lWnwCe/8jmmoVERiTdNA1I8grcUtWWadPfUw7X6KwQAl8L+lBE78qykhgNKM
         ZTmx2qkREg5YWb0B4UzODLzbvNHV2slQPtpsqAUq3Y+tyjpG/pqIlyOnf0w4yowj5Djx
         83EKnPhMzICzLWVVRnk4CUeD8xUmcmNTlVZBsDr4YN7/m9xo5BRHnBmN1FedmJLufQU/
         HPlEChebNCKCIV4x2IeD9j8Oiri9k8goPJNeIOTUSQnjKKhK4gAvxLEEPcaH5vK3m8oL
         rdKy+SEQwjTtY6PN2AhNNEYHuHXS60osPLqdAxfZwBQPyel1p+eTKgjhLagYcQONSdpa
         mbbA==
X-Forwarded-Encrypted: i=1; AFNElJ/RUssQp4exQ+k7dlGzq681LYFR/r6S80kMAuMAYynReBxut4PQNI9P01D1I9r9rSN+PJ+b5ONY@lists.linux.dev
X-Gm-Message-State: AOJu0YyV4DULOiWo9B4xUA8UUzzo8h60eNfhgiAro5Mw3L4QV04j8A5I
	WA3ttdzlZI7grqJznZJsK0IvSE0oFmUx+30Y0ZpGSe5tN77wx054F+1P
X-Gm-Gg: Acq92OGotrWO90tSm2aSMgrv9vcnOoe5bsBJ6O5/iGLuKpqqhhAoQDhH9i0Qn1AK9VC
	m46BxI0AW00o9+31hT4NXr4gXUoYZEzJgFg32ll1QC+8gxybNRqNz5NDO5uBDUM84iMTSS060Kw
	KPv3N8fDoL656/Y9pRGUM7+wxfHE6FIH+dx+lZHswMyXVx5l7lP9wEGWmvz1CC5+jztIKxxxs8f
	3b9eWL+Px9gGXOj4Crg4W3mnyPtGirEgpVooSn0vN0/uPoymcNahV/FlB9FkO0QdfL3qZELUwtP
	9ITU/0wzOgOtmXG8W6Jaw38B3WsNRB8UQ3IWtRc3XOdwH3Jde9lByVU9TwxkbD11c7wtQs//qye
	hvrmbR5vvDhYrWUzQe+fz1NO4+IN++4dipDAmk2UHUR7+J75DGKn0tAQGZSKZSmUaBFG+fEQZN2
	Qi5ajf4hdZBwvd2gCHRwSSHGG9rOJ49gDK0VdVMuQ89zwXutPd2vC31mxAJy0=
X-Received: by 2002:a05:600d:6450:10b0:48a:7a10:4f17 with SMTP id 5b1f17b1804b1-4904249d125mr126693985e9.6.1779634010232;
        Sun, 24 May 2026 07:46:50 -0700 (PDT)
Received: from eldamar.lan (c-82-192-247-196.customer.ggaweb.ch. [82.192.247.196])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454cfcaesm177192395e9.4.2026.05.24.07.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 07:46:49 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 77111BE2EE7; Sun, 24 May 2026 16:46:48 +0200 (CEST)
Date: Sun, 24 May 2026 16:46:48 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>, regressions@lists.linux.dev
Subject: Re: [PATCH 6.12 375/666] perf tool_pmu: Factor tool events into
 their own PMU
Message-ID: <ahMPWN_PZlQLisk4@eldamar.lan>
References: <20260520162111.222830634@linuxfoundation.org>
 <20260520162119.375577583@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260520162119.375577583@linuxfoundation.org>

hi Greg, 
On Wed, May 20, 2026 at 06:19:46PM +0200, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ian Rogers <irogers@google.com>
> 
> [ Upstream commit 240505b2d0adcdc8fd018117e88dc27b09734735 ]
> 
> Rather than treat tool events as a special kind of event, create a
> tool only PMU where the events/aliases match the existing
> duration_time, user_time and system_time events. Remove special
> parsing and printing support for the tool events, but add function
> calls for when PMU functions are called on a tool_pmu.
> 
> Move the tool PMU code in evsel into tool_pmu.c to better encapsulate
> the tool event behavior in that file.

While building now a complete set of packages for Debian for 6.12.91
where perf tools are included as well, I noticed that now the builds
fails. In fact in v6.12.91 

$ cd tools
$ LC_ALL=C.UTF-8 ARCH=x86 make perf

fails with:

[...]
  CC      util/stat.o
util/tool_pmu.c: In function ‘tool_pmu__config_term’:
util/tool_pmu.c:62:49: error: implicit declaration of function ‘parse_events__term_type_str’; did you mean ‘parse_events_term__str’? [-Wimplicit-function-declaration]
   62 |                                                 parse_events__term_type_str(term->type_term),
      |                                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~
      |                                                 parse_events_term__str
util/tool_pmu.c:61:79: error: format ‘%s’ expects argument of type ‘char *’, but argument 3 has type ‘int’ [-Werror=format=]
   61 |                                                 "unexpected tool event term (%s) %s",
      |                                                                              ~^
      |                                                                               |
      |                                                                               char *
      |                                                                              %d
   62 |                                                 parse_events__term_type_str(term->type_term),
      |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |                                                 |
      |                                                 int
cc1: all warnings being treated as errors
  CC      util/stat-shadow.o
  LD      util/hisi-ptt-decoder/perf-util-in.o
  CC      util/stat-display.o
make[5]: *** [/home/build/linux-stable-rc/tools/build/Makefile.build:105: util/tool_pmu.o] Error 1
make[5]: *** Waiting for unfinished jobs....
  CC      util/perf_api_probe.o
  LD      util/perf-regs-arch/perf-util-in.o
util/cgroup.c: In function ‘evlist__expand_cgroup’:
util/cgroup.c:498:32: error: ‘struct evsel’ has no member named ‘first_wildcard_match’
  498 |                         if (pos->first_wildcard_match)
      |                                ^~
util/cgroup.c:499:38: error: ‘struct evsel’ has no member named ‘first_wildcard_match’
  499 |                                 evsel->first_wildcard_match = pos->first_wildcard_match->priv;
      |                                      ^~
util/cgroup.c:499:66: error: ‘struct evsel’ has no member named ‘first_wildcard_match’
  499 |                                 evsel->first_wildcard_match = pos->first_wildcard_match->priv;
      |                                                                  ^~
make[5]: *** [/home/build/linux-stable-rc/tools/build/Makefile.build:105: util/cgroup.o] Error 1
  LD      util/arm-spe-decoder/perf-util-in.o
  LD      ui/browsers/perf-ui-in.o
  LD      tests/workloads/perf-test-in.o
  LD      ui/perf-ui-in.o
  LD      perf-ui-in.o
  AR      libperf-ui.a
  LD      tests/perf-test-in.o
  LD      perf-test-in.o
  AR      libperf-test.a
  LD      util/scripting-engines/perf-util-in.o
  LD      util/intel-pt-decoder/perf-util-in.o
  LD      perf-in.o
make[4]: *** [/home/build/linux-stable-rc/tools/build/Makefile.build:162: util] Error 2
make[3]: *** [Makefile.perf:789: perf-util-in.o] Error 2
make[3]: *** Waiting for unfinished jobs....
  CC      pmu-events/pmu-events.o
  LD      pmu-events/pmu-events-in.o
make[2]: *** [Makefile.perf:292: sub-make] Error 2
make[1]: *** [Makefile:76: all] Error 2
make: *** [Makefile:93: perf] Error 2

Regards,
Salvatore
