Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D7419CD03
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 00:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767746124; cv=none; b=sAT0/whN0X0l/f34vEycv4Q90g5j8Kppdr0lcwYCH6TbFFlUs3+R6QOMvgU0kzRdfKbDgfqJk+MjRfsqiQ8eZ9upVH07RURHvhPk5XsYXrIdZFAg/HTjXA9pX7FagfWeimkcqQLw04EKp4x06l8Ptu7D8exRs8qjUjpVBVpzTV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767746124; c=relaxed/simple;
	bh=SQHTamUMARk/4HeKk6tbOiLGG2s0CIDs2tsevS20n2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZXEjySEMNQjagxQGpR7sp4TKo81Kk7eYz9vU+5tW5cVGS2LV95lPqnDWw8yQ+a7lfDEFD0QujL0RMBOrPrt/IWQmJ3YJQJwGvRLHeDXXPUgBJttcymDpISeX3wvK3NE0vkQ6MKBnwChNe9WpPEpo/OvBSJWGJAZK495NDzTIBn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mu+q2ANv; arc=none smtp.client-ip=74.125.82.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mu+q2ANv"
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-2b0ea1edf11so2065536eec.0
        for <patches@lists.linux.dev>; Tue, 06 Jan 2026 16:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767746123; x=1768350923; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fVvSiMXrQw7tIv49SNAYxvhVw8Ed8hsijayWkxWyGBY=;
        b=Mu+q2ANvvGeEMs+2zE7kyPSkMATkW60M9X9eJeS8WMUBeJ4Qls6/R5Cb/dA/5tSVNv
         p4cuy/T9lKjOICuOVRyk19Sl4m7lWekTC8SxCfiZwSJfj5PNoXHgEXygc8diMjF8j/s2
         MQt6gYWwXzZOtn18mrqNNTOBG++ga8OtVsvEjX1jXoVKPP9OzJ7Y4/l8aXJA1RGx197l
         UABWY+df01h0akTHAnPunqzzLcdjwypEmllfdL+WTsFJmhQz68CwrHq0VtmUMAyyopDy
         896PMixKuZ9dVsnMXHx+Ax3LgtrJupTTEJP7wGT9LZlnx/nQimgVtT04Fh/WeS2PXTmm
         ThYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767746123; x=1768350923;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fVvSiMXrQw7tIv49SNAYxvhVw8Ed8hsijayWkxWyGBY=;
        b=HCVKwXhpp8uE5q81XilkQnkUmW/phg26gQLPoeZzgRr106JH9iIpc1yKHGbcY2uNdF
         BMbnyattW7d4T91AR3OER2sifYAivU1DQZMDtnO6nNjKuJGocACcjGnQer71qiJM6wgz
         yAARSEuFC68VZufIIpGZjCVMBkm6FZX/1or3PTaCEExu0tDdw70QXgL0V45a5Hmkj5oh
         4IUOsCuiIVDV4JKkKoMkrlxCs1UHDOVHKe+ciKE49KgvVBbJifglEQeuLPClkwcRvkk0
         lPuRLknIW2e5D+sDVAPkz2pzKy0AdigHgmhAACvtUwCrL9qRjDZCn4RONjPsaAQwp8ZR
         tWfw==
X-Gm-Message-State: AOJu0YyOkrY4LhF2EppYjphOxijwiwieDECXq66pfM2nlNtdhKKfXRqH
	pvNqkVtzyL9WW0jMdZsmlGDWPdVdaGAFVP3Lhr6RnStxblyo1lnp8UUd
X-Gm-Gg: AY/fxX43DxluJsD43xEFR7CnKGGyU+GpPd2svq6OCD2JkdTDgUJte6Jy9VWwYBWRnTl
	R91jjBdooRWM8cxQLADasfSBjQwEnvpQVEASXaJM886ucwZCYWqn0iLXiO0TKIj5e+EnCJZNSWy
	SymPpjeRIblNLpFUarsKiZUA8LNx+I2ngOlFI1Lsir6YS/HBzcSvukNxiKmn1Z3hE8L2vZpOv0a
	h7zsODIzwTRl3gbjsnQTlSe37M/90dqXeA3/sthi+gpcracn5Kzf8TxFIKvUWI9lLbxywWXsa8w
	GsqWfY+R6/OXvJRY9Im8fcRuKHruKN4EiMTGmXBY7/OIFiD4MlC58mnJpqBa7KWe+FXvB/qAWmN
	vxerYaB32Iy701rgsd7DCj04koosDu4hqNZquJfovfO7crJChf0anRCVlKLhbCiZLmt3wKhjPts
	64VySJqiD/Cn6/VtPlHdQaZRDKWZoGVClDmbGgwA==
X-Google-Smtp-Source: AGHT+IGd79dWHwptBHXu+7I49Qt9sJ+A1Cod780f/7MZ6LCroa5lJhgJ6S4GXKD+cVkBXrNiBlbG/w==
X-Received: by 2002:a05:7300:bb07:b0:2a4:61a1:c0d5 with SMTP id 5a478bee46e88-2b17d31c9bbmr834642eec.36.1767746122486;
        Tue, 06 Jan 2026 16:35:22 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121f243421esm8099217c88.2.2026.01.06.16.35.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jan 2026 16:35:21 -0800 (PST)
Message-ID: <62b3574f-a45d-4c1a-9707-53e391b5f5f7@gmail.com>
Date: Tue, 6 Jan 2026 16:35:19 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/567] 6.12.64-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260106170451.332875001@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/26 08:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.64 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Jan 2026 17:03:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.64-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
