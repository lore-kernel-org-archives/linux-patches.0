Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29D83DB646
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 19:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776800131; cv=none; b=BPUJrh9WuVCHKaaJe08aFDgZVtTxRPV5fB3MNzN/Y7Tp1RifZXLbwwZjD414p0OmVEoaDkd+khSIwYMwp86cVB/JLV3D/wyk6ooNNP5JSG5FHoww27JjhFBgJL7pMkZyO4WUMwd5quotvKH5ebjek4tASRMWH1UNJuX8FnnI8P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776800131; c=relaxed/simple;
	bh=ze1NjMvenVo0wiUNIk22Td81LHPfr699YVBOGRCfXQE=;
	h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=TmFvmqnFThv3Y3WMH+AMNL1+HadXllRGZAVGj6uqr4b1OEWsPjblscYHyCV8W5alT27WuxxtlKXs2x+wBJwy6fvi2cAMGKjJwBuB064pik4Hwm8va1yiXtApvJMAReHvqZGa1LDuFweygFLXsS2sIuJ4voAQEdPSR8Jmhe4Z8ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sfBsUb5N; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sfBsUb5N"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48896199cbaso47487695e9.1
        for <patches@lists.linux.dev>; Tue, 21 Apr 2026 12:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776800128; x=1777404928; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ze1NjMvenVo0wiUNIk22Td81LHPfr699YVBOGRCfXQE=;
        b=sfBsUb5Nv4wXYJu+7W/6v6l62vDaNRsJslxYR4e4pN2UQgTZMxgU1JpuzGuNhFfNwB
         L9oovNtgOS/Gwuzl5uO2C1AYS9j7Xf3H4JhvfPgvvxhWd24R2Mf4DdvDfcWlvD9FpvLG
         2aGhBWKfAA+rsKf45fcGSDkAifC9Q9Nd58OU1G7EySBb4lDQUcTqGx8vj5fctDpKx3C6
         RvZ8IvFlDwTtkWQUx0HOG22DymTL3CkGWwN94o/MxUu0hVmSFAcWRjKMYMPrwZ6KqkNI
         IqytDPBNtZOk1LtnHk/O1d2gsLjCsC/1NEwMfwyDE/XOShGZO3Nt2xkwEEMwFDnKhTSs
         kldQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776800128; x=1777404928;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ze1NjMvenVo0wiUNIk22Td81LHPfr699YVBOGRCfXQE=;
        b=BV+SQM+nk4S4AN5/776KPzJj/5YzR3iZGW94ncZGaeUz+zl98mTaz9wCCEi8GJWNxR
         PhNUMt5TGuItGrr+kLNjyCFOesCyWkomZ1oV2bNSEFEAQNh/QwKusSFLMoGtDMs5totJ
         l7LvXj1A/wzP4kaOzZIDuopurFRXe3aWvtja51jygbniwiCKCWTBISjkFHdqwouaJOX+
         tU5ygAi0NfzCviSF6tqZrlrV9+iVBYhag8ux9uUQQ3Q9A2Jr5720AKIQV3omrS0LWMRQ
         ibDLGgSJWsCzKKLoTXxshJOFoyo+MaCvmJB4dnb4MfK8+Poj4cYOlLwmmlkfW/tcBhh0
         1ZmA==
X-Forwarded-Encrypted: i=1; AFNElJ8YCNhKT4TQyveoeAoVdoO6Oo9EYRQmx9WMYtwD5bjo78vhyZcBAqfU6bM3WU0bbsipVqeKwijs@lists.linux.dev
X-Gm-Message-State: AOJu0YywTP2sNtHsE79WgwVhhuOWTWhtj23uKBE8A5ON8RKyshpDvLSl
	j92C1U2/n2Jt9xZjay0+dVkyaYp9VtTB6cD6H7lmDsT2JrpWmI8dRfsu
X-Gm-Gg: AeBDievdBJ/SZ8oizds5EcwXZCBMSgY+Yd8iLCC+1d78dyUdXEOc8YSnq682hhxG6G5
	i1kGd/ZnYp3sZMK9hptq7FFHhJ7dkD+7k+MkE/Oym/3qpoRBZxFT8wOMRrv50OVu63enD10BjQJ
	9FI0ACWu2rsSQIg/JKRpMQoBcTzc/oZ7J/1vhcOm1RGCKCx3Bcof/dBptEd82ja8C9L5vaYizGR
	Cr0G9ougqvu1YTWWUUp1Sj395a7x69cCkTcZ1snkY6wO2PCf7kFthLS4+UJqVvpjxhWeT67JKPR
	ImlC6IhMLujJMSjnBkMoPqXW79Uag4SBUyMUvmbfkhTvrfhimVXABwdPtCOySZEINBZ5cPG5WVI
	GKTaC1IHzakvEdkyomcsW2LHo2qdn2xpuWeePnCzJp5sl/CWASmAWT3AuZDhdib+0csMPkhGWnL
	0DbRG6fCUmFEAGRDYorF+XcWT0e8ynq0ZaNaTsXH5hgd3GrPo=
X-Received: by 2002:a05:600c:4ec8:b0:485:7f02:afd5 with SMTP id 5b1f17b1804b1-488fb755caamr293169705e9.13.1776800127824;
        Tue, 21 Apr 2026 12:35:27 -0700 (PDT)
Received: from ehlo.thunderbird.net ([2a00:23ee:1cd8:1171:2646:73c1:cff8:b7c1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc17f642sm357665345e9.5.2026.04.21.12.35.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 12:35:27 -0700 (PDT)
Date: Tue, 21 Apr 2026 20:35:27 +0100
From: Josh Law <joshlaw48@gmail.com>
To: gregkh@linuxfoundation.org
CC: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
 conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com,
 jonathanh@nvidia.com, linux-kernel@vger.kernel.org, linux@roeck-us.net,
 lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev,
 pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com,
 stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
 torvalds@linux-foundation.org
Subject: Re: [PATCH 6.12 000/162] 6.12.83-rc1 review
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
Message-ID: <9F457CBC-139D-4736-A9BB-7B2CD80CDBBA@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

All good, tested on qemu X86_32 (and 64) vms

Tested-by: Josh Law <joshlaw48@gmail.com>
