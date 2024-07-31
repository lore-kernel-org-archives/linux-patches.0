Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFE81AE85E
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 14:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722436979; cv=none; b=VnYT7QpWYDRv7XSIlUWxLr4l5Ve1RP+GDTmRoaGrIe+wuY0OJAA4JUpGJ75K8nC8qe0I4fwK1B8pmBF2t1OyRdidQXiiBnAnwuJYzahTavqmcm1roZtiTKq6/iGtEwzm51eykwhHo4foB6JYkEbshHX/9Hs0+kH5nDZXLVDe1YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722436979; c=relaxed/simple;
	bh=03o06WRPMECBH8cNLsTZ+D+b1SXhalEQ2Hoe+OeZjbE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bF+FcPYFzdecnK96YWxHHYzbLu1o42MgpcPSe8v+amrZd+2cg5ijxRhUuGzin8dX4IoHG5J+8UOwSMxyND9LfyzDCdSP7CZFTdHzTAnjFp+NC9QSe2GhKz2Z2dhVBOJSskYrQpnGfAqV1wKGVnzSnV3GP//FmZdKdxV5Io97dRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=FArfMgQH; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="FArfMgQH"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2eeb1051360so64583771fa.0
        for <patches@lists.linux.dev>; Wed, 31 Jul 2024 07:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1722436976; x=1723041776; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7+eaS7WmK/h+AxO7xK0Tq5m6QMfSwjAwlMf/qchy6iw=;
        b=FArfMgQHHPm8nPwIpszbktIpF5geq4fVsv2AlcLFSaBj8PA7MU36SMu0K4cBk3JocJ
         9yr22S5P5q5hs4Q0Gyd4lIoURbmvogzWRK2KwZXX4Tb4SzndYz4N3BMtLZVlwvlHkm2C
         rEN8aaXzWzQvGxmVcPXyBeTgN54lrCIw6Hbo5M27CFHNak9pOnj3Tpy/2NuTY5aH+LYB
         EV1/9p70FDgSNqHl8x33Ke3ibSw2Zm6yuhCBoQPHxwwdbyFBWQGY2YBW9Dk/wAYpDW2D
         8IMRQMAEqIeNaEEhxYrgg1ksQ8uwNs7mF967FgJ45e4J97/rYIgySaryFwGQf6oz5lr1
         PDEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722436976; x=1723041776;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7+eaS7WmK/h+AxO7xK0Tq5m6QMfSwjAwlMf/qchy6iw=;
        b=PGomZU5xzeGCPNjm1MYkv/3yFIuOYdRGD+yXyt1JeZD0BOAnhWlWLcBAClwFnByeTB
         uhlmWMtTXXFf2Zzn4eZVChF5vEHHMki7QVg6yclddH+LgKw4wT3rxngNNB31NFSo2sIk
         p9TlPhFuYEMUDWudVBR1LkbF4EYeimibLFWstTqLrUz/3rfajjoEF5ESAlvuljw9NlAa
         /Jx6OMZguSpZaNPD+tfdekkgytq3HBDnM7Y5Eb2CYbmL20HFrc7/7XodDw05+LgAGW0j
         phT4T1bbbcBJMiFMIpS2PpoYJUnMoq86TYsLDLctbgm4WS97B2UMagaqFC4IBRZUQEyj
         vsVA==
X-Gm-Message-State: AOJu0Yz36hqnb5rQkLwYYyh3v6ibwFUsLTkEgPNzww4weGthHcj1TANZ
	PoBDcFG/aKkJSLMZ7rjIwj5sKXZ9EPZ8HMfKEignc1yrvKaxUes=
X-Google-Smtp-Source: AGHT+IFXclmu5DEIX5SRJTwTFkq5JFNwJWu6kCEgvQ/1i3mVfeno0N3amnMwKWgaIPb8PCQESr5PZQ==
X-Received: by 2002:a2e:9609:0:b0:2ef:2a60:c1c1 with SMTP id 38308e7fff4ca-2f12ee1663bmr90480651fa.21.1722436975606;
        Wed, 31 Jul 2024 07:42:55 -0700 (PDT)
Received: from [192.168.1.3] (p5b057724.dip0.t-ipconnect.de. [91.5.119.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4282bb6403bsm24239425e9.35.2024.07.31.07.42.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jul 2024 07:42:54 -0700 (PDT)
Message-ID: <018c2396-3a00-47db-be60-4a49e3668a9d@googlemail.com>
Date: Wed, 31 Jul 2024 16:42:53 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/440] 6.1.103-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240730151615.753688326@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.07.2024 um 17:43 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.103 release.
> There are 440 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Aug 2024 15:14:54 +0000.
> Anything received after that time might be too late.

Just for the record: this builds on my 2-socket Ivy Bridge Xeon E5-2697 v2 server, but 
fails to boot due to a kernel panic which others have already reported.

Looking for testing -rc2...

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
