Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4062E54B0
	for <patches@lists.linux.dev>; Tue,  2 Sep 2025 19:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756840661; cv=none; b=sj5n9bk/KoPneYPJeVksWwbv8Gkcq1ZzHoJn/IfIjNATWMq+bvO1xC9cT8SXll4fdDOGToaKpCdXws/UDpIrct7qewCIERp3v1T/H0rSSXk9MQMa2NwKPvEvNcNLmUQGkGLCooFMmXNzzXt1NnxTByBzzzwywcGR80JQUN2E7ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756840661; c=relaxed/simple;
	bh=RjqLgI4citiPJIaE0ZVGeagqCqs/x5z2BR7Wa4OBtrY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZtBwHCLxrTWO3suoG8zF/Gu1foJnD0MMGKt/8TrXCKL2ZtOdtIOMB1rGo2dKCH6JxzYJoa66WCLsZotxC2aKTYtZfPfSoWzg9VcevpH4wS7vI5iHX1uJXCMo+T0zSZgsfcox2pKUs0J79R6cz+JkSxYZX9TNqlpQBoGQm6gMEOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GEgv4WHP; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GEgv4WHP"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-80a6937c8c6so13985885a.2
        for <patches@lists.linux.dev>; Tue, 02 Sep 2025 12:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756840658; x=1757445458; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=NlrkwIeeF5wYzTf+TDant5f9voytbCkXdqUnd+fma1Q=;
        b=GEgv4WHPyzqgw0PsJ/osSt7bavRDYfD0iHJPGiHQ1B9Tzn0DCzo5vDjZ9/IwPvAY+Y
         NGnsxWLI2xbUrVr67s4cAELPD0IhcOtCJCH3IXgP7O42NMTTa4tFQ9grO8aT1neKXuc7
         itmn2WbWjM0WXGiuKusdcI89wtodF1qbT0p+GJf8Ge2QaHagM0WBXRlVjTMl/5clNJwi
         unlo0IlTfzxINNGnWYcoOFRgjOXenqNGoOE0XQFMJcaInE2Fx5mZ9WlwmtlEbhiCw+an
         MjtxLqB0LiMCP1UwonSFMaqqH4VXqxLg8m33pOHJ1N4GOFx2SGXb3/AyOLVj2vwoPt+t
         U39Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756840658; x=1757445458;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NlrkwIeeF5wYzTf+TDant5f9voytbCkXdqUnd+fma1Q=;
        b=eUcBIEfzGADKpjN6o3DCg0KhDOhPNTPPQTeDrHp/NCnhF0tpWu2nnF693bNzwZTgXQ
         LiN6Uusr9C1hdSpTp9cE4dmxGIH8rrfRVBfvzkdl4u3Zoho9Dnrxufdz3rFTshWepgqS
         H8jaOyqFEqK4L2HCHTpzI+218RRCImlUOzMfTDoDbzBr2lwT3uwimjdd4uPUyxaI7EP9
         8ar4DDUyOT7nLHtiERoB4+nK1FrtrTdS27Ht7IXk3UsR+WigFNDM11uc2gESZ5WxOyZd
         LdRFfCOjzDPm92NXZysjAwkMp4GxCu7Tx5qvLMJmRuFF1HYqOZt6LMOu5bexqsrGjeeW
         p6FQ==
X-Gm-Message-State: AOJu0YwV4S9+F+/0yuSfWRDXbTV/pxeKDKtZajaTsO0hkzyPFzKM0+P/
	2SrcTYSmrCsez1zdsISpm3cV3BIjukmGhB6rpY62qeW+iFzAPNjDcPFp
X-Gm-Gg: ASbGncuxB64DKao/W3Isj777oQVrrXrqmlLCUUmy1mEX0lehIYAHWoi5QzpW1pDF6Ki
	G8ACBUYI+Eifb3n7s/b5XMROom7Adeh2h3h5bq7WhG7v6lgX5soyqja2UI8oylRlOBLqmyO5ejb
	BiID6aTbAac2eXSUmCLznqhV7gA9rhJHg9p0OuX8cNDgNIdNWl97wmyg0uMhZW0KApoVDeiTjxo
	10CB7WveU9nvNnc+4JLenL5eSoXohqqXw/lULjw78Cr/GwZkiET2sSINVsqDDAnkyLK4Ucu7pFf
	PsU7A/EVi1BUJ/RAumb7nIdGMzk0fEDnzKn6fk1jqaQ5Yw3HZ7y9o2clU+KysONUTUxW6kCexEm
	byWTVgWO0toPNFU9ePPX9GP45U4zskT8mmhb4wRuhu4GLU5Hgew==
X-Google-Smtp-Source: AGHT+IEykFJWH7yrkW7+ucL9v1OvvtN2ojheggdUlr+BEf9k5Ns2xlztzt970YBxqlYGYmBPW0OSjQ==
X-Received: by 2002:a05:620a:2804:b0:80a:5665:d959 with SMTP id af79cd13be357-80a56662345mr66635985a.75.1756840658272;
        Tue, 02 Sep 2025 12:17:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-806980659f1sm186427085a.21.2025.09.02.12.17.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 12:17:37 -0700 (PDT)
Message-ID: <f961e180-f0de-4a6f-9c35-7163fb979a31@gmail.com>
Date: Tue, 2 Sep 2025 12:17:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/75] 6.6.104-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250902131935.107897242@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/2/25 06:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.104 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.104-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
