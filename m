Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22E418E024
	for <patches@lists.linux.dev>; Tue, 30 Jul 2024 23:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722381162; cv=none; b=bR4UGMUUl1E7CW5KGDTH8JdFMBdzzSvcVkD9HdQ0ycdoUVVe58hWzJ8BW8SMmrLelc/pV/V6xgsQ0cEEO1hw0vma+l3kaAjfJmSj8lY72ma5igHKxqTFekEErt0rpOPTQ9uKqTwg+wZEzLr+fTHUNeNXpHfTLTsS/Qxy6bu+x6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722381162; c=relaxed/simple;
	bh=6nOVtisGZrnzIG1KbHoEr3XdAicZOw547gyR8vU/FIg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=blCEBQMQ4pS+9Q9PoCdrLmjBIxprLR4xBHkhq0UBmV7Q9YO88/gIKLuNFVYEYUoIxHG7HkVNJtJY5abOQbugrg20q9/74tB/ZNsvsjC7aJldk42F4EAq+dJsimHxCsrAt37i0JZaEdJGI6WTSX49SxiBjh06tr0/5OKCfCq3R/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2QR6XGB; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2QR6XGB"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-39b06d77756so288185ab.1
        for <patches@lists.linux.dev>; Tue, 30 Jul 2024 16:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1722381160; x=1722985960; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J2P1E71IYkzOdBwnRc4tNA6uPm3qXbUhT69oX7YYVj8=;
        b=B2QR6XGBznbBjjbLN858K7q8G9Or9u5cHpFCAUNOCxRs9iiZrVMDIj7FpzopcglWYe
         YjrtCWFKvhoyFjCYACHxFN214vE28XaH/FwA4Z9AEF09D4ETogLWICUbOZ6XleEFGFT5
         ckgdPgAExKsSI0BgVIQO19GNmpYETrOMa7BrY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722381160; x=1722985960;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J2P1E71IYkzOdBwnRc4tNA6uPm3qXbUhT69oX7YYVj8=;
        b=nRevoEdx48VtReCj46vnsVBnHPfdKZFcsXK/I3sWL7TUNmB26eaBpwkeIcnDBhaP8a
         DV32k5xx8xXsFkVX2BeNK/1DaN0g0OeHfGl6G11yJVNB4yxrwdrOre8VLGujapL12z/D
         kdEVm6DYBBMKUdJndfh+yptXQz7+CE+6h6dcAGKvzQtGF6BYVkXnOjA9KFVCCwkuYFYU
         1HQkqHmpHX7nvnvN99pnXNnGPM1NaJQkfJycX8bhlxllkEoopNpxT2Qh/YrPFvNL9fih
         TldyG/+um+TYx2plyGoPkKNBSjBWpQYIufOmEwT7FKOXWG28P0gIHPLzZlHX/Mui3G0n
         7ueg==
X-Gm-Message-State: AOJu0Yy5KDocMoGAhPWWY2kb4ixVgeIljfM65OLTDDGZnpu2sehpBYPE
	/mWTRqL5730GAF4uVO4Y+7snxJQkBt8qHrGQYO/CdceKEtc5pLAnVV0W1RvEK9g=
X-Google-Smtp-Source: AGHT+IE6YiE9ln1YhYBVo9IaBRhL2NnvcTn0NQcPP1byApuoCU9ZdscozIUjeO+SX5ffsWwUjlgBFA==
X-Received: by 2002:a05:6602:6504:b0:7f9:3fd9:cbb with SMTP id ca18e2360f4ac-81f7cfa447amr1128113339f.1.1722381159820;
        Tue, 30 Jul 2024 16:12:39 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c29fafb9c7sm2966159173.82.2024.07.30.16.12.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 16:12:39 -0700 (PDT)
Message-ID: <9f5f6c00-0134-46e4-8170-757baae16193@linuxfoundation.org>
Date: Tue, 30 Jul 2024 17:12:38 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/568] 6.6.44-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/24 09:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.44 release.
> There are 568 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Aug 2024 15:14:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.44-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
