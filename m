Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6D73E7145
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 21:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787693489; cv=none; b=adlAwZzKzmQqBlOkA2ONQ9D3ZK+ZbStcI3F5EeCPBg7IaTWecNNyh/c6Q1rDrZ8PmK5deujCHqiDcqt3XYaPjhTIUkHyNPK1RkcH3+yrhEjISe2KSsogrd8qbcN9kTDR+tos2uSi4bYWl4xnveOKeno66CNY7rpd6pEezE5L52E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787693489; c=relaxed/simple;
	bh=xSAn2eA+gsK2NX+/wquGLiUFNntJe9ngu2Rama6GOdU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GDpP7r2b9BfNbWqjQR6NFxGLPWyrGBHSlEpEVAX85bCewbp2N9n9i+XEM+HFFFMsRlp9DL2E010ECL0ip8aSyA0oLhpY1vkRZRuhhyOfwsL645jZiKZa0JNU1/n9mpAijsHHYuEvORaNQ4/1FLBrKYAchyroAxETrY1uXZa6eqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AvawckI8; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AvawckI8"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cedda2ce6fso2437265ad.1
        for <patches@lists.linux.dev>; Tue, 25 Aug 2026 14:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787693487; x=1788298287; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CmIh6qdKxbDeRlvcOdLJQsm/geP5sjQy9z3qmCMHb8g=;
        b=AvawckI8ReOIJvn5mzX5HUh5weMnU/OPIBJMlBLAbCGbnyrSPPOFonmIj0nHELq6Dz
         zZJLcEyONh13I+/4lH+XUht/QKMhN6gWsS/kuUOoGSPGwQNdSeEXopJ+uofSWerMAuBC
         TF73yPEGRcdXRgk0J+hDendolwAtLt4y0ooIBcj4Mr8wIw5tu9jLtoKg54RILF2sxEhj
         dzl9aRCFfM6JxEsPMPv6/xP2b/YEldxPGxZBHWfG092M0rsY06PEHlQNA2NY4Mgj1Ey1
         BTGhh3MAbXHr5Mu9dhhkcsLtgrUTG70w3IMUpATb00ouP7i9+2wcGp3DHjfF1yHeL4UV
         SHSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787693487; x=1788298287;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CmIh6qdKxbDeRlvcOdLJQsm/geP5sjQy9z3qmCMHb8g=;
        b=aT6RpiCMWIc82kgkvig205YOHR525Jk4EUtV75Ew//f85PH+O64CO/H0nNzSYGhEZH
         l5mkgXhZg8ymgagfpdcd2Giv9t0vDSRsJu9g6pQsyQbv5JFwkadrMPTFYirfSmZQmwfi
         KHGv9PH22YqLPVbk3kRJdJGrzNftoF/nAl3SCGbIkUubXPmBQg92c1QnB7ZjM4raHrji
         SI7LWzreCCStQvsjgNWJ30aZIyeFekOZNE5gXSP7sIBd+fzrQOnlFqDzSwAyKC4CsnTO
         DAN+hhtqEpMtqT8ewOcmCOnGfS8t35CG7wiWKU9ydf2N38WVwXYMggNIuNvIiNzRBHaC
         Rm0g==
X-Gm-Message-State: AFuF++ka+js30kahGcRIPP/OrDaoh5wyW7IRQZUuePnYEmKxI/gInG6I
	GNF29sRxZLNAiHcqORHOHtb8u925U+a0miZZ2NLaAD74lwomRVDuHVRd
X-Gm-Gg: AR+sD11FTnKvLji/PBIB5eP/B5t5ameLVaGObcBjr9CV7JBJ+Z84WyCoVaJ4C9yg4xI
	SzBWEp/OHv7xsgCFEl35gd9a7HLQ1CYMKpXh8ZoigS9UfQTQ0KkmqgViCUHsd9hHr5Y/KUOKzCm
	Zo5Xkch2QZ8LevK9sMyAEINAIEY26+dBs11ma/GzlnSoB17+haMyhMB9taDqdUbnJJzHj2CORql
	SjBXpvCSIMCJDgg7zoHK8OLYY7UgxYRAM2zOe6aNEcxZLcWSmSRp6u+OMZn/fGcZvlmrxH2eDw+
	tpqFPISr9PHdSaqEqE1nkgRXiKwyThKr53SXUAXL0FtTYJ78Olazv9RknnIMYvsR8aLiEjzngFZ
	cNgm0MoV5enF6z9t8DyhPNoo6k1CJ8JY5M1L5EmUXSyos3dqt108Vf5f4JKRxVio8Q6AfNhyjl4
	mZ1oEZwcWvvQWYORT4jbf+5EuvaIGjaYEyg0iglfh2MQ7kZalVwQBAj+HhfKptRtGySbKZyh6+X
	V+tEXp1d0RMjkvg
X-Received: by 2002:a17:903:19ed:b0:2cc:864b:539 with SMTP id d9443c01a7336-2d7079ffa9fmr22032265ad.6.1787693487074;
        Tue, 25 Aug 2026 14:31:27 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3283d60c291sm3197944eec.6.2026.08.25.14.31.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 14:31:26 -0700 (PDT)
Message-ID: <d1e23ddc-f85b-4c4f-b866-f7d34b498b2a@gmail.com>
Date: Tue, 25 Aug 2026 14:31:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/79] 6.1.185-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260825132541.677185791@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 06:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.185 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.185-rc1.gz
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
