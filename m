Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D46A20B1E4
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 16:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741277019; cv=none; b=FKSzBVOlRjh83GCbQGXUXl0XjlHb50adOLNEoHh6NP7yL9uzEldcX9W9z9cASmAFaSYB5eufoHr5dTDwydmaWutcdn9fXCDJl5/tLry4AmKVZqzcX+t5aPjynIWJg27Ow0KejNLLREef0aESUg6l37AHSVq/vOFojfsYVpGpCU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741277019; c=relaxed/simple;
	bh=xVNSnb0jyNfDW//8xinTnXuPgEPSTDWwEpiqXIaFplw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ivB+A2Om7L5GodgX7rV1qHka0zoJNwxojARP9rXaci7ccCNjqaLMKyJsK8z+oTWlJGaYY8mQqya+oz7Xjp5TELrNaMeEgl4uJytX0pElJZCwL+paK7BN9cpAxw/o1adIy4x6AZKq2te2VP+0sPL+x5wskxsOuxsNEltOGNSLYEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCrso8Ec; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCrso8Ec"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3d2af701446so7573135ab.2
        for <patches@lists.linux.dev>; Thu, 06 Mar 2025 08:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1741277016; x=1741881816; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BcNdPRCInpMj0KbnCBF2KUxDA1QurFq8iTZjeemnwJ4=;
        b=RCrso8Eco4FKhQynGd3hMIm2b4RuBizUZbHhTEZWHVLdHwmiWvZC+O6B90s3Vd+HaS
         GdabzMNpPZe28xFLdMDCM2w1TWhfoN24xBrv0ak1zMBFRny+EfoSlN2F+bSfA2kFRDFh
         FOIi4Enh1dstHCTdPCsVxSjVMi9AOAK3kASAw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741277016; x=1741881816;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BcNdPRCInpMj0KbnCBF2KUxDA1QurFq8iTZjeemnwJ4=;
        b=NYE4I5xFvTzEBwKFVohBhPaIIEk41tWq5v0Cj/bxY67MQKJuCHhk7SguJThj0jxp5D
         YW4xTVCXFAynyanej35OpsWWeeFbZoYtBzpnrlkU+DmOQKu+1zfTo4AZ3GNOeht5JXCw
         9HZ4aqldNE1DWr2KDpQaKjV56gDBHiAxVMimpM695gd9X6afLNe+bHdZwwk+9vZUV5/4
         in0gVpMcs8hoh7ZgMhFxS8YGEpRr9mkGfa6m7rFvunG6XxjRZzIicyHBU1Y1miPF4sIc
         TXMP0iujSqjtyfD2e+9Sax8s6Vz4WpiIgG4XQgy/vnBcGujiFPoCTPTXPhkrNNMlgPRd
         +1ag==
X-Gm-Message-State: AOJu0YzJgtXywXkYzC77nzh83tQQztuceENeBXOqCNi+lCxi5T6P6AVq
	/Ngj+eUK+FVx9gs52HPFjUjPJg61IKmucMLX5+PYf3GO9x8xW+Yhq9KMDrXySuY=
X-Gm-Gg: ASbGnct5hddc+6n/RMxV7sXhA/tMvPV/fbfRnfCb4WRFR0/CNqhZPS6fw21PVDnaK9v
	fLMFvPX2ydHguTsLmpSnBVyCf0/elTnOqyfhtvYzTTDBQcBPDIBkGpLPYeGs7DaWLz3KcmJ7mpY
	0BsEoM9r/Fv2qDyLqLoJLcBNMisWYv0EERAhxVbJcUSJza/RKlHSB6r7dcXsDKttYSNJyCaqshL
	CPm1wcnykLmfg9VENJo1axTWLvLZoDFKbGsZGUi024mzw07vsT7hQGHJMMx9ou6S6UsCa15jMJb
	52WwfSJAeaFdDkz5zDD3/RezH3d8q7YGUIDXeBO12DG0p1MRir70qQ8=
X-Google-Smtp-Source: AGHT+IGQHGUCX/DcHAB0f8MKsKPYCnuinUn3LSlGNP0ULjdmmx+23Lb00DxVmOwmlf9J59UO66TIrQ==
X-Received: by 2002:a05:6e02:164a:b0:3d2:b0f1:f5b5 with SMTP id e9e14a558f8ab-3d44187c021mr799245ab.3.1741277016390;
        Thu, 06 Mar 2025 08:03:36 -0800 (PST)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d43b586ba3sm3501015ab.45.2025.03.06.08.03.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 08:03:35 -0800 (PST)
Message-ID: <dc1e2731-cfeb-422f-8243-95746aafc889@linuxfoundation.org>
Date: Thu, 6 Mar 2025 09:03:34 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/176] 6.1.130-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/5/25 10:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.130 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Mar 2025 17:44:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.130-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
