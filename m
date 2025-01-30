Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43FB1AC884
	for <patches@lists.linux.dev>; Thu, 30 Jan 2025 21:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738271493; cv=none; b=OP+6If1MAGKIOPMvFGWPWpnD1vJX0houfsGMqT9qm0JUuWrcUHXdPdsj53YoTSlzw6YWGzcXe5CueJpMWQ+lZGIb8FR/l19OvIZ+gv/bAVgmylOteRL3nXjmpAhYNvgOQpSVAs/Zn1wd9cP2ytuuaiIpc076oTDFpyByxTPl9g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738271493; c=relaxed/simple;
	bh=IJ6fzV5t/Err4DKXH2EkjkKQTSF4qSpO2IdN+SraNWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ubHGFv1KWMGz3f2JCERVOyqB11DPMZhNX1fKDEoW4wrcz8gyEpsSn9ko7b2DBYop3qfn+XntVwkHmT+sozgED44qKxDXvc8Jog7aHDNDxG5MFCEsNNvuaimlSr13ZUXYlzZPQxepWhYFm1JdLJ5YlVtNSgHDq6+S8Wt+0T26pUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D4HfvnCf; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D4HfvnCf"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-29ff039dab2so526676fac.3
        for <patches@lists.linux.dev>; Thu, 30 Jan 2025 13:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738271491; x=1738876291; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=zrozKZhUsf0BYF6M/RZ+jLUhYLZg8n+tyBNJQipgXl4=;
        b=D4HfvnCfLOpXIZpqez+Cdvy7wEMO/xMOjpHGxslsOfU652KtBEYengFHHtK8fCl90X
         C/BTaEBBQjQOWsnCjChHBsTx9s3kaHIdaP3P1iiyOcATuBgri1miN1CMBK5SS6lbigvy
         aJiPr84dW+SjuK1H+LQo2/+WcMCTWCXkGtfKvBx8WeFb7cHJ5KsHOhFQ79uSVpT45iiX
         j8CF5+vnI3uoV2iNkJMwe987T78yB3t6BgxssXQ/WX7JO375QIiF4PUw0y1EVAEBsnbQ
         RYqdvHrUdSLhl2hVz0FB/dIxQE+rhHMM5iS0tdF7CUmiAhk+RqMtHJ5Z+RsH9i4nPhaR
         VbkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738271491; x=1738876291;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zrozKZhUsf0BYF6M/RZ+jLUhYLZg8n+tyBNJQipgXl4=;
        b=TbuvpIS8yB9KkFzqyru0rxD9x2CqeRWF+vpqo5BZFy3tlntp7YgWelPXPKN0EWx/eb
         WkxBeteJtrlEUdeDtGWxG4sEnX9MHfnSGHF0FZJNtI1s6SjSLLNpzNnhNnzD3TV/GmCe
         UKQmM46Wnu+uYZ5Q0xdN0/bSO8CMAyUN11c1SoY+tzhCsJh1uWFhUiPoSGnxD6ACG1WD
         WS+Ls6E7Oxqm1xOHBaucmJlapVPiOCMRmh1FPoEPWwHvZY0jReuTtrIpQoYRGlNBUyxT
         MDHQT+F1ZsV6fOABBQ3uvKCSlRS4WnWkSwkojYE+KA13qQ7i9MO7D0Otw2RGgWjgLR8E
         hizw==
X-Gm-Message-State: AOJu0YwobDf+SfyxgcOqa5HKEIUTxbxy3VsGpi8A9n2QC5L1Zr6XQcCm
	HKlm8GB7akLz+6LVtTffNz8Rdf8ZeUUgoyrdfaICkNj0jlQwGZro
X-Gm-Gg: ASbGncu1z+TX3y/8OM/NtYIUKst5vpLVBH1yGt87tENhA2KBG51I/g43rGEhG+n3MAQ
	uI86szhYaDTOsHGIR74aHxBgW83B7z0d31ylfk0pCGX1MO+InNyfol8JOLlWfRbyd4YbOGKhJqa
	ETVG4aj3uI66knTFqULQpM2VsjROzgnzLcX4a2Wc2XOArZ0S/R/tEThK1enjVQN27Qb2zDVvbgm
	T+6iOPOrfbJ7ilQJ/E6w9WzhPedLNBN7GThli6y/x0gnYN1LiyssrM+AyO0hHARy08edMOZBbxh
	eCakpj0W4P1HDUvf3xluWJAJawgHywiePk39gWJeSb0=
X-Google-Smtp-Source: AGHT+IFj1l7gMmlp1b021UFXOKqvtrROOkTwStsq4sQZ8D5840chGoARIZF5cP4ECTA+XUsVsDzK7g==
X-Received: by 2002:a05:6870:e0d0:b0:27b:61df:2160 with SMTP id 586e51a60fabf-2b32f2806c7mr6358267fac.31.1738271490772;
        Thu, 30 Jan 2025 13:11:30 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2b3565b4d43sm631689fac.38.2025.01.30.13.11.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2025 13:11:29 -0800 (PST)
Message-ID: <51782a25-3bb1-4b49-89d3-25721ad9c3cc@gmail.com>
Date: Thu, 30 Jan 2025 13:11:26 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/24] 5.15.178-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250130140127.295114276@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20250130140127.295114276@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/30/25 06:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.178 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2025 14:01:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.178-rc1.gz
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
