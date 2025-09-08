Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E05919CC39
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 02:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757297147; cv=none; b=APGDPkIO4A+dL+kq6S6QANZT0aopZSq4V6n2GAmfjVuRBMS6GAKV1d5994G02krzV1R4mJOhxRIKljdzj7RoDfgQZR8zOGeQb0GlVQy5CtgtEexX+VLRIuJ+P8wxRy2gIdVUcPpacrgOaY4GQT5t4HgQ2wjB9YS+HT7n2WooJmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757297147; c=relaxed/simple;
	bh=htwW1xfmVzPRRVkaJnN+izgyhESSK69PwxwsdZqPpdI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tUriOgKhxt6KrrkmzbLrMAo8p/id2vlnx9xE7yo2Vtz2DOR7Zk9uHALdZFq6gZkO3OqGGfKY5AfbjDhsIusDhc10b3km/2m9eTm52EbXOroFKB5p7rasq86uF1jgtdA9nlV++tg/ggrYpikzcqpheMN2xVwuIgSKTDKbLPZZ/ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aWXy2IY3; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aWXy2IY3"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-251ace3e7caso17058975ad.2
        for <patches@lists.linux.dev>; Sun, 07 Sep 2025 19:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757297145; x=1757901945; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XMux8eKktzYrGyHNJj+h74891VBOnd8NG5NmCraJ1jY=;
        b=aWXy2IY3XvSazXX2l9ydGUxbm4KsCAjtsBsCYwTb81KF/SPhSzp3tkvRl3WGoTsoUV
         Hhnh+0AqYQq61qnM4Y8wZEMJyBLYYKXKq/HQJagf/fRWLpMWwo7gxFk1rTfZbA5twxig
         AdoXSRtVE3Lp/03/tBHdRIopzq88iBDDow9hn11GPg8C4T756+/KGZQYB8fTbOGSA2PK
         +rWm6wGQzaOf9OxZlzFczrNb5HIOgKySA6U9hAnFakfjJCwiHbL6Nlz/zn3TRccSmQMK
         3nrzUMowfM1va9xNWtoRwfF7n7b4QV6ntBszOWQvrZxQmP0hkukqOw4+KpMHrnNv5Cqz
         /ZDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757297145; x=1757901945;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XMux8eKktzYrGyHNJj+h74891VBOnd8NG5NmCraJ1jY=;
        b=taKIPrmjAaGWNW/eb8qacKSvkWHdPaqYFFdUZVx8fnkDiKdGnm7+kt495BEL+8K+lb
         f87AXo2k6xH3hmKRorb0NUf8xGhP39zv0WuZj6TbDF7usPyoYdzPSm3GEy213RSM8CqR
         br4B312PvWFMluKD0vgbVVuj3B9eL8wSCO9FQgSj1vnUTmvuYgeOsJNMPNgWA6siGiMt
         py7xUSeFdEZMTob9DpW9H0jXJI5WdFKj8dGKuE2jjCIDj1YaRpjDTUYpyLUe8/fTM2wB
         0o5STQY3QmjeW626/kB8gNXFHtRE9C1DJnDxCuE0tmu3coVg9kzfwQjNwSL+U5wJH65H
         4TEw==
X-Gm-Message-State: AOJu0Yzun6V0C2dDlSzIZXoEThZjMajTOedSPvnmFUW3NpjzTFuTcKn7
	Liw3Dy2XX52BLhY06OfLz1IkGE0lbx23ryz335Ksw+GPHklWCZbsudAId6KNdcFUYSU=
X-Gm-Gg: ASbGncuUw9Tkshzfmku4hz6GK/GdYnoyzcX64lKVio+fKaP679CGh9LOLg0uw9+Tpja
	r0f2yQAaqRS/zfcd4BfJdB4DR1VpR5H0Ojb+M9V720L3HZFD+b1u8y99DUkyKa0RtLPDROLf+tC
	v6pGbhCUpFMQA8+hz0kiAGMOiZmxNd6E814KVMcbJrF0xCrcjoxqPT9asGGSCW2J0kE43l5hKXX
	dEO5wyAncaa7q6q882lBGwnIxk01vaG32EUlGfBsEEqSjPd5bOrWUBk7JM6T9nFIUEm3bTDttmb
	Z/5sWFjXR8uBPyhqcL2MCHo8AZ8t2rRdUdTZm2DWbq/leTA5hSmEXNt8qL+qGy8FtA9JsjMUiv0
	4Ae5Wn11kW22mFQlTCHd1ZGdcK8aiVV3aKdfT1XBKjU/XRmZIN8z+WIxHtYisHeBK
X-Google-Smtp-Source: AGHT+IFlWTF5WOzkIXIZY70TiMkV+dwbPWzTmWOpp6OHRIk4MOu/rKmvFMqIXWjKtv+kofwGYOnsnA==
X-Received: by 2002:a17:903:22c7:b0:24b:e55:334 with SMTP id d9443c01a7336-2516d8187fcmr66151985ad.8.1757297145305;
        Sun, 07 Sep 2025 19:05:45 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24cd5092951sm94757905ad.18.2025.09.07.19.05.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Sep 2025 19:05:44 -0700 (PDT)
Message-ID: <2a1e081b-22d3-4f96-a0c5-2427de8a44c5@gmail.com>
Date: Sun, 7 Sep 2025 19:05:43 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/52] 5.10.243-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250907195601.957051083@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/7/2025 12:57 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.243 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.243-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

