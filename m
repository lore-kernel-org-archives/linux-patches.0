Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7544B2D7805
	for <patches@lists.linux.dev>; Wed, 12 Nov 2025 21:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762981835; cv=none; b=NY/DW1XS6Ui7y/3gGLDaQ0u2vx1DVFnpI8kkGG51eNTtkg/vx/hKLIN/oTFlpqYwzlL6RLhpmDLkwCsNMr+G+7XesMzP6fC1m/slmV4DGwNBxfM0Uxx/n+Ork7JslwvlmIiVM6uv0fzRsBVHDyVTuJ6LpJ17TYRS4L7Aw/Fnbvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762981835; c=relaxed/simple;
	bh=NFCiZbCWZdsDuxKkR+3uhYDtGTTOmadQRYG4/hTK6zg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=UbbJduVJz7T8+S1TfbcIGoTgkxXvAkdWIvoDScGpo2RoP8DrI6xqZ+iYJ5m7cRigXYhlC79T0yOcn/FP94ENXlnwbNWS+tWNR4gUcI2MjRzZNvYfKfC3olTTzR75DC/9jhqkSKIhGaqMOXTBs5bVLNXPHM2rmmgkuDQVfLHBw/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T4itV9nJ; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T4itV9nJ"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8824ce9812cso1178376d6.0
        for <patches@lists.linux.dev>; Wed, 12 Nov 2025 13:10:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762981832; x=1763586632; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Q8qaWvPN3J8o3Bl5ry+HYdP7j93QWDZn/Cnz56U1Aog=;
        b=T4itV9nJywbmBmkH/zGn5EIBRP9D8g6gj3EYGv9pAJJnsAf2xLq9Cz0wo98REFNXIt
         A8PvgYt1pf0z2zyyipFNSWt6HKWGkeZoYvo+ejxVn8CHFJW+YHjgDgRz/ONBI/W3EFt7
         oQd7lAQ053brVDiE/4p/oM4iy80mn5MlVB2OS0Xm9ZfwmbIyp1nzKiMTRmg7Pqt5+oPC
         k96fsaX5ZOV/F07KA7T0zLf6Aysn1ClqBI6A9RKMee33a4dKiDaRrusvU+e0RP9Wpj5j
         CWwdRuzJ+M/lds1pV3smkx037WlFZJ3KFtIoqJ1scisIcrdesJ0EvQ6RvbEsQG0J7hJg
         tRRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762981832; x=1763586632;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q8qaWvPN3J8o3Bl5ry+HYdP7j93QWDZn/Cnz56U1Aog=;
        b=RB6K6ejq2v27bscu/cTPVJbZnrZ9bQt23lIQSVJct0hoUDFfZ8cRAbqdzUJj4jOTWK
         2zowzK/TWf1fJCs/xfuWwUf74PwpohOYBeVXaoKqUWW6ac6KyKbkzEK7fPSGq15qEfDC
         XI4Ldsv0gYZghameTPNFtnMPWdIpPwnjoriB/xwqyAIlKVwT6M1kmpdscIehPwlC7/LJ
         5s6If1JqwOOnw0nRrfDzoEpI/bfTajcDiNSddQjT4O5DKEpIuIHfjWJD5xmYWVErfMUp
         k3pIlGnohg0vqmX5iBPMI2kSt7sRAWzTZi+6MLvpzUlDJsCIj6elvCY1irVTgSiryY7S
         Scog==
X-Gm-Message-State: AOJu0YyUCgzBOWNAdLb7nCtBb7wXIoY/qG4/tHHTPL+y6t7fk3pK8B/o
	wD5ENNE1w7VozGB8kPANfdnvnr0iSgfh0zjAe/9hyVRtdqEoB+Spb8pB
X-Gm-Gg: ASbGncteZFXzXTtUXffjBP6F37ralyUx4KGI9WT4iWIgpsd/uqBakdf+RK2pIm7xpyg
	Yw+EfywfxlItBcUjYtGvN9TTKfDsylUSKGw3jAVhg6X1pqPBaMNZl1ruSj40G1WZsGW8zEZSozU
	h0kFW4THZIeevXrxfd68VrQLmtyTQhdL6wK/Zoh0YkoH3wz92VJ0Z0EWYZ7n8kdHlZrJpnXZF2p
	TRu/HP3cTrABfIWOR8FlxzH7TwPF0jaQzkfoH3XM3RT1l222LNr7qUfVAm2IJ2i/QPL1Dp9yVD1
	NFE4Gc/mZ+NlaEIAi33BAdvOashnGBHjQ8bzoxvOq6o9R5AOlf1Og0xloMZ/UVNiTB4NNpkvbjH
	DdwS6Sl90WdDtZrsQxNZLRqzeF1n/ZFE5OZ6yG4LQhMg3aBbXHUEpOipPJ26db8K51TDd1WnXHD
	1dRVEmbDAxkTmaQpjUITBa3IxecQY=
X-Google-Smtp-Source: AGHT+IFofS0tn+1q/BFHwqg8tHswBktjEiPFttAd7/GfZAqUecg++L2+A/6CVudzDds3JxckzQyKcg==
X-Received: by 2002:a05:6214:48c:b0:882:4a63:63a7 with SMTP id 6a1803df08f44-88271a4232bmr71218726d6.60.1762981832057;
        Wed, 12 Nov 2025 13:10:32 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8823892b84bsm103123356d6.10.2025.11.12.13.10.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Nov 2025 13:10:31 -0800 (PST)
Message-ID: <845a2c50-8d2c-49bf-bb47-2f6ee1c31d61@gmail.com>
Date: Wed, 12 Nov 2025 13:10:27 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.17 000/849] 6.17.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251111004536.460310036@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/10/2025 4:32 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.8 release.
> There are 849 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 13 Nov 2025 00:43:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTb using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

