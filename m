Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949AA1E1C10
	for <patches@lists.linux.dev>; Fri,  6 Dec 2024 22:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733525084; cv=none; b=mFcRGL3BkMtWjWcqU4FHd2pKG/Qg+gK1SDQssxo8hiRDTRlhEDJNQUMU5ea1CfFhcpb23KXcMMRIgXXkT40itd5bQ9ubkFttkeWcSoNDSbRi++Xm4V/hSZSVFq5CcDmGsPkc6EdPzZDn3pAHoBQukt38hU3mSeNKOFoKETM8OW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733525084; c=relaxed/simple;
	bh=WI2J7dR0+ilHazk4wgjzpDOluD8//9je5uTiSk7GoAo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fnfua1se44Inkgx+512q6aYyAKWjDm/N49hqEVPzVGuj7VVbkKJqLpCGFnzgQl4BFP5w3DUw83ZAwd0MBKlciwn4HJAIDk1wowAljPgPc8WLTC1XYnbsa31ctaqTrmvrRoJADWcxjDMdZ+pQyMhbZAIKHpVBGskppbpZ8RGbV/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gmIBJ1Lc; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gmIBJ1Lc"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-46684744070so24702481cf.1
        for <patches@lists.linux.dev>; Fri, 06 Dec 2024 14:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733525081; x=1734129881; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=iCN7jYmq/Ly3S+/F2VYvFeB81jNT2qnKK+9AsXABa/Q=;
        b=gmIBJ1LcVcxwCHCAGq6sB0nX7GHeNWj8pUoSlY4H0m4wbgIm6FZeCiQ/edogN5wd7d
         qYLL3u0/1CH5GC4HmOKtWJ45nKKwvhvFKYatVs1KTCquU2GWzJ4wgWyGnHupFk5aqJQ6
         /n8RJEtI01Eynm8PjkKhtDOSX7Q8g7xQCNyqYS/Al7X3QSxR+h7zjHcM9fKwvPRrkrNJ
         0RA826/EgFt5NSSsoie/GMQo2OF44QnYiETMVmjqDT6rjmAtIpZyZPcTmkpu5jRLctiZ
         lTJiyOGZmq6t7VqXEuyu1+o9CNYs1WsWdYdlawa3lhN5zZwhTIJBaC9aJeG4KqLnUAFP
         Pd1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733525081; x=1734129881;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iCN7jYmq/Ly3S+/F2VYvFeB81jNT2qnKK+9AsXABa/Q=;
        b=B2L0nKgjPbUKz6ptu9ploGDdisiXKwmqHbXWPIaeqRm5u/1HeyuNX5JpqT/A35rUfH
         KoBEbUsh/xrtg1HeMPpk20JkVxGgMDhd25arfsAnWuvS3eTzkXRni2uJkrzkpkO8Wm4Z
         IXjMBl/HVPn6GI3sDK42uDQryrZeqCdjOy4DSttBnEZAzlyV1lbiij6ijDfGfGBJuBn0
         QhDsWZUkLiklVUpyzt853mbkUgG/GvA9BbauXkywwXZEk2EJLEhz2zbhI9UpqAtmWZiV
         GkDMkzP1Z/vfUNXbNgR54LyflpfhFxUyNY4MlnUpp4NM4VN9/Uyrlf2U2p6gDryjUmbR
         tzwA==
X-Gm-Message-State: AOJu0YxbOHAROSUw16Unh+wBl/eSJNGj7fv5mbd7D3OHUz969DcfLkih
	HMu1T8Hv+TwrlasyxQcZftp/u1sveCN0qTd1aDA/apzRrv7KuDKD
X-Gm-Gg: ASbGncvHJnDCS5pijPN8rnUsn6KKh2xKaaU9Ub5n9d8Q+M3nr4x7kvQCltXfphYFhCO
	zIWuo1M6hB6g2nfhKYFylkwtM9cJ0ufnKrvMT2ja+RG5D3CV7C4A1F7/6b/t4qqxaOAe9AKA6tX
	aomcnNmq9l0DZI1VD/chwiKM3j5mPQJHs3C2edN2ioSwHiV6JOne5OG6zJkb1CvfGhEI7D/GIQo
	iSdJxCLkWXRhG1PsboxrC7l6VepkzZAmpPaWMn4bRY11wCkI8uCvHpYAcw1CgcyFcSOC3DsqaDz
	og==
X-Google-Smtp-Source: AGHT+IE+CaF0eGH3ZR5dX95dfeuHr9PvwB934hOYv3WA31istBnI0LMpUh2I1Nn9x0ochL1UtCrAxw==
X-Received: by 2002:a05:622a:1a99:b0:45f:bc9e:c69c with SMTP id d75a77b69052e-46734c87a09mr106144231cf.7.1733525081432;
        Fri, 06 Dec 2024 14:44:41 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-467297d6c5esm25928661cf.82.2024.12.06.14.44.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2024 14:44:40 -0800 (PST)
Message-ID: <61d56813-0658-4893-994d-4e9f0175554d@gmail.com>
Date: Fri, 6 Dec 2024 14:44:37 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/676] 6.6.64-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241206143653.344873888@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/6/24 06:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.64 release.
> There are 676 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Dec 2024 14:34:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.64-rc1.gz
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
