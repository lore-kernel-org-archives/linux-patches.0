Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354CF2E041D
	for <patches@lists.linux.dev>; Thu, 15 Jan 2026 22:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768516873; cv=none; b=Qy3oe1z1R/VDpWqYuCIvhesl8aIRVUj+zieslqvdyGDZypetxFM3uz1mErQDoiBk/z0azWTv+2kJqeY3CGG4/v3PiOgp6ubNAnzuv28fS3WIvOBAf35lbwPgBmOpw178Buid36jCA71/oZFoaQTh4KWRUIvOw5y7bjzUQ6OmxZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768516873; c=relaxed/simple;
	bh=2lYwqcpD1qh8oUgxiGPRQqTQgcICEOUzpvRx1FHvRK4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wi+e7lJdTXEK204z/nOM1fjWG+jrs3ZWuIGOHnYuHdVNiptR149lr1Y7pTh5xYfJ4E6TeR8FGkEVchCF4O2fiXfVcvLsfrDAwzMyl/xz4JSch46A33WliWdi0+LurYe4joyBKG6yyvn25mOc5zXwa414krIZLYy1S9aXAiV8lxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C+Ak6I5B; arc=none smtp.client-ip=74.125.82.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C+Ak6I5B"
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-2b04a410f42so1749934eec.0
        for <patches@lists.linux.dev>; Thu, 15 Jan 2026 14:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768516871; x=1769121671; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dtP8XvmEW21KLqk2Lzwa2yyH3DFghc0b3G/IV7xLbn8=;
        b=C+Ak6I5BmuCJHTdUtnRsAvtef8ukhU21P3cKRG8bpZepOGvhOUDgFPKUYqWW1wBqcd
         LVWTJlyDl8L7d7WXg9nW3d/wrrgwJ2gd+liCJ9mL023iMUHBoNG0K8PNdCYafh4hDSl4
         vSVhoeyrkkZbtnAUNufaEukHk/PEeeg3bNHIdYTKRPOPd/nSLmEWW8/tOyTdszhFy1Sy
         9TMJ3hKN9ELTCQOrqtbaZNTlp+EMWyi3pdlXn9qu0FRQYFRR+iHUcTfxBeSXnd6N9qIJ
         X12+Z8UkYSmWnJmH6uujn5m1gGMT6iQuZdFrLGK+LuHndKYEGJOs927br3BouRLsk3v8
         JgZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768516871; x=1769121671;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dtP8XvmEW21KLqk2Lzwa2yyH3DFghc0b3G/IV7xLbn8=;
        b=YVxRUllISEc774Koddi6f2ejp4SAyBUnsyPkNz/SLYtwwrxYVnjXgWAXQsQCDlq/1u
         JFBnvl+DQO+iD7MgtN3A9plFFk3QwsWCyAk9xS8mgv8rIHRP9EPaL4ewzClXOYj/rmio
         eg72mnopQdWe/6rm1YWOfJ6lgIbMHcNZSnBWBhuJwJNYfxr0IcrDlD6qFqepqP59IPXr
         SVagChXtjep467shMZYiyA79uTRHrw7DGNyMpPhcVv5jysXEh/9FUyiHlVAWgf2XuSBM
         8Lbf6vEbQoV0aqiOXmL41sShE9zr1a/3kW9Hblc6XCvfcGyW2CFezsDJUoXfd9AxTjBx
         EPzw==
X-Gm-Message-State: AOJu0YwKvMHZr2mg0KRYdHiDK8C7ajJio9EGwln7YMWJyNyGaqRMLCE7
	rCCWCsHCeYttf8dpdCqLeu0kTPEZOfqe/hqOV7m1lPDYoAo7w5KPIqu4
X-Gm-Gg: AY/fxX5fJbK4oKafhR4nFKZFTM1inNbyz257B3FkkXMBemfuNg/fwDrGhjj+48AZrTJ
	Vz8rvuMAOHUm5jE+udik+xEh5+67OmMXOFFdi5ZXSrSHNO5DNQyQr1ZdyduxPhhcuMsBxjU/IQG
	PhdWDILJsnZT7ZaBW/ihFeqeOvTkbtHN6Se8z5bvSJurzw5hcuRYxT5PSJ7QPgwr8lkn2+pELYc
	ijpAybqB5gTABk+HUaogqNuu6w3e6ym+SNhmvSxpE1p/fAaXM8yGirLvXpeXaqLf9TTC0UJIAdh
	KyyqLvGLM9d4i2ej5zOffju2/ZfUUoc9lPLHNNOUoomrgU8XJCqzWCggZbufHgbHn9Ne2SG7iFv
	mG34wZ1mSHKZlW9Ak5VzEHljz7lbZ1bZKXRVr7eAbF+d2N0jmn0Ihf6iC37MTpmt9O7MeW5QDKQ
	NmFr4e2uRI9iW9VhMeXz9wsK9w8hukSOsDJ8V6ytf0NBy9keNI
X-Received: by 2002:a05:7301:4184:b0:2ae:5f34:e93f with SMTP id 5a478bee46e88-2b6b46eb0d2mr957343eec.15.1768516871197;
        Thu, 15 Jan 2026 14:41:11 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b6b3619a7bsm631683eec.19.2026.01.15.14.41.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 14:41:10 -0800 (PST)
Message-ID: <f1630172-8a6e-42e5-9771-563cf626478e@gmail.com>
Date: Thu, 15 Jan 2026 14:41:08 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/88] 6.6.121-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260115164146.312481509@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/26 08:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.121 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.121-rc1.gz
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
