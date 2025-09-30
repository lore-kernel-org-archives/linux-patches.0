Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3960B24C077
	for <patches@lists.linux.dev>; Tue, 30 Sep 2025 18:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759258294; cv=none; b=PaZ3dsVJg20XZzifDvy10j6ONwQzapSssdevtCkaVhy42mLY7Tm68z21P0LPHZj3WV+2+1sWi54MtZqpotLZ7sj0BFLJNqoRPqzXghn5cePWKQErnpJcxdRl20d7ncA26tkgAAblxk5ck0/JQeFRoRKDlkgOXpvHyqb877kbu4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759258294; c=relaxed/simple;
	bh=dYdnX8ie+JZ5tjHIeJUYzVzetNEwv4GKCyotFs/b7is=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jsrGklKzeqNHLijP2IZhKO6e+fzJIUbD0jCahiWuBIlx/2ovgxAHhIDxSZ1nI89o14uuNHacNsj2RmSGei9FUzkD+hNL3Ity+w49pOfLBcyFQOjF+6LhZlHPUpJBTDYeQDMHYnxDFQXVtlxutDsSJlPEnUIaa8tRnvnZ0yD4G5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hWZvvfn6; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hWZvvfn6"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-32eb76b9039so7394796a91.1
        for <patches@lists.linux.dev>; Tue, 30 Sep 2025 11:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759258292; x=1759863092; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ve1C6vWoOmZ19F9zqw9yKxDVhyGQuev6ZjtgPA7WGW0=;
        b=hWZvvfn6zOmxpJhJ0xyPYCPumUYxWJDtNQsIvRXvjfPMRkuknxpRcNSgRB1vfUl2vd
         txJbDarFTJL+JrIK0QjXZ041DTKTlHhO3Nankj2L7oClKlXbYU3vtDFjFSLrk+5+8xEd
         y7c2rc9APlLrFGa920hiKO7ViY0zStYCSVkZoVbRPi6DqVnRoUlVVIxTN8Z7UxKZosr/
         YsJWlkYyeXPUmGV5Zwx6sqI7RuK557/kpW+qdUsD6YIQY9oHjac8lLc3o6X7mNiRGZYe
         FxW/skkPkWz5z1xGRkeDiGyY6rKwGEf8LEI0bSUfki0vEWno9oiyzMX4ytQojTjBgK7v
         K6mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759258292; x=1759863092;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ve1C6vWoOmZ19F9zqw9yKxDVhyGQuev6ZjtgPA7WGW0=;
        b=u0ETk0kc/b01U5X6T3T4pdWXHr94wAp35Uc1NnHDaNlN447ksDKpKFwymx/TbfVhXJ
         4JOoWUKdyxjNedHLcl4M6N88UNzD7UiS9O0/dIN/i9hPMdhKEWmzNXLvtiF9ZfkdsuW+
         dsT9cORSxmEoFj2oTklRMP4b7S0SRTyHn1yzEtl5vBYqGTDt2OkoweXaU04lxVyEsXPa
         XUrFxR3pa92czShjJlQon4uysa5s1F2gDbFLO1KALEEVzNyaNquo5++VL6Q/vAfE6pWh
         2Lv7zObzU3f3QXUXCoDSNpw+e1v3lOP9qYLbxtiH+QrCYG2JJr+ODsNmsBiMuSWa2HN8
         bimg==
X-Gm-Message-State: AOJu0Yz/4rb0xes6C/v58lEpqKbgFHU9KR7cKnd8Sw7efM+OzH6Fejjs
	uckCcvAsjvqLmCn22Ca/v4JCkjjQ3jjwvz4hRejCozkQbWbo8Kni5Geu
X-Gm-Gg: ASbGncvG/ZJ/pRZTbo4qEtePmYQnhs/BDIOH0E7KJJn6As+DIBnRUrdpQsaRN+yNSTJ
	CDw9byiqHE4AsW6necX2+Zf+RUDTNWCnKJ2JWvb32YhXsKfYvvfsbyydwgYO9XZym5V4PCC/WSp
	0mDdZzIWGViD6jjbevNh2dFxtBNvugBx30TVp5Kr1iCkKgc6SUbFIM31FuA/7Xf+nQSJHY7WkoT
	bYedoaOedM57c/2losdAaFiFrsRIfD8X2x8ip/qUkfj/H3ae+DEv/gH8Kf1xRgzDRqfoVzUOdpZ
	WptfldcqEaqbp15UHjjhkdUCDvX3i2Opvcqz1S/UPTzLMWv362TP4t91VIPuQOxKWgKuscF2AGz
	xA30MDqtLe2qJeQRf897/WHApnzhBGhf2okiLrT/WBKReRo4ZbBWOxSmKSnp6Rh+724yjkQIBmQ
	==
X-Google-Smtp-Source: AGHT+IGzLc1/Ztb09xi04tvvcSj9Kk8hLB6B/Dp5tfeybrmtI9NtITB9D3tx2zgrXWtztj/sQ3lA8A==
X-Received: by 2002:a17:90b:3e87:b0:32e:6fae:ba53 with SMTP id 98e67ed59e1d1-339a6e265fcmr637049a91.8.1759258292367;
        Tue, 30 Sep 2025 11:51:32 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-339a7039cf7sm248164a91.27.2025.09.30.11.51.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 11:51:31 -0700 (PDT)
Message-ID: <4478eb84-a8e4-4b3f-8cfd-192fa0b8e3cc@gmail.com>
Date: Tue, 30 Sep 2025 11:51:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/89] 6.12.50-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250930143821.852512002@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/25 07:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.50 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.50-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
