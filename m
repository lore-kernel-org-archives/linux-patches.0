Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5272FB98D
	for <patches@lists.linux.dev>; Mon, 22 Sep 2025 22:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758581015; cv=none; b=po1v1u+Xs2pwnIk6sV+uEjSHQewp+K+XIYySyJ8u32aBCLDkwm66lI2K4UobHzcQskeKO8okRhMl3QdosF+oUk3DtOpE6/qzqlVgJ6kIrVtx3EUiYdfX8EOsijs0oWEAAN01xxIlXDbPiFjlQqbmQxJf/OLmp46IhPKT7uqIbec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758581015; c=relaxed/simple;
	bh=uk8zDoALOJGCpc6J5qC/9xvOmqzcv8BXgnYFvenDJm8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jbTp1AmV9QgZoBIUpbGEUoMLdJeHLjCx5S4gMiMZshUaU24JuQB0iqtbDcBTU5BdACIWa9703AhKIFUTNDhmL2E8h4vZFs5x7i9cEMItIEh9toc0uXcI73f8hZp0OlLLEqE13niccZjj1/K9HTlbGbDpEOR5cAo7Atz3XzIeXRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q/xeNsN2; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q/xeNsN2"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2698384978dso42140135ad.0
        for <patches@lists.linux.dev>; Mon, 22 Sep 2025 15:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758581013; x=1759185813; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FgCSsQENa288XITw/HVlbMVFXGjqWN4OmK4n73b9eYI=;
        b=Q/xeNsN2xyDO3o/Qsv+9HCYBHmedrF3868pI+ElhlB4XsYCF9YA61AJFBpBfRdZcUd
         JWJ3XG048YSu7mHyFGbpHxhBXYf0C0s6MhoL9EFgV+infSYBe7C/wInx1OWxWWYda0O9
         hPGeY8zLD9LZlMRS2a90dChjUXCEP5CR/Hxbt7kIoU7iVBFgs2cT6GI1OUSA/T/po+Bt
         SGPkjvtK2/CO8itcpvUBcZ+O4TGL1urA9U80yMeWJaStSUkus7ybJf+1PsySQLmogpQH
         UHR2acVipKp8MMOZc30TsPSf80iBZx9xg6qB4rM06ET/M0BESUONKlMqWpoX0fiMElve
         lxNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758581013; x=1759185813;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FgCSsQENa288XITw/HVlbMVFXGjqWN4OmK4n73b9eYI=;
        b=v5C9JJ3j79C0SOwD+RenZRRBoy2njtdnGDpgs5sGQLQoh3W7JB9uBr1uzVwmIZoSnN
         GW/NK2nGjfkn4QgA9RsVVkTkObYnvdrPWrBurNotYf4gLavbhUhs/KNMlApnpP5OG3+P
         mrvrnuReF+Oi10fld/NOn7OjOrDAON1OhSArsy/nJAHuV1G8sSX/jCi3uFjl53jeX7RV
         TvS+GBY1pTd/1G4cQae4zRDrSHo6asWTBA2LlX+lnc9+F6a5g4pJKABOmnHeSyuZ3bYA
         jH7QvekXAPGrfrGutv9xqUmlVpm4993K/s0ztX/Xt5A3wCUYFvVTPeRpcsjgOxM/bXhG
         IU8Q==
X-Gm-Message-State: AOJu0Yw7S4SRsnCKLaHhUfaj0jd+MBOjzk5npCiO48Yfuhs2f8Zd9z6o
	CMYn/DEub5WTFrzca3nuCo/W6P5QZLIu2XMyMTdE1u1QwveTMWtIqa2R4bWrfw==
X-Gm-Gg: ASbGnctSBaTTHR9LRSava6nTMJjbNbLb1kUXunUkU74WeK/GyVJb67ZN66oQmnO1mlT
	unKD+Xn+UM45iTKRosgABq0x9UVO87n9gWd28cYB+Ojsfv7DEhuh1f9vPx9XVrvqLoN9owkG8ib
	Gy+wiWjSVlDsLCvC6IYfpm59SeSknLaBVWEO96X0zWSPL1yOBAwGvRlZfTk7S6BgsXqxampM/ee
	en9GOxRtJqniRdPA/2+ZCYog22c3YR2SybLleCPmWVG7av6r+3obsdy8Sc+jStdimuwcwpp6R+/
	watZ8PavWVhdqJZGL6bQ/pRHfN+Q0Om+xUjDgjYwQ35fumyYSouAiv1WJNfjQo8QU35AT9ZPc8k
	jDptn5k3HDhYv6rF8/26+TJ57buc7DDKAJXqrWLkiBvlA1rtcsNuBMHNG9UGoYFCkNq+PQKqli4
	SVahxs6FXt
X-Google-Smtp-Source: AGHT+IHIp1qkMddrTINGGwbaE3hOjo0maJ+lSPzxbZ8279E8GS9DPPZ7W4x8rQ3ZYqAY/VwbhzNeaQ==
X-Received: by 2002:a17:903:1248:b0:269:8072:5bda with SMTP id d9443c01a7336-27cc71212demr6761385ad.54.1758581013388;
        Mon, 22 Sep 2025 15:43:33 -0700 (PDT)
Received: from [10.255.83.133] (2.newark-18rh15rt.nj.dial-access.att.net. [12.75.221.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3306085e6dcsm14314305a91.29.2025.09.22.15.43.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 15:43:32 -0700 (PDT)
Message-ID: <96c99d72-6231-40b1-abcd-1d4f968fe904@gmail.com>
Date: Mon, 22 Sep 2025 15:43:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/61] 6.1.154-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250922192403.524848428@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/22/2025 12:28 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.154 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.154-rc1.gz
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

