Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F0C2E03EA
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 06:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775024588; cv=none; b=UC7JOMA/u0h0TQWX4M1UHpFlXiTSijUwkLORQMXeS33gEIBDHUX+2HwCb9iNmOi9NXxoi8jjE2UBYxSIbVX1YMghAdYJC+CfMayT2ZdzrzWhkSHrosuVnhDa4NGBtXzPNr84Qkoy8nQkYHjp+0gKcdt1xA2lTMIvzKykIUBWOcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775024588; c=relaxed/simple;
	bh=yyj08EaIhKFqqClLafAv0Grc65mxWyxtG0STvYm6Znw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YO6FiEhy1C6FJXpZl6FHG/I8yIRC/qBK5OkYGyojaHpu/xA5DFwYBH0/Jykf3RJzhMyDqeO6wcvJSuOULQkC1I+paQ1aC4FknyGpuf0BjUfixHCWkUwW+LnN8rS+OsQM3OH21PgU7oVLaUs1iqy1ZEA+Ju6Hlb+C+ZXpF4z9WCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NAv393wS; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NAv393wS"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4852a9c6309so53958045e9.0
        for <patches@lists.linux.dev>; Tue, 31 Mar 2026 23:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775024585; x=1775629385; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=onLR2Z+iKa7puCirK+rttnPhdv4+tlf1MEERiMaPV80=;
        b=NAv393wSrqMHv2Kb2IaTA3YgCvvB8S8czd+MB2ryLR7TcM/ByRADqcElWGxe8CnEyk
         nEuJcbCGc6+xtkrmp3HA+q/CMPxp1HZ0ccrIj32ufpZAiAbt3/yyp4ijsdh65SSrDSrM
         pIU0AZbaZ04rZihwgp2bE0+36ke5h1q8Qo/6SSDA1ZGMgKL/YTvPeqTfqzzbzx4VNg1r
         /ue2TDG5Jpoo9qUSwvpeTzbd+IskI7UfWH48G2EzPoVeBaTSzURjneZZZr6pcEh+gAOe
         YREcjKC8L7IKGIFRjUM1weslMky3PuFGw7BZx04lLlFY0gB9aRQVV3WEmsXwb0AZMqLn
         Q+tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775024585; x=1775629385;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=onLR2Z+iKa7puCirK+rttnPhdv4+tlf1MEERiMaPV80=;
        b=OJNLsj9Wq07ldrbD92044lS7HFG5E+p7mEPlplfmxfHKg58OAWn17Ke1Vvnu2A2mZ6
         S5R0yjvYo/PPcGFXHiXSaprd5ZcDYWAC1tz5UiCFym3wSt00LlqvIh3OeHetI96pwsTh
         tHwcrYtcb97oofIxcrzCMrk0/iVzdHSWs///nraN/aTfS+Eo3wR+3Qmcab7//T153ZmQ
         I/wIZdNm/2yGWISetGM8S39PsY0DucqlHtS/F5Y2EF1e8aEGAqH7RrqdmDFyvzLFIm/t
         H176pyurbZU9pZXH9a7eMqmHHuutRYKxJmMI/FflLtKbSd5cuZoqRx9mlJkcoiBqX3VU
         NtSg==
X-Forwarded-Encrypted: i=1; AJvYcCXez8sfcP2x2ZqcrS/RSTdffo0rGADpALbtgMgYxpkyN1l/r/Lu9/DaMwfbFJ3uWTHYPBAMljMe@lists.linux.dev
X-Gm-Message-State: AOJu0YwOTKSxGu/ZiCapr8eEDhpFvLVg3x/t1LoKHR0ki2cf3rUzwTit
	XKPyiSBQMzmQ8frYc+kQA1koCtcGi5579rLNBGBMf8dnlVAF0T0tRGl+NNrQOoLPCv5iJUvXBG4
	FcO7P0d4=
X-Gm-Gg: ATEYQzy9nObeNC/7z5CHSAmF+TwaHdwiZiAcr88I52rDY0TBb0qFhNfO+1QvSp0IkZm
	uAF5XXted7s7mZONTZk5Mw5PqJX53ToKwP/rPLWd9DcOXdIHJCKbsbpBKPlKpqxHJinHdTxXtd5
	YYxNh2LTlLQK8vnvTXu83uqTHr+UiiMFy04Nfby1JqvAmK3ZtFaJWVrfrYNbkUQTyOnYwL8ya5W
	zVWSKxuDruFrHSjF8FqhdUxf/Wc1Vg3NEWKKZa9mGXG8HewWfGDh6fijd1HBfj3y53IGSLcw8p7
	A//GEKrxuzhkbwuvhpfd8ES/asF9KGuHosG1CHr7awsp3MjvSumVSW4KN6qsgmUoR5R6Uc9ikUt
	fMVHgkt4utPTg9nCM2+B1S0WdxKeOnPSHTdKJX6l8D+c75/oYrSL/Lohg14V70nPFnpVm9K7zHA
	tGdNt5ECbBPesIbrCWVTUyrwkuYfssw9VzMYWzkeK/aGOIS9or
X-Received: by 2002:a05:600c:1d16:b0:486:fe46:b647 with SMTP id 5b1f17b1804b1-488835633cemr35519025e9.10.1775024585404;
        Tue, 31 Mar 2026 23:23:05 -0700 (PDT)
Received: from u94a (114-140-80-217.adsl.fetnet.net. [114.140.80.217])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76b5b9f153sm4093110a12.18.2026.03.31.23.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 23:23:04 -0700 (PDT)
Date: Wed, 1 Apr 2026 14:22:58 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>, 
	Paul Chaignon <paul.chaignon@gmail.com>, stable@vger.kernel.org, patches@lists.linux.dev, 
	Andrea Righi <arighi@nvidia.com>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Alexei Starovoitov <ast@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 034/244] bpf: Fix u32/s32 bounds when ranges cross
 min/max boundary
Message-ID: <i4c753x3y67ek3r7dp774pcmaaaid3gvxcsvdssosdingre4in@od45qzitwtrf>
References: <20260331161741.651718120@linuxfoundation.org>
 <20260331161742.960922011@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331161742.960922011@linuxfoundation.org>

Cc Eduard and Paul since they know this change better.

On Tue, Mar 31, 2026 at 06:19:44PM +0200, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Eduard Zingerman <eddyz87@gmail.com>
> 
> [ Upstream commit fbc7aef517d8765e4c425d2792409bb9bf2e1f13 ]
> 
> Same as in __reg64_deduce_bounds(), refine s32/u32 ranges
> in __reg32_deduce_bounds() in the following situations:
...

Hi Greg,

This patch is causing the following BPF selftests to fail

  #222 reg_bounds_crafted
  #222/27 reg_bounds_crafted/(u64)[0x7fffffffffffffff; 0xffffffff00000000] (s64)<op> 0
  #222/28 reg_bounds_crafted/(u64)0 (s64)<op> [0x7fffffffffffffff; 0xffffffff00000000]
  #222/29 reg_bounds_crafted/(u64)[0x7fffffff00000001; 0xffffffff00000000] (s64)<op> 0
  #222/30 reg_bounds_crafted/(u64)0 (s64)<op> [0x7fffffff00000001; 0xffffffff00000000]
  #222/59 reg_bounds_crafted/(s64)[0xffffffff00000001; 0] (u64)<op> 0xffffffff00000000
  #222/60 reg_bounds_crafted/(s64)0xffffffff00000000 (u64)<op> [0xffffffff00000001; 0]
  #222/79 reg_bounds_crafted/(s64)[S64_MIN; 0] (u64)<op> 0
  #222/80 reg_bounds_crafted/(s64)0 (u64)<op> [S64_MIN; 0]
  #262 reg_bounds_rand_consts_s64_u64

The failure is caused by the selftests' expectation not aligning to the
stable 6.12 behavior. I believe the easier way out is to drop this, then
wait for [1] to land and pick it up in stable (or I'll try to backport
and send). That should address the root cause of what this patch is
trying to workaround.

1: https://lore.kernel.org/bpf/d4fe45f8bd5c6a48efd2ba3b66932bf7eb5aa020.1774025082.git.paul.chaignon@gmail.com/
