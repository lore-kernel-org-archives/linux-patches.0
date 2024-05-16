Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DFD15099F
	for <patches@lists.linux.dev>; Thu, 16 May 2024 16:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715876991; cv=none; b=Z8i500EMdlX4KdRvPj9f2rSRzF84/qH1eOxLN71bUnQiOd7A1itT7aQ3Ww2hZALxC/8VUViOsWryphjQVo5i20KGtcWhRK5E8BGGQVZTmRRH9eFrEC7528kBoXxx6Mnbx5YNZtkWP/IIym/m9+YCeuth3+yc7G8Du92NBKM8vA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715876991; c=relaxed/simple;
	bh=VJa82yhmn2im6N/4IW4PrdpHXnPhynKrnUJl06uH2Tc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m1SbUklZBHxzkLAGB2danTRcjQC3smK1OCBZzVBFEunNHhyeGz8UxeYwjMC/Bkcb8xq6ZFaZxI9FyGUApTgbffuSeGz13SnFGlb+TyS9xs6YsffdqkWwygR4/ynJvjasV2j9viKPvsGIdGl/wcCJugCGLuhIcS8rNLB2/tRAWqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kay7iOI/; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kay7iOI/"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2b4aa87e01aso325969a91.3
        for <patches@lists.linux.dev>; Thu, 16 May 2024 09:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715876989; x=1716481789; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C58EmLarDuraI5No+cuof+OfCxS4CadtEGy5yB6YfHg=;
        b=kay7iOI/5U4z+2u4SSlRj+Ol8AihvQv8JxZvqNxSr+Hm2RoeAfVh1En0zYzmd/cxy3
         t2rcZ9+j0xNZwbJZQy0Q80GEFiq6Uo7XtMr6MzWdBVGmLqpMIR0q3Y5Uo/BqlJebVbxn
         VoWkwVnL4E+UMUN2trB9KYrJEjlv+mfJYMmiTH0Izt+Rn2SmwVXSaISqkPSgbodHj+UG
         hggZ1vIY2heoxdCDX9teCU866JFZAhZ/m2uXVtpSHoyjcpT2UPpkG5lpT378UXUXDAc5
         sICes5L93u/xBVovCuDRE0nt/y3LoA6naI6f6UvkzExtYNs2UeY9pH8bOe1uz3zLQwdi
         O69w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715876989; x=1716481789;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C58EmLarDuraI5No+cuof+OfCxS4CadtEGy5yB6YfHg=;
        b=csSeExXdxZ/+++74oBV+C9GQc9wZBtF/hf4tV5zEN2gh2/Tm6jCy/VKuTSwXrLP3wT
         MCO2iIOfJpgUY8PYD2wGaYa1NHH7Hwj5zFaaTgIP13leaOxnTcUhOicndSptFjajkszh
         ZGWF7Sk0rER88+85QBlWm8uD6QadsQ4SSzuM5uZgUR9GWZ1mkwL8gAsNRl/wVNXAdT5G
         Zb/Y5SjUjJfDiyCk5n+ioAWqhZ7VOJuff5py956mqIH+YyJ+7cyJ/VoKRQwo9CGgHCpX
         FH50Y8XhrWorQ92wdrLSFP+uFeH9Dy3wtIQrqKo50MvFQEfKwHR1OMclvgjQaNW1eGFb
         V02w==
X-Gm-Message-State: AOJu0YwkAevVcPcRDxtaUn4BRbIFLrVmVcAYJiom+fL/Rc4X7Ao2hMWY
	g+T1evbhDLUZnnpvBglJ219uhqkddScqmgYY7EBvbtoa0fPH7xaO
X-Google-Smtp-Source: AGHT+IGbB2vOTcAQ0CQTy0AHMGQu0uxuN2/qI5sFGkPcfizztSbMB3CuPFVhNN25mwLFUcDFoJTHKA==
X-Received: by 2002:a17:90a:cc8:b0:2b2:9d08:82d2 with SMTP id 98e67ed59e1d1-2b6cd0e7be7mr17253653a91.42.1715876988979;
        Thu, 16 May 2024 09:29:48 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-2b671782d89sm13856392a91.55.2024.05.16.09.29.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 May 2024 09:29:47 -0700 (PDT)
Message-ID: <eae40ad8-48a8-4204-91b9-37514d05e0b2@gmail.com>
Date: Thu, 16 May 2024 09:29:45 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.8 000/339] 6.8.10-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240516121349.430565475@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240516121349.430565475@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/16/24 05:14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.10 release.
> There are 339 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 May 2024 12:12:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.10-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
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

