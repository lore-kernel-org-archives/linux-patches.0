Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDE875817
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 09:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718012634; cv=none; b=o5ieSS63Yo3ZtFyOw8tNk26H669c3kW9uPeOP/W+8N9eJt4VQWPM3wiF3Voch7oJ7mtlr/viUQIy95lJB86W1YCD79AdqbmvwPNr8ApLs6h/War5FRsNckWTPlEOBnyj1zrj6UzjRMM0YL7h76jNEm+PfAUmreB3hAqB2Jaw2vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718012634; c=relaxed/simple;
	bh=bS5RlvgxIgcjRqjmYWH6qB32WZu/LwYze/3RpeQ2ypM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L6kIGiD9T7hRlKKHbj2O5KUn6n24oQx3Bv4BK1wahsMz29w/Mtw4pvsKB5VJ7su3E//ZaTXjb34PVQ+TKY9So4KilHBlaBnITa7V+yXqR0ejrmUs7r/h8iUDHDHxkOX5gnD5daVUZXQM3uXOXngV+FTgKAzNRcCWyVEf8zE5i40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mvRmQa4q; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mvRmQa4q"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-4eb0f868f2aso1416623e0c.3
        for <patches@lists.linux.dev>; Mon, 10 Jun 2024 02:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718012632; x=1718617432; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xjhpNNupYWVZWKcUvHP1lyKNkdexlWuohzaYbXqZdQg=;
        b=mvRmQa4qIAV2BQGwzbSK21hyEdT3ixL0J0m6oVH6/mWKiaNIB+FE42Cme6VnRglGgq
         JrI0bN22BD2crlNpyyk3zwsqWwtO32UnV3AzezQ4oCfR8OT5DzclVUOTCvLO1wNUVU1F
         a8BN1+SzraAggpPJ8GtG/2Qp7gk7Mp9To552I6D3Aa+KNWvtILvpC6nq8F/Ova1Oo4YB
         K56821SM6VfaTmPez8tq+MYlIB27dbVUqWYgHsV93CwFHfFUq0pTQquM2K+iji0jx9D6
         0u5mEXZ4LxxpK5ZW162LLqPi85z4yKV2RmoN2gtsyTkeRYoIIXw9caklWBp5M+HPfp4P
         J3fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718012632; x=1718617432;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xjhpNNupYWVZWKcUvHP1lyKNkdexlWuohzaYbXqZdQg=;
        b=fno0swVG+TUkynmyUxRsezsIWNbZxD6vF+opjsB2MLNyat/U/KffGZmqoYLKpmF9PQ
         lWsLdDlQ66xWVg2pN0bqgFaLIt2LfTSY8ohzZ2n+Cxpnl+HvoqoS/pI4C5JSVpgSAqkM
         rAdAZaHPHCryHVilNZAvr4I37obsB3lEk+pAANIvKYM8PYHH1IyJTd2rlS/KLEhM5WF1
         vmZJBXgI6pvOU1ygDvK47sZ/ZLHW4WDqVwWVV4GdeTEmFjR0nlW3zCbKuIBqOoe03xDy
         W8JfDykFZeM3jxL02lWVoonXVaHnZpvCAEOtgFxUah/UcmjxFfCKSOzEG20WAq9mEfbt
         xi1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWv7hd/0az/9ynDPf3qqrwoPQJDB3ERk9L3ds1LCMb0oIXFf8QW3rLETaQ5GHwDMlLH5ki8EiFXfHvfVpzxgK326O0r22/KzQ==
X-Gm-Message-State: AOJu0YzB4+noMG5HbW/Xu3cKEjYzyKPa9aZ9BEN3Pn1JVQ3ingDxOyiS
	7AK7D+prappINDCjYsGEmW5Zl+jminR0wkcDdWYdmb7nqpxcPmZrLz1AVhO/paCm3zaFZCXXbiX
	TCxZQJdYRoFr4WWWF1K+dgEzSE1llUeUd8G/6yw==
X-Google-Smtp-Source: AGHT+IGsldTxg6rRfZyz1ipYFZ2s2KO6v7Z4ILO2JX+E0oYUdd+a45WFPOs1q7SluiHdxBw4X8zaRbxU1Xtk02Z0Mks=
X-Received: by 2002:a05:6122:1799:b0:4eb:5fb9:1654 with SMTP id
 71dfb90a1353d-4eb5fb91857mr6829841e0c.8.1718012632207; Mon, 10 Jun 2024
 02:43:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240609113903.732882729@linuxfoundation.org> <ZmYDquU9rsJ2HG9g@duo.ucw.cz>
In-Reply-To: <ZmYDquU9rsJ2HG9g@duo.ucw.cz>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 10 Jun 2024 15:13:40 +0530
Message-ID: <CA+G9fYvW+FmBVJO+3928H8_tBKKLQMa9bBdEKnUMd56G0f_itA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/741] 6.6.33-rc2 review
To: Pavel Machek <pavel@denx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 10 Jun 2024 at 01:04, Pavel Machek <pavel@denx.de> wrote:
>
> Hi!
>
> > This is the start of the stable review cycle for the 6.6.33 release.
> > There are 741 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>
> 6.6 seems to have build problem on risc-v:
>
>   CC      kernel/locking/qrwlock.o
> 690
>   CC      lib/bug.o
> 691
>   CC      block/blk-rq-qos.o
> 692
> arch/riscv/kernel/suspend.c: In function 'suspend_save_csrs':
> 693
> arch/riscv/kernel/suspend.c:14:66: error: 'RISCV_ISA_EXT_XLINUXENVCFG' undeclared (first use in this function); did you mean 'RISCV_ISA_EXT_ZIFENCEI'?
> 694
>    14 |         if (riscv_cpu_has_extension_unlikely(smp_processor_id(), RISCV_ISA_EXT_XLINUXENVCFG))
> 695
>       |                                                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~
> 696
>       |                                                                  RISCV_ISA_EXT_ZIFENCEI
> 697

Thanks for the report I do see these Riscv build failures.

 - Naresh
