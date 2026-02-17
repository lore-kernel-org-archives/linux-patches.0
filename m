Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A780F5B21A
	for <patches@lists.linux.dev>; Tue, 17 Feb 2026 22:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771367480; cv=none; b=XnFBClusqPYifCV927eayuSj7EjhC06IlFxSQqWJuWeoaOsTyq5Sa9F15QPzueUfX9B0lfWr7em3Jmt/HsoIckRq10zRGWvrXnDjB60xc/NGHCUmKOTsPxMVHSTqGENaqzH4CTdgQ05Vw7P5NbUonxFaXHZavvrUDtDSK8+Z3UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771367480; c=relaxed/simple;
	bh=/hcfgfnNsUh12ni1Y2Sk4wBfr48WfmgnZhgYQyw2Gts=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JHwkyJqbQqLzyB675cuMz44NDEmnQRQ2jKSupUOoF6wM7kdrapr947K83ZX4O+0GJi7NeyLHkQjTAZ/HIfjc4G5WQDX9rMypzW6xiaZLHI9c+wuAWw5Xq9/jPSHd6gTbdUXV2HO+LUfcuJvvaopGTj7Rf/9uNtB2pRNQC3jhg4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hQH7Db5W; arc=none smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hQH7Db5W"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-12758ce1e8dso614193c88.0
        for <patches@lists.linux.dev>; Tue, 17 Feb 2026 14:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771367479; x=1771972279; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MX1GlaEzkiiHgH7rrnveVU7hjk2Hhd6hxXYdLPwdnSQ=;
        b=hQH7Db5WXL66riLiqPDal2LXFXhf4IuBgqI3L/ptpItLgFs3xanMHoqshh638GfDUn
         E+xFvvkhb3T38m0hTrRik7+4XIR7aC/KU/TdZl7TlkoQoJHT/AfV//Wn/ZzuVKzcTV0w
         7QwTciBU+sWYkozbLPsqgQiiARb7JOKiIW/8Xke8uj0f3dAq7c1z/UB9t77xIioxxgYg
         DmEHqosqLntmAltGvASA3n86wPuC+OYFDEfpeghIMp7PoYbLLAxJS1Nb1ZVtNw8liPiF
         iKEDGcX36pwqz7sbDWsqZpkuGKBaO+iIpK1xLGzIEwGT7iYqqyEylfzwz80JsG9BuLak
         66Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771367479; x=1771972279;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MX1GlaEzkiiHgH7rrnveVU7hjk2Hhd6hxXYdLPwdnSQ=;
        b=n07X0+uRDJd7vS5zTGzCukH+vC7NH+oUNnd1lSwQRbQz6oyUO9UZgRvAu6vRMxN3SN
         vdW7Pj3k8ExFK3OCaENHk/2/Bc3pUPGvtGiX63ywpwb+Kj/c+KzIL3oTEAzyxMCOhmDW
         mmWb6Q6ak+6//OBzhHW1LJevjfpsxMDRkXjO9es1Y6kw6m7feSe7aQ5pkdajXeQ0I5Dz
         NtcHCd5UyH8vTXmrwEtUecKwo3Lh37i9b2835c6sjpK3pbRDLs/2SWON2YruJW2bsOhL
         M7rrAbtGXIIyzdUQ8fvXITQZZ/o25/4Mcn4ROMXHkUkWg6CLE9t82QvwkyvI/tX2wGwg
         yM3A==
X-Gm-Message-State: AOJu0YzdCGY3dqtTgMUxBuorUyy54Izmsk0++R3oFdlZUlWVU3UFfvS6
	joq8e6XqkyAjay76W7EnSK8fXAzrIF/qZLWgtTZ7PAjzklWe1L2nUyXp
X-Gm-Gg: AZuq6aLShDvZWmJeWk5uUPZcqZxf7RUmF4ctjNbbfE7jW/9MjEYab2aWPYif06KpHj6
	H75rdr0cwN4X29yh9P9S3ZSG3TA5RzJUh7T9hpsxve7laXOpmc/eUdQps7AIJVGLLUqfiNEW9VM
	r7JaZaKtI8OtsUfbeXaDrSlR67LPJiRRTBB7FS9ihUNoX5uGRRhSPxsopkJnTjxCgBTirO+ZTZm
	JV8V/huj1/SdAi8B02tUliA4uhk+0cujncUyjCNdVVXlilNxvTiUHPrZMQ6v8DlZs1ykH+QvoQa
	zX+F1feadjIsVS7wKmIbJ2+WNBMD8n6oIlZ8GjVXQF4TecmWRdh5k3HUmpF3xVZJXpU5mLhb80q
	knrVjXpOBA2uH8cjYX3R2W5ICH7dsR2/hh8OGHX6lrR/p2B2jXxvXyhVPuSN6JEU/UJumF3HLWX
	XBKjZVU1GDhVS1cARMhIXmxUXbXZua1O+ujCy/cerPaoebi1NbuA==
X-Received: by 2002:a05:7022:926:b0:11b:9386:a3cf with SMTP id a92af1059eb24-1273ae8f205mr8215143c88.48.1771367478665;
        Tue, 17 Feb 2026 14:31:18 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12742c63feesm19433128c88.4.2026.02.17.14.31.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 14:31:18 -0800 (PST)
Message-ID: <cd0e8049-36d0-4ab3-89a2-eeb01459bc6f@gmail.com>
Date: Tue, 17 Feb 2026 14:31:16 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/64] 6.1.164-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260217200007.505931165@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/17/26 12:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.164 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.164-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
