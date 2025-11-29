Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC1E238C3A
	for <patches@lists.linux.dev>; Sat, 29 Nov 2025 17:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764438234; cv=none; b=NOtAEsyvOeOgz0nyLUJmsPtD0tE7gYpbtAhRR1DOfBiAlzIvnEUYoFiSiX41laTOJXB+/xu4O+HZkZLw2GZUPnp0TWsQPsAacTVNOAWR02Ua1aV5pc579aeTVWmWonG/XFu7X9CiCJHU8XX4wAd8MVr8rf51DnO1BxkgcBc/B9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764438234; c=relaxed/simple;
	bh=hr/EnxzYarURpGb9g+Wt795YBjF7OBdlPOZnM7GdUlE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZR/XOAvf28Jjfzmpko9q2CaUZFlO3MK7L8Kv5cBHy2eHOenTza89Ma3ISTxm1Y2puxDb9ALNub9nM+Tp3av7Y8Zns5T7gbcyv47S0gALDM1IRN8oPaOj571ObHmNZb4pg53UN/zAa4dP9ACSyTrx8016qY+QQ4Z9sM2sfYoFMyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nNrhRvDM; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nNrhRvDM"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-bdde8f1814fso2387602a12.2
        for <patches@lists.linux.dev>; Sat, 29 Nov 2025 09:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764438233; x=1765043033; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LjKc+y/SFNC4IxZSCNtfDR+P0M3U1zDfQwhqKcnpxBE=;
        b=nNrhRvDMIvvU+vc6m2WcWX8V7vcnl7e9e1I/CcxKY6M2bpdepYUzucanyaZnvY7xFB
         w3gl3TtOceV3/mtqDXEb/v8RMzEXR504mQgRcLbWMutBwg/34C7j71LuiDRjuFR5RoVo
         Cqid3gCU3NS96z7J4h3xz4qjCcygOgXuT6L7WlHdpfs/2jTJvhslpODEAKp5RlqB+LSV
         DhTYuhG22qSwJ2gcj/vLre4vhznyModMu7vgmlt4VDCYc3HKukRidoSFaCS+Dyh+RdsI
         g2sSz0Ro3Pu+Y/3AbeaQwuYZO6MHebURZXPsHejhKSAlGIxDjEMWOxpzQH4ppkQ6pNoX
         U0VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764438233; x=1765043033;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LjKc+y/SFNC4IxZSCNtfDR+P0M3U1zDfQwhqKcnpxBE=;
        b=m0xIxLVlc7Vd3vatZdNu0R3EzWJa0Lc81NMIxXbmA4sG/dvHPdoCQ7ZfqMAumY/fGj
         aGsZ0NIxcKrlYX2qoAGCU3MsDyfGSQDRZnPji77DzUu9xVvW+ag48V2GLcZCbHUK7Ti4
         vTYn2ip2kiKn+5nIKdxYzXginiuhNIkPAHH7Uifj25BJsEJmlYzwMoqss8M0w3H86qRY
         xJMIa+dP7w/bMLgEtw1VcWwt08piOcNRgY7tcZmfaxkaFTJgNHwaXk6AJxtxOVSJ73Cq
         M9Jmvce+HPmuHuLrBrsNNgt0wFuo0uiY7M8Y2L9qhBsbOM/J7W4R5OLUQNyDBSc2DeTx
         dRDQ==
X-Gm-Message-State: AOJu0YwbowYk33fRY8b7d0jf5EX/50L4ySWWi2B9OqdeB25AzMfSkOBg
	/jdJbF4dvuc6VGDYbJ5mGViv4rRi8fM88SWelKAXjPPFl85FvaZn08vR
X-Gm-Gg: ASbGncsjv109Dxc1/GPWGj4zX9M+bXcjhpwHc1CV4S2Slpy5LMGpFKbyZKGDyGMpaQ+
	9zpLN7cY9pLKhSppzowO/2EQLLjVyYQHV9wyfh2hZbpO9FM9TO6CQS+ovpE2dOuTXLWowvqdNv3
	HwOLj6GKLtNLqU4oPrH52PqdKNi58NE1JeAf1gB/9JS+F4CPnxkbb135SBcSlXj+s6RAyb0be7i
	EckbjEjRergVdwJl8vUxQvb8PNmfDopP7HDnZTyNSthz137DroCSGoN23gSi4CE6I+8R87N2GCI
	tu5SOPB5k3OzVKBHHEH9Zx59PKvrN8YMp6uvWIomX2cmmY7LPkzBIOW8+z4JPniVE3fDbdXX0y/
	kLnE5kT8t5jpzR+2739dV4+vIgp76zUTHo5ToLvWWYtjWBzpjr9g4+o8ttUQqiODQykaJx7gbdt
	Ke/LY2NhNEFxZ9wm1Wnft1cXU48ShKGGAPKnlq56o0Ab5+AMDPE6tq
X-Google-Smtp-Source: AGHT+IH93LL3+ITbLAjL09Z3q3AunM/juzsLkPDlXTrXTowB7qxVhPg3FS+bcxr2Xm6E0HA19rYfHw==
X-Received: by 2002:a05:7300:6b0a:b0:2a4:8aaf:d6b9 with SMTP id 5a478bee46e88-2a719112b90mr15450649eec.13.1764438232493;
        Sat, 29 Nov 2025 09:43:52 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a965b1ceeesm26746638eec.5.2025.11.29.09.43.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Nov 2025 09:43:51 -0800 (PST)
Message-ID: <9fc9bf59-8d96-4294-ae3d-5286588791fc@gmail.com>
Date: Sat, 29 Nov 2025 09:43:50 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/86] 6.6.118-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251127144027.800761504@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/27/2025 6:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.118 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Nov 2025 14:40:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.118-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

