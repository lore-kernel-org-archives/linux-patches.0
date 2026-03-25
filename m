Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00042750ED
	for <patches@lists.linux.dev>; Wed, 25 Mar 2026 10:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774436163; cv=none; b=oYxpAVHS7mHpeLBGUQO+myFWrHE2n7ykSmB9Tatrq+xwc/SqxAFeGl+rpLH3KqMdEpNY+Zx0iTtUrhS6OCrU1AvuDkCNAonW9nMQUoHMK+YxGcj79pBtOOYy29HPfkXM4ro+7PqfL4YQ7RK7CrHnkUghCiEWBYDXXloaELHYnfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774436163; c=relaxed/simple;
	bh=m4571C4KsP5S+tvy3v4ajwODfqrsP5H3SzYFjB/0vtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fyUmYXwa3BMYnsQ3lIdXZcc4mcAKSCnHqfckQoB+NWEDnwBrk1DbvC8+RgtxXPwu192rOCvnrr/AFWj4bNbMIB1FAWlH+PEUZ6zPL1VOMfO+ca/RRH65WC3Z5vvNZ+uRNSFyIaVavlguGHhJfjy1i6kka4eWceLlZQk/DWpt47Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Xn6fWkk7; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Xn6fWkk7"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4852c9b4158so48146365e9.0
        for <patches@lists.linux.dev>; Wed, 25 Mar 2026 03:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774436160; x=1775040960; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6cS8MLONKqJ5qnXkc4uPkwYfi3bzAQ6aZbhxWDuF/ZQ=;
        b=Xn6fWkk7BXboeL1mkcEgyglzRGLOERoTWiR7wVvGLjRc7v5dN3tyrOPk8C09otqg7z
         IL119HV0YywBuXFmZtrqk99SWxFPJ7VXRDBcO3NUHf5KRsUstVTqZEfp9Psw4tiONrtH
         Ef50YazNkCEA+vm8dacTMiEMnMndcr9142FWFXCRsOm0VnmKZ6BEwp7M+vLttoWoQvVE
         U8wGTm5OHMqiTmgPH6m3lgm1q8W7w/fHTfsEfff857hQ5Vn5PvtjVgxzd8u0iM2uu8i3
         eoMCAjCxoh9EfnD90sYalZNrwjmEpl4mAtrl6VuVY6uwjWxmDRH5hlXz6DXFHTzqucWz
         Gm6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774436160; x=1775040960;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6cS8MLONKqJ5qnXkc4uPkwYfi3bzAQ6aZbhxWDuF/ZQ=;
        b=VJmI5Q85fZJpGyHU5t61ixkh4UEg7Js285DKaq76WqSfJDkrAIubW2cIAX7q9/WtBP
         2tT1Q9j/vgsxk/07cI9qHysSI4k8BJbIvRWFnUD84XVTciWnl6+lOZLXl9l+gLBc3djX
         njvBzEAbV6oCVW+ojtFx1FF8LSCyFBKnn5XXr6+xNgosh6ir1m7mX3DAGDiR4O13oEQO
         8ENPlBJrz2Q1MTyJ9n7RELzWbWiIi71OOp/RlT/ij4H45w/7yDR5XQWX87HDky6v/W0a
         FZ6vwnld7gEpyEoGDH4XNqQ5jp0Y4eh+p9wONIud4qqAmJr2D/w/DLxM3hquLNTPlTWz
         Y2IQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRjjJdYU7RofjntQyNfN+zs+zd6U/t2+4TwYIoNgZisWyhz9L2LQICdWHHcB+p7sTL/NviRdH5@lists.linux.dev
X-Gm-Message-State: AOJu0YxekHY8u7mcwyA5O3sSxuKb0+ILZrxoVdgPAT4Gv1FzzbLusOKV
	GQkxrDPUUFQcRuqM/AtsOD6/MqE3lMuoZGLI9oV4v7T4c2Q6rsOhov5hn0vXbJGDIGk=
X-Gm-Gg: ATEYQzwEZMGr8mTxT+sMZ7aYP96hAeqHQHCBwm+YIAxjAtZQa+5Vuu3r7N3pFsiFoYf
	2kiHCMRGtY/k+bxXcXlN+mtEYN1c1R62GvGUq0aNz31bqf9wy9Do+vJqdlLn5vk20B4ouvB0uRs
	QIBNJvFhtd9WMU2F4MEbjTXjlA0vNoY4Y+UAwQ97UhTXx4r92BD33OkgCUqhHuGVj0v0D77rwHJ
	b5X2kSBw3C50F8RFwwUuguUgSjn1rNUfrkIDcHzW/38Lh4nauHlwnnMi6iA5jOsjhysNxFt5drF
	mpyPJE+Vdsk+xh72oyS1ZMNXk5twlKyt21L0OkjtzRKddaOwT26RMHoPJbHzGMUUjPLGnAXkvLx
	KqiEq0jBXgZwDUwVsqW6GZujQwDlkXSJ2qURvexOkF7LKiuxqZpkRciGhzyfFV4KvmdYFmu6uTK
	Whw6I1KVfBPYDfJR6Hsg==
X-Received: by 2002:a05:600c:4f53:b0:485:531d:28b9 with SMTP id 5b1f17b1804b1-48715ff74dbmr44190865e9.14.1774436159850;
        Wed, 25 Mar 2026 03:55:59 -0700 (PDT)
Received: from u94a ([2401:e180:8d68:92ee:b67c:a5bb:13e0:f6f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c0e919be5sm946775a91.3.2026.03.25.03.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 03:55:58 -0700 (PDT)
Date: Wed, 25 Mar 2026 18:55:48 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/220] 6.19.10-rc1 review
Message-ID: <v5jifek56gr5vuh2x62uwq6eqxercf4ntfoil7bgwkcyaph2ay@lrgoyh2c6r4u>
References: <20260323134504.575022936@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>

On Mon, Mar 23, 2026 at 02:42:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.10 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/23507388452/job/68418868804

[...]
