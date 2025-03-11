Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8373264627
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 19:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741720825; cv=none; b=cGMKYEy11/E0CG28p9sli8Agnd/uaDA1yIgG1kN4Lnx7pM4T8TsLR2rsi8W7MPbbR0+gEh3H90hr4HxtS210MHdg/rTwhCtCMjmSKRBn+e2u9ovnpB5IQIsNX+OVB1KePDi0yHnlB2fqO2OJrwfABmn4y+62JYIHRtKf7j2KG0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741720825; c=relaxed/simple;
	bh=WPsMIjesWbvLxN+8bd4H4OdLtWrSfXjKDXPtW8Rpunk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KRHV3r1By4mcU9YoaMYKCkN2jcfheFzg0jHDhuxkeievztIPtRi1ekQFVNO0sakexnbjeUgAKu5EbEEJsNVuk6/drPlsK42s6DLXzPIFAyrwp+lMEr3B7+hPdvQl3SRRWqvKkCXEHN8HbO7gNLBMb9uSknBKa8PwzXRoV7Inx7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LxfD8m1K; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LxfD8m1K"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7273b0d4409so1282094a34.1
        for <patches@lists.linux.dev>; Tue, 11 Mar 2025 12:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741720823; x=1742325623; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=mMiqGShaf6+4mNvxPXScNzPrGmIKZMZmM+gc8GKp3q0=;
        b=LxfD8m1KSpqTN2t/qrlhqZJtejBzOOYEeAfCxzVBFJBP4xdXUwCODUmwBYNiWZucu3
         MF++CKHdpjQI3rOmFdwkvpUmK3ffYJ6P1rJhEHcljTSdZz8vmWeNVQYaYi9GfKee4TfX
         Ef9JSf5a8fNmKNvzl3CZeT1Mdk3X3HVqY7bo4UVSx2XPMlJ58fqUW3IdZiXdKxn0eiRl
         2eZaicxJlkCH/6cwne/Yn0EQqDRFlQ4i+7fVDEAJwy0UnLsgjBn7D0JGT7bi7KuFEscG
         tQq32QD0/aN1O2JRGkiuq1ZN0FdB23y2VAgUO6zPz9a0l16H3V7SvtEaARxQ47QwN2uU
         /FHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741720823; x=1742325623;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mMiqGShaf6+4mNvxPXScNzPrGmIKZMZmM+gc8GKp3q0=;
        b=UgDcvCwYZ9fSmHMTHh/M1v3TWdoAFO5eKfBtbOh51Pa5KYoWaMGGSrCHdzR98lRF/O
         drFnC1nvrxhnYVRrJ0MmHaSNwzLYP8Pd0GZQKvgU+Hwa4r5GzhsNzVqVKyNXtTlwreVw
         tD6HotMEQ7F0kUxVyqbsbZ1enbxAx71JDR52B/eKXYUKEl+9YkZZ+3tSzDKY30eAXulS
         UycAyglz2tSQpQsqYCMv0ZqF7ecZc4FQYTE8ft4pxXY3vVCbdszwrI2F5F/XeYEpN6Vu
         Wjt27T2ln9dMrNIXHXDpj1WnIgic5Nw0OBSupAJbpTXkmT1RsfKqpbhg5HJZbcx1H7Cp
         emiQ==
X-Gm-Message-State: AOJu0YzGkU1I3KbRwmnOkoZs/HHzC5EyE+dJu6s2UeXoiVEfVMsag1XU
	EjDlU82UnLIyuVs6t9uQI3McHy3aiNSduLJCkbrJzFTdwVbPXP7X
X-Gm-Gg: ASbGncvmok2aczRSkhT3rKazlovvYlz0XsCLa13aWYYgigdX4VCTRdv4A3cu4He5C58
	uM7CmnB0D3zedUwn+4xJ8kAEHL4IB4gfnvL7s8zPrzfbQLyBTwjKbxOV1BmRKR8vJwHjiFpLOc2
	Mlgeolq6Cjc23NyK0ALURXWZc0p/fCnumbCmstHg917IlHbC3crTwCXLBIuJ/bFCDnZlcrJkgjN
	y/zdTDK15Bk2ECAA33HDRajPaDnf7juklXyoOVFM2UwI26SBoHmLs5yYLuw2sNMI9BgBuRMcWkX
	xkO/41Uj9c0kOIAhUnrdXlAuVgi9WyyBYqvpxBnzFTpYs+Uc/GsLDDgUI0dIwx792JsdbfzX
X-Google-Smtp-Source: AGHT+IEF4j8mRUpB2qxdGfMsANCksqXmOCN9I60IJQKLmhsubG7t739J6/Ooqp98toqiXOjb8GW4eA==
X-Received: by 2002:a05:6830:6d84:b0:72b:8c4b:8ef2 with SMTP id 46e09a7af769-72b8c4ba2d0mr5419459a34.24.1741720822862;
        Tue, 11 Mar 2025 12:20:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-72b7ce3a641sm1447569a34.24.2025.03.11.12.20.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 12:20:22 -0700 (PDT)
Message-ID: <19cc88cb-01e4-45c5-a784-1c4c045fb6ec@gmail.com>
Date: Tue, 11 Mar 2025 12:20:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/197] 6.13.7-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250311144241.070217339@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250311144241.070217339@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/11/25 07:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.7 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 13 Mar 2025 14:41:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.7-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
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
