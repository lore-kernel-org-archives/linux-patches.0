Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD1727FB0E
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 16:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188646; cv=none; b=ie1nrB5yHyZ8OkROl06Gx2erlHnrd6NW4Vze6IWx8HmzzBwDJcyeoh5OVSDI6PuhttBmPqEEMU75aZBCw2jufNTjc8X4EvD+hx1MtFioc2rb/HXx3zScZahl81NoKdJkguz0bB4hid8RnD6Kjo0w3ttmhHjUzFCYSZ7dtlZNxdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188646; c=relaxed/simple;
	bh=+csLiPvaXB7cw5DKMQWtltLuwsR3d4lws5+o61L603w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vy7IjjRYCevV5RztQ5osGgKnaMzqlbcwY9BOi5Wzk/863sBdPoDJxfFkFESRZo8NqZJqhlMppm3qKROyDvgTdKJW0w8Y+kPvQ/QjrzoYzts4rU9KX3HDRc0dHzPYNLx/PaTcC8pbRPxPASkYt7nke4uiX3DK40dlV7iHnJewjxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sl/10h3u; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sl/10h3u"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ed101e8486so63111621cf.2
        for <patches@lists.linux.dev>; Mon, 03 Nov 2025 08:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762188643; x=1762793443; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m5Im3Pln0a9an+fAWtgyl0jY5GCpUicHm8/nn+JeBo8=;
        b=Sl/10h3uwDQHUpI7H5DRPwJfaLoNfgbkMQwzpmxJCAvzsYwVv1U/QF4tU8tPt7hdPd
         4WDaTC2qRyrITaJQnv3fDtPzqPdJYaUOGQED0gyKlJU9QFUBjjGZ4YHs+dyuSVk+Yypn
         3HcCAItYeI6irKfJFJqAwyQjnXjPMAKXlZpfngE1PkPaIVBpdFX6RRrSAfqRG2wjQenG
         c0VnnXZQW+iKlya0iUl1Hze/z/wPGvKMWtT5VhYKPgEqMKkrucvZ6YtxE5vqAB1L27+c
         j3vdKt53grYp3xtlgV4BFz63y1HUQU9TkRdEbq7WZTpkbEMTuqxjycLAvz+aDyThIiiM
         1sJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762188643; x=1762793443;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m5Im3Pln0a9an+fAWtgyl0jY5GCpUicHm8/nn+JeBo8=;
        b=Q/BI1flywHrpmib9mFKs/w6bIjCqBCx40xm+iDK425xz7+9I1JfrOhm3ii3PMTIQvK
         +I96tNYfz0BgHAeZiPbhCfu9xl51GU4LN2MlqifmmQbpDG18XL5B4AWlhLeNVoCpkwjm
         wwIHg/NrskTjAtREoK317Rp8Vtt2UEGupMnaVYDGoaKqlntrrqOl7kbB6sLnc8qNGLtB
         0Z1gNJz+8DHLF+qfTY+SbNh3VzxXfcrKLEASfHhqqzbQIEY6ETn5Q69yeAV3RBL+I8GW
         iTWC7AE+ZiK2VqzV9yYEh/odcmWKNu14a83tBLP9iT0OqliWc4sKb23OGYPco9qUqYId
         qcNg==
X-Gm-Message-State: AOJu0YzknR+xCAmwrEWRO58eaNKI47TJQR2ZGqM8k/LYJKKZlmGsLZwG
	MP68fU/eKJUTmSdr5XRlozYpNu/e6zFY0/hDkNMS6yddjHYmjrfnM8nx
X-Gm-Gg: ASbGncsJ/p2XwVoMH2d2w6Wm3tlQ/Nr7Rx1COcPMvR0kUmjFcYoyAQ6ADf/Md8FKSih
	7yGtgZ4r7/Wjp+k+6ROLoWU1nhmY47NNp8oHYD0lZxtarQ8GoPJYNSjmx6LVnud1G+J8UUhzMWh
	UyVTn/WEgrrwjOmEeTC2OPznuN9a5arl7O/W3yePEq9u70i3DOq8dp8EEr9H014MwM1RTIjQCbN
	zVs9MQQ3bsBtP15wq32Zk+la7A0ZZjNNRrbBxPuCKotGRN92TluZexm8Py3PeqvN0QdYR6ONgm3
	l1gYZS8BQdtBXe3CHx9AWw1xOgSobYPhAOMlISX1NCgegJ1nHsfw6Cf2oX+nhzmzhkKpM2lLRqj
	gP7YG+zQFZoFid28J9snaEASb93naBsJYVwlQhVTg27L7k3mWXCtar9e8V9jHCH4s0wg9zto2ls
	3uEWqH/SHvXESPTiHUa9HKQGSVPMZ7ArD5d0uTjw==
X-Google-Smtp-Source: AGHT+IEUK+QhETnkizEVhsn4OSDbW8TLlREputnus2DePYq7zcOHls1TEMf1YxRKvCho95j2x2XPsw==
X-Received: by 2002:a05:622a:4890:b0:4ec:eec7:483e with SMTP id d75a77b69052e-4ed31055828mr154509391cf.68.1762188643647;
        Mon, 03 Nov 2025 08:50:43 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ed5fbdf2b1sm1644631cf.17.2025.11.03.08.50.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 08:50:40 -0800 (PST)
Message-ID: <36d2ebd6-118c-4847-9233-ff848f6425c4@gmail.com>
Date: Mon, 3 Nov 2025 08:50:37 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/40] 6.12.57-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251031140043.939381518@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/25 07:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.57 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.57-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
