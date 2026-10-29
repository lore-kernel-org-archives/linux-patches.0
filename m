Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793288868;
	b=rsHRv2gNp2583nlbk7gckfs6X/IG24ZAncl/edPrZS09Pms8LvJ2Gzsx+TNpnTqgz6d7
	 7Xg8n5Ofyl1yBBStNrOH+P9TU8h0aqB1EkHQ2xB4Grm1/cYbxE2WN16tyYMdjUFwivKQ1
	 9AKvKVLET+tPZz50/g9YflxH3IP64eZ48LyIKEnfQL7Iifud3dU+cKGcQEOKzmlTzRXcO
	 9/zJ6fmy4d7wWK1Yjf7bMJ02nua7GLCF+btn6xaLsUkJkH6MvJRkVx64ac+YWQfuABmii
	 D4lHKbc4vM7xwnoDIcaon3ERXQEBkdy6yBSKIME4+a3DDMLLYlOxR/KdHu3xf9yg5ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793288868;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=H4ycqpfgZiGJ+RxRGCxitL2+CHZwQ6ss7LXiaKzsngQ=;
	b=I2tG5PyUchsYWU3UFY10Gc1P9bMLd9v8sxp+71Q596zTm1Zjzkg8z6Tb2ZP63OFBeDEC
	 4d7UiKrHk1K2be0s+PumY1ckJ149s3DzTKGYthJIpKM0Pkz4IN0pW4nC/vnUhh9E1+njn
	 fNw7sTwBwHgnEw9TyMfuRCVB4Zwdo2GWkAQPBfW0wPt6HI4kIOtzqIjpexyCmL0e39yia
	 QG6IuALQlwdIDDDHxOSd2SLaMYO6ETpu7naUyno64Q0GUV4G2bc0DwGm2lxLoppaCPysE
	 9BBU7PTgYePNpA2BomeY2/VaKaC84E7R856ePveXsXMy/3mNIN73LTj+n0Uc8ejVU6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=PuqPBf46;
	arc=none smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE953606A31C
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 15:47:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE953606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=PuqPBf46
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b486e1d02eso3134984a12.2
        for <patches@lists.linux.dev>; Thu, 29 Oct 2026 08:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1793288866; x=1793893666; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=H4ycqpfgZiGJ+RxRGCxitL2+CHZwQ6ss7LXiaKzsngQ=;
        b=PuqPBf467iQ4Gxblzkia5Dt0v4UEo/7ZHRKt3KJwLCyn/BKN3Y4aPlbMpwzks8V6rj
         n9pGVyx7hJUmjae10P5OTGtsy7PwqzSu7duReo9aY0TAo6SpyK2SI/Jkzon/f4BDRW1C
         c3rka1eGUrjp/+MjwvQU5Tp5VYcbQJfCw7jXD1GGjXf2140rczXhKBQO2RlQfUyvYDYi
         NoX7oRVx8HTKuTsfIcYv/vkGACpYCUkhZpg7GUa2cO8ebRmQnPTGIlNf8sBPqHfqkNiu
         /XyYUs1/i/XiF+CpGqIpY/i1iHC6zq0dCRiQyfBafsKkdiYLuKX9Tu5T/Ad4j+umkTcq
         6n+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793288866; x=1793893666;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H4ycqpfgZiGJ+RxRGCxitL2+CHZwQ6ss7LXiaKzsngQ=;
        b=Gc1Yeix/OZN3E3tlClWQ0NqEKHf6kHFhs+qzxcNtwZhbpiWUTZxs/7yPN8ni9JI8Ak
         qZIjMiyDBrlqNk9zd03IcwNx5KOTiywwRdnO0BtbzQIuo8C/HvSNbM5ArvMbmSsqlobm
         59j7tv3Xxbq6+Y5hZ4DC9zeYQQwWIrTiRkji97pr22G1nmSugY2zvIdFx4vq7coFl2Gr
         0OxN/Hj5O+e+3+Hcx0MyXGkzfI4PvZTb0HSCFoZnAVC36OPOD3tUOK+7mrb3SLqQN52B
         NOj/tCmcAGfA8EkSrMHxzlFfqQG3zldxnMfXfUUy7K9Ovdn7rxjAxRm1mwwpRgeN7HiT
         6vwg==
X-Gm-Message-State: AFq9FYIaFziCEzBcRR/T9CgAyVkHHh+Am5adCPmprRn1etPsKd3q5u8r
	G3k5OqBoQoWqX9Lxrtc96ct3Ba+RMgSdQ15dX0tQKFEOK4QknG9TrD8=
X-Gm-Gg: AYBFou2jl6eC6PmIwpeG5rbj1dtUzrf1M8qIvFf/V38nHZ9VI2tTXrI+oaQfUEeaxBN
	2Wxw60ROs9aRKI3fnRsaR3JSWnvnsBcCQ/acfk5BXxo3dBqHfmaOo6F3aJy9i6Egj6+4EADHxfq
	x/FY+czEUA7OsKGiLSWCpMzdkBqsU7qIASQkbvb9lmQ3S/GC9m4v6vODp/nYRIq5JxcQIgWA/Vj
	vHxpbN07bM6W/LXQshCkZo4poVy4UVGAP4bKStsZllvoZQqgvUVZpb5KElTtusVphouCpKT1lzf
	B7f5JdyhKQRw13/vy/WNc8HYM2Bs+vJb7UVV365wGgSlGGSUHUg70qWKeVTzmCC6CiGJw1qugjm
	HNHw7T5ZfPwBMZTnMpKIZsySxAbLss6sSx1VeP5iKRH1mkb6LCUlmghNYKBbfUuVG3IpoGraDGf
	AmiZG4+iVN8hJDcOslFzKd5EKj8jLMK3VIHsbPDlXB4d8+eGav1BJxolqdMbQOLZk/5QJYh/PjF
	QA0iKodNOqnCcUnCCELTd4pfVNsQsU58h7CvKPTuQ1SEUtrRukld+XKuzQ9ySTo4JV+d+S1MutL
	Vjrq5tvZYrymh3BwRGG06QvOgHI1Ox40ODrA4rzaQHrsAQwWsOwURe1cajlxU6r4zSXRECtiHlG
	ODfjzdw==
X-Received: by 2002:a17:907:6d29:b0:c2e:3f49:df04 with SMTP id a640c23a62f3a-c49bdb68d6dmr521364766b.1.1793288865850;
        Thu, 29 Oct 2026 08:47:45 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac3f1.dip0.t-ipconnect.de. [91.42.195.241])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4ca27a05f3sm6802066b.81.2026.10.29.08.47.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 08:47:45 -0700 (PDT)
Message-ID: <f16d1c32-8b05-4046-909d-ab7c9da92464@googlemail.com>
Date: Thu, 29 Oct 2026 16:47:44 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 0000/1879] 6.1.191-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261029073135.159947193@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261029073135.159947193@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 29.10.2026 um 08:33 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.191 release.
> There are 1879 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or 
regressions found.

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
