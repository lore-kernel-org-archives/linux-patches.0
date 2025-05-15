Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116242253B5
	for <patches@lists.linux.dev>; Thu, 15 May 2025 12:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747310659; cv=none; b=OWhat+bMb3YM2oE+EV8UYrHLJcrLNrhRXsGcDpZz6ODwmE2aggOfy4u34DPVbyppqY79co9uw6SfgHpmg4BJA29e3yF9S9gMQM+/K0lN5bF1kbEHSUnZJsG9r6aqqp/dnvqp53Olo/DLBHaSumijhAkQk8iafxwScCe8N2+fcFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747310659; c=relaxed/simple;
	bh=EyJpXkdehfh1auuhWF9I8kU2/U0fgbfr4WDdkSgpv4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XPdghDE5Pr09GWMIOxwNftF5qWO/ZWMqE11POkIi08LBHc5MPzxfan0Lohte4NWH75++U9pamWOR95qsDA85BCGQv4upQ+akoD3YDRed++JQ6OVXhSWqKgdLWszl/q+rEnZdGFcVj1N1C6jxV7Ztj5iL9gxsjOCbVzSG3kJyKZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GkxuUugl; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GkxuUugl"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a206845eadso494370f8f.3
        for <patches@lists.linux.dev>; Thu, 15 May 2025 05:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1747310655; x=1747915455; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JtVqjc80kK6sCY9kafM0HVeU2C9ROGazwmNlgFnahQM=;
        b=GkxuUugli8f3zeNPNLUV1IOmZ8/E0SsXL0rnGA+p8kK5PL3G/+sDiuoY4egkS9Xo94
         FgpuwPM8RvXVLhHbjSKzAavMebAhKjzr1Nukk18ZJ+zERR7KZDlLsQV5z3OqIoVTREYw
         6pOqtn4sUJ/hmfqcusffLOwZqtzqgYEH5TTgqo6rauDq0Hq/DDSw23vs/R9flqb8+JTW
         OGrDMSHA6SH4V3gbpNyCD+kXYIpN06pjJwnqS6MucWD25JHJiFCF4E2Sk7tKQdHXX02k
         uuQyx6FttcWTgHOKPpWhbrJ43pxhYZWmx2T1Gefkd9YpyRYezeKlB6+0AKkfUqBJhdpp
         6PXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747310655; x=1747915455;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JtVqjc80kK6sCY9kafM0HVeU2C9ROGazwmNlgFnahQM=;
        b=BFYYZnRm9crrCq11lV7dLy5/xLAqOMCokwD+xsoqXEKij8L7YN+nGkKAqJO7lhJ5B9
         pZPUWfIdqgTLeUph41n+h2BvPP6Ohcq6hsf+v7AER0ouIHmHzorWgnwqb47/6+jeUA2O
         /6Di8hSEL+UlfAgz8F00kt283HtaeUHPXzp952Zdtypv5wibEiZ4ShMJnO8p2zst7oay
         kqT6JAG1RPHuxa0kWIAEhlEUGY0f2c/nD/WiBhBls9Aq0NkIF1sZGkjtYWKvazmgmQ86
         uOYIiyBmGvkD3pxyBfdVtlRSEXBalOw2flBFvkz/ivZ76wcZArSOBSmLA5Iv/TFD2Khk
         ehqw==
X-Forwarded-Encrypted: i=1; AJvYcCUXT3wF0vwy0gNtz8NL2k3cjTeZJhewT+WWqQ42a/VSKwVlzXswCLp/gArRC4l1o92F4ClAcvAI@lists.linux.dev
X-Gm-Message-State: AOJu0YxuRLxu7wxZv0/0SFPv+4Q9BjpNzTmYTq+/Cpl9cRQdX6f1euKU
	Ioe5WsgvaZo7uo9Ft08dIXD+e7yj7ZYcnILya1yDWSEL0MFOrPbnqrdZsCekxH4=
X-Gm-Gg: ASbGncuTFQ/D7ie4MhXjMeTMhJZ5KSqRPAaNSC272P4hQVrAxigEf7Dh22Uy4yw7NFV
	38ih0dwmPYgeHcEZ69TUiku53FGzOgd/6okyxlHKKIvaKUt+3h60+7fgZUVlu9Q9Fhtu5/NltIT
	djpHe+owVjJlS8kJRST+0SFoibug+yFDjG4qcclkm3/lBPVU/ecEq+i2G4KGtHXqp2BvGfbGziK
	MmeDGGfHRfNGgIrz2L4DktGPBJbadRiv5c3l8FpkxSP+pwQmCZJcqDlPIa+adb922ApvYcqz4cy
	8LaaHUCvnEGbdQW4vsfG5IbsNbyZW6z7Z0+OZMHu2mtUiDfWXmqWj6iSzh9DN9SS00TKgBd3u3o
	7h8kVil7PHeRIE1Y/Ho6KTEAjCNAbRh4uDUwuJLdw26LH
X-Google-Smtp-Source: AGHT+IFVleGXWb394vxJ3g1TFClYBJH1ORxzbyUoB3lbpc/3PPg81qikPncaNTT+LnlATVlgCEOW0w==
X-Received: by 2002:a5d:598f:0:b0:3a3:4a1a:de6f with SMTP id ffacd0b85a97d-3a353748601mr2088152f8f.26.1747310655226;
        Thu, 15 May 2025 05:04:15 -0700 (PDT)
Received: from u94a (2001-b011-fa04-b2d3-b2dc-efff-fee8-7e7a.dynamic-ip6.hinet.net. [2001:b011:fa04:b2d3:b2dc:efff:fee8:7e7a])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b26e383cdaesm456300a12.33.2025.05.15.05.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 May 2025 05:04:14 -0700 (PDT)
Date: Thu, 15 May 2025 20:04:06 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Kees Cook <kees@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc1 review
Message-ID: <6cratgkqkq4lnln65bqjiqn4vle7uhtlvnmi5r2v3l4lug3g5p@n55v6sogh6x2>
References: <20250512172044.326436266@linuxfoundation.org>
 <g4fpslyse2s6hnprgkbp23ykxn67q5wabbkpivuc3rro5bivo4@sj2o3nd5vwwm>
 <20250515041659.smhllyarxdwp7cav@desk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250515041659.smhllyarxdwp7cav@desk>

On Wed, May 14, 2025 at 09:17:45PM -0700, Pawan Gupta wrote:
> On Wed, May 14, 2025 at 07:49:29PM +0800, Shung-Hsi Yu wrote:
> > On Mon, May 12, 2025 at 07:37:30PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.14.7 release.
> > > There are 197 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 
> > Running included BPF selftests with a BPF CI fork (i.e. running on
> > GitHub Action x86-64 machines), I observe that that running the BPF
> > selftests now takes about 2x the time (from ~25m to ~50m), and
> > verif_scale_loop3_fail is timing out, taking more than 6 minutes to run
> > compare to the usual single digit second runtime. See [1] for the log.
...
> > Compare to a day before when such behavior wasn't observed[2], the main
> > difference being these additional patches:
...
> Not sure why but this commit seems to related to the failure.
> 
> Below is log of bisecting v6.14.6 and v6.14.7-rc2 with the test:
> 
>   ./tools/testing/selftests/bpf/vmtest.sh -i -- timeout 20 ./test_progs -t verif_scale_loop3_fail
> 
> # good: [e2d3e1fdb530198317501eb7ded4f3a5fb6c881c] Linux 6.14.6
> git bisect good e2d3e1fdb530198317501eb7ded4f3a5fb6c881c
...
> git bisect bad 336f780075f36e0d1181ce44d6d4197e4a22babc
> # bad: [665f26e5de2325e3bca107b632bc2ccac1b9806a] mm: vmalloc: support more granular vrealloc() sizing
> git bisect bad 665f26e5de2325e3bca107b632bc2ccac1b9806a
> # first bad commit: [665f26e5de2325e3bca107b632bc2ccac1b9806a] mm: vmalloc: support more granular vrealloc() sizing

Thanks! Just dawn on me after seeing this that I should try 6.15-rc6 as
well (which has 665f26e5de23), turns out it also reproduce there. I'll
report regression in a separate mail. 

> ...
> > No patches touch BPF's core component, and while the
> > verif_scale_loop3_fail test did time out, the verifier is still
> > correctly rejecting it, so shouldn't have anything to do with
> > kernel/bpf/. The x86/arm64 BPF patches only affect JIT output, and only
> > for cBPF.
> > 
> > In comparison, with 6.12.29-rc1 I don't observe any timeout or increase
> > in runtime[3]. Below is a diff comparing the applied patches in
> > 6.12.29-rc1 and 6.14.7-rc1. Seems like 6.14.7-rc1 does not have the
> > CALL_NOSPEC patches, but I cannot tell whether that is what makes the
> > difference.
> 
> Thats because CALL_NOSPEC patches were already part of v6.14.

Ah yes indeed, sorry about the negligence.
