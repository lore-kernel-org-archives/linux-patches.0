Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B051C2BD
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 19:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709665696; cv=none; b=EnusKiH2Rm2xinFnM1KTjarNBqTsjMwL2+QZf6wqb61ZF3/BRUOYSfhy2zZZwZskM5Rcbx9W5dvKzFTrtgxZCpDYjja/HFH5EduV78bu1RW8d+dbFLx5aAilXSOvZLIHRG6klxji+y6dMkqwGKilFx2QM4ZOWQFJzjPrFuNDG88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709665696; c=relaxed/simple;
	bh=zb4IZTY/x87Ncc1bMkL3CTMPfWQYFZkRxFcrmtUHFnU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ha5JDIv/iNEr46fWUP0TBZ7aLgaKFxpAi489QsJIAT338pWINTJf3UxXsVxnbOmLeluLacHnLARUn+Me+/29nguYexh5No8qKx/KMeR7rHDyRkEuiyhaGzI16AilN3J2/52/fVHoyM+Ic7tVQLFQkY5nfM/NswO16q+RBtrwQYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+xmVSdz; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+xmVSdz"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so69292239f.0
        for <patches@lists.linux.dev>; Tue, 05 Mar 2024 11:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1709665693; x=1710270493; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7/mpXL7vjAphJHDf2Fr/x+84U+2e2qh8Thkn8K9to5g=;
        b=U+xmVSdzn6zjscvO2Hv9dtaBr/wMpmsm8e0weuxPxKbyVrIhHtusXIMJ3FBU4kESfr
         xUPa8HDXptIxBRFKivSNojchVahTjB1lBPHBA8rVFhAq38Tdpb5+Km+eiB5vHO7C0z8t
         6+9Y4wtfCJqxMxcaLHo5i309td/+Eb0Sa6a9M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709665693; x=1710270493;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7/mpXL7vjAphJHDf2Fr/x+84U+2e2qh8Thkn8K9to5g=;
        b=fDL+SClreQlKSBzLdkyU5ZNdMOMTY8s6cF6kY4hy4vcU03NT7/TomEk3WDgf2Kwvr+
         qIkAYjmWFZ4d79rOJg0GQs9Cy/5em8s8Bl0e5h+oiCJgHu3BMbmkVpHyf5JiHdQxm4jq
         8a9LoDHMsyzNjnp7dvX+Yj8QWeqw76JWODhj3wdsxn2jJrebq1eA/kb26+NEeqYA5fv8
         A/iRAycG4Sq3D8i50NtqesgEAXA6rf3gJlUlBxoLEW+RFUK1TINUBgBkDHz+6vGNklEh
         DY+5r2tGX1YdQPjD6Ym02HHUuN+QSIRoEHrENffFzLYwp60OhuACDNti0VWVY7apB8KR
         rWvg==
X-Gm-Message-State: AOJu0Yy3FqNseKbmou2jPWqLNrN2Bi9bsh/dgTNpvT3/wOkfMWaqWWt6
	hRaIhC/cstpUn8PrpNxPYvFg5LKq9MQxic9z7xfUXEhBn+ikpBBCsVSrl+ppPYM=
X-Google-Smtp-Source: AGHT+IHhaLRxwGXGGeY6kU0XLCNrsqy86E0hTy6A2CS0fhkBIb8OsxhB/njDQVKF0hsBaZ54VPxVaw==
X-Received: by 2002:a05:6e02:214e:b0:365:4e45:33ad with SMTP id d14-20020a056e02214e00b003654e4533admr1424775ilv.1.1709665693631;
        Tue, 05 Mar 2024 11:08:13 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id m7-20020a056e020de700b00363909191b8sm3190492ilj.39.2024.03.05.11.08.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 11:08:13 -0800 (PST)
Message-ID: <b7ccb15a-4271-4bd4-abc7-038a7930657a@linuxfoundation.org>
Date: Tue, 5 Mar 2024 12:08:12 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/25] 5.4.271-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240304211535.741936181@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240304211535.741936181@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/24 14:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.271 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.271-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
