Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072303;
	b=T4dthodzcAp7jLmjuGb6Ikgb9Dz24nqrPHWIJEx5ih6tB/sWOY57M1n6UBmC9N1nAp3D
	 2bDZw+JV1m5qrfghvFcL99272yMtSThbF/jeoG832M7u0peNojpPC9nBAH4MvtUpXV9OW
	 nk3kpOFUuQe+wc9cbumb7oidQrPXT095nSVt334W+K/uSC9voU1X3yNFsLvS2XuK0HH28
	 mhStVfWWcJ8FGbV+Q5NicrpgooM435dBRkY0orm7hxfcSGj5HQ09LgfqJW5yAXYd7gM1R
	 evqZ0Y3Z9xcf4kkeMmSXDrF6pVoqN+FPB2K7AHLAp3LhNQDJq2+PoEy/RuodPzFtSmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072303;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=56K4FbTqN9iuqeBa4x5ePXVEpS5MDyK7GetIQvheO7c=;
	b=Nc2pBjiduF8wznHyOSzloQb0lpFahBHNm4PuK3UhaYmVtji6CZFIjIO4H3PzYjbpOqxL
	 j93WTFqxBnv46xxTmheJB2iQO0JJc5AqiJYL+Cfvqws86aWFA5ScZwYJdIis0MFmyLArM
	 GkgVUVNXquJ7GAaO0SWfb7pGpzAE0OTwAAqs8yp8xRSxKn3i2t9zQ+KkQkjreijlvRZoX
	 H73tRIhz34AShPxoffLG6os9e3jzpcZd8pnAEAnr2NJZf61UcuRbP6yRFAoBB1S1ntQAv
	 h99LNp9p/H6Bl7ft24gypyVewQZNT6YdyWtfZnY+ozwDWmiWJZp9Pyw9/fsDdK2+0Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IrmAWafI;
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F264606A32A
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 07:11:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F264606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IrmAWafI
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3b0e0e65adbso1009738a91.3
        for <patches@lists.linux.dev>; Wed, 18 Nov 2026 23:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795072302; x=1795677102; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=56K4FbTqN9iuqeBa4x5ePXVEpS5MDyK7GetIQvheO7c=;
        b=IrmAWafIY8Mh+1dvG86UiBPAt2YGV7T3Khqn31gub7xgQbc9WNInbTN5mEVNscyuL5
         eicjNnLjfuS4wbNjl/yN8lhedTZYazkTxYJCxhpTA9qHp08YmtUAaWr/Hp53tZfcGt98
         CgS4nmwxe82h5wW5zHAhxybMcwj0ncRSP0Is/SK2wBmH0o8lNqt/+MQ8M0On6lY0XFKr
         yiDGrJnq30UiV7eAvKz+QR4OKtHi9543a3q/pmXQphnPtte9dJ7LWFjc1+zWYNLZCS8d
         ZJBC/j+ZLarxDEIHL5u2prwTR/yG9SYPX5YCitab/brqlmKnegwwN0YjOkrPRFHeA4OO
         PIYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795072302; x=1795677102;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=56K4FbTqN9iuqeBa4x5ePXVEpS5MDyK7GetIQvheO7c=;
        b=EbAsCsmaaRPcvgC9dxvCgG1N1WOepROfE0PaZ+s7qXofyqh2+JPoyUc3nanW8A/e1Q
         jpq0hSYh85u4twYtrE+FYzMotlwYPr4lu0/t5UtJ1qxnl063VrHl4NsAZCgyNrS5IUlY
         JCxYd9h4sSrJ/I9Glllzoivm0bYDV+N5/3w5wnbxIehQP7MpmhjN5enFPmrscDqaZ8ke
         fYE/u5EQwPRTkTRyrc32v29ryGYLnJdv0DvyTKp29ZKCxcKf2uoXFaQNvtoCAY5UFAb/
         4LsXTBOrR/hCI0PFNdpIUbrOcE114Wynur5A5TpIW0F4F0TJUgbDTOjZaxlo4/4EsivC
         uRuA==
X-Gm-Message-State: APuU4Z/oEFje6ez1WIyOA8k1fE97hWnXTB69bBKuNH1nyTvNTJ5S4CyM
	ViD9eVvaEtBQoxbwLxGo264Bo1bePPJzNy2gOyAaQ/PaoTk7r0aV36II
X-Gm-Gg: AZFdTZctRezFRZajp7BcXDuWcuDRTl730csZEmrbXgy/cCPJLpkfRpBPL5smUvCxo6U
	+8MZgkLayzTrt51SZhULiut1rRyXIVJ+R+limcCihhH/2ZfmrX7Fmrj9/cPw3B9zmLX4Lp3wlEC
	mUuWwP0ILDvuCS9SumNFndDkTVDt+beRsPC8F41E597cKtAvx1v/hzuczSsLYv8jz3vpFmeVC4B
	aYNXhgV/+ZWAHnXFNTsjDswLQ4+obchti6m5Lkxag4VQIFRquvZirDDXMSfsJgTk4nmGxXjze6c
	14aFjFMS35EvPfwwv5q1xokYjyDMRYuuhOrcZ+en8n79BBIEnSICHSJt6qPN+MC0ZTKWg2UPfEs
	hWrTEPW1SdvoP0GKDIZT8XUtVqN42LR4oPpe7PRYhW87rzut87JW6ZcgH8RjOdTVE3ccPuuWFN6
	5foeg/KW3I9u8gEzGgDnozyKfYa2TrY0qO0rAOdd2Ab6LDQTrWEKe4T+QtShdqqMDbPpyfbUidY
	YA5zKzcBm2ktU7k+jeiaBj99fKqEVbmdQEBD4VXw8DdR7ji3ORSAKHXeSPkUejZxaFBig8FriuC
	Og4vxGlR8kK7E4jZNt40M8NOT7YKYA==
X-Received: by 2002:a17:90a:d886:b0:3b3:b36e:8c40 with SMTP id 98e67ed59e1d1-3b3d07cd39dmr4957649a91.62.1795072302037;
        Wed, 18 Nov 2026 23:11:42 -0800 (PST)
Received: from [10.222.0.188] ([59.20.222.201])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405ecb486sm1183692a91.16.2026.11.18.23.11.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:11:41 -0800 (PST)
Message-ID: <69c61b39-1b78-4c9c-8289-8ab40cd13c96@gmail.com>
Date: Thu, 19 Nov 2026 16:11:37 +0900
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 0000/2651] 7.3.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261118150247.972732815@linuxfoundation.org>
Content-Language: en-US
From: Joungmin Lee <leejm516@gmail.com>
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/18/26 11:20 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.6 release.
> There are 2651 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Hi, Greg:

I see the same rust build error as that reported by Thorsten.
That error was not observed with 6.18.65-rc1.

Distribution: Gentoo Linux
Architecture: x86_64 (ASUS Zenbook UM3504DA)
CPU: AMD Ryzen 7 7735U
iGPU: AMD Radeon 680M

Tested-by: Joungmin Lee <leejm516@gmail.com>

Best,
Joungmin
