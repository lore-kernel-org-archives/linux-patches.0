Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9632DEEA6
	for <patches@lists.linux.dev>; Tue, 30 Sep 2025 18:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759255235; cv=none; b=cmTiWL7QcxWl70SJ9WjXHG3pm5ZAiaVxfD7Ud6/n4kDkIImc/rZw3Za400YgMMeXIc2i+5dAgjm50G6RSY3Dyw3Ka3uchhwbjjm1TFor6HWNu+0zZN73sWcDD/NLBWrwMuTSMqFosI5iKbCfSdKrTB0QJLUW/5Uwu7kcAV2PH/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759255235; c=relaxed/simple;
	bh=YbSZbrwLsMWtea2gVsJ93Z7HflVLWz8Y++acXgdJZ78=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jM05KlnrExEjuhe0Wonq36ZVNYMZO/yMr9ZIPAB30mLTeYkyAS8oIB+ex3WXrAN/PkO17ezxZa9/IeLfeLZStENLeoCsxpQAdiA+KJI8V6J3Z/Xt0FJtZwYHp7pQaNXQNK7n5kggSZ6+ds9DncGdhyXK7wOJ3N4t8BgUscL5vwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fIk6etMs; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fIk6etMs"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4da7a3d0402so2368411cf.0
        for <patches@lists.linux.dev>; Tue, 30 Sep 2025 11:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759255232; x=1759860032; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QwfmIPtyp+rsa2DwTVLeGN/bTgy7je9QsgOF1Vb5InQ=;
        b=fIk6etMsml1PexU9qEde+u7BiAKEL7lhR99naELo/cltFbrRde65iWcBA53Jl6eKz6
         U7uM2Wh95Eh4X8+7WqTyAV93HZQ3jps/q2vlUn/TumgCkqBR6r4MjHioxozm6GGlkoSF
         bQl78gMq0gTdiWo2Z4Wt44VjvW7lc0WY0SvZ/tgzGwZroWuMEzlJ2U12O6V2Zmrsg97X
         hbKk1CnQS2g+EGomVYKeV3fjPPAmJ4wgn/czMKlxR16YEK7TpWk1Vpl4/Q9pExCtebst
         l3yfuKaw/5zrekW+Z4wH2F5KZ8iVSnl04TfTZhZMOT/pzsTUtJt5pFeJ0hN8Mae6vjnr
         Y7eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759255232; x=1759860032;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QwfmIPtyp+rsa2DwTVLeGN/bTgy7je9QsgOF1Vb5InQ=;
        b=dRFVsk3A+O5expekP4YN70XymL33ybJw50D4/FObbvoE6vCOi6cidWPXMn5PoiQqmZ
         u/UJEOJ3IA2XeUjH0vjD1/EUFWDagFLBx6pnGRnUEGF9ayPytjJeb0C252SVw1rs1v15
         Sv6NHCV2LDyfRZDqVph2pomg/I+vZXld7nrOp9JyRkYyY7Ud/HqHB5FZ3OaUT03uXKmC
         UgeXCIJK180ckjqKi33QuqdixPUDVGaelTFoyOGPCUUHXrrLX+VprVI1lNMR6nwEZaXU
         F/gk/tIbtPN2yBzGdTNElWog8AxQVMN9IH1RhepWNxH4OGTn4qz7OA8bxDyAGaliote8
         l/Jg==
X-Gm-Message-State: AOJu0Yxh5wMroaHDTKx/gT351XXqTkgXKJliSZSE19EH2H+uP8jfNQ5P
	eE2T6DMdQuJPK5kLEzZd4cd6+q2dN/U/BvW43v8L23Gn0GL9UQFzNtyf2nWkFp+5
X-Gm-Gg: ASbGncsGYK7B8DbyMO/yEPDPiPgW3HiWAsUnXUbGenC+H66TPCc9iFCfqbcZEXzbp98
	riZYAThlIrTw5HP6AkQa7PYlKe/PSLhlu56r8JRLvj8reCFKo5yWHCZDzTW8QBGEBYZPuxgt5qr
	GeyjTfxrRnreDuC3JaUvulvRWJn996/g23r9bko1Cmu/JtlCH+05NRWm12w3J/V/XnIX8qVy1gN
	zlKEu9yVEbpgO3Tq6qd58ACHya8X+W6hVvlCLuxjAZH6XQCAc6pwMcHSm+pQtW79ZfE1ElIQOan
	SgoR30PsOzBwrGbQYffH7x/P+xwLKnavOgkzhjcH8FkzFwudXBJ0sYyYSZIkjrktT5OqW1J4cF9
	A6wVI6WD+X2Y9+w0hxbCZHOsDTtEkvBsS+w3mIU/sGajcub4TG3ofstapCkS61CgpUIVTNGjExw
	==
X-Google-Smtp-Source: AGHT+IFqOmFo3m9m1uH4m6G/o8zmkURBdCOT/WGf9A+raEW73lMwTzSH15T/s5dgz5pdWTKLfpVFBw==
X-Received: by 2002:a05:622a:14d4:b0:4b3:4fa9:4cd2 with SMTP id d75a77b69052e-4e4068d9458mr13682061cf.33.1759255232394;
        Tue, 30 Sep 2025 11:00:32 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0b56fd1dsm98261811cf.12.2025.09.30.11.00.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 11:00:31 -0700 (PDT)
Message-ID: <00640a2c-8d8d-454b-924c-81da31e95d95@gmail.com>
Date: Tue, 30 Sep 2025 11:00:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/151] 5.15.194-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250930143827.587035735@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/25 07:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.194 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.194-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
