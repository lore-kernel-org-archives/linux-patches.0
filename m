Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8909E1F463F
	for <patches@lists.linux.dev>; Tue, 25 Mar 2025 17:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742923530; cv=none; b=hFRhaltlQdeGFjUDNv/k3Yje0KpNKObRHrL66AH04vB7AwHDlfJfaT52LF2xwSfDvvEKU7sM2j70H7kgudaDtDozcbF8OArcWRvRTkzhr2JslDrpplPxCJmKXHCp891IZBr+QdOq39GEd/ARmxwPguRTj36XJSqPTqF9UG7vlr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742923530; c=relaxed/simple;
	bh=jCGftAdwUvwSjqhvK2JTU58i7utMdfc9xgi/jh8KIsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l2oMru7sinXwmm1h2XKrSoKky71tVwWYUQbeSnpNe0f3uBR+OT04f2xGwznH8DCotWhm52ha1tYWhg9i0+gsmt7qHNLFofx7qohiomKh2SmdqCvtFJVEp8/r1VhPWWYOpxTKyPsIbCh9bweD2Lld07aeZx/+vbR7fd+SS6kmOs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aPeJNzBf; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aPeJNzBf"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-72c27166ab3so1486793a34.1
        for <patches@lists.linux.dev>; Tue, 25 Mar 2025 10:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742923527; x=1743528327; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=97PUfAL/8h3avcD4JrjfHb6Spstam3hgf+isWLN1TQ4=;
        b=aPeJNzBfUHccB65PvN1GPUp1n0SJWgLK6oHSxsc2AP/X75uxfhfBiiF4dMZcjdPJH8
         VlU5PXKpMmXYre7tdtPxZU1iwIV8HroYOYNKi1brc406BTmzitSFB4tfIa+EXsTi/Dt6
         MMQmF2g7Qyj7gleeTb+NdoxIOE23qnDRiDUmIdmyg38W0wqwnVH4YgpOr3nV7APquaCR
         eZ0Mwxnw05lSJknmA19kChqlTUMiWqBRB+Iqgt/+/wAbd748sMyf1+Hp2oB2F2ngV3If
         432YibfYHUlBDJpNO+09uUDlaT1AbDnf+DsskpIIWdx8gvF464KJf9uLT6O2foUTo/Uy
         H9Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742923527; x=1743528327;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=97PUfAL/8h3avcD4JrjfHb6Spstam3hgf+isWLN1TQ4=;
        b=g+9QKe0stw/PKtaROk7eav8b3ZLkqDWUbfwtDMS+40bajKEjnoZ7d0PsT2JEgeZZPD
         jpD4+PLNmx+lFeUqckr/qyV62rmA7IwF2h/I2zMo3AU14TGU4nkEg9MMFweMwB2TFztE
         Fhss4J2pOZPj1reqA5VuStk2hkCklH8ZNpAipDvces1sWT9p2g4oPdjsHTbmH/RduZev
         bpUIi30hqX0dFVyXBbciZGEC29pyFW6RVnoDpdywwjyOdJJpoSPzLfUPwajOefl7huCU
         2I1tDENAmA7FTweFNtZGBnEs5SySB9CgZJDfMTZZZ7UmIA6Qgdh5WbJ+03eAOUqVg2/l
         RjkQ==
X-Gm-Message-State: AOJu0YzNYfj6EUrl12Xr84xDIW8a47VgiMRCr9YUg2no+Z8uk5LjfDpx
	Pup01e+thx04FQwG2usjXjc8/ZORCuXB4xk4BV9DgyABzorizXDA
X-Gm-Gg: ASbGncvYwy/mHaT9iyhwi2MltsQfG4y3FxR9yiQpoCQZVbF7/FWz9DghAJzDR7xHgg9
	aTRbn/Occ4jOU6OULXvDP9X1PzunPa8OxOD+SssMVKnZsiXCZsHdd+64eyL1SzKgFo1U/qJxvqk
	nxCa8IZrpFDegVyRdYcxwRmZTT7s2S+zLbtOCSPhPbfXzMPmo5Jv2oQr5PsNWGNGJRK1BYOinvm
	IHQE3v0DVThx21no6CRCz3RdXKpBDL81IZY4zQ4KdktErn8h6JHtIvIhu4N7LanXiTtAqq0YiXL
	9sh9JYfV8H/9UGiSixZq+Otl8+28W1cFnfGHNPvT5+YzHKET6Ox24ubiCSjcsOOhzR8139aM
X-Google-Smtp-Source: AGHT+IGxJwl+ciiuLuxvQmDKAkVfh3pZiVb1nGFD8pabWWUgHnGHyCX/5Ral1DkskNgZKXMtB4P/ZA==
X-Received: by 2002:a05:6830:6587:b0:727:3e60:b44b with SMTP id 46e09a7af769-72c0ae99914mr10733151a34.14.1742923527304;
        Tue, 25 Mar 2025 10:25:27 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-72c0abac21dsm1997130a34.2.2025.03.25.10.25.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Mar 2025 10:25:26 -0700 (PDT)
Message-ID: <726206c3-163a-46f9-aef4-dab0f15c5b44@gmail.com>
Date: Tue, 25 Mar 2025 10:25:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/77] 6.6.85-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250325122144.259256924@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/25/25 05:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.85 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Mar 2025 12:21:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.85-rc1.gz
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
