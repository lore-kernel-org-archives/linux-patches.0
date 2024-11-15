Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E50157A5C
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 18:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731695475; cv=none; b=hx2S62Xfbm9uTec2DqJ0WakrfPTy66g+3q0vwiAHJ/ohJhiATuQPfspQhtRRmwzCEx9e7gswieqUbsdMBOf1fe/e1OFd+VjB8dn9RTYtHPvMt9UjQ2+t6km9pnLdU3n3vbQQNY5G8ljAR3A8jUsHNomGBqqg/NtaSFuf7OISDTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731695475; c=relaxed/simple;
	bh=JODjRTpKBkPMRWH04neogGd2G8r3/CHT2IxPQRcwslY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GRwNCbWEcj7AYnL9XlxuQGVJxkwdW0wW/vwcnmvxQy8td3ozIl5+jZugrAm+r1ChBbCgcA6qT8yM7DIgTMc04ZuXf5E+D5xEiDynIQfwqCKbnLfRas7ZkJKsy1IBWKYCRp9znZvt7LM51vkAuU5yXbrebdgWYCHKWh/fHZuXo+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lt9f1jRY; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lt9f1jRY"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-20cb7139d9dso23173435ad.1
        for <patches@lists.linux.dev>; Fri, 15 Nov 2024 10:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731695473; x=1732300273; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=aHCcipxfzFCrkviPLeGLq9fyU+lj79SWu+62BAUE2uQ=;
        b=lt9f1jRYSnRhQ4m19dALfzz+WfNBeeQhj2G0D2K7Lf0diukfpHGko9klk+fBOlRpq/
         k001E18jIXCH0slezzg53iZAbTHMC+rw+I8Npz4kyhaN+xxZS9ML92mIMbBQRwKDZCNb
         7kmVD2oWMLFWqPGwsyuhGsYev7zkdT9wbc3fjKs3Un/Wcpa8aPjf8TDhKJqi5QOVTxHP
         kP7q8ifk3hRLOiSAD/6cCfSGpG9sYw6PBQ0tzFtTjVso0XH8nyY7TzWLnlaQRytpn7Iz
         w2ahsVKNC5/+nqumG2mWxxcz3P/nJcOTBLiaWl1ZGZVmmAW6kHgYr18f50sqLsGwfIcE
         ZVBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731695473; x=1732300273;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aHCcipxfzFCrkviPLeGLq9fyU+lj79SWu+62BAUE2uQ=;
        b=inPFn6aWDXWE+TakwxQfFfzoic5Qefxfp/PStc8WRed9BnA8JoQH9B+Wl/tJ14es5T
         VraBYzrmK0cqv8wtCMHcRTBOGA0jRq2YtGjoDtdEPZPgwPjvaItY0vtaaY4fILHPlgNx
         ADfu4Vc41UDkhX9KQV9IwCWzCCwzSnGwERzq95uaCl9pVsO5T0Ko4v+isw3rzZDNnxu5
         r5hi/7QaXU44m7moyo52C0muL2AwzNi+L+QWAZxjLUDpmSTxVTXpTjMMQj1T9GHQuvPg
         mj9a189mWfAWMhX/3RAr4y5+ePmFgkmiJEa5YuTWTaIpiSP4uK92FQDSSxy7RnI4H/Gu
         2V5w==
X-Gm-Message-State: AOJu0YzGOfzVhY4/9Hiqqu9jnkxvvTg4P10CNGqSlhjJdsaOJTmp2VO1
	JtVAZB1aoYFkZ0fZvC7zkaK/YVRrFMPx6CRZ/GwSuAeH0pbl+miR
X-Google-Smtp-Source: AGHT+IG+d9dIuZS3cXiCcQi6XH+olstsin3G0aBl9ePW5QCjcZvFlGfHUlTRpgQxEqXi5blVRhYH4w==
X-Received: by 2002:a17:902:f683:b0:20c:b517:d715 with SMTP id d9443c01a7336-211d0d83b50mr51672155ad.25.1731695473254;
        Fri, 15 Nov 2024 10:31:13 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0f47a5dsm15397815ad.189.2024.11.15.10.31.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2024 10:31:12 -0800 (PST)
Message-ID: <24bfa74d-11ed-4fdb-ade2-502a6bfaafd1@gmail.com>
Date: Fri, 15 Nov 2024 10:31:10 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/67] 5.4.286-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241115120451.517948500@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20241115120451.517948500@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/15/24 04:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.286 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Nov 2024 12:04:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.286-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested with 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
