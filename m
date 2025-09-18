Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D435063B9
	for <patches@lists.linux.dev>; Thu, 18 Sep 2025 00:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758156459; cv=none; b=mKLZeciVvCwvZo7t5xnGeY37Vh/tjnyhIPg8MspuS6u1A0eH3upEdd5BLuuNfMSlPwaH7aZg2DuZdWoEIthuJAJdMWyItFmsCUUEck3oIwtdVYVuoXKw3ZQBwRCX97tzekyTqEwiV8b3vzUGvKNPNTeckEj+DpekJnfjTnHOObI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758156459; c=relaxed/simple;
	bh=IrbF+vK94gpu/ozn7Qtd6NvlKSesxn8hE2qZizKldxw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NROX7uc9vRx33psmw79DtuUHIuCjs69VjCbTsilgW34oqdvAGK9wQTLLdULyYgCuzL2lTpbkoVx+AUTASOjg8bNsOqGE7TqcEkaE7mwNtMdkvzLNys9nsaoNifjim20x+abTgC8UeAvPJmA/NYPCzewrCSNLcVyy94eeGDvjK7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=jIe6kyPE; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="jIe6kyPE"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45dd513f4ecso2361585e9.3
        for <patches@lists.linux.dev>; Wed, 17 Sep 2025 17:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1758156456; x=1758761256; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dy3po34F373z2LL6aW/ho/h2XKggLTL7CNUt6WWnkWM=;
        b=jIe6kyPEld0f4OxJsyLTgORvGFE3Qyy2vek5y5ybC4a4mmNze5Vqcyx6bto8EvDvJX
         ik5fuohtUPkXqpy7PKsOBscwffOAd2BZ+DV8iG4dNMv5rnZeQ1Ru4rTPmt5507IzhnWV
         mCNu/bmxA1467ONHakMCAWyLhFdtK5c3G9Rt6+ngIA02eR945dyGyJCSqsvG1lkrLt3i
         oQcpyi7cPEJFov2tKQBhGwu6bkgW9+upQLgtJZl1mTJm8bnES7nrG1LSDJ4nBXwQfiju
         JQgCGEAgDuCLH8S+yVUM8uFbmLjh2RpxVliQtmV0Rn/yVNhUAsVY6qleM9nf/e6c1I93
         2YRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758156456; x=1758761256;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dy3po34F373z2LL6aW/ho/h2XKggLTL7CNUt6WWnkWM=;
        b=jnPaea04qy7Gl2I0oiSxmmxsfnoYBcSZQG0oDRKtTg48AyKlCUr0siE/kG1Jpbkus1
         IemlbyCr2clRKGmMmeoqgIya2CgNpOJjKqlL9NtobycHOJMpfgfpGUtQKbZGuhSw6J2M
         RNH6S0pcJvM44hujbOJkFr8TIwoK7jMTcZJJY9op2KVP6PzrVW8/ytVh7Zzo+LtFvsdT
         +m6qj0Md2WDKCy899bAEkcPGRNys0fLG9FdMzBLw1R3B9+Yn85XjZz3CB+LCoQvmoNJ6
         MlcUQ+ZjMaVBvcKcYtAdNY+zA/dmickS+9alzUTYzAu5zBBvrbwY3gubJDp0gwmOkyah
         cVHA==
X-Gm-Message-State: AOJu0Yw9NY4tgsWWVW11dXg4AKIqJhoG0ZNpufFvoiP+Cv2dMXn0pGN5
	2hRbdkY4KWCU0hwJdb60KRxR/Q1K/kPUqwL2Y4j1NHKfaJhtr8xr2C8=
X-Gm-Gg: ASbGncvtRn9jCfd5CI8PIyp+jCrZysfmDC2VeyW3LYHZfyR0rfTkljgyI6QcBGGcb+h
	TGn43q2+kfAjn5j23TzrScD6r649bzD7qRhjtHlNWSDE3IR+VPMqnSaZUZ080AkFQuOsiwa4aPD
	qczEuDTVJNUahC+JoC2nWvZOstuximDFWpbVeHqnL3ft9OD9BlS93PNkPJJa2SU1zz81QoUa7Ye
	ryGWCt1REdK6YCfLjxhkULFR9vyLCgwvKl4Wjhth/7bHqGP5/8SZ5Ocij/NpDOO30loP77RbJbH
	MLvQocjAfU3RkKQ6qdxSyYfUaFbx2K3W5MOjYG0QM4+VCz7KLJFJIWNthxKXPW9UjpRC7gqYc/G
	I92uehSCU5GboM/Sq92j+4MbA0f41V9NIYs9/0LYpxz2JWqJQsoIblnDPzC5LbnoFy6hbPet8Od
	HO/J44U2JEvHBZ6FiJZw==
X-Google-Smtp-Source: AGHT+IF2GdKlp1Cj55CMvxh773K38LbN60g3EFJ2JiKm4A5B9QL/on7+DP5zXojEycCtnsrb/d1cTg==
X-Received: by 2002:a05:600c:1993:b0:45f:2cd5:5086 with SMTP id 5b1f17b1804b1-46201f8b30bmr40989045e9.3.1758156455984;
        Wed, 17 Sep 2025 17:47:35 -0700 (PDT)
Received: from [192.168.1.3] (p5b2aca14.dip0.t-ipconnect.de. [91.42.202.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45f320ff272sm48908065e9.1.2025.09.17.17.47.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 17:47:35 -0700 (PDT)
Message-ID: <b7a5110c-42b0-48f3-9a68-7681ad588142@googlemail.com>
Date: Thu, 18 Sep 2025 02:47:34 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/101] 6.6.107-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250917123336.863698492@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.09.2025 um 14:33 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.107 release.
> There are 101 patches in this series, all will be posted as a response
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
