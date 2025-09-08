Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C27235BE8
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 12:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757332913; cv=none; b=Km1oGs8XTsfAjPvxE/cF1RJ9lOZVnCm/zubhlzIy7thvdxW03PYLdcWk4zIBUE9/tJBVU1fWERsmKaXZ36cRgJYJYPIQu5K7DZff9/pVOC965NKG/GysLUYHOtqf2DMD+s9O7Pulv1rsmUW7BWVIpc/x0peI0lIT3CaO7MsiRAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757332913; c=relaxed/simple;
	bh=3az1bFP31PmXKgodlWrJN4R7NnWbITfEuKRWNUsgvhQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PE4M0tY8SZTO5BO3sGARY7QraN0GfcEEmv7GW4049SG6qS1ieTT0ueGutP7suijyI822Lf5dvH4OAwggSWxOyi3NqPhwfNITktll+PXjXFgAjjv82/bR7YEdmtppow1Co8rPnXzEP7okURtsDNqdfo2DJK2DY0sRi9EqU0Gpscg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=E2KbIxQ8; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="E2KbIxQ8"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45dd5e24d16so28565945e9.3
        for <patches@lists.linux.dev>; Mon, 08 Sep 2025 05:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1757332910; x=1757937710; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=abO2E4antkIr+F9McKxk3C1DePF1URlorKr+lqTP9uc=;
        b=E2KbIxQ8pE8Ykt02rxT6ryjJt16vCctEZUouemyp+fvLYV3Hjq4dhNFFxombzEyGjU
         F/PW5gtZNdQ3YT0M6o32mW6mNB8EOQCwaRmLjjoNucLs4Wtw8+9KVCygBAnsjdLp3YHp
         KYWrUWZS+0ho4JRLpdBSCMhGQ/Z9kD6WxJ61uxyn5ezt6eCFZlK0RzJOvy/1hY6cyr/Y
         Qnd9kKqyEyKrpGSWIQYjsFwj0ei5sfZ40CDChu0r8CM3D8dniavT/97xTmGpnR3WK0W7
         on/7fwqw1UQOsPrfe/HXv/1kUqVCdElloA6uZSdgDHJpxfIijLfYvUEj11yJAv9OkQDZ
         Vx2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757332910; x=1757937710;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=abO2E4antkIr+F9McKxk3C1DePF1URlorKr+lqTP9uc=;
        b=lkcWBDfFRGhyfglVL8cJOL6U/0rqRl7pdHhCiJaFwaN2FcsJZwA1b8qRQML1pG48J/
         RQQ/Os5O8GyV16ssUVBDh7jbiKwVTOURVUjvqf00L9O5Q7AGb8Y2nAqWsld8xP9u5TIs
         ZEYaWb8tz+Vss0aS8a7kXlPn9wy+q4EOGalBGyNFxWviytF5BUyqRSd8WHlgWzxTQb+g
         PuOohBefgpTY/4pBtnVs48yc5IVCIF1W3dNZVqtI0ectfjAW4P1Qe6eZk8Y/6jIE+iHd
         BAk+hrLViSyY/bUZmMV4RW7rXYNjx3Wm8II3nnHx8Hb08bbJZAiDsCbGvMpuaED9P7dW
         xqLg==
X-Gm-Message-State: AOJu0Yxuwq9+3FdJ+F4LSt5+/ifka2lZC/ADv2NlnU71OD7Wn2NX5rbV
	iKVYs4uUCl3avKRUskOVHAkfo3p/a0IrtGIkiYGeIm+uewrL8ywtSx4=
X-Gm-Gg: ASbGncs+s9nqGZaCLSNAS5ePWwt2NBbyabF+3ABE1IHPip7FzdqvaB8VPS+YaNRh+VP
	2kz/bX+MOtY4PjVJoXaZwfFUH3IeGo40V6JWnLyyvWPj2ae/gM+3MGtTmWtB32dXl5sx9yAbihJ
	P7oqO3PBYia2gHPRn2CHXcjzNee0NYLehvnS5YtryK2lC+JrlieHlBlQehOhFYnbdpB7fmu9Nof
	VL42TnHM+ZRb6T+LoI5jdjkfM1zVeaVziAm5R2h8qJKsa/wkTnLwLEODS+D5fh/tmOTX0EbzLFN
	1UZ+BSdQJ7wZSmzHWuMRn+puWchd1+I1L8Tm+pAgjQV8arGqvltvPnfI42RU7zIE8OMSLalc8f2
	WeTyEmYEk3JOAGQTL8QTD1M47rTxxls2QY35vuB5TUu0/TwXS6NlbvxNY/2f+MHJxJHPsoZ39QU
	GyFZfns3sqlQ==
X-Google-Smtp-Source: AGHT+IEvFwbaErkvEQ7nTpClR8R3mKOcdV2H4BXfSyWktuAsA5jjbG6BjNElzDZa4f2vafytVtj+6w==
X-Received: by 2002:a05:600c:1ca0:b0:45b:8352:4475 with SMTP id 5b1f17b1804b1-45dddf02148mr70641025e9.36.1757332909051;
        Mon, 08 Sep 2025 05:01:49 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac262.dip0.t-ipconnect.de. [91.42.194.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dcff67787sm191651675e9.16.2025.09.08.05.01.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 05:01:48 -0700 (PDT)
Message-ID: <9d9a8d72-fe59-45aa-8336-f662db7fdc2c@googlemail.com>
Date: Mon, 8 Sep 2025 14:01:47 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/121] 6.6.105-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250907195609.817339617@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 07.09.2025 um 21:57 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.105 release.
> There are 121 patches in this series, all will be posted as a response
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
