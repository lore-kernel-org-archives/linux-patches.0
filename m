Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062511DA31D
	for <patches@lists.linux.dev>; Tue, 13 May 2025 17:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747157270; cv=none; b=fmrTqMTXMF95DaR+KmaIikhpbP5zr2DckSMmE47hMNUNmp3iUgiITTREeMrF0s8RIgybp3GGy3YdOTu+/sETSRFNqF1amSoG/3LAW122aB2+jeD8Zr8FGESF/7yO97fZ6ckzqsL/aJCFzOuipn0u7imBdmP8e8qD7OA5nGrED6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747157270; c=relaxed/simple;
	bh=FH/Y6BLNrOTT9W7duN+j98E3MgnT28o5K5q/3gQVaYw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mMU7ktAHh4ItRi4iqj0TQ35LA1XkqRLhIdXhER9CQpaT5ARbQeApNdUMIHFS8X0+09kaWeiH7dCwRvvGGwL4IYlL/jYBK8aUWZ3vtueji1lcKwdlOxiErBNW72KNgkuEQv1rhhwLREdRxpsk46ixKetrvhxVV46NF1V2GxTFRRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=LbGU0nFL; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="LbGU0nFL"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43edecbfb94so60732705e9.1
        for <patches@lists.linux.dev>; Tue, 13 May 2025 10:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1747157267; x=1747762067; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hFHTl3sxSxODJRQX3dUP/vUJz2dgKyxhXi4v/Imnz0w=;
        b=LbGU0nFLs5pdLxBOmL+57qFyEeF9ttmfjw0Kjnos+U5wphnv+1LW1S4VUToDYf9J/H
         qIBsd13QBYrMUU3kRjZPob75/EcEepivrEqXpGpu96GzBPU7sZFNdMqW9GiPe1wf0wrv
         nqnyA0pVLLhACTL7cdXflKJCgJUKEiWnEyUXKWKWAgoPwxRMc307qWs7uLB0+7d53WAV
         DTw0zdZPchBN4J5EjzFsq78GCzNWJz+BH4mCxQvLUfvTDKglZCKSrfuD3WyRYK/SwKUI
         gezEUtL8QnUcM9o10IjFcRIHqqOUXSt+JpRIhKJHOebFKbsvhk2hYGxzYTaXYQafSRyG
         9SJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747157267; x=1747762067;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hFHTl3sxSxODJRQX3dUP/vUJz2dgKyxhXi4v/Imnz0w=;
        b=rCo1v7xsRfZ2Ya3FmAK/6ZjmrrkVwsRtAqM2VaerCozLFQ+gTLiKTyDHD4WvWiU7EM
         CCVHJx60Eyb6WiI+7dkJ+rIE013eNOnwTRgI2r2loG6ytSKOU7enJoX3MhResdGd8T7Y
         Yda3Lz+j92kcxkBay2yrnJml1GKUeKZXbSHagOROrsq9h0JlX8TH3LZSLqesE/DycCaE
         AR6P70hi91L+bWMFJQwwT6W0FzAK+uqz40mhtTQwbPVEzGA02q2I3FOXuAWpEfO1xmnQ
         pyQRqDzLirXhYSOXijxunSvDOBDJ/Ib81Wgzdf6++rWRcWrTkv1R4Z7/im1RgxDvLuhv
         86og==
X-Gm-Message-State: AOJu0YwQZBtcgmH7//F4fR1wKTOifOMVIxUMS0gGw8GLc1U8akYL/BaX
	HF4IcX5sX/VPybiBuKVEK0ReP2r7oZCBKOQ7962MOj/dBhI9QAM=
X-Gm-Gg: ASbGncvmiRFULzPrjb43A37ArfLfZ6+RjO8YMuVjaY2wzAQxFSSwTmCD4/870DKRaXv
	QWoRxiT0agUdxoiEoZUDFePE7fyU5nJaJmCMSwTWTrbbG0ok4RUGbZdtmDsYJ1kHLmQR3MQijjm
	O5S7aQgBJ6ixkWur4Y31gHYU6+Qh1lAue4qFvBX+TixIoAIpMwYgkn9wgwl2MPn9vdBPe/7s+p4
	QeoURVHREwNXhcmkar/H2OTYrB3au1dcpkjiIKWcxVFcoE2/xMpJunL0K4CcI9Dcc7HRW/uG5CB
	7JMtQ9nAI2Mj2tozqicqzlJZNMIhd7BUSwQZOGWYU8ButVLG3johHYQ3uH3vbMU3BmSJ5SnU3Ei
	3mFek+9m4adsMen+UapU/XmsenBtw/hJwZmmY8A==
X-Google-Smtp-Source: AGHT+IFegG3B9AB/jeEdVB8RF7vW8stTIvGIveMzhDquGXnh/dkqV/LjdBREIB52qYe2+5DtyQurJQ==
X-Received: by 2002:a05:6000:381:b0:3a2:229:2a4d with SMTP id ffacd0b85a97d-3a3496a49fdmr126321f8f.22.1747157267140;
        Tue, 13 May 2025 10:27:47 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac006.dip0.t-ipconnect.de. [91.42.192.6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f57dde0esm17197357f8f.18.2025.05.13.10.27.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 10:27:46 -0700 (PDT)
Message-ID: <7e1d47bc-a30f-45c6-9f14-820e96f144aa@googlemail.com>
Date: Tue, 13 May 2025 19:27:45 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250512172044.326436266@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.05.2025 um 19:37 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.14.7 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
