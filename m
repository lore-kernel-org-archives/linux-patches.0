Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD974AEF8
	for <patches@lists.linux.dev>; Wed, 15 May 2024 17:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715792431; cv=none; b=SOQzpG8Njx0BQOekN6Hea65ORHPeE38UfhvaCTn6pbxIKXSV14cFCKOqXEb+IPWY9ckmH5s52cfzDHpnT6tLKLjProJJZ0x7OHHIx7lsTJ+onYn5cQL+ToeYvnWgcVpDvsHwhadnzGA9wfEVeD455X+a80iate4Ow2XUjn0WROE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715792431; c=relaxed/simple;
	bh=ipUnLDSp5m6fO2qsq919pjRhPcJf9w9/0pt/Gw5+BIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p4CxReHhTuC4ugEEjEFGcPWs7FpUcRa1S8kH+GkfLhXpB38sGzDnoHqLE4RR89R9ac+gUD4O0LgDtI3DhRDCrz8ki9XlhW7Cz8nD64TsWIzYwfC/g/FE89AS1ZMX3MHjFFwB1dZGydLBx3Hjo+jrOQV0vf3bRzmCzbSugmsI8hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MEpuT+D2; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MEpuT+D2"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1ee42b97b32so58713615ad.2
        for <patches@lists.linux.dev>; Wed, 15 May 2024 10:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715792430; x=1716397230; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3ogL0PcSv5uEu2C9EyEKXQC0QIaA8VojhP4hQHXPLTM=;
        b=MEpuT+D2g+SMiMOa0ZUagJpIbo0Ll6+n99YLcNSjCgp/r//Ml5DdqXt00g5faU6vYK
         MskX4nA4s9fAZX7evdWCfXCo+dOLC9wpIUDo+Igdf88FPF4JaSESoZdiw1CNTJsNTDVK
         xSk0Gorg0Kxhp71ZnHaHhdS0LWVTWxiyi2Q9nvXaQc3GocyIUaytNMj6RMtHUCN1pVq7
         6tqlcZZF0P+LiMavUGzzK41XTjAyb2eqW/5mbzmcfpT3zAoqPhHV/Be5G6DSiANN8o9a
         fcsk6s2l+IxkEFJIEkddouKCNN2gsFNFaA/JzKgI8pocNLCvw2YnGmWOtTiGCykvdnDO
         wK6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715792430; x=1716397230;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3ogL0PcSv5uEu2C9EyEKXQC0QIaA8VojhP4hQHXPLTM=;
        b=ElHsZA9NLKXLVMtMI5KUCZ7Gy6laNQCOU0PXMCSealjj/IXTnmIo9iUnTv1lXAQWz6
         L4xk41mLOBX6QC8LOcdIDM8NoDgnYgs6Agxxxp7dugURZkRiaZrZ2g3AA3GuB1A4LXbS
         gI+V/iOvjRbAS30lmkBB6ViZmsO2ov49NYVeq57JsdUlXh/V1s9mrYgs9h7k/8ZFdiSi
         Zqei4TrVQwMLyqY4aVonYoD92bHBsqz3ZCxHQiGZUC+K6du6/ebdFyWAW8v7d6qgm3LI
         HNxnrtYtPt9+PTgp2ZcfiBKyp/8xV3Xn7dZSocwd625lB4HuG6HEV0JAAmxC0xL/jLYs
         7pxw==
X-Forwarded-Encrypted: i=1; AJvYcCXlugWe2si3b79uViU2MuyJmgvnUr5/2InCvfqpcLLPFPjmn/JZjWMd42x07YiJ2n9U7KDAcY2X0IIq9FbRuFPF948Ka6YxBQ==
X-Gm-Message-State: AOJu0YylQp9ZuWbiXRqFtxECany1m1fXWIcxHbaF13N0mmI4FkzSyq7b
	ZlKVMw+oirp5kx4qm5deLcEeOuk1w3izty263vfQ7Vj/7UwRntXt
X-Google-Smtp-Source: AGHT+IGipl44hFoMXSggtw7I+OXvYdffK5jFslHogrO9eSXQLuWok/sVFoWFpgfWeMn0Iha3zJ6dZA==
X-Received: by 2002:a17:903:24d:b0:1de:f91:3cf3 with SMTP id d9443c01a7336-1ef43f4d284mr168274375ad.55.1715792428282;
        Wed, 15 May 2024 10:00:28 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-1ef0c0361b2sm120009205ad.202.2024.05.15.10.00.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 May 2024 10:00:27 -0700 (PDT)
Message-ID: <7e82ae93-5067-4bcc-9a73-27820d8b3dca@gmail.com>
Date: Wed, 15 May 2024 10:00:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/243] 6.1.91-rc2 review
To: Guenter Roeck <linux@roeck-us.net>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com,
 Florian Fainelli <florian.fainelli@broadcom.com>,
 Doug Berger <opendmb@gmail.com>
References: <20240515082456.986812732@linuxfoundation.org>
 <39483cfc-4345-4fbd-87c2-9d618c6fdbc6@sirena.org.uk>
 <CAHk-=wjntFiQ=mM-zDHTMnrqki3MN3+6aSXhjnJozBaKqLLUDQ@mail.gmail.com>
 <823e7e2e-4536-428c-a029-8907ebf89635@roeck-us.net>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <823e7e2e-4536-428c-a029-8907ebf89635@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/15/24 09:58, Guenter Roeck wrote:
> On 5/15/24 09:20, Linus Torvalds wrote:
>> On Wed, 15 May 2024 at 09:17, Mark Brown <broonie@kernel.org> wrote:
>>>
>>>      A bisect claims that "net: bcmgenet:
>>> synchronize EXT_RGMII_OOB_CTRL access" is the first commit that breaks,
>>> I'm not seeing issues with other stables.
>>
>> That's d85cf67a3396 ("net: bcmgenet: synchronize EXT_RGMII_OOB_CTRL
>> access") upstream. Is upstream ok?
>>
> 
> Upstream code was rearranged. d85cf67a3396 affects bcmgenet_mii_config().
> 3443d6c3616b affects bcmgenet_mac_config(). bcmgenet_mac_config()
> is called from bcmgenet_phy_pause_set() under phydev->lock. I would guess
> that trying to acquire the same lock in in bcmgenet_mac_config() results
> in a deadlock.

Yes that's exactly what is happening:

https://lore.kernel.org/all/d52e7e4a-2b60-4fdf-9006-12528a91dabf@broadcom.com/

Thanks!
-- 
Florian

