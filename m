Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF37B2989A2
	for <patches@lists.linux.dev>; Wed, 28 Jan 2026 20:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769631504; cv=none; b=paQJect4Xc7ds0n3R9mFaKKYq2x/cjY/YZEgDpd5S7I6xJHcP5jdgjYgleL19nW+CkdxkTBcsV1q5g4fg67DDAZFBgOk8+RuMALCyZZXG1z4yHGM6dTGiIssr0+av2UJKBnkxW8wDHDdGekREwYsVFWsD3TzoxUXjB3Fwg6l2qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769631504; c=relaxed/simple;
	bh=9mph6xTtQkmaNeghWSKq7NNljHdk57mypRBuyUulH3g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=scLp7jtpcwHYYNMo1C0xm+/ULQzRwlEigTOoPm+YgtZYXr74hBRMxxO4S9ce/4V8iCNHTrxJ36OWSMxQyWZ5jnT7cQgST00Q7kGH0s9WbQhcd/q37f3xTmEAyDbkON+s1YL6iu0tJTF0aCnjL/HELNVayt+e/RcyhDs8JMJfpz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Go9cwkk/; arc=none smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Go9cwkk/"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-2b71320f501so476590eec.1
        for <patches@lists.linux.dev>; Wed, 28 Jan 2026 12:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769631502; x=1770236302; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jYqawXnHzJ4c9BVq3aW9QguYoXUPSj/Zq7c8p0HJoeM=;
        b=Go9cwkk/w72lxp06H0xTIiVFeBQYb3OfxhHvyHdUWzGVPfoqAHGbsykTNrh/MtQdSq
         PmOLQ1u7OMXcIkcKscRdrKRVi7H7DKt/F7g9dAbHcefoP7wL6Hb6y8NPR7qhizzbHhWm
         4A+KVNtNWTVMD8+9l0AxXnUuPwDaMvhEw+9RgmdjIdIkhr770NtcJhNSDlrYQFzT1wYz
         joU/uD5cAjkMnTNJDUz1j0AKIomqDO4839Y8tnYzsg6zcaaq2G4NkW8wybm91OCnQ2ht
         zY8adLIkDSOMsVD4ImdLHgtqqQPERB211pSNh9sSUzj9I2arrp633J5xxEyTjz+SMuiO
         qz4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769631502; x=1770236302;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jYqawXnHzJ4c9BVq3aW9QguYoXUPSj/Zq7c8p0HJoeM=;
        b=uzf+s++KrEzQR9GQSDefepyzb6EN7Od00ew4ovNfZR6jMYBZNUZpQMvVRJdWEHGmkm
         S8+qYzJ8MJO7TMpClwqX6N+D/QbxHFIWRJY/2PPwGasVy/V2diDyzPwo7C0iwZsaROFN
         IAGsbsExnAIvsqBxvt+V7JGDoq+peYAcmp+FUtIFbhbyLuldFTNS7+XseIo/1Ltyr5I/
         60t5u+hahqyJwoG+acddISWxPXelp850O9nWKWDev/ICXuZ6h/Kl+2EfZFdRGVv0FZWL
         oNJlYAJGwI+eyGBy5okLfFcD9TUPSrZCneESZuSdnYAULrk8mlXJYxZlgdotObu4Gyxt
         DUqQ==
X-Gm-Message-State: AOJu0Yy/jdsdQtb4vd5zBkXy1eE82w0Nkgs2cA2otH8rkT8AyH2tS1oI
	fb7OfXLTxZALXrd5styqQzbOEkA8yS1o6sCeigW/ZAHT92McW+tCLPGF
X-Gm-Gg: AZuq6aKwBrIXq9HCTt03pn1X/7lWlL+Hw5r1ZRld39+yM8N8bI2ilqiOg8r9mJnexLd
	E8l5rXn3mbyamIyAXo9bNgE2yuVUFRwrlWtJCEYCiV/99WzH7XpKstSGwLdMvD2fBCgVmHTO1oa
	nxZAyGABSwY7KMaK2LtmEVPOT+avQIju2EVxQkc7/YS9LtqGc4k6YeTyEWR3NRs+l2LiReO4ooG
	4tt1HmiAfDKTBrg0ocot+OXuxSF+cgDOq17iPgv+QRM0xneRGR8X02h+bFivz/7ZsDCgl79tscp
	I5QQgss4gHJJJ+MH0Aywe6dYxUGsS3rHyeynCsU2eSR7+oKLUu7hBD0PlzLFJNmoVbvBgwyyT08
	eXeBQ3oB8Y/iW+zSxmTPcTcO15/6mSYeC8ji+28ogeisdaLJrkaD9kdLhguSrVCODdxCpbCIZBa
	pwZ20jce3RTSb00wqXjmjUveyJ24goAIlfP7Us4Q==
X-Received: by 2002:a05:7300:6ca1:b0:2b7:1d54:87e5 with SMTP id 5a478bee46e88-2b78d90c1camr3872742eec.13.1769631501760;
        Wed, 28 Jan 2026 12:18:21 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a1add664sm4200634eec.26.2026.01.28.12.18.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jan 2026 12:18:21 -0800 (PST)
Message-ID: <aca8894a-518e-4b90-ae92-cf3a24f52ce7@gmail.com>
Date: Wed, 28 Jan 2026 12:18:19 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/227] 6.18.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260128145344.331957407@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/28/26 07:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.8 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Jan 2026 14:53:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
