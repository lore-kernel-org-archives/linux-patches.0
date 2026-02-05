Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B47630BB83
	for <patches@lists.linux.dev>; Thu,  5 Feb 2026 20:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770322992; cv=none; b=EraaIrer4zrwu9R7SuavWqK78U0tgLqpOyX/wxkZ830rI7aMcju9e6sclr2PieU7vN8tZOzTju46ieeYAhxbiPpxmyRY+o5SPmX0qbF57TjRK1TKWamMD2+1hriHlcpWaEV2DE/nRBr3FVtLCBDpOhRVXt7HHi5Br0KKA1rxVZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770322992; c=relaxed/simple;
	bh=1H6yOvlkgfRdhfiB8b4StbElJFSjTj0AYv822Df4Usg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mTGbNB/BP/RRjFk7ByjzaGdTX/Gfi885KOr+V/BL7YFAaJKklVg37wLGTb32BhaZ/LIy5xm+o2rwRWUZkl2YF30HcGHiukNs7HvBrgU3SMjrzHak8UzM8oHx44bZMPxhJgu2svRnGIpud9Odg4sOjmZV5342oqw76I/FfiD2oBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JK07cBqx; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JK07cBqx"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-662f91bba0fso1531999eaf.0
        for <patches@lists.linux.dev>; Thu, 05 Feb 2026 12:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770322991; x=1770927791; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aQDPSDXDektpkBXEs0zQ+AUHNiEaUoVGQ6uI5fG7CkA=;
        b=JK07cBqxJQi+mz+VZQXKUIM+jepel7YdQHCwV0EbnrTjm2x+//XZP2+8jTG2/1j9VV
         TZaG6ozL1/o4mDYiOcDXUYrAz7/PYHcc08srhy16rNSt6q68W3b7ZeNKsQhgAhleVWg/
         CxiJFwy5HVOHXUWHO9Rinii8UvKTYIZK77ojS4As1s56GPEx18qHkNduYycZZ9VT7FTe
         rg531HJG251KD92Mo50ucwf51CFf/ojKaGSD+iRz84GB64axdbvz97iRn9Vemjw7rig6
         jVqqspKReYVHgYhIzHYrq9iD5uvsC39/OQ0zvn2kat9kFjYPLAov7wv9E8oTbq9lXoWi
         xrKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770322991; x=1770927791;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aQDPSDXDektpkBXEs0zQ+AUHNiEaUoVGQ6uI5fG7CkA=;
        b=htLG2chKxf2/u0IT7IJN68VKApo8np9OjBZOil2yJWiqIzfmlMWWP31X3601BSqtwW
         97sQKy/jwYjLkjJ9MLwNNY3wPMGTRr9C5sEos98oXfepuHUfocGgxZInlX5cP87s9Xhp
         xTbgUF7PhSIudp2h2QOHmmppP3eC3Etr1udmo7wxOgoT+659vgSbVpu9dHjgzmF7KiJw
         K6282zX+kwoZZdoeYPueINQzo9vIgw1dBTG1OX0mffsCJmqCGNpxmrYLq7N0yvA4winX
         L0DrSMpPkJ4BfWsHjMA43CI7hrCyVJN33Yk4yrXTrMeDUWlTW6q9kvPfVPDZz7qfZg+W
         /IDg==
X-Gm-Message-State: AOJu0YygW/wAP8DGjA8v6t8IScjYFEMXdDhLN1pJip3b/vtiswFdJ9OL
	4PFVnxkk1kT+FsLHSfwpspkkNwVLxio1fEVG+oVphpX9g17I5c4KHYTX
X-Gm-Gg: AZuq6aKUWviUt0a3oxHty0+sxJ1IlopssoE87tL2ZRSjEbrM4aqoGmQJCsjUHPazavD
	oCIAvJQfY1s5/pvNRnDbaN1HTsabXhh7D5dCM0gfC5yFmbyVqKJASbE3dyR1mXcAlynXjkOApFF
	UQGTMRuY0C17+UxgUDuotP86OnVzZj0IWt9q8LqKZjjv9KBYbBaNIKkm5u81D8dPp3C54NixmG9
	gKOe0QZAhNC9zzlCVUeShTJx88MGi6wuGZH3z+z4KNvtREbWT9mhSbuEhU9TzTip4PMNhwcnmfe
	MIdcxrjYS5kUgNnYeEhUDmVkFIuYU6A1ZJvNrbYIkAGJ+mcCZhfblgQIemh8aaKhncMyWccJ/Pq
	W4oUMQAVOIrZVR92hGVtL/aQkSL3yefP1QOvGWVgYpWKP3whrnyiZuvoK4k8cua9BGZZeSIR4PH
	yf2PWCeya8VBdG2tiFaJ7zaZ+EjvLw5RM1dQNaag==
X-Received: by 2002:a05:6820:160e:b0:661:154a:c289 with SMTP id 006d021491bc7-66d1534f706mr274351eaf.31.1770322991028;
        Thu, 05 Feb 2026 12:23:11 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40a992ede02sm157502fac.4.2026.02.05.12.23.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Feb 2026 12:23:10 -0800 (PST)
Message-ID: <bb053dff-cf88-4750-b678-09c215579e20@gmail.com>
Date: Thu, 5 Feb 2026 12:23:08 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/276] 6.1.162-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260205143450.492803005@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260205143450.492803005@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/5/26 06:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.162 release.
> There are 276 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 07 Feb 2026 14:34:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.162-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
