Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E92A267B00
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 18:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744224388; cv=none; b=qItqumGzf1TPDyjFBbHgureMYUHmB/bsFVwBl0eYIy+heZNbzij2ETchMDJ6kAPlLvAANniG06r/+VG9Ocl0iHO3NHC6e/MVvqiEUyBG8Kpg55lAxpmPb1C51uCKj001TtVhhWG8ovKUM4NF6kh8YM77Hc+nar/2QIDJ7aHFffs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744224388; c=relaxed/simple;
	bh=GB+KgBrxXEDkjE6FtaK3WN4JU3vY/RUiE6ujvmcCTWY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=erhqRJyZ1FZioM1oU5I1yP2qN49314mqVdRxThAIX5bHWqiEPHXQEH5ws9x0ydf8NJ4Cty2BsMBl5GmNRHSrtmzVQJxmnXy4Wssvik8sGShlxGGGM61xY88pkT9RmZNdIP+k7uIBIxrOPTSXHCm5xvWAkV5NmpSIcL8nX1iLTXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hFUlyX5N; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFUlyX5N"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3d5eb0ec2bdso152035ab.2
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 11:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1744224385; x=1744829185; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ifMmUjJGIsQhwUTV/RCg0YV0PIkSUdUeNOFNrIPNanA=;
        b=hFUlyX5NLVg3EQkfGAIut1ul+kHeYuYO2pemejU9W3oj1RuUYKie4coRLeIuvoS3qB
         ALQM83VAKuZV+lLG87AxxfjkiPpq7D6ZRdYbOxflBiaToNXvQgxibGnXuGFXKNUdZ0TY
         GlEdRkZ1Vi9sHlpeqQWD5LFW0eyPk5KJtj7xo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744224385; x=1744829185;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ifMmUjJGIsQhwUTV/RCg0YV0PIkSUdUeNOFNrIPNanA=;
        b=etHdxGupljtg/Lm98ul+Y9QQkd/9ipY65+KKK7TGijuKiIlhrYtw5TkoGAdy47rKi2
         SLXjUQ/Mx/sXtvqxgwwWM2u0PIO4O/Z/ki2f+j6LKpzxoxkse1luyAQuOHD1aFgvMsju
         DVJPKF48uj2V/Iu+G8uMm8cIWyo0KYFGN20oZCbYWycSXMbhrdtPQ/B7Ya9s1DlBOWfm
         U4F4HziJ/hernC0HVAVeDtBPWREq41Ifm715evowxxGkPEO7JaQpP2PXBAXchyteIMyC
         H4VqfDdHlMOSrdSljofImvwUIMoclKWDNRNalyqybXQ1C9YKOW1gGs8sURkD/xVdJwrB
         3CqQ==
X-Gm-Message-State: AOJu0YwX89ULBtMwOXRVMcUxWKqC+EugyMDGTib2CW1YBXot/b96Mqod
	VXhRsJlEM0pSCaNzir2nqdCGr6LP5IxQC2QGEZ1d0Dh9BITuWV3BrplwJbxK8vw=
X-Gm-Gg: ASbGnctxWSmTl06ZlU7wXe9QUaBFjNBS4bPOhwCdKQFoGjEwyN6lvQkz106uyBElqWZ
	DbIORx4BJ26blQi2X0Y0MCyHgOnIWSUffuXhhjegjdKpdJxGhjRKbVj6Hb5cREN1UJ68FpIA6mJ
	QalyqZcqMmWVSgwS1IyvoY+oguyO05V+8Re80epC3NktnUvOOKHMYl8zSYI+dnSwFE1gHEkkmOr
	XvPooQuykjJMomZVtBlgKXYgVJ0KIzCPW0UmUtwIkCjC4AwxOrQHXxFD7B1noBnNWWNwve0iRIR
	qXuDWxt95HoiXEURpABd2sagoDTWB5HoJq5A7wgxUvnMw0bc+D8=
X-Google-Smtp-Source: AGHT+IFQuufNWokgX5APUUxZrBWTZn+tndy1/mhA0AQzSeV+nWt/l+N9Jvp35CKItDvgOWHyX5DPUw==
X-Received: by 2002:a05:6e02:2207:b0:3d6:d162:be02 with SMTP id e9e14a558f8ab-3d7e476fa60mr1761985ab.21.1744224385548;
        Wed, 09 Apr 2025 11:46:25 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d7da491383sm4091795ab.0.2025.04.09.11.46.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 11:46:25 -0700 (PDT)
Message-ID: <16d90cc9-72e2-41de-9484-224ee23f6cf7@linuxfoundation.org>
Date: Wed, 9 Apr 2025 12:46:23 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/731] 6.14.2-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250408154144.815882523@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250408154144.815882523@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/25 09:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.2 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 15:40:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.2-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

This is the one I tested - please ignore my reply for rc4.
Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
