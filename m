Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55C4433CB
	for <patches@lists.linux.dev>; Wed, 21 May 2025 18:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747850435; cv=none; b=eEEq4yAkJ6iASxz0xrFBrXyoc6eyMMCitGnAQGa5sgbQH1bd+V09ua2WyzWz8NuXWnhEbU6bPqdgJNGJ5wcqfMLpKVQW7YvDEBVLmQNPZc2gqqr8btOU2hfnuzp764//evIU8ACVT/QNogVsjPpFlBGS6w0Obl8te6XwlgMyc1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747850435; c=relaxed/simple;
	bh=hSEhiDzqSaiyLOhzjpCcXuTR0mgkbVOtc0ok6q5hkyo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=etw7yyv1SmMwDRtmg5mWPQIp46sXxV0HYjlwpRoLeIh1+xqkQthlLwjmlqPZEvqmbkSIKUxbSYVk4Hm2iyhKWKm94X/ESy9FNweNNLc7i+c9A/d6CZ2gWx5vqsT8CKDaeHQ4MjNIDLT+EfahNEt20PD8CzgwwuSfp9Av/LcDrx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=JVKpfaNY; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="JVKpfaNY"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3a36abf5df9so2772539f8f.0
        for <patches@lists.linux.dev>; Wed, 21 May 2025 11:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1747850432; x=1748455232; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v8AA4IZsofQYOTdeu/xMopNAhMxBwcxpcA9eFx+l8xc=;
        b=JVKpfaNYtPuZWWbugpyHM5YduRfu1PJSAU+K65aktnVZWO0x4gF3TBS6yUcphlyY4M
         /JmEzro/RDNP8bIOMmN4GEFAfKxOcbD/tHQkcQoyBFfw3jJetaN1UYqef/1iFXsk36HO
         LPWu2o3CykXR3rb5twhDXSd9gFokOQSb+OhaBjxgcT1nmrChZDIy4CdkXsIU7HFxoDar
         y2XsJqGYzXBbXMuOcAB1RK9gRtfb9FONL6HQblrq72oDnucYREbNlKR0GJFhWpRULPqD
         BSIqfYm1zpFDJ858JdVZX4X+/rtl0/AAUpCcECvwc19osM99eVa45wS0Fravma8aD3ih
         vZRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747850432; x=1748455232;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v8AA4IZsofQYOTdeu/xMopNAhMxBwcxpcA9eFx+l8xc=;
        b=C6MHk2vRHkgDTOqzAF0lRZ4K40aj/lq3vX0zkxI1eEoX8AFFjCMO7TZRARqB/1xMco
         lrB2aHfp6qygFsDgkkmCqPcEv8NfGa/7W8qrLun+Zz3Ctl9zx1ljkLI2kf/phRc9Vzmy
         SN1uw6HTCDOCd2nWRYWsfdogTQK9qbEkVNLF81kbk8kMBl1neM6i2VIy3suZSMHetM3C
         pSXyMwmR77mocuDwlNP/ZyqbgCOysyINMSeM20+jQ2l4l6uc9cRTVYmvGEFJs5/Q7hyL
         RNV1iTcQbiCKKFcqmmFfLHUSYmomtGKK5TP7WmKsg92yHWZd/+HzcGTbk7f2ckgFzd71
         dITg==
X-Gm-Message-State: AOJu0Ywv+qdw0vaFD2h32fA+Bq2U1TarzfWcS1LfhnqKpBzSIpgPyl8+
	S17cAu4cZ2y5AwxGOXfNITyRLG+hcrqsRMZb4/OhfUERW0yCJ8IJZMw=
X-Gm-Gg: ASbGncs4uA25+28Z1JjVCV85gDzOqMShXLU2uwCtCAiRDFLPH+KgZaRM0M9n/m1pIlO
	+PEpffcPb/UTL+lEtQ6eXAsWQr9Xt1jZgBTjmk8HlFAHa+Ddq3BSh7pEkNJGuZ2M1xM9W4PN+z7
	+SsVnQuSq+24oXPeaycbZ4keEvEgxTV745lL/a8oX00opsYj+sO6Xl1cZR33S5+lfmWtIVBMi6b
	Lx4GxJ+WqtUpmk2DNnRizIeUkP5kicK5pZNTtKcNI2OrhPSdLcCkLWAjM+MOlLClzKgkmhqeV0Y
	zUju3Pqujq3Tpft4pJyQJd4WOVt9Mr4HVDJxP2oXKeQZ7XlIJmWcsXnHLk7m7pQkjXWag2mdxgT
	mTvcTtbSeay2Tpc/g7m4shvzpmrY=
X-Google-Smtp-Source: AGHT+IFh2AGmng+VALdHnj2jbzj3BcBZ4blsY4cvN/b9ldp9O+4JHoVbg40HkfWme/bgODBOdOKQyg==
X-Received: by 2002:a05:6000:420d:b0:3a3:760c:81a4 with SMTP id ffacd0b85a97d-3a3760c835fmr9803335f8f.24.1747850431771;
        Wed, 21 May 2025 11:00:31 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac604.dip0.t-ipconnect.de. [91.42.198.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f73d4a3csm79716415e9.22.2025.05.21.11.00.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 11:00:31 -0700 (PDT)
Message-ID: <66f9ad91-99b1-4791-8cab-22b01eefeeec@googlemail.com>
Date: Wed, 21 May 2025 20:00:30 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.14 000/145] 6.14.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250520125810.535475500@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.05.2025 um 15:49 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.14.8 release.
> There are 145 patches in this series, all will be posted as a response
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
