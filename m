Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1531E51E3
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 19:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744226767; cv=none; b=JDhLwWO+kaZUaxSMe5OfFbd2VkaBSlPhtFKYoC0Q1KIpGEC/Ku8G8ELaI1CIuI3d9gqkqD8xKVx3EgNZ4fbXANIuYmXrMbuxcX/NUnzETwgwRhobbbTmjkvZ1njJUl1ettXLdFbaL/g0uQyFRqmdeuI63VZP6xfEQ0fpnaAp67I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744226767; c=relaxed/simple;
	bh=3SBEV8MZfMBjCqYFLD+ArNUi8Y61hUNgzgmis3D/R0U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hVO4i/Kg7nYFVmaHvthWe/qQeaCd6P0BTwFaUSwm0CtpC9mssVMR4SNdWMWcA3k/fHpotWIojQKKiGdDHzPUFnGBr3+E3LQKhpR0uixv6cmmbUOjC71QvuIAISNSX6LQW9kqjwgqL13z6JPdxlLCON8ZHLbjWF4doeLv0YRsADc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HEZ9cjwt; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HEZ9cjwt"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3feb0db95e6so4700811b6e.1
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 12:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744226765; x=1744831565; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=i8uCw6ZP/r7CK+ezW/oHT+okn6HNIqDAYmxKjHPCBPg=;
        b=HEZ9cjwtiFDd7ykKVDka2ZUXGJUX+D3sqqQzPOcXZU0lfA3BXxSNfml6tKGlVrsmXW
         QnfrIWuFIPL0VXxssYbZ69V3B/xVYj3VeaSkk02jHvDZvB5+H1i3rihCkcLcUgZKUEDW
         VHjwXoOGtaXloQRVT8vGoK5rUaom29Cj+RrT4xWmsIPvIb0J+M/52MzOYyT6VnP+Pogm
         KIdZbVCEwrOhveRMri31TVHvZjOd92e/4nbIWkaw15gwwSopTFVde76M39/AnPgYKD6P
         DIB61UuOfrRHFz/vOHpZMjkwBCZOxeAoFqC3c9zDDyv2ihGd9g9WEx8Uww+Xk6SRGujz
         TG6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744226765; x=1744831565;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i8uCw6ZP/r7CK+ezW/oHT+okn6HNIqDAYmxKjHPCBPg=;
        b=dpH3s9+Ly1cT8F0mrd/2ehCdhA9y9O+l9mchs1CEOJKPoOqLeFKeONtorZlB5OHOlE
         nY+3LFJU5K5dQUAdGM9pNf7CjYHOM8uQfpDyu+1kXy/LO0RqtgeprZAVp61thlNSWba+
         N/mkaim2fx84PyMjmW2nz90NBnQH5ttMoJFNQUnjDI5gK0ig7IcKx4P1iqKQbwSLvbcM
         N7gg1XnSUmMS3XYsOjynH4UuQi9VACAjG8uvvRI5W+xElN2eBeWMt8srutyWH9OD3075
         L01v0t70zf4hGaFQWc8wfKUa4xQVotRRQmw5H1JY4wdOuDLX+eMDaAD0UfWYRYv01uQX
         44cw==
X-Gm-Message-State: AOJu0YzUez7MfgwdNID+YHLLwWokgbkHI4aaXNGDZPqOT4xoxtLIg7Cy
	j8p/4XcMs0ixAJCg/1uSiqgoCUkW8zme4Y40tOnyjnUu/POkS8yS
X-Gm-Gg: ASbGncvnYiFy/BfJkGSYCA88lyZul2L2M9vr+mnQx2r1g28SwJf9R7DlkvFlamBy46l
	lRvjoi2LxJEs2of1pzVjftPkD/wO2chyZDzSeNAX0BbVj1SGrh2zIkQxttv79eXuhWQ64B9dafU
	VjS1Fkkz4ld6EIbmtAeGOGxmMGBRRG/1E4k/LbUqTDqObowhCPCYoDCRluNJe4fAfqk34Va0A3T
	V366nWefOFcDkGWzxlMtow4S1kHRl8n+Hpb+lllCh5G59GyakhHBim6k+uSEof1JEcjlED/vQrr
	AdegGZOQoJEMHZuUF5ZvV4kw/dX2qSjird9usKhM+vCUOHoIVkx9gkpxUs9qtl3/+Q/E
X-Google-Smtp-Source: AGHT+IF9qtLTL7Dndec2tinFOG4yDv6dWa6r35oGFtyju8MgFEtnsBNPWP88QJSq7xaJtwUlJFiInQ==
X-Received: by 2002:a05:6808:188a:b0:3f6:a6a8:d340 with SMTP id 5614622812f47-4007bcc3f63mr49436b6e.16.1744226764630;
        Wed, 09 Apr 2025 12:26:04 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-40076282682sm276833b6e.3.2025.04.09.12.26.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 12:26:04 -0700 (PDT)
Message-ID: <f43469f4-9a92-448f-84e9-66ee85127bce@gmail.com>
Date: Wed, 9 Apr 2025 12:26:01 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/228] 5.10.236-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250409115831.755826974@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250409115831.755826974@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/25 05:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.236 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Apr 2025 11:57:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.236-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
