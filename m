Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966DA1DC198
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 12:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770727973; cv=none; b=MmwpgYAvEQfuDfenZ/kdDqWp4HoSDTrgwRT/HpH4iixz8kXnQhAlB2df4/eGe7bLa82pCuXGR70k/eXyVJ1DDAf/Josp1QQgqR2TOeyeiaDih24Gb8ms8YBZxFIb3vKOgcyEVZF003ExrIyl/ubgAfDratqzvs3sgotMiKHxFwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770727973; c=relaxed/simple;
	bh=1DyKn3UycXsFxgMaLuLclJ04D3Ikzr1+OHEY7VyXY8Q=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=fLz7plW5slVgPScbPFLZOl0cDDh4nOO2HPfdyV/lYq8J2zmXM7DFChiOmjGHNqmBHRZorsyn4EiRH/5jtVIdTQJ7MSjHLuGkiZIWgyN9rsJN30yDW823+IhjUOHa2zF79fdsdqc9oAzcFLOlNpihRgyZg2n/gWdrvlqusuA2VDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qj5qdh81; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qj5qdh81"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-896fa834290so30067036d6.1
        for <patches@lists.linux.dev>; Tue, 10 Feb 2026 04:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770727969; x=1771332769; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:references:cc:to:subject:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qJMMhftj/EXVrtTr21H/s198w+Mn/XzAcQ30g3m1lVY=;
        b=Qj5qdh81ueetUchmfJtyf6dLR+p0utWVajToL5PvzrRBxmy+VNa8bS9vUPukHTQavt
         slWW24EbnR6bE0dW1hLL0qSC7Vw2KddO/KUas9gk84gSYgDs4z+RLjUWB+XFtpkFusqY
         AlcYAcv+e8M9OdVdaY0d5yd/mJAx1dGjsd2pfGu3Z0fpfF4+xnSJhM31aDwlslFqXxQk
         NGF9LjYCwxfYSejbDaiDK1EGQ4l7eWliKZ3hcH2i/eHHJyrXC5HQawgLx9YcLV6P2+90
         /+droBOaEN0WqVATu5kFJO348BCuSYteRhhMFUbJ61nta1KTxZma6oaatQWgn7Y0VFoy
         ufJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770727969; x=1771332769;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:references:cc:to:subject:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qJMMhftj/EXVrtTr21H/s198w+Mn/XzAcQ30g3m1lVY=;
        b=If36hoFkSzCTy7njAHW/hSD0a2hJw8IfPAfH1zx9WXYu1w4GH8fAIK/rqmS3z831QR
         Y12SJhLMlLsAy6Wl48AoAgaXWH8bXEqg5zWQ+9EHDu8AGlYVaNEG+015d4sA8sIC3U6p
         VaMIo/xOBFhwJN1QJHcI2riQ8PJMskqMg+WSitLQN5Rb4WBi9BJh7RcDyhnxSUGpXF1Q
         XFh3vWezG0zfOSr0irDrPQ9YgSydfTryn+9Xy6gOSn5AyK39bmRKwWEzyE7fvXHsriM2
         k4i2vevx4PPeY0tHheZ5/SE5m/NmB+A3ojoLMhqOknKofoxjdNZI7qc6rWe7iBV2WpmA
         oySw==
X-Gm-Message-State: AOJu0YzhyHNqEW3K1S//iKi3vDHZ8eR1iel5Puqj7/mm0CsYm85iGoPu
	rmYPGki4TfFvSMgorIrNAL9Jqcu3VA1ODVj5R0zlWC4LQ+4av+Ag8aM=
X-Gm-Gg: AZuq6aKkwFviDF/m0IdxLe9BpRjmzE5H7w2wbd48rUwsLH6jt3GHcW5F862bs24K8Q1
	7L6D3gXT2CdDM2MgPnu6zlIYLxrMecMl4GPq86tyO0kAaQ6MQwXSlSrFygFGcjZnERdSdHfX54N
	8U6AFZLVg/YBVRwRQbt4az9HAk6WUJJrqmAMGmmBNerUmO3u6HcC9kf0EWlr6DylERBK+Dzxcvd
	8GPOfchjzWvMMcOXsxRs1DLfNWmmgmr9ztxOMt4V1Y4xJQ1q4BjfpgnyiEyUNx74w4gCBqw7RFM
	3l1HpGrTGBfV2tLqBG4B74wteN0L8qYwQjpTDrH2bksA9nGiXSV798fGs0Uv+gBqm6sSik5JmQX
	NesedHtjIUKMDpySOFMQovyay8nMMVBuOiHI5ArLrI+FZn6xRTsZ2x4+YscGJCgseDGbGSEthyk
	2G1WsGtRiGaqov3gMfMZ8XNdta/AmjLWHl8BGYAKn238E5YT4g4ieO0GbA9Lc+yg==
X-Received: by 2002:a05:6214:2429:b0:896:af37:9594 with SMTP id 6a1803df08f44-8970d3b4735mr31026316d6.9.1770727969533;
        Tue, 10 Feb 2026 04:52:49 -0800 (PST)
Received: from [120.7.1.23] (135-23-93-252.cpe.pppoe.ca. [135.23.93.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89549659cdbsm79024856d6.13.2026.02.10.04.52.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Feb 2026 04:52:49 -0800 (PST)
Subject: Re: [PATCH 5.10 00/41] 5.10.250-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260209142256.797267956@linuxfoundation.org>
From: Woody Suwalski <terraluna977@gmail.com>
Message-ID: <25384e0c-f593-4083-d1ec-5340fe330adb@gmail.com>
Date: Tue, 10 Feb 2026 07:52:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101
 Firefox/128.0 SeaMonkey/2.53.23
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.250 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
On i386:  builts OK, boots OK, no new dmesg issues.

Tested-by: Woody Suwalski <terraluna977@gmail.com>
