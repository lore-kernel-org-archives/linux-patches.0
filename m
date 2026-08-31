Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EF637CD39
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 19:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788205279; cv=none; b=UbYxU0G/wfuxkR3LqUcjWicnX2KQ9+pLOefWchUn3nmw74GgsqjWareDZR7nbCOHtxv/pLAsJaDTkujSdgRAVicMn3GpVjsb+Kz7u0CQvK3dDTIPPCBvsiUh6GHi2sg29HKr99QCQdHzrWTxUw/4k4xeJ7gJ9vxOa72xsN9VMmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788205279; c=relaxed/simple;
	bh=3lDcvEcgr4+onaFRlYHaSNZV0ZlWUMowCmDvvcquADU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tfzUOouwdzHDnDch5LkVIunozmngHynhSv3HXVWj6xKrPO2/43ObEihjY2rcGXeRqZirlmSFlT4gmFdnGqUi1UAEcSfCN3sNX5YSt6CPzxJ4krc4t/8ZqZt3rVpBHWEOics5jnTRBhONIICaedJaXTcbZpj0XNf4YgRa2VPTh60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=NcZlC2qH; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="NcZlC2qH"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so46236435e9.1
        for <patches@lists.linux.dev>; Mon, 31 Aug 2026 12:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1788205275; x=1788810075; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OhxWwWFcvK+eSFYY3JAtOiS/hfjCxl8syl0ArgsjgOA=;
        b=NcZlC2qHABUvJPFumQkxf4Qppr3K1j2nRBxD91ppJETzsL9h0m4L24VaUnt76rTcc6
         dKmNfFgJEYWbEk7haLnXDXoiN3BNT1l6u1kdUhCwUlmnf/mNLgrNbZ/zOG6tiP+QH/8K
         o1o8XPpEANMRTVXEnNHBb4QTN21oU3oC83vqeM7pyJJPclf/oOMKRZ1ldyl4qDW7L6EH
         73U499GvV2RzdKL5BVosdiNYv7ShBoIolh4T7Aa7xT/8URUruXLYD7T+wRHjSPtkU4Ao
         NGn1rU0VWL7Bb5PPQO3w0QXNMxM/v8015zqF5RclU/hRUHfNpcguEBScAfZy7KhYQLd5
         ZnHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788205275; x=1788810075;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OhxWwWFcvK+eSFYY3JAtOiS/hfjCxl8syl0ArgsjgOA=;
        b=e63JsR6blf5CJ+Fz5NqAR0D8Yvcj5dOqeDcWd5rulWbAHX1LL3iq5s+280eE5/VPHC
         xoz4dW3a3vbo1N6bMdy2WpqrGeU8q8EE6DMNDoEq3E/LIXRuckizcwtr96F/eYxOpmaA
         FC/e6ZrmOoTHo/KRsKOTKU5Q4+RqNMQPm/24ta1qwWccA0/I37ux2Em9GbzH2eHBcP0y
         5A7tVgKbUmasyFjDLUiHskBMWsV/9FLKZSt8UKCNGsJ8tztdb8aqrNgXZHhD4E8BCurH
         rAwQBV9nQSFSvyjyqpXmyL1y8UcT2V+EiEr6tb37QURNEH7P0RmRGlklGDtAVc8dng5w
         s76Q==
X-Gm-Message-State: AFuF++l6m4vPxnGSa4BG2xs94+zvssnP/fOg/BOxTQBQhzGLGhjQoyOP
	65o9KyA43LYEUxVH0y8MH/3dnzA6oGuGProGNjsVBa1TXYwbe3v/rgo=
X-Gm-Gg: AR+sD10+2uqhVvgC4rLUaNGJubFRNi9J02PIakFYRA56+yOklQilDLfgJlv0mNZtgAX
	W9UZcadK3Zi5o4CdRnbSNeNoNWvFmPGB445GcnBOOuo1LRMo95HSEv4mVvJ8/J8WRZZHnJ4HzbX
	byE0yjLPi2WILVmF/PFRrT00EYqr/7nk9tbthw3LM1kYBniCS1nSo+a4eqUsNFh9ZNAxzPD3+RL
	1kjsihZAxlDJ19d7SgnI9V7cW2z4rRJBTKCDN6pkCUYM9Bj2kt2svpZJawmE1ZjoBXBbaY0HpBK
	dmLV3/pfKPwxA3hmsbpMrAcRzQjuFYBNVJ7gK/8W4ehMeJ6NlQ+JXaegT+Lx0r48d0nqPsSMhUF
	U2CTvJCh01JbV6LF32WRKxjYREuivPVZA7csckmVXGkQeT2PHfCXaJykvh/+FL3Q2XMNGQHwa9z
	ucpj03eLHSLmFfbRLNy09zatc0QX0nvjr7beGumZwiLxZ3rBmzbCObB7HaivQtKDN/qLXunQ92T
	gA5Fdz1MSEdGnW+xHTqvB3EiHfyq/m2m33f6Dz4dJ+Zezsbrg==
X-Received: by 2002:a05:600c:198b:b0:49a:a101:4157 with SMTP id 5b1f17b1804b1-49b91c24e71mr452535615e9.7.1788205275377;
        Mon, 31 Aug 2026 12:41:15 -0700 (PDT)
Received: from [192.168.1.3] (p5b057bfe.dip0.t-ipconnect.de. [91.5.123.254])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b91c52fdbsm232753215e9.0.2026.08.31.12.41.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 12:41:15 -0700 (PDT)
Message-ID: <15a79ea7-cac2-483e-8dca-60568fe76502@googlemail.com>
Date: Mon, 31 Aug 2026 21:41:14 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/92] 6.1.187-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260831133359.482388899@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 31.08.2026 um 15:33 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.187 release.
> There are 92 patches in this series, all will be posted as a response
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
