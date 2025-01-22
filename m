Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AB7214813
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 17:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737568521; cv=none; b=YTiKFVcyBO4hhp5wgyUDaksnjl9o8N6xUx9UhFrjjvX63g59/kewQ314PcS2mO0CawjAs5sEkDT3LnE4odPDdVRl5XS2uohGzjpdsbQw9NOxLR+jOMUXURRU+C1VJqoyqlb7tYTHEuTA5uMMfouLFOZrFoMHIWC1pyHub3N7z/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737568521; c=relaxed/simple;
	bh=FiKvQhWWcgzjNg2WfDfPY2XGbpoyGRFUq5zQ8wcvRMg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FCUNFSKELfy02/1MrHEU7KDvUGRWx15K+5jVVAJ8RNoxtiuJCfQUVxlLKPuGi7Rzdh+b1MRMAspCKPISZUwvAhmVNSPEtizWjOJXUADPLi0L1JJYvRYeTcVvvnrZtt0mMMSNPefW5BNaMmvshQFYYIrGkKgGlxgNJSVX2I+yxEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZlbpTx9+; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZlbpTx9+"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21a7ed0155cso119127755ad.3
        for <patches@lists.linux.dev>; Wed, 22 Jan 2025 09:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737568519; x=1738173319; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tAmirg1CIyb5YzEX1B8dmfqHpOOsy++HekRqtBIlcI0=;
        b=ZlbpTx9+LUS8diImNLewonYmNsROdi2amY08KSy2+6ivvsZP54u4l3wu+PwJHVYd3P
         mRdnGW6D8eMoaRfnZ9bCkvT43HIMKgW3E09P3v1DiYgHmHwQtAt3SKG3hU0n7Fb8yVRM
         flUW7DaDc5LwgPRLkc3XWlPkJq0FMwj+YxbG7OCQmyK2l3AlqEX4N2nwQTr6+nyX50B3
         NAI24ulo0WWz1bsP6+++o/ieTUH15E6dxVSlLe4VFqi9J5jCcVGRPyMLN9SWMV0Sv1Ho
         oZ5cemUvm2X4+3pUHgjFWuQ7/u3rtII/L6LOpLBPoRCNtVlrM7irbjlCRR9M0z9IIFso
         3cMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737568519; x=1738173319;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tAmirg1CIyb5YzEX1B8dmfqHpOOsy++HekRqtBIlcI0=;
        b=Na6lN9cD6pg0J3gNIl5shqA7nb9sZAcdASjW26dWi1MTp2Ip7fwgXNEmvHUCIbu8do
         /nkUDIneVKSM/TKteSlyvDerjvttHolmJyu3NRsx6kuyf0858BOIZkXham57xdtficOs
         5Wh++upL+4NxA2EUy9T1Iv5uXx1pn63AU/7PETizwGTtZzfhF+Elc8mv50SUI0CRnj6k
         dQJXU8ncMthtVHPU2FbAPkc7hJdIcEeX2npvvjPTvXl1g6SHaIc675WJt6vgRPgFkry8
         FbY4pDrx/v8SQZxdfF52tUk6vUN0tcJqrYTPo7EwoQhIlez/vL0x8VYcIRy2oCeOgVoz
         ovIQ==
X-Gm-Message-State: AOJu0YyBpNR5TXeFvaytRCTwBvoarqqpO+F/jYlX0jbxlxdTVaHgcDnK
	KeYPnbqU28JqElAIskwKR3aum4+nKr0MQGXgcvFC/fgaZTQ+8U8S
X-Gm-Gg: ASbGncsYcMcF4/5GFGX+rKKz44Hu51JrJI1g67WOPd+AjMosrcyEtSXytYF4mmBbZgr
	t2EC6gsB4OkKZO8hWedNMlVL+9x+5arbtSSIH5zfSU0ruuLzgWWMWxgzZ1esEM+35J+yQpy9j8n
	KwFPEjer+s4RZVVYs6HmhBuupF1l+CwCQ9oJA4cZ0fwKTqVcy52SmMBrcxc5t124SzZ43l+5kyj
	oObLksCLI08OtG6jJlNHWoAOli+XPrHoC5MS5sD3Osmt4Hf35X2Sbq5tw6jXJLs7ylnMUOgHPI9
	pptUQKwIxJdqmBkMXEr5qelMNOyCAdct
X-Google-Smtp-Source: AGHT+IEdGAGQ50OumXsr2JAd0xVZ1mHUrvK9F/0nSsdNgSw65VOA248e1RtT2fdqEeMcxlGB4NF9Dg==
X-Received: by 2002:a17:902:f54a:b0:21c:e19:5692 with SMTP id d9443c01a7336-21c355c43famr330708385ad.36.1737568518886;
        Wed, 22 Jan 2025 09:55:18 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2ce9ee18sm98968985ad.52.2025.01.22.09.55.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 09:55:18 -0800 (PST)
Message-ID: <2e6d1073-2b31-4ab5-8ce9-050ec05f0c54@gmail.com>
Date: Wed, 22 Jan 2025 09:55:18 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/127] 5.15.177-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250122073830.779239943@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250122073830.779239943@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/22/2025 12:03 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.177 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jan 2025 07:38:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.177-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

