Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC9F27B50F
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 02:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781661696; cv=none; b=teFTnvwVNt9r/PyTwM0HtL7eKFYGoZ880D6Lz2ms8NUSwiOV0y7bOg32L1NSvug7rNMrXa6Ir3JwdN9dU2BUc+DrKqmKF7eNvljRhxvf3OyNmUcLLASVsyOmFKr1+svF3+3VC23jw2f/jTyeBt9TkqMPVzVMpNC3c4wsiatVbgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781661696; c=relaxed/simple;
	bh=iXaY6QzEtxYygAZCiV8AZoRabJqbvJno7GdjGaSiqpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r8FITr92rxWUyTFNzl12RhiNEgh+diSeURixfgXUaUIzMYy4Scf+rR76l1zoKDyufMafJjlLdEJISnJjQfAvtrtHqNC7s/WOI0YrkuLBBWdFV13uW2EyLbN9X05K7yotfrMMfrvdmJ2iKKQ9xkq2koLb46pxVwX1Nqhg8HmK0z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DTLcnBdZ; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DTLcnBdZ"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-69532288224so1302874a12.0
        for <patches@lists.linux.dev>; Tue, 16 Jun 2026 19:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781661693; x=1782266493; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PWA1IEbx+mpOnundKdVvEVYP0eJfVw5sHeHLoIBZwuo=;
        b=DTLcnBdZt1TgeLzFv3euamElK5MSUz630wjSEj+kVSTS5OR3Sk14KRSfeUPyYdECbs
         SW20Pz5v7FriuyM2yMfgQONHYSVFXdf5I4pXQhmvWzMCowJf7d8e3+yxtKVSPdEjSu0x
         1woOzdJpoBqVctUFEMILNxtCqOMe3cCP/W8FZMv9LZK97HtPAlu1DVymZCS7S29754gp
         HM8Ju1ben2n9lM8mot2VtMdzuDe/8S2rPZUpgIpQk8FbH5qirLoIxZb9T0LYjWBoghx3
         p6dMn7RAKglS9K1piNZoVq5FYPCvThHZy8bVSUTqMiW9j3Iw0idoBL0BA6f+qwsfrAfy
         evCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781661693; x=1782266493;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PWA1IEbx+mpOnundKdVvEVYP0eJfVw5sHeHLoIBZwuo=;
        b=CAot/USdXt2bxvUpAf1QtJJB16WhJy+HjU7AYiNaqnD3hJpHRM9+x1CNi7cMsOKnVc
         1KdXEHMsgTt3uiu2wJ95c+n8siSBN6MgZGLLDiyYxRBBcydWUikV51uKbArNrRA+iIOT
         y+RVlNo1vE5c8LzUsZmKGFG2OxK8M+MkAQg9ZADF4uudVRy9NAH2xHhGX4rqj5Uso2hU
         v5SHDLPH82HM7YQiZkf2KT2MauMv+tpgFqgbjLYG9SLPmPCH5/SD9NicXvEuXq8/FV9B
         eizLPu5K6wmCwEbmoUikDlrn0othkA7h6LAS0t2eXAiBEvuay2YNrva39DSNHurGwSDU
         +ImQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Ytpt8JS6m7Uw+QsZEoEeRVgpNclZ3LzrAhVznR7nD94/Qbu8vn/iRI8UaMHJzUy9D/83YWZtx@lists.linux.dev
X-Gm-Message-State: AOJu0YzBfsLVZ9dPP6VnLlO9MDfZXtScRapPuYHAIpQtFiGUhmPkQjCc
	zdEchBIDj7uQsIQgJYa6+ryc30GG8Cuj8DPz2TsyVNpX+VYq0Q6l03o4uNa042J7TCw=
X-Gm-Gg: Acq92OEFHtPPog5UogMgfF5DkQqGdYjfrk2bTiwuEzeRGTWWDiH5n4EXxxPTu/eK5Jg
	PjQpPeQdkjbvk9MWI1LmroNSSrlYoW1d0dP2rlolnbnWKteTV3w+tue5SilW+UeP0YxzINnTL/n
	iworx91VZ6IgHpRk/WkOfxJ+5M7AW31NmQ6i5I+39TyNVIGo0wQVs08pACQzC/T8UKavU8vFoiV
	Cr57iZtxWfoxZk017qjlWdR/NHWYbaRuyLNmjJYlTa2aADCMcjpXBrr0cxOZ3mQwNVwU1apOkMb
	XHn5pO2t2n0bDf1Gde/aj/LrZ+WBhXMvFyQy8R519xaP6nmP6xHSr08EMCe9XGaVutC0hGGaL6j
	QvWhRJN+FKKXf9Q8KlmcVRjt8ADuoPxB+4ogBmXn6eStS9BhB/Va0/rYrF4gFI9hub75u04Z6mM
	clkg9AMIEjYUX5CXDzGVuAq3YO6GKElSKXG5XsQw==
X-Received: by 2002:a17:907:9692:b0:bff:334:1fe1 with SMTP id a640c23a62f3a-c05d2158c8fmr68094666b.12.1781661693393;
        Tue, 16 Jun 2026 19:01:33 -0700 (PDT)
Received: from u94a (27-240-202-183.adsl.fetnet.net. [27.240.202.183])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f2e52c0sm149949405ad.13.2026.06.16.19.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 19:01:32 -0700 (PDT)
Date: Wed, 17 Jun 2026 10:01:23 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/522] 6.1.176-rc1 review
Message-ID: <ajH_0dKVcvGaUfau@u94a>
References: <20260616145125.307082728@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>

On Tue, Jun 16, 2026 at 08:22:27PM +0530, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.176 release.
> There are 522 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/27647340765/job/81762433305

[...]
