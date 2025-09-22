Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354181DE3AC
	for <patches@lists.linux.dev>; Mon, 22 Sep 2025 22:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758581314; cv=none; b=MxMt+WO0MHxHDdV+AwuRk7AKks1+RZVI9WDEzrZVA/mPFKnsvtx1YvTZYR7V6ezmG0sRSf5i02OnhdIRpnuQq93dD1bfRMBo2ZCYlmyZS3eFrMOFs55nNmmBcFz7LFFeEbfqdo9FaZfjT7lBFYOJYR+hS56T58G4aCKu1inTWNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758581314; c=relaxed/simple;
	bh=2Z2tTtspoe5psrZmrmmvyzFTIj55orHfEAQOmXO0Qiw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rBDX+eck/XPl6QVUFHruTY/2JZcv7uvxm8qFS2tnJ9FlGOcnOAnPE1coM0e01F2sWJrQ4FBdKryu2Xx3D77ivXLKXUg/ouVLI8UIWfCA3JwgDLN07tWDr53tG118RMPFMoXjxNUjX8PUNQz0WOvSy63Y6fZvt7zORTOtCIAD+AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FBV5oHVL; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FBV5oHVL"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-24456ce0b96so55362805ad.0
        for <patches@lists.linux.dev>; Mon, 22 Sep 2025 15:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758581312; x=1759186112; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CLU0RdHoW7PoANfhukGPTAXKBWaFmMBiRRNW5pcWh4Q=;
        b=FBV5oHVLpiErFQK1+w8IDDDGTMM+9deS3DksIzXoYXjc2cYD4Am6p4z+RbAHmJH/FF
         9A3ZG2G/2VnAPStjgydsqxjr6o4ZW6qZJGLuSvldyUSnrMO81vxC5NN3WzfMne4ZdwBj
         sLXuSftM7yAefeysTR9W9KEHtkb24lViBgYHZ32LngXAbl4rfcbIK3NnEXgBz4X4gHGF
         8/MVZ0htjvRge+pa9w7/7WBwrlLs97N7NzHDL6AALeSZexurcDoyLBN5+S7HX/xlmFEZ
         zomEtyXl9JURMvrdxS2DnFOlwxDaGeVRO+A0aMNU6uqf/c2/DEQJvZNH+9UJa5TZHT8n
         2Npg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758581312; x=1759186112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CLU0RdHoW7PoANfhukGPTAXKBWaFmMBiRRNW5pcWh4Q=;
        b=jU10V8CoZ/vEHKsN9og72I7TheOCKXFzJ2wgxHX8Tul69+ZuuXc2pcP2AhofXAFA6l
         C8kZBDH1cEpaS0pHYCoOJ8ImKEgkW1SJUJbfw6dnNmbwEL3dpF8W/VjPK/SitTSXA1Ok
         EmOgtBL/aee+LufztMk7YyUfkpNQlZPLXctc8mPeXpl5BPjf0K6xqVqQNPIwzKBARYHL
         IVmDiuTqxGoR5DWD4HGt16tATOhVuYDQAwYEyBeXBmnXQPcR4gHQDSdpM0raLpUcuY+3
         /7ytScaOx/wAwt05MriiYD06HPEOghVCq8ilfD8ENoW54sZ6CPHBFt7fONQx3GG7Qmfo
         tLuQ==
X-Gm-Message-State: AOJu0YyWyx4IJedTo6/9Q91HoC8xbMDf37etTEIeLG1ISRZ/rFsmAevP
	6/oyDuhEHq3+tdzKGsRqLbIuwFPJbw0kyAZQXK0gNd1ULLdxHmP/QxlV
X-Gm-Gg: ASbGncucAY6xD2ZJLoo3LyRzuToThIvTgMzBu/X6IHrpPy7mXPrkbaTTx7A6SfYG6pp
	0E2XAWfS86Vc5AAhFO+jjccGbwhnioaGDG8QXRPTaGgxCO0LStd6i96fq6ip3JGsVCyHj67AxR+
	fEgrhLadVXA9e+11H0X802rf2Pg8qpjoyrC6I9HhcF36R25rTpLgf+IkEbKFJeZQMOHURDnOanS
	p0ipepTJOgeO/bI7kYFPtTSYUQ12IdFhIfsyOG53YjUegheqOWiaR/VJwpfKvAc+x7xskektw4p
	X17dpldBRPhizUcWqjq3SrDyLfcULJxPoKBu+m+qC73u2dpqhjUXSZ/8UIXqc28GdVumiiMeuzz
	W9RaoFMFgj0e1r/hLFvMlNICAzZrfaJhviMhQUbt85dk5Rr+eItzmFmjM0xwjbrtZvBu2CqEVUf
	JZQqalI7OB1lGIYC1P2l0=
X-Google-Smtp-Source: AGHT+IH+XQhrEjeck5jGys4mBDO15ghzcFF7hUwWuk/zDaYKmd6hNMS+rOvtx2mxlHZTk3VSN760sA==
X-Received: by 2002:a17:903:1a30:b0:249:71f5:4e5a with SMTP id d9443c01a7336-27cdbbd1124mr3539555ad.26.1758581312340;
        Mon, 22 Sep 2025 15:48:32 -0700 (PDT)
Received: from [10.255.83.133] (2.newark-18rh15rt.nj.dial-access.att.net. [12.75.221.2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-26980357043sm140133185ad.138.2025.09.22.15.48.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 15:48:31 -0700 (PDT)
Message-ID: <c27d2fdf-0c99-41b2-977b-cc9551084fd7@gmail.com>
Date: Mon, 22 Sep 2025 15:48:27 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/70] 6.6.108-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250922192404.455120315@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/22/2025 12:29 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.108 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.108-rc1.gz
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

