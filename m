Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3AC2E3387
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 18:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741285649; cv=none; b=k0jJI+1YtBJqD8/y/g49bvHIA2ecPVbZy4XQczQMpCBFVX8RO6NN21CR6kreJCe9QsH06pYxYZGelnlJombNCG7kX0inO8mpKEnvIAj/LhTxEchwbtOI5Nkqr65zJFeu+b5UtPf6n9jWYd4SGfG2rOR6jBk3eKeYnfZ7xZ9oMN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741285649; c=relaxed/simple;
	bh=u17mTQN+8NGjgTrzhenTMjvDiTCI7qT/Uu6sUKAN49A=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=AN6XlKzcttQPsubnSgdvrvd0fQT/jT/JSkL84OxN3Wgmrdd+Cdenrfo0hmGnoMtfbM+txMTAnMF/g53emEUbCtNeLivINVzwDTSU/nf2CuqvS6s/HWqc7JgMI3aWLPbbrm+akeZluUKAOCLt8//Ylgo4snI9s+RDuk/b68i+WjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A3lS21cY; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A3lS21cY"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3f3f4890596so555397b6e.2
        for <patches@lists.linux.dev>; Thu, 06 Mar 2025 10:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741285647; x=1741890447; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dxq9TpE0nVpJ4LjErwwMJdonTvvCHuk+jzxyXFO4lsE=;
        b=A3lS21cYLCw2WTwLD0vP1LNM8jcuudBooYv4+mpSwC2wytjUHpLX38NrWLE1P6nZce
         2HktVC8QisgfZOdgh37my+Y7/57G0EsMHgF27wdcCatAmOQMJV352xXi0ECTjFOMRwdL
         V3U/kJlxAPfkR8Cj3k9gwOjPW+eiFdDFwdqLTAE/fkKNjVf2kPYbYO3PV6o9cnmYofmp
         zNmUERuQqOXoxo7XaQ7zOOalo2jtryPf8AX4aW4K0E1HUfqiRQgZWvrlLUeHjIKK1DES
         qrEuMQMwrOdKoE//vnBgIOdW+CAKHlboKWGlyRceHCQZiQL4HNQBnOtq/Glg9BB8WJOr
         j+Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741285647; x=1741890447;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dxq9TpE0nVpJ4LjErwwMJdonTvvCHuk+jzxyXFO4lsE=;
        b=IdTPVfWBYnteh/r1rTjlL/gbVowNPutzq/lvOwi9lg+bLQBKAF7+Tcvut4DNjOiFfE
         e/9mhQFSR+8NVNfvUNyPRbj6mFuivu6QFg0mlqsBAoDpyvTPQ/TjqEMLJYywDCtRZBN8
         xT6Tho8Agc7Nb5YwlMIRPgceXFD2OMyCep0IIWbnpLMsBwOePf9LQk6zV1dU2ZhnXxc6
         EaAeXJRKMojuSW3sA/FlpUFMhZXe9Kxx95eQOdAjEUGQ4JtB2uVM3l4oF3sl0g5V9rBw
         Pz5U8bxhU1yj4eJQfjjJxt2S8/xLwE5WUfxkeozu9WebRUrVpP1j3NFbaNKJro8z9+lm
         l43A==
X-Gm-Message-State: AOJu0YwGVFMqb43NhCodo5GELvMEPGvPHCpcFAHAURrRREjjVM0qNpxm
	mhwlp6PCSBUTpqd8x4XE8UleEblQpr4ZInLRD0tNpRucsg0ljguQ
X-Gm-Gg: ASbGncvAxSBiJDabc3WW1ncwIioQ72sZtDztpwBcup5HHQ60BFCfGtLhsbOxoBNfZVX
	C5wlC08luHcoqa/u/uxbr1ltlFXD4wXGTencnto8a1+4BqOA/gwofbK1OtakBTLPPy0p7HcxS0c
	9z50iysmsQTke1i9eiA+fPebP4K1A36AFMAuvKUGf5e33atepFBxsk83sf5/hUwqiHdeOR8KzDU
	nl76l0DuVuUqh25qcZd2UCwsRVIA/kHnM3I4/PEI54K4xznsQL9LocUUsNDiVwsxlIKzJmyPapn
	9querBspmV7Bn/+Xx3dHtbq88Z15nGWShQTN4X1DnPO1HAlPVvv1i6onJMl7thfSvtnDCE5p
X-Google-Smtp-Source: AGHT+IGESmuRrzHfywIuQCgSLLcA7xP7MfEHE/ovN+Dnqjr0GlXyblDPYRx8+ijjlyLbRfzNs/WByQ==
X-Received: by 2002:a05:6808:190b:b0:3f4:d61:3709 with SMTP id 5614622812f47-3f6978487ccmr258828b6e.0.1741285646957;
        Thu, 06 Mar 2025 10:27:26 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3f68ef9d93esm347003b6e.5.2025.03.06.10.27.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 10:27:26 -0800 (PST)
Message-ID: <9496fd88-d58d-4c68-8ea5-04387e83bc66@gmail.com>
Date: Thu, 6 Mar 2025 10:27:21 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.12 000/148] 6.12.18-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250306151415.047855127@linuxfoundation.org>
Content-Language: en-US
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250306151415.047855127@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/6/2025 7:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.18 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.18-rc2.gz
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


