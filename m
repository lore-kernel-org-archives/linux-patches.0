Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C60E26ACB
	for <patches@lists.linux.dev>; Tue, 21 Jan 2025 23:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737502516; cv=none; b=eoQP5TjwGi7YOi2pwmUw5Syw6kb0NgsXYKEwzAcIWhI6oy7w2g50FdKJYbxsWK2nZBptuzcedo2MHRYlmEkvj40yGF0Rqn6/N4krCBZB+nar/O5/ZifA1nOYsYkt/bNuk7MNoNtUKGTrRPTADBzwoQbGidyUIENSINRoA1Lt7FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737502516; c=relaxed/simple;
	bh=osMtyxK+pHAgjvID7ctuHvlkEQeRdUCptYQ5IZsw8pc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZuNcsPXiBwgmoOsh7/ca07rqlY3ngNe85kL9UVQ9NwYhiO7j9iT/xDrzxunSI8n/TOoIdPzkPDRsRS2lvLOllPy/NyNARc6IQn8JQuL/L7wY6Sa051XSR4yvuvNTQ9U6Dy/M9pzXjfsNoVn8eiWR+4UhW5uWvcL1ctBwAyVSTO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Na+R/KyV; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Na+R/KyV"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3a9cdcec53fso46497515ab.1
        for <patches@lists.linux.dev>; Tue, 21 Jan 2025 15:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1737502513; x=1738107313; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x3wuJFte7c2tUcICxO5JAQgnHYLJwxx9ozuRq150yvE=;
        b=Na+R/KyVK2H5eJ/JyaJPy0wJ1fsHKFchKBehBMJ+WykXfLMnu+A3t0FTslBEyIlRf1
         SATBYyEGjXtJomPT17mbbG4CCZbBZlIYnEiaG3WiT7gnq35x99zhuTVQI09EpNxghMtQ
         3j/+eyOIjIQicW1iTwZwx5EX9KLNzgAoTZl6Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737502513; x=1738107313;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x3wuJFte7c2tUcICxO5JAQgnHYLJwxx9ozuRq150yvE=;
        b=gIaBAW2+1Y9sYWpMdL4yQxKdXspo/IRI58CzLvQX1kMXWipbZGM2DK9slKBZYZ8UWg
         DawwSj+mecIh8aoP61il6EqNoEMi0WDswmdSoHXE0pgqn+GzuTBEAl/oSvZYpGoCoSKB
         fOLzQDEYRr1LHiM3Pidg4sTY+c8a4wJuYspHQPJyE79lr0Et3iJPe8sUAhEpx7VZVi6p
         D1x7lD/5l0KD0jx76IDSQb62HxENCVSuGFC2FdKG1xZjXwwhFLNr5k7Gk0uZ+iW68HYj
         FKfpqoSchpXb//MVRNNoY1YjUxOWWfOMgsOU3qP83hdqz+5EB99cs29VfTJUYPrQimlK
         /D6w==
X-Gm-Message-State: AOJu0Yzi/Hlue6eahB9oQrUg/PuZ5qdEFAhIQ59UjKQMoZhIobAK7ucS
	FeK49hRXTcu7K0AwaoSmfL2qh7i0DQHDmFZNlM6Uy3siAf7gxMusKmhvM96gfNQ=
X-Gm-Gg: ASbGncsz64wvLUSVq4fHrF6+BV28/gTkIcZq6s2HX82AzgPbO6c2ya9N5YIoWdFGVoU
	tE05beS33jlyhGIhcnmEt057YsX6EPqMLjtx12g2O+lCMAQ4GKscERFxFXtsdQcA7TG1xTjmQ3M
	zYOTXToR4xADnZeUeLcWQSDp4cozd3z+PKrqKc8H73NsreYKNFH/+XE0o/AmD4/Y3pxfH8y5pLP
	+ivz8j6TxWsve39a4ICnJ9HFhHUNcttIj5sGHhiL2BYDvAzJSJ/0vXGYT11KPEEfPovCcWzN0tf
	Iij+
X-Google-Smtp-Source: AGHT+IGe2UVE/0NZQzMBI5Zp4gYxSfpmsBRAXWWGudzI5TLbxjl/l0uX+pqaRBMD/NIFK0z55TSc6g==
X-Received: by 2002:a05:6e02:18cc:b0:3ce:403a:8be6 with SMTP id e9e14a558f8ab-3cf744be806mr170891115ab.20.1737502513243;
        Tue, 21 Jan 2025 15:35:13 -0800 (PST)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea756493d7sm3596819173.85.2025.01.21.15.35.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 15:35:12 -0800 (PST)
Message-ID: <812623dc-491d-4a19-85b9-0f70605c31f9@linuxfoundation.org>
Date: Tue, 21 Jan 2025 16:35:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/72] 6.6.74-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/21/25 10:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.74 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jan 2025 17:45:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.74-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
