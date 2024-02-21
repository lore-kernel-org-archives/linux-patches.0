Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B943B2B6
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 23:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708557970; cv=none; b=GQ9xgmSCai7UE28SD9Mez4tHCGYAAE6ruQZJOdGuNzQakj9WZCsibXmjm6lMgAY3lC1Tbw4UnIku2s1TWgM+LgsHK1Ur255uk8M9sldCaI70P5Annv4M/0tGIg8RgK1yZmqAFrvgCoWbNwqi9Kw7ng20TGf0kjHNQ5Ah0Zu4iv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708557970; c=relaxed/simple;
	bh=cLrGhOhaE4oHc94BO6GQrRS9UTk5Y8xjOuCUBV7JkNE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fkjjrN49KVkSGHUvMCcYCjyb916kouy9DikppL54nkK0PlWxbZxHmGXwNE5DBxMWGvCYH1fdvni3nHVhBfngwpc3CQydoQmHriFre1aenskvDDMfn+F3CcodPLDBfTySXowtpyEP/h8lMgeUJ/I/aZj+/yhR8BMM65WL5PtIP+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bh+Xn5FG; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bh+Xn5FG"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-68fb803a4c8so932296d6.1
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 15:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708557968; x=1709162768; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7sv3xme2pkmdyf10k62kb6/EdiEZUt8KbocWy1V5v68=;
        b=bh+Xn5FGW69wHdv3yP/wfkFJfeT9YdPP4N61aZS3szoCxECWZakGlDxIAIliz4wCJ4
         Ghn1ZH+JTtKdcx0u7vhlLpfgjghg0mPlJ5f6jhMOFyeMVK8TldNl6UsqEb18+5BJP8oY
         b1+hUZjRvfDR8alA9udVQDMBHYnawf1TDnGJkCIDXUydUiJnfjZP7YshpbKt/fwnk0ln
         u06YSFJEDxza4GiOb7E6bodTjAxgAmgCilelUMEAD6y1t988rDgUrWVqTaAkZveBWgd6
         QZ5cwWhSFi9N/TamFAMMxoFLtNqMBuieMNgsOuu7Y7Y7P9gdvmpE05rzuYqZP6EG8isJ
         V5xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708557968; x=1709162768;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7sv3xme2pkmdyf10k62kb6/EdiEZUt8KbocWy1V5v68=;
        b=ew5//hIdcwM0uHPnFE4OxRm1U+8KxZFE3whDZSZ7UK20iewx6KBv9oYQphdmzMLkGH
         /jLeqy4T2a2YjzEKtljDesT6knClW5mwh80qsoKvO5k1QTnxDe/SUWk3JEgM/i+bRKbv
         OA4wxexd9XsWxcwni00UTeaHEwGgtRfFTPAMPHivj+KWrEjxy8EufLw4VvjgD9LxtcMW
         aM8/dRyCMYbr4z6bdFN58GzpqgOpI+CBhEGIRk+NFDKOuQzA00woqIEIXEla5DbXun7U
         hnFaLXLy/DF1vVboorU6OYfF0/wA+hyqNnE2JElAi5BXBZhxf3uNWBGUxDbtqYgtBnmU
         PHmw==
X-Gm-Message-State: AOJu0YwmWlxOcLPBuOYOAqNxDoRb/dmQFoCsn5foVR4++tvrzsgQ+Hxr
	XoLaOuSWk+fqz+7MFB7wNBiR9kpB/NOOurUIUrIPJWzHTBN/DZtl
X-Google-Smtp-Source: AGHT+IEmMlGNptSf6TjZwpfySh/HXHnOQ1Bw1JZH2A03Xa9iiOh52VJprA6DzJ/KQOMfPewo6tp2ng==
X-Received: by 2002:a0c:f551:0:b0:68f:4d2d:3f30 with SMTP id p17-20020a0cf551000000b0068f4d2d3f30mr11987645qvm.51.1708557967946;
        Wed, 21 Feb 2024 15:26:07 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id nh6-20020a056214390600b0068ce9f8df8csm837591qvb.115.2024.02.21.15.26.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Feb 2024 15:26:07 -0800 (PST)
Message-ID: <6ecc87b3-0a44-452d-81bb-4c18911a1c34@gmail.com>
Date: Wed, 21 Feb 2024 15:26:03 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/267] 5.4.269-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240221125940.058369148@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/24 05:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.269 release.
> There are 267 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.269-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

