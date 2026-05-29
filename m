Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF873A63EF
	for <patches@lists.linux.dev>; Fri, 29 May 2026 19:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780082371; cv=none; b=pVDdshiziNp2PP0sKMKbfazVZ59nxGxRxBMedaWaoUdB0V2S690wGN5m4L8wSOLoVO/x4uMFJOLce0nae7FxlYNsMOhuOrldFhSvULFpOfcFvYJ69geKmwTJiZY9gLJ1+/CkSIln0KhIH4plEotkpELIOj0r1m9cxDSyQHs7N4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780082371; c=relaxed/simple;
	bh=fOemvi70JZMFN2GyrEzFeQhd0Y+wBzm190/Q0QI9nF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bAPGsOrr0ByS9Bsy/hxbLq9dp8NInU/yRIEbbLbK218IH5xbB57LEFnzjT7dyYrHXDL3InjZaHCfP2bAvWvXIrtKk4rl56/gpmJ9rJjaiRJ4IqjmPiy8PR+JZxjrMFcrxb711G0MqGiV4n4DkW6CrDF57nDoHIF7i3QvcBnKRb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XEs20hlA; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XEs20hlA"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1363fe80fe8so9454393c88.0
        for <patches@lists.linux.dev>; Fri, 29 May 2026 12:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780082368; x=1780687168; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZINR/+yOkvzg9+RHXkOB0a+V3afB675Utrw9+VyUxyw=;
        b=XEs20hlAiqp1X39gZYhgBRwOsowtUXjs86v1L+b81x4mIFFPDA58/lcpUt8dW+tflT
         Jo85/bdhzNw810GyeEthPtAWiReaVZzH/4d9jnZuh4LmvlHYKiH7x5nQW6WMFFZ4r1Kg
         VNpWxLZySwxYw+2/8jRfvIKHJYZ1dYyUqNMPSiwoTYhfuGRbEZl5wZuuusdU7mEIWaLi
         QbQ6JVcv3ZPDqrYkF65pW7nnyIPxNU8CdHbcuo1HDfyIPSJbKkCOglREoif7R7Jn4Bnf
         kcp4DeBl+ovTnEdgMp9ehTV56qJzGXQWw+C2LbEoLNlaE6S8zzuUcZr9XSNrgAhhEc3P
         1BTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780082368; x=1780687168;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZINR/+yOkvzg9+RHXkOB0a+V3afB675Utrw9+VyUxyw=;
        b=PSmr9pkkQ5VX6bC6yei1RHIAyepN2Sn7f2cBEQZvGX2h4lloTKcTIWUZJCTT/qFLSm
         0qD/PS4Mr0LpTVNOPKMMBV4c2BXmX4VpvtE6weu6GrtDpjgJTKU+svrthRoNcZErT1ro
         APJpEF46f+heuOxVYNAknZLezHWo2RXX6K0fWfsuswN9kVDyvs3eY8a6FhI4+YDLWviF
         dOtUyE7483Zp+6X6FbsvY+ciC8pebiSnPns2B2T/MXLLlWFgZ/dFJpJj5gfA+T1lFjY5
         ZWstR8Po2lpRqGrD5bbyXQC3kaeDzMw7Pygru6oTGT57FKCA9LzwIWfRfjDZSnISu5l/
         Nmgg==
X-Gm-Message-State: AOJu0YzAz5YAfUWcPZ+7oxSTdtP4rV4g9Pbs41siBynx0FhSp6j+S/Es
	cMYdlH9nDM4DYCjSwhg1CZ8my+gF1lEgTYPqkisyNC4d5p7kwy/50yR8
X-Gm-Gg: Acq92OFsqGelucPsAsHqB9cBNFVLqQ992rPFlJXXqsERMWuyVx+sFS2XHftgaNq13B3
	NXuWJ3lb7Bsane/WX4ljIpRauXFUxFEm55C1mFLjxico5xHfFSe+7rXqwbgLja7WIBD+YRtEGOS
	LmlGAMP2Gx9o6cB9g+oedX8qjDAOSv6RuccnUHZNM/ox9dKr5KN3reArQdxXmUCTSKPawYLlHm2
	YhfcBtjfa5zJYzrhnbapWXL+aHZ5TyHlCJ1H8c33Ih1WB9kfqNRFzfCY4IrJEhTgd8s8cqrxEHi
	K8pvqGpsSMSjA2V4363zKIdVWtlVoLyTZO7hkzKLBjSsm9jgHlFkFDjb2Z7it7o4r6tMHlCVSu0
	86Pfh4KKNI7Dn1XnmU/djHuEsIDaZLNIQTpRA+ID6n/bxEC8YGEhhbYrbr48f92RsvhnGOzwMlQ
	LrJdNcop+mgKJnxAPu1BIsUPQkcSAiA7psq45z3cif2eALky0kT8m+DAKU/095
X-Received: by 2002:a05:7022:438d:b0:136:959a:abf2 with SMTP id a92af1059eb24-137d3bf6096mr456088c88.2.1780082367586;
        Fri, 29 May 2026 12:19:27 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-137b3c7e4ebsm2013630c88.12.2026.05.29.12.19.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 12:19:26 -0700 (PDT)
Message-ID: <dc4e1209-57b1-43a0-8657-c3bad1a070aa@gmail.com>
Date: Fri, 29 May 2026 12:19:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/272] 6.12.92-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260528194629.379955525@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/26 12:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.92 release.
> There are 272 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 30 May 2026 19:45:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.92-rc1.gz
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
