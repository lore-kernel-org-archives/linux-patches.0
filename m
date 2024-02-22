Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC1A28F0
	for <patches@lists.linux.dev>; Thu, 22 Feb 2024 00:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708561501; cv=none; b=Q0P5b2dkcm+CmOLEPD23IWCWnqX3MCRDgDphSpiTpGq+AzX20Bxh5lfVfsUkzxBzppeRPQBOwNS1fN6xUsclbiUA44OG1dfWuXFUtrWR1a3DCB9s/eoen6nx/aBGxBS2V6TSOwEI5dKZKZgl4EUKW51fKrmTcQlMnqHygAvhp8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708561501; c=relaxed/simple;
	bh=6cM1nNU4sUYIudgP5How1TvdFL1U8i4R9xzk/u45MW8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VEp4ZTqqp5CNe+5WcSsURNnGSQpnBGsiJqAhQcAddFSKh9PAqon3tKK73BVI5jZb2KSbNdULmr0XrlyEVpnQqI5W9/uxC6P7PSfLIuL9L0LYnmpOAKgsEqqDmgkZhjEXMBdkT2XEL9G8uTZME2ydRmKIQfUqe/O6uVlWKeJgZYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NmENPqeh; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NmENPqeh"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-68009cb4669so35266806d6.1
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 16:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708561498; x=1709166298; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=anqGFlBV+rsLg3vMhzVMgDCSwtexSsDpUKQLzjs1Ooo=;
        b=NmENPqehPB+CmPQBKkIPHJRw4hHnod6BGdob+mHR0qImHpC8v+Pd4kT0J3xxx39bRd
         kGkZ7dOHFCNXAM8jg9m/Pb9Of7A5lumKXrHXQMPmD3PV6UWDPt7qx+4yafZalG39xHl+
         9m/9b13vTDaTGS7q+I/XgIHvPZxFr066KKb/iBqAf9hYbgdcidHhDFgw7Pkhvwy8Txt3
         MQN6vpYrzpZ/wfbhk0tLxwd82n7vxglNP4Mr2vJ0JSpIh7hWKq6ElKUUly0IDpuwqDRk
         r1uI5frVsaeL14lIkLc8B52mbJx2jV9XXq0vkYflIoO2/jEYbPo1IgLg7UQxEYjWtThp
         LWQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708561498; x=1709166298;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=anqGFlBV+rsLg3vMhzVMgDCSwtexSsDpUKQLzjs1Ooo=;
        b=KIPw1TM5MqBb506JHrCrqPrICqk0Xa68LkN+oLEkyOPq6XFwt9aufbJy4oHV8Cfwjw
         K4bXmng15T+9N3ntTN3urU0+P+DaqDQ4RlMDMdryYaCh/+COa6CzrevnH51YRr/qT2Rg
         EbC3+K6A6/jwP4WnOwneqZSRruSYEGKwgwfqz5gc66ohNLCt/qJeJX18ks5OZTWoV7lr
         C8jF7herokV45piYicgjkvIg4so2S0hBGvvF4i81ZyV71Cv6aVIymBxUKnmOit3LfELZ
         jOmQimaOs1IMU5DVBQTCTh+sIqH6i49u+wORmbakaLO4RnrS9LrgqSTX6z0GBwyZushg
         REVA==
X-Gm-Message-State: AOJu0YwfNcvpVWK7pB905kh2HOci74uNePV/apUfiGzhVSxf0lDqn9HF
	yBWzhuFUOp2LEtt7kcqth/KBl30jC91iDqXb0dfgEGNajniPOk7RPmpN50bCuL0=
X-Google-Smtp-Source: AGHT+IEEGx4qOQu1n7xW61AL2JSTReDsufs5qC56cdZ3yIFGqrRdkeZ7gcw9oBgnuzV4cOIWbbFgiA==
X-Received: by 2002:a05:6214:2422:b0:68f:6dc5:149b with SMTP id gy2-20020a056214242200b0068f6dc5149bmr10959031qvb.58.1708561498418;
        Wed, 21 Feb 2024 16:24:58 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id db15-20020a056214170f00b0068fa7e73367sm1160611qvb.42.2024.02.21.16.24.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Feb 2024 16:24:57 -0800 (PST)
Message-ID: <58d5141a-6813-4831-ae44-9ccfcf79893b@gmail.com>
Date: Wed, 21 Feb 2024 16:24:54 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/206] 6.1.79-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240221130223.073542172@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240221130223.073542172@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/24 05:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.79 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Feb 2024 13:01:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.79-rc2.gz
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

