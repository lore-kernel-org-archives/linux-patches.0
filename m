Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E168321771B
	for <patches@lists.linux.dev>; Tue, 26 May 2026 23:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779837699; cv=none; b=uKr3cqTb0T5xmt2Iv5ab+sjRITXaTxDOdAHTlMBvfGVJygKAuopxXPqUPEeV8FkHi7wgtros69QnJVrVUssrfL7cQH97I/hO70K8MGHobjxDMB6VfWDXHdqIKg/MzDzG2gnl0cCx/7FokSZfPsLLUizl6j4SiOK/bkb7KZdHaWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779837699; c=relaxed/simple;
	bh=GNseIYPxJ3cmW+l193MU1A8d8rdG4X/eR9u+Vb0r/Ug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y8Wos69VsxdKT+XuGd3WBrJovVxTrlBmDVlZ9INhIDhHfNdKBbacOK05lAZ/VFZlTqSTbFnHaRZwB0graiXngjt+Qfh1OuVd0RGB5QASJ4n8Jw0nLJUi/b+GkeZ8nKn3WkF3oH+uv4iNI7hyYs8d/oAo6CVgNI2PsaLDuNm/qyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WkS130dy; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WkS130dy"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-516d86cb62cso3811041cf.3
        for <patches@lists.linux.dev>; Tue, 26 May 2026 16:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779837697; x=1780442497; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BiZFVTxQnyNG17gARCnVzZAOXJ6pRd4xFKXb5aZrpTw=;
        b=WkS130dyDw6sZxSL4Q/0jJ++ovXXxF41Tf3iEOfvcoVsp0ovRgQWKR4ge3sXP9e/M5
         WjAkOVXKEUOzVy8q3UHrg/z3Y5WmF/ejN3P47spsNiYUTNkG586bZrtY/aox1PrfQ0Tn
         QNcDTZ8gznBdNYCxU0uzaiy3yZA8w4J19BcqJ9O172J4+aO/rLJxrA8RN9c2B6/pMWzH
         ay8Bhxj9L8T89MBoSVTuKX84wmMRhBqzc4iCMVWU6kfnZOM/nEcCK1GQXJ+fFw7O62Tl
         kymSq9392zF1EoBg+I+7bcm0UtdA3zEKMvPqfUvR2K7Hq7XnLTTqwOOLp9qbXKmOpJ5W
         LomA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779837697; x=1780442497;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BiZFVTxQnyNG17gARCnVzZAOXJ6pRd4xFKXb5aZrpTw=;
        b=bVnwP6p3kPpQKro0RqBChyubiopvHQ01n5CzGOlvNy+PUZpDaH4/1XzFM6edp9JPKK
         92xUB499b8vjxyYBG1UEiD8t3erJ0JHQaF3foqvNVF7t93LBaWtZBMzq6ZpwbTtTPriM
         MGsd1Wp/gUuyby/roGC97icUT5bMdTAbXY776lJ0PYkmkx86bJxQyuPHYSXVMBAuhVn1
         3Jy8kSQJpK8EVivohwHtyps4tSnGTW24AWMEmSx2WeGNYQw9lnsm/riQwyIxVmw6IEMS
         43piz5dIhA2LcJIZJwZ4Lhd3VfQefXhdnzdcKHUJ4o9SYjY1aVE9++SyIqRAgjZxq1Qw
         4u0A==
X-Forwarded-Encrypted: i=1; AFNElJ8BgycVPrJ868ObfAxiDb9cqEL3/2A/s5az/vCUK3r0tOrQ6cpG3rhjwrAyYyvohySVETSVmmzv@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1uKbOSt5IBPutbLQS+yC5I+x0TS3YcvoyKMMi+elCmKf5Tz6U
	UzxPL0IhbSNoRTcGVIZIEMPgLHh+76MqSHdNSreJYJmbowQUKunhO34A
X-Gm-Gg: Acq92OFoSq0bVAAlO2TNkBfiA1nd7D1rY5MNYEP8l0Qnbj9FFCvKv/oVlnfm4Us19gp
	cs9TGIKNgQDMc9CMIyjIKgdJmcnBJHTmERdBDEg4HebwoXuhtlQa8ZPOiQ9sdxXB65ghvLoYwgC
	76wwX2ywJXLXW9FUmUCrHrGBI0XfBQFcHKn4RYgwLJSngGtXDVVkJ1QiegsPTJEkKv3dRVh/dxa
	DJDqD9Il6T/fpSwYZz9CYI59nBcnOVRWq2cVrb0dwZRE6OHEuqTZ5CZ7akDXJWZo+oF8HspAh7L
	Bhbd8EIbH6VHAbr1WmGY+XBfNBHflyodwLWn/ZSvUFUGFi6c3XeI1gzDmaKwL9WGyCzgiE+8KoH
	3fkZEQNzIjlKvLu36OJ9YGKHDK0RIw93yYcuG2cRSt0o7PS1FC4BFA7tvhzVvbxNMZ0YLiTp38b
	gRxgavToEKnjtkj/IR2G54H5+UsA4MMLhvXHxDNYqGJSa1DW3QGVhNszXjeKcFE1nACVBtQfI=
X-Received: by 2002:a0c:e091:0:b0:8ac:a205:f118 with SMTP id 6a1803df08f44-8cc7b5e585bmr199693176d6.8.1779837696675;
        Tue, 26 May 2026 16:21:36 -0700 (PDT)
Received: from luigi.stachecki.net ([96.224.31.104])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cc8132f780sm154586406d6.49.2026.05.26.16.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 16:21:35 -0700 (PDT)
Date: Tue, 26 May 2026 19:21:33 -0400
From: Tyler Stachecki <stachecki.tyler@gmail.com>
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>, Sasha Levin <sashal@kernel.org>,
	regressions@lists.linux.dev
Subject: Re: [PATCH 6.12 375/666] perf tool_pmu: Factor tool events into
 their own PMU
Message-ID: <ahYq/YrKZ+PjCh2W@luigi.stachecki.net>
References: <20260520162111.222830634@linuxfoundation.org>
 <20260520162119.375577583@linuxfoundation.org>
 <ahMPWN_PZlQLisk4@eldamar.lan>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ahMPWN_PZlQLisk4@eldamar.lan>

On Sun, May 24, 2026 at 04:46:48PM +0200, Salvatore Bonaccorso wrote:
> hi Greg, 
> On Wed, May 20, 2026 at 06:19:46PM +0200, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Ian Rogers <irogers@google.com>
> > 
> > [ Upstream commit 240505b2d0adcdc8fd018117e88dc27b09734735 ]
> > 
> > Rather than treat tool events as a special kind of event, create a
> > tool only PMU where the events/aliases match the existing
> > duration_time, user_time and system_time events. Remove special
> > parsing and printing support for the tool events, but add function
> > calls for when PMU functions are called on a tool_pmu.
> > 
> > Move the tool PMU code in evsel into tool_pmu.c to better encapsulate
> > the tool event behavior in that file.
> 
> While building now a complete set of packages for Debian for 6.12.91
> where perf tools are included as well, I noticed that now the builds
> fails. In fact in v6.12.91 
> 
> $ cd tools
> $ LC_ALL=C.UTF-8 ARCH=x86 make perf
> 
> fails with:
> 
> [...]
>   CC      util/stat.o
> util/tool_pmu.c: In function ‘tool_pmu__config_term’:
> util/tool_pmu.c:62:49: error: implicit declaration of function ‘parse_events__term_type_str’; did you mean ‘parse_events_term__str’? [-Wimplicit-function-declaration]
>    62 |                                                 parse_events__term_type_str(term->type_term),
>       |                                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |                                                 parse_events_term__str
> util/tool_pmu.c:61:79: error: format ‘%s’ expects argument of type ‘char *’, but argument 3 has type ‘int’ [-Werror=format=]
>    61 |                                                 "unexpected tool event term (%s) %s",
>       |                                                                              ~^
>       |                                                                               |
>       |                                                                               char *
>       |                                                                              %d
>    62 |                                                 parse_events__term_type_str(term->type_term),
>       |                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |                                                 |
>       |                                                 int
> cc1: all warnings being treated as errors
>   CC      util/stat-shadow.o
>   LD      util/hisi-ptt-decoder/perf-util-in.o
>   CC      util/stat-display.o
> make[5]: *** [/home/build/linux-stable-rc/tools/build/Makefile.build:105: util/tool_pmu.o] Error 1
> make[5]: *** Waiting for unfinished jobs....
>   CC      util/perf_api_probe.o
>   LD      util/perf-regs-arch/perf-util-in.o
> util/cgroup.c: In function ‘evlist__expand_cgroup’:
> util/cgroup.c:498:32: error: ‘struct evsel’ has no member named ‘first_wildcard_match’
>   498 |                         if (pos->first_wildcard_match)
>       |                                ^~
> util/cgroup.c:499:38: error: ‘struct evsel’ has no member named ‘first_wildcard_match’
>   499 |                                 evsel->first_wildcard_match = pos->first_wildcard_match->priv;
>       |                                      ^~
> util/cgroup.c:499:66: error: ‘struct evsel’ has no member named ‘first_wildcard_match’
>   499 |                                 evsel->first_wildcard_match = pos->first_wildcard_match->priv;
>       |                                                                  ^~
> make[5]: *** [/home/build/linux-stable-rc/tools/build/Makefile.build:105: util/cgroup.o] Error 1
>   LD      util/arm-spe-decoder/perf-util-in.o
>   LD      ui/browsers/perf-ui-in.o
>   LD      tests/workloads/perf-test-in.o
>   LD      ui/perf-ui-in.o
>   LD      perf-ui-in.o
>   AR      libperf-ui.a
>   LD      tests/perf-test-in.o
>   LD      perf-test-in.o
>   AR      libperf-test.a
>   LD      util/scripting-engines/perf-util-in.o
>   LD      util/intel-pt-decoder/perf-util-in.o
>   LD      perf-in.o
> make[4]: *** [/home/build/linux-stable-rc/tools/build/Makefile.build:162: util] Error 2
> make[3]: *** [Makefile.perf:789: perf-util-in.o] Error 2
> make[3]: *** Waiting for unfinished jobs....
>   CC      pmu-events/pmu-events.o
>   LD      pmu-events/pmu-events-in.o
> make[2]: *** [Makefile.perf:292: sub-make] Error 2
> make[1]: *** [Makefile:76: all] Error 2
> make: *** [Makefile:93: perf] Error 2
> 
> Regards,
> Salvatore

Second this - moreover, because of the other commits introduced in tools/perf
as of 6.12.91, it's not possible to revert just this one commit without other
conflicts.

Cheers,
Tyler
