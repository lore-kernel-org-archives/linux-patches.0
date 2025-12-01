Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711501ACEDE
	for <patches@lists.linux.dev>; Mon,  1 Dec 2025 19:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764616943; cv=none; b=cTl3zkcR2s0z4sK80CnDEJ45NboRF2D3+Z7rJbEs+Gr4qB17pgq31vpmkMCS87doD7DuzHOOVfcXpPphuzksfQbkXBHKmxAYydvmcqKrqO/RWmhZMaHlocTjuG+lkEGZZCOL6U+Dw3wKJz4gasE1lkCcZkcehTX8+pgN/Le4CsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764616943; c=relaxed/simple;
	bh=Zgbj8PlSoDz3e4r9wFsN81LzssrEk4T1hX/dR5Q9zhM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MC0d21/+cBZhOiGuCvhmABoLl3Oi/0X2bGd5Yea+T05I8VNr3IZr51/xHWJtsErNLsFbiipTKDc1cUpbThsf9L4z3gmhWaYDqJTtOi6ssFz4XFwoKf0HSQrBk69xTSJ5yQeSfNR9Bde3EzfLBFp6w66OgGl3FTNvTILhJm1u6y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MKhn7xZ/; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MKhn7xZ/"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8b3016c311bso575846585a.1
        for <patches@lists.linux.dev>; Mon, 01 Dec 2025 11:22:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764616941; x=1765221741; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fzDebQjWZpMlRG+LtMc42JVB6/2Vh3cogJRGNlIZlvc=;
        b=MKhn7xZ/t/KZ18+0YOckYP6QYlF37KM1Lpq6UPm3GeEVWFahCIuzD728VTt5O+jvt5
         X4Wz5OvINh74gN6SlZsVcmw5JDnlXG3/voARDeItrzLN9PLG78OKkPFlqnfmFOL1yuvF
         WfuzmbXl+9ekYCAe39KfO33V3Ole7Svp3SADkAu5G7AsTF4/AzoBogKuMWV6Qq8UMyuk
         4ifLqGkM0Uco1/XTXbqzU1K7bqKVJIh6AGP078XC9p19Olj92MrJADWmN4qU0bUZf5Ym
         tJJGtw4hg+mG9BxyiaSdgQXBiBRMF/RGiPv1JeY9tyqApWApalHGXYaquMqWXVlrbPF+
         a1dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764616941; x=1765221741;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fzDebQjWZpMlRG+LtMc42JVB6/2Vh3cogJRGNlIZlvc=;
        b=gOkhiR65OqoTqUj3RcNb/G8DeHOMfJYNEUjS6UKn1NpUMyJC+FhnefLRGM4Afh3TMp
         glO48msDctw3fcCsnbgoWMjBLkVKnm/WxfcagBoM9uzQXu9cbulPn36Wx3UuETKibQ40
         nLf9grvcOi81S6nLuxDUir09kmESZuNTDYBiCiTsTs9t0Fo3uir4urgFluDxCA7ZEF7z
         JRkjKrnvZRIVTa4mShngEbgKqSyxsU/JTWjShtkC+5DJvwY/MCQEBd744RwwknI6qBoO
         fHOlCud+h2qIyZ0oZuc+4leyRq6y/o0zbdTudQIi7pAEjwr2GSciKQYtU2I79rSqqqxU
         y1pQ==
X-Gm-Message-State: AOJu0Yxqz9HS9x6dmQbbW/ucZ4/PJmIQyu+mMprYUX/xdz4lVJkRIyBR
	970RfOoKnDIk52+uFFRnPwRNuJUCaG5+VGTnrlvzH97M9ob8XvOvgjdw
X-Gm-Gg: ASbGnctoeR7g0EcRRmz80WQNTyEStiEroJ+dFlET5y4nUwmIShQGITlQxLMTXOvshUp
	8GJcxzkVxq65Fa+yS5PXByGnVyre8uQhXiNB3ulLv6XiX0YiIhLqXYtKcBqSphG8lMuSrto1kGI
	ZSAeEziCZlnj7+inZOhGyP6FM/DZMmc4pkBgiQs+W+m0bGosBQA/GspkfJ0nrmWkVQyYN4j9yK+
	DZwhe5PO1xunuiavdco6JKUzYFIorGFG4FrdF3TcPUPjLdOz76qFxW9/SvQLBxx3jLYSTDpNwoT
	PIK+jnXgn74lGrKoFguSKOa2sMfwK4f2XnvaOJJ3/30XVy7QcBo4CZ1pasLTTomhwUUpnNQY/Be
	sDK9S1t8m3knxAoCVfP2hc/J2IpO/+0mrZNEzk7UgiN3ZP+DsnbTNmxyOOgCNbpXYPoTfXJDAkh
	cXcK1a9bnk7VpFeod6yekO7taq09zUW8FLeYjs/Q==
X-Google-Smtp-Source: AGHT+IEcZfYkFHsvEMBvJ/GDPn5E07Zsr5/1DwlC7SyfCIghNvunkD76FZLcDH5dLmHl8dQPucWPTQ==
X-Received: by 2002:a05:620a:450f:b0:84a:d3ce:c749 with SMTP id af79cd13be357-8b33d4cac81mr5684882585a.64.1764616941346;
        Mon, 01 Dec 2025 11:22:21 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b52a1dd169sm907120185a.52.2025.12.01.11.22.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Dec 2025 11:22:20 -0800 (PST)
Message-ID: <e915024d-af6d-4919-ad17-153343ac0967@gmail.com>
Date: Mon, 1 Dec 2025 11:22:17 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/187] 5.4.302-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251201112241.242614045@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/1/25 03:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.302 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Dec 2025 11:22:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.302-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
