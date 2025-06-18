Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFDE1E9B3F
	for <patches@lists.linux.dev>; Wed, 18 Jun 2025 05:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750225396; cv=none; b=HD8BTjgb+CAgRWZyYMCAg2zeykro/8nCJl79F5zvS6ZzHWECKh69qYgYi920ct7iIAPY70wBjLsvSOv4YqFKx/7K5vwlevVmfWxdJE8b8sjO3MbgDX06zt/xHPmo08+1ENGWeIHZJPUoVMNY+C5DV2kEPWJSck+r+0ziMxYFluY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750225396; c=relaxed/simple;
	bh=1ET92XTHxvEo/gWuliIs6WzTWqg2s89wG7XwD4w0q8g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rji8oiLDGzL0ZjX925kxwhLnBWUA+BgWYBVFBgQQEQV+NzsFh9U+ijotXIDpz87EV+HfsHuwGefOuQDvkuIQgvCGGfZdVRPoPinqn5Sno4VlWH6xK82Y4uaqKQ09w0DciBAqNycnGmwprMHg04yNwjyCBFHSIqZXEnSj90eZSq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=BltEem6d; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="BltEem6d"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a361b8a664so6334839f8f.3
        for <patches@lists.linux.dev>; Tue, 17 Jun 2025 22:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1750225393; x=1750830193; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EDPyxhrKqnB3wYWa9STwkUgXZUbdCHyqxl5kFElQAQ0=;
        b=BltEem6du4vM5+uzCr0GIsgrzxPbDKZHnzP7qT+Eo7lHiYdX7QGMJBeNMVfneajKK3
         NRVvKuidmI9KGW2QrjrhrZcjG7qQy/RLCvLvOiRzQ/bNCIlNApEHtaa3NK6euJ3sJedx
         PlkKIGbi9/keu2jJt3LxfXxihVivkRd5ReTvHSS9slOTq0/m8CNQDXxxsSSVt4eA0yNk
         LoDDanTjlh6lQ8IdMZxGL7bklUTTzT3y/SP/1tSHM9G7tLofo2D1cNCgwNOyqtwENcHw
         zMRaGlihZupIltSoPEgNXKNTX3jSixjGFkgXcu3vLNuTA4KysbLP1IRyE8RsRl5j/hWk
         KvTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750225393; x=1750830193;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EDPyxhrKqnB3wYWa9STwkUgXZUbdCHyqxl5kFElQAQ0=;
        b=oPHNeRCukwKZuabqsGmglSu9eTmvuVO0p8nIYUCO4swBYyyNAgG2ZnNbYgdEUbT7Lf
         vGH1JzhrjffJcd/e7yxUbVsREl//4QmYMeWT4LvnGzd/ynF8HCjNu0giFzM/bdHtIpIN
         kQYxLK+fOiodJoM8YUqvlkQ7D7akWTwKPHtNZd1ru5OYn+fjpqdNrAuxuwH9r1BN9Dbv
         3Gu06CLskyoiuPo2Cm959TYurvAWbJYFnBHVVtH282A2sABaaWQiqIstXDwCYuATmoWf
         aK7K4mIZXYrOW4M59OWveGi3fBGb8WT5hlhSr+kKtQ8VkJ2Z6dFZGZhfoE+AmMmV3j9/
         ECnA==
X-Gm-Message-State: AOJu0YySRh393fm/fWK+ak72Gfw0RjcGX+4uoMH3ypcsHdoo8fVaiMk1
	y6uVW8arlFeGBkwZC8SifVVswl50+EU3ZBQC/MlUqYWQmao1P1SOe6k=
X-Gm-Gg: ASbGncsWdEVbMJkBwvgWao8nC7SDh+oFaI9Hgu2rmEYMyqSqf+U5nayVJb6Qg8eWfcd
	EemTEW6HSAPFtpYRi8VimbsWdC9b3svwDWmUpJ2OwOa87RytVHeZ3Blz8DZG03EqBsPoRQCCVn+
	cHJLBv345caReACXJ6Q0C8vvWpOA4Q/9doeNIzwoxCJGJKslmXEgN85+Of2NaZwuB7W18hiOwLU
	Ave2p4p0TFux/CBWeuS1IFwC4O1b427CZ3obAwHc7E1B8bEKz04rM1iy3p0VqGAZRZt7xhB7zII
	x2DiVlzrN3lYAGFP5eLPC9/NXH1g5/L/3SFWP+IVCUlkVFBDxlJ3rtNOu3n3jWwXY1BSGp8hWAA
	1wyqrWkNP8abO3Vn0umCVA+GaoTHro9LOOGHsCA==
X-Google-Smtp-Source: AGHT+IE30ICEI4K5qmZV1bFKxegSqORhVi3QZC60MchHttexvFAoRwIQBR3B2RVwnsbHDgVpn+z6PQ==
X-Received: by 2002:a5d:64ce:0:b0:3a4:f513:7f03 with SMTP id ffacd0b85a97d-3a572e8bfb1mr11845311f8f.44.1750225392513;
        Tue, 17 Jun 2025 22:43:12 -0700 (PDT)
Received: from [192.168.1.3] (p5b057357.dip0.t-ipconnect.de. [91.5.115.87])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4534172d2b0sm127511775e9.35.2025.06.17.22.43.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 22:43:11 -0700 (PDT)
Message-ID: <3bfe25fc-f5d3-447a-9381-27b712b60f77@googlemail.com>
Date: Wed, 18 Jun 2025 07:43:10 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/356] 6.6.94-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250617152338.212798615@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.06.2025 um 17:21 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.94 release.
> There are 356 patches in this series, all will be posted as a response
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
