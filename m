Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A431E0DE9
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 22:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729549760; cv=none; b=sKuMOL4jXU//Y+ht0Lv/9EFOC+YOFkeWpCJF2Gar0t8aRezPcd1l01fVcUrTeY64Rvj2Tqsx5n+jpILrdhqm/fT55lIumcbvMF3ibl/4LhO+dqpt5I1Okgmlpa6A1TwhYwnNytnWFaSZM7m2Rn/cjXZNMBBka12sTXGfPsWEmUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729549760; c=relaxed/simple;
	bh=DK5cAoaLipLQJ1Qq11dmR38yV4BdPfJO6Co5qz6yZms=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tNzxMY85XnJ31G7BhBCRaxcyzHUwUetfyfTw3FIm7VGWpfT7V0/l894R65O4+ayZqhvD196aSIr4L//VxZ51F8keDJRx02zCu4Dtc+8LpELSsV4y/q0Id3YTepeKUyVsoNYhNwpt6izG34Zt/wHNiUAGkfOvCOE9kl2kRHo/5+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=anRawg9E; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="anRawg9E"
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-8377fd760b0so198035339f.2
        for <patches@lists.linux.dev>; Mon, 21 Oct 2024 15:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1729549757; x=1730154557; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TA4XM5hTiGNOd+KQ3u3JDVeWEwmpgPZoFJVi0gICoWw=;
        b=anRawg9EHNmIBpNbhPWAIaZiA/6zW1hZyUiAzn1CikhXPUioP2GTv+vZ3PKotuu0f0
         bF0nKD6+gm+nYH30kER5sPnltYWqK1FoUFzW9DkkrZfhkJAtiyo86TJ6i7HOI8e54f8w
         5uqS2XljBYVyHaofaWc/OTYK4+N4QB9RoC/OA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729549757; x=1730154557;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TA4XM5hTiGNOd+KQ3u3JDVeWEwmpgPZoFJVi0gICoWw=;
        b=EzrMEmnxOh5ONOPztOjlrFzDfNkE356jUetdDIh319X+QT9lt1ab6lFlQQ7AZCPknB
         Y/TuKc+Lq0hCqnjLtQx18lH7LADwt8p2XmxZm7rBBwqq6k1nE8a2rPzGPyLzprGle6xs
         5AxNQuBsXV/uOOBgo6J+DtS8utL/UW99ZatkEtV7QAlYp/kUn4QcBhlt/Cjv5Co69xO0
         s8jGsZ46CwWrNYPJvuakUD4j9cEQ7O8LcuINJ5z+Q2gwhgrbB49UkOy6Ldl7TrHoqW3j
         os8BvfdpBLK/sPBylPRBoqkVmaFInKK7eXuRPsyojVuxSzHL+dDNvSVh5KAJ3G0g8wFB
         BEzA==
X-Gm-Message-State: AOJu0Yyw1dYtFczsv7hvl7ouY2i8FeX3I5NC7QoQcLfJw6jxf3Cjlv3j
	aPmou+lp6yMUXSF4VJX9IH3wBw5eVVKPg1Bih4ymb+C2p8Bx2O105qmsNQDoht0=
X-Google-Smtp-Source: AGHT+IE+r2Sv2Vi8956gLES8UxPVDLR8WmGuc8PVr3WktKjFjqRF4T4ZtzxG0LU9kkxugixlftUMTA==
X-Received: by 2002:a05:6602:6d16:b0:835:4d27:edf6 with SMTP id ca18e2360f4ac-83aba5f2764mr1039351939f.7.1729549757368;
        Mon, 21 Oct 2024 15:29:17 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a60947bsm1235916173.116.2024.10.21.15.29.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 15:29:16 -0700 (PDT)
Message-ID: <6049fc80-b936-496b-b1d0-134de9fc19dc@linuxfoundation.org>
Date: Mon, 21 Oct 2024 16:29:15 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.11 000/135] 6.11.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/24 04:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.5 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
