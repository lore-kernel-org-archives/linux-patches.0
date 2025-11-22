Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45AE285CA7
	for <patches@lists.linux.dev>; Sat, 22 Nov 2025 09:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763802313; cv=none; b=cEj59f/4VuTyxSyqAB5+rkBoQuUlDC+z1tSzc3vLb/DkVBirS5QCx1E6wc0ud0So8eJKVACxIXZDXskzSSa9cYH6DXMjYCwcX2fj+U2X+yaw79ObsHsqfMqZwZbNyMRe8U4AqRLTHTfnqUGS9/h8RAO4wLFjFng4wU2XrG+5DKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763802313; c=relaxed/simple;
	bh=+o58sTORT/xBJ0WeE+q4xtcaupkwBqq7A8fMCMaSfDI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Prds0e4pZ78sjAJ03pgvWQLFe5rRpUdcpZeNZDkWBEy09uvhrKmn2tEIAgWkOoVJ683R2VBiC9vpl9WA2dT6ckjmM8jD/tcDOANXkjkTHMfHRTXW01z6Qkv7I6zIqDC1CCVL5c7T94tsRyz3vw1U0H1Lr2bktYL+I5Ew5jOZaIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=gxLO5hdN; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="gxLO5hdN"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4779a637712so17282605e9.1
        for <patches@lists.linux.dev>; Sat, 22 Nov 2025 01:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1763802310; x=1764407110; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=itmDZMIfZPUUazRjkC+XGSwKghDLDLe2dKB4qRZWduE=;
        b=gxLO5hdNWVTnJ3Nyrzl/muEqbpcLrY0vX4v1AL1Z8ffPeL6Is9JAbmgaCgkicIR5Qd
         uzVhS7/KRMKrGxBaGE8oIhCg2hFoEnFc9MQdJUsCQ3qOgkFdpAGZm2oftn5KiGLehhV6
         zt0pvnGKG6jSdPBJloYq7O3CiyVLsQ4Y7RleaBq9IL5rVlaRcyrwVpXaLYca0ZDfKfJf
         H9eaJeG08RQ8VRm54hyTU5lrsJiLs7vprA0b2jfFKmnq0qiKYgBGrx0RzvKxinNWB02D
         NuafRiYH1xvQ9QtAcUroB+kP3b7ZmIdz7J8yN94pefHIaE7w2UC+ZmFGeJWeDJrEAt2f
         v6gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763802310; x=1764407110;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=itmDZMIfZPUUazRjkC+XGSwKghDLDLe2dKB4qRZWduE=;
        b=ur8nPNHSG+AQfvqm7PkWrF7CsiOYAFvYdnDVkGqgffT4dYyfoO4v2832yZGAXxtMMV
         3rMekof/WAdL1/gQ3VDIkyimpVkFp8sbqQULSJ78qiqqa+sCRw+/EBBJNriNb6EeN1wN
         gptGcu0qDrm6U2rqLCpz9fP3JoLJfI/X3JkV58gBzmvafdh1Fq2gTI1kBmkdG9jMnYbw
         fCGfSena5iZQ5oJ+v7eIxNytPs7OgPJyoucRgwVsvKTB91Uhh0DB7xyF7lqjHjNMN1/E
         gXYBB8W+GQXRye3gMApJVD7f5Xebsl8lSqcBQNphegJS2OiKNmwZbJyQuOkA+Hv2gnuE
         dTmA==
X-Gm-Message-State: AOJu0Yy1OQ/hGawQnnGlya6MV2+Tw3V3gxPQfr8SCiplAwxbvhi08g02
	xFsdfTFEjRHle6kC1S4VF7/6KgGMW8H4hjhvvvpEoTDebVtaaeDy3JQ=
X-Gm-Gg: ASbGnctRMK/sxFg7VghvGhOvT7VpYfke1l0Muq8bG4Fm7tmxsQ6EbpYzVa1mHmISYvB
	5qUc9AXJflISS8UVCnio2yibhsvTN3GxqvSPFqDjrocrIhoAE9EQcjFmMid9C9Y8sy92W2bX7o2
	BtI9WtsgKD7Xo59HTI1BlHia1SqA3qo3XJZv0UME+jLyfhgnxG3zj4O5EcWzE4meamDsnds64BM
	Jx6I2z6rqs8SZp4jiBTJTQF7Bqq4n85pbIt9AgrvqdcBFg0hdQ1bhWy22bvkJNUz/JKi680/sMG
	LHkl2H1s4EEOvExttr3JkvGJoxgQz2tZT2mHGuiB1LOJXnuX9o2ats4lgKAR4jAtKr6ZKinxu79
	+q3choh8qh6m5+I84RSJ58vRAd9171mrenB3DZeX1yN5LZliu+LWoYliG4NUpDhzZwMmonSWgPs
	6T2Iac1QNNhWyH8gzEwzv7a+O2EfiJnEh2MzLdK6c4A7bLjROd/4kwP8ciamEhXupAr/6/k/i4
X-Google-Smtp-Source: AGHT+IHuK/MNIwFGtsGOTl3BFzuHhyADVeHagZinDoohoIknS711qVlmVrtu7NTaglvI0Y7Lqm/mwg==
X-Received: by 2002:a05:600c:4e87:b0:46d:a04:50c6 with SMTP id 5b1f17b1804b1-477c01ebc76mr51757965e9.30.1763802309757;
        Sat, 22 Nov 2025 01:05:09 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac108.dip0.t-ipconnect.de. [91.42.193.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fa3592sm15114665f8f.21.2025.11.22.01.05.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Nov 2025 01:05:09 -0800 (PST)
Message-ID: <0291453f-516e-4df3-a299-142f719dc3d6@googlemail.com>
Date: Sat, 22 Nov 2025 10:05:08 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/185] 6.12.59-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251121130143.857798067@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 21.11.2025 um 14:10 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.59 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
