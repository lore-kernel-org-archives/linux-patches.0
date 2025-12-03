Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA3532ED22
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 17:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764784298; cv=none; b=PFkUSDqTGGO1OLRYPaDl59YSr3s1XBLXMHSSk2YxWtivUzMs64RPpqWqhq7PkchmBGvwondGGVqk7MFj7hpEbQQ5N6dNWwLd4iVU83Su2zLH6/zYFTBubLvzbIeihdFIKmbDyxjDXOYZoF+UxOE2ag+DEXP98PY/DBIflwSClBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764784298; c=relaxed/simple;
	bh=m/HSIYITcLsa5oWRvzEUVbcH+VnZ2fyECYfRLYWel6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SQVekGVNERos9ZXn/6xedDGHcYJIZC0l0lFjNYakyFsDlJUI0p4T7h0IwwbVGGE3eXkuC3v83rc5otVyGjLuOwiypPM4MqVuwwMfFabTcA+XWneiBLa2K/naLSiQtFE825Pe5fqlSEKcL6SAV9d0DDHrJKNlAn0iVp93Iyl+5qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jqc5wm5q; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jqc5wm5q"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ee44df7750so355791cf.3
        for <patches@lists.linux.dev>; Wed, 03 Dec 2025 09:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764784293; x=1765389093; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NE9b7xWLRQ2Du7armuVSfl/uQrcZAwxDIzraZOeyv+I=;
        b=Jqc5wm5qpCD/bTDyFzCY3owZjPt4XZ43DBXukGvsK68FNs46P7b9CHM+6LgFQhmRI2
         Kl3oHVE3YZdqyiJmDzaEIomnx2JP/wraVV5DWAMuaByWf3k/2EVdlK38nbLVgDsBEEXh
         TqJZaje+O6Ng8+iNCzy2LY6PqL4jJv45rBUwCHEWgYcBpUWfbjuaV/Z7WAgfQHeXFlyL
         7zRzqURCLldI8XyqTPUeWzLyLPnx/uCGp5lQuzteIfk9SMDLalb3yY1p14p/O20ranjQ
         FrV6bFFnK6huBYCvuodqstTAROC3r2N8zZKUvfOdrrZ/0rpsXfxWcgm3G4vg/4qij7TT
         75RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764784293; x=1765389093;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NE9b7xWLRQ2Du7armuVSfl/uQrcZAwxDIzraZOeyv+I=;
        b=dVdeLB/bbEwdFDoWFXe/jPjtH4tfE275xEs2rfypkFudwD4kNIg4eSWGrF29iGdQIU
         Fg113ZZfAOXOwTIsoirr11NcFZRYH47+CODavtTpKL8Sxzs60w/b9s6MGDJPGtZccCwJ
         gDtqVf+2zlRJqawHcZllZ0xWxbli4LtSBI10gIAr+7GtWWuuwy9rKFDDxAEW0HpKQire
         Wa8SZAs1WFyWJcmSpbdsMM0N4RT4s7jy9W56XQDVG+c9CDjKfM3kpVtEzzYPUxJVBP75
         3Q8F1vvKfuzczed8ss4QAYmzwLpJpGrx/xx/6RqnapGxlzS59ocdo9iGIViduEgRsvGc
         VrfA==
X-Gm-Message-State: AOJu0YzhEYkxnQDA9Jx2GmOnJ3ehe6vGdJcmFT7cXLmI6r7rgO9ejjWZ
	S/XVDMK/dnIHYn7O5PA2t6ryC7cfBR80e3A/N5cH5CBg5eiM1sOPmxL5
X-Gm-Gg: ASbGncuiiSkcBD+OTitx6G09vi+xncHpfqaSgsm+grusUvjeXjFujdB6BMxc39xwSGc
	0imoG0YOeyci7YdBkgHs4WolZt2nVeMqKyDzqcv+SbP5J1Ke2FWS8O+PnIUIupmFFlSW4wDxoFv
	+J8PfheGt/22DEc1k+1SHReMVVvaVFU8qFcnQRFoFaQK6G9yJBrgGCAtNbG48vP7SZDtAIkFemx
	/IT5KI8BnYNA2y1hqZY6JjnNgglpsY92DxxnuTSpjIUNfVfnDgtaw3E9R/Yrqso7FOkijVcYCW5
	oItdItgD9kAgdpnZJJH3sAHDQGL2zjQw9IHdG3ZyxbNy9tHy2L/7osvCXh03n/z1qahKUbFB+Av
	hrwCDzZI2Z9JotD+Tq5QLyYQNapd1znBa9S0+Ebq18P4iLKjHkZYBycLSVl6rSVWo/5yry2zLdM
	B8WHq9kPZwq7T7Kn5ayYwTLzbAiAU3fITMLNeupw==
X-Google-Smtp-Source: AGHT+IEodQvzyGrpchEKcNgajKI5gYLkGco3SSXaT8+tavu+JXqnc5pwPkx7UsTe6eyZcxNixBiaPQ==
X-Received: by 2002:a05:622a:cb:b0:4ee:2721:9ec9 with SMTP id d75a77b69052e-4f0176b6076mr43450351cf.73.1764784292514;
        Wed, 03 Dec 2025 09:51:32 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4efd2fd00c0sm118897111cf.13.2025.12.03.09.51.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 09:51:31 -0800 (PST)
Message-ID: <d9adb2a6-47cd-468a-bb6a-de11aff80659@gmail.com>
Date: Wed, 3 Dec 2025 09:51:28 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/392] 5.15.197-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251203152414.082328008@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/25 07:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.197 release.
> There are 392 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.197-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

MIPS fails to build with the same errors as 5.10 with:

arch/mips/mm/tlb-r4k.c: In function 'r4k_tlb_uniquify':
arch/mips/mm/tlb-r4k.c:591:17: error: passing argument 1 of 
'memblock_free' makes integer from pointer without a cast 
[-Werror=int-conversion]
    memblock_free(tlb_vpns, tlb_vpn_size);
                  ^~~~~~~~
In file included from arch/mips/mm/tlb-r4k.c:15:
./include/linux/memblock.h:107:31: note: expected 'phys_addr_t' {aka 
'unsigned int'} but argument is of type 'long unsigned int *'
  int memblock_free(phys_addr_t base, phys_addr_t size);
                    ~~~~~~~~~~~~^~~~
cc1: all warnings being treated as errors


-- 
Florian
