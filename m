Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E68342CAF
	for <patches@lists.linux.dev>; Tue, 19 Aug 2025 20:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755636677; cv=none; b=kZQ/qQgXdkJapPw892J/UkTvnNY2WZ5CVeZobU5M7ClsKdmrlGPHsPVnYugloMZTb/WzP4siyvnBCv/AxJrw5pr5W2ld1xpcqzSoK4Cr00xMbdA7K3NUIG0RjTrKAjHh72tSZ30Qa7hduRy2Qco0NFk/rlQ3QzQte6wTS2VVbek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755636677; c=relaxed/simple;
	bh=fbXKqVb2JPhnvekqqoKj7sdPLgf3Vmir0X005Q94bOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L52+boNqgnOIblNZ5IeVkRWozF1mGdVa4tRFfvek3rzCRIJgE0UChnoWNhnCbupQyiAEl/zRd9M1NSqlQbHQBWyx5L3lL3LsjtcqSWzwSqqfKxHlnjSGTdl2yCcPTnj4wZfIRjwIvfETAG0A60ZxjZIOSVp+K46ZnuTvNIzKGGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=npHf2++n; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="npHf2++n"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b47174c3b3fso3585648a12.2
        for <patches@lists.linux.dev>; Tue, 19 Aug 2025 13:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755636674; x=1756241474; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Nsf75o5pbqQ/RVrm3BZ39NsSKgyTHItMNr8xH9NMGBY=;
        b=npHf2++nqvRF52G0YgoMXbhRsV71hvV58Jr0/MlX6OgUfC+E5oyuOg0NM2dPvPJ1+X
         qnv0eZXqzFYBKmf1WKuWhhJeBCRdIS9JtZYrOdP1eay61jPdSHi4ziTiTGgOQBQXvZwU
         dOCPJlzaJk6ikUY6z/5tnobRyA9c+dO8pEtmcL02S3zFZrnC2Pv5Bhb+0ocjSr3Au1ik
         2UKFJWyz4gkAdZ6IfQOZhSMZ8Qb2COwfTyH4u5sW9eAvMWtrdhhHC7D8ihYkgyEViR2b
         JLAjavj5lIK0umGUYdnEln3HaUxon+zBNi3O2rMGhoBzJtxlErQScykIx7IYWMblFJgc
         ku/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755636674; x=1756241474;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nsf75o5pbqQ/RVrm3BZ39NsSKgyTHItMNr8xH9NMGBY=;
        b=Rhc616IV4tLRzSmM4gKjWeKUdn4gWtdXJdFEIgNxf31udNDK28TKLU/CoUl4NeIrbT
         /aZgX3ce+EQHretxKLqk0VH1TdLe3uPwJ1W3yzMfTLMwfEl+2wI08nP4mGbTgLEPwauv
         kqxFwgxwCPSx1LeKj8y+I6nw+JpydDh2OKbiuLq+1EzUncvJCE9a7aPc4ekHZ6JxWiDT
         hbi/j4i8gf1yY0cDlnkbimC+26O3w8mDBwOlLmQSNChtXGC+EkrUthKY3gt4tlc4h9cF
         3thLEN+Pq+yUDkVU8ou3u6QtcAiFThMEqAjTGonxGm2ehK1i4yAMbXTH+whu5gq73sn7
         WVhw==
X-Gm-Message-State: AOJu0YwVOhiCM3qIol40ZHnrIJZluF+jDl3odmMhP2sbJ9tLXpBZbnMZ
	Xrz8kNShgy2mVrTynTiqnplnMeo5A/A3XcyfK/RpRIoY+kcGuoXntnIP
X-Gm-Gg: ASbGncsZwHa0mgTpcCdWvQ8cj/7dak939IP6zZnjV8TQ5pU3886Wh3QGVYKHXcBvQvZ
	ONXstoNMBJiezafRXnh4wr+aviYbthJu1Can9ZJ+EubXXhv/TSOVFms0OualV8tTIQMm0bXMMDz
	axTFam4rI4OaSEwI3yGkYQCUUjm+rLC52Yy3tsKSIh35BEwiZffjaZZz3tA33eVwjqx3CRS+AMk
	zxHttwzo2hEuAocJNTEG9uEojp+rCPBAk1Zlty/yjra3MupVDTkGUdjWR4L5I7JzMzNeDTk4i+R
	xDbrEWVogV6oAT2eBI41LAawK7lAv7gE8QOf3Y5TE6wXKhv30XCF1Aeh49rc43bPUcuylFCFlOX
	N947WEvcWLF619eT5ezcFEl2L0gLsw20lPaaXcfg7d6Ex4VCCxJlCAVA=
X-Google-Smtp-Source: AGHT+IHdnDqTAdFyfeuwzzQ3e0xeMJNl+vkkS7OmIQ8wnmBFdLlf3gL3RHuTH+7osbvxSs3vvwWYTA==
X-Received: by 2002:a17:902:f64d:b0:243:e3:a4e5 with SMTP id d9443c01a7336-245ef2854a0mr4139625ad.48.1755636674267;
        Tue, 19 Aug 2025 13:51:14 -0700 (PDT)
Received: from [10.236.102.133] ([207.212.61.113])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e7d10fdd6sm3411398b3a.29.2025.08.19.13.51.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 13:51:13 -0700 (PDT)
Message-ID: <8769a705-6343-4795-8df6-bac3c851f225@gmail.com>
Date: Tue, 19 Aug 2025 13:51:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/509] 6.15.11-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250819122834.836683687@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250819122834.836683687@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/19/2025 5:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.11 release.
> There are 509 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Aug 2025 12:27:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.11-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <floria.fainelli@broadcom.com>
-- 
Florian

