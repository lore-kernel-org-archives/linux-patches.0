Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B3B25B667
	for <patches@lists.linux.dev>; Mon, 24 Feb 2025 17:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740419563; cv=none; b=WBmI5Gim1VxzlQ6QrT+5kOAHAIHYG/XJhOTMo3oBln+2UcuSShMsrYE/Wn0ekgcZCxZt4MQLZcTrx2ZzsKQhCNhWPbsgzL6GBvrWUmSa7Whr6LmVwio2kGUmqCd7TYP78CT+ZHu3EewbDoPzYnJZ4f55sd+P07bVOow5uBlfH8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740419563; c=relaxed/simple;
	bh=NCWOxcc0FggZlDvNi6x8FO5aKjhVwqAojymTejm/gw4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TL8qDmL+ORmP56g1JZ+eTilYNcaH5Ff/3R18/X6tOV+Z5jI9Sa85jn98AZT5XQ/Ebd6px/AMhJ4klK6Vgnbwno211o/kezLKLkT4Ow5/2gzCgdbKwqNv0Jf7okt1uyk1BeOx+jXLiDLVDQpn5Qw05fi2zDntjM2DjVKjvK1iLxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cvV/1iTz; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cvV/1iTz"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-2bd2218ba4fso852942fac.1
        for <patches@lists.linux.dev>; Mon, 24 Feb 2025 09:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740419561; x=1741024361; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=yIlvp+k0tIx87AXyfg99ULU0xhzVvlrx+I8UJDBnNyc=;
        b=cvV/1iTziPYXWSymkKDglIwciH+u/ETcAVY2UX5PgnXcPPuc0jHbgv83ixqXXyxD1i
         zAWZBR7i+sk6NCiuX/ROBhcT4hnGIpVykK9tvV5aFk8tKSS61xzto4z5CsWxM3ipNX2a
         F+1U8g8CWZQm8jhXE7d6mAetT1OmyO1kSGDEdOA35r7J2MV3Ehv1FOwMwOgbCT37EgUT
         Jl7nhIpZXZtUAkBYmdCezVCT81FADpw22J0K4r8ycdhXvoWzu7cyMd1c3q3IV7RS/RwX
         kgFS5pn2iQRi9nf2WE9Ze72CEZsTLWg8WKeS4fOlKpNdcp2UxIlxHTngEI3EUx8QQx/3
         5a6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740419561; x=1741024361;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yIlvp+k0tIx87AXyfg99ULU0xhzVvlrx+I8UJDBnNyc=;
        b=qEpn5N1u8wGG7p55o8ylY0PeDHO5Q7wEJIZ/fypiAVy7FEjb0Gy8UYExiQCtIy8Rt4
         kYSJo9ZJHSsq/6A24unvZo5uNI4QIbRAetC4SmMU+sPSQXbqp9LO5chVlexuSMGAAINf
         fcbmj8dPKP2LdllFQ48OJsHRM4cq+JQ8NO/xa5vYZihL1/mbDS5nuQk+SjETM14hUDSm
         NCFD0n72x5U5tGK0CrJi3nXZuW2KpLC3GXTUCv3F3mfYu7cyYoMuKYaBwvMoXuVmEcAk
         8Q/OFt514YpyrZ7RsnrnU9Kdvv0cZCsyL9XzbLxHL+yYy2xe/dKUi/iZGtaed/7PSnS5
         IR+A==
X-Gm-Message-State: AOJu0Yz2idtWg9fBIqMS8Z5y3tPPa67lvGExVvrf26nFZDsWme/pBNsi
	mz/Dp3jAeH+9vIKQvE474qZ2jN0zAlBdH/dbQjlMkZWHtSzM2k7h
X-Gm-Gg: ASbGncu1yHC0PQuM+KB+n8oxMKeZN6irvhaMAwhX+p/xV0PH00mD7MYM1MITQTFobDP
	OYqxsyo48UOwrJYGXXoK8G8aMLBvVuU2TjhmTE0ZoygA1traun0AczBsoNT+PoQKY9Edic+eHv1
	yzH2COM4Ehj/aau1UZWLs7WZ2Gk33reAX+3M7yAwbstZEuiQaWqJoBdT45y0YZd4mmqX3v9yoW4
	U6f5IeeM5uZHYbZ7M7jPnGHgVHYxK9GQ7EPaHdr0/wldPzAW+TLACFGmMT1OErfAV/pzVbVemrB
	KOv6k73wnRtWGZGJmkrZ0srRISaoHQwF9fRADZQpxQ==
X-Google-Smtp-Source: AGHT+IFAAhDz+5WaiPZ2rXADMwKGQp4dEUYxwemzE0/IOQc9mAVrcQ3bl5lQM2sU02CK0QSvDCfkIg==
X-Received: by 2002:a05:6871:314b:b0:2bb:15b1:55b4 with SMTP id 586e51a60fabf-2bd51810cf4mr11184858fac.31.1740419560902;
        Mon, 24 Feb 2025 09:52:40 -0800 (PST)
Received: from [192.168.99.86] ([216.14.52.203])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-727295b7eeesm3654778a34.46.2025.02.24.09.52.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 09:52:40 -0800 (PST)
Message-ID: <eef85f1d-604b-4c53-bb3a-9785b23b186b@gmail.com>
Date: Mon, 24 Feb 2025 09:52:38 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/154] 6.12.17-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250224142607.058226288@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/24/2025 6:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.17 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Feb 2025 14:25:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: FLorian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

