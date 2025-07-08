Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65EC2E54A4
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 19:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752001544; cv=none; b=XoFkcbddZsUy9sTWj8hmv96VQY6kM7772WDmldiSeYMZu5/0tFfEUU+a2JdP4CrLWBmn+oCI/7W7+YPUyIsYcbJusLs7zqye2hR52GwdlS6m69SXp6sM4iR88kPCBXzF6aOQRfglGYg1qVoGJB0DdsXfectW8kMDs2rFdL8Edck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752001544; c=relaxed/simple;
	bh=UGQASGraoS4RJgSapElWkV0mXbfAG/bdLWBihBVlcb0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aVpPR4iJUCfStBSXn8+OrS7jnLgQ3lmNh8hN0cXgRJuxK/Xhz+b8uySOdI5AAExUiI97IcbRBzpoqRXZAGMce0TJdunYIBjPHyf3qkt7EVgAoRxw8V4xTafK6VXplXnGxBIQ/pLTw1hKv+hah0v6LrwvkAMPQRdAiUwHDN/6vMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HoyOxK7b; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HoyOxK7b"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-313cde344d4so4652667a91.0
        for <patches@lists.linux.dev>; Tue, 08 Jul 2025 12:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752001542; x=1752606342; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=yYgFtTx+hdhSK7R2K55RqajEkH2fZ0dRxSKeY9x9obE=;
        b=HoyOxK7bIx0ZX1UYPHjRIUFo1OHGAoVtAFbVm+eSmoTydzD4ECUo0DEXHRB5NLSFsw
         3zAuF3C37wioLtPeUHpcXl1Bf5LGtujVAylzCBS5n6XwfiM0xMY5k1dJFSVbjsvFxIcT
         u1yRvjNtIxcIzdZz4X2cW8vP0ZKEa+FIvExucNt6fMG5tU6XGPSDZ4X/zbB5KycRWQEe
         x9cr2zVFldctdMNAXFgLSMMc0zadilP5jogDt21frCiE0fGtVAlbSDa+3RQF1fFu0kkV
         DPOpxdjmIj/NqPN+invjtaXQy12nal1DIeMrIECLQzyPwsoJN9UiXkrYknT+fpCdR/v8
         /tBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752001542; x=1752606342;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yYgFtTx+hdhSK7R2K55RqajEkH2fZ0dRxSKeY9x9obE=;
        b=H1BrQAIxcxfHZ2MnOvnTWIL4OpfvOaPrhptkQs6DG1q38g5rvS/hpVOT7Dqdoz/V//
         ldAKhaM/1oJaY/j2KGdBtsvUjnoNYVTKwC0BwHXiK8kBOr2MKqXurFKqbbyH0sH5a4le
         NKhDFsLe4aVtAgT/QceDAb2UuhXf4zrO3IiGN/G81JRHDr+0/Nt38/TWKWfe6CXbzWzM
         BUcv3lwXuwg65YkBGM8QnnHX4SDi509a5c8l/g+FK8O4gcUakocZRVMF9eNjBKdJLM/u
         oiAigpCPqMNB77WYGvfIti/wbOFrDP/+0c4aTXYkQ5UpNYssAR6jR3hLS2dxe2pbED54
         zJHA==
X-Gm-Message-State: AOJu0YzzBCaRBE6L6cWAeNyeWxFE/jjO0U6rzzm3EDA97nYWwkHpRNao
	Sfimu20Hj2R9EaVxDuu3p3qtLlt31GmnsBw4WmC7ranlAfifliXCKmDV
X-Gm-Gg: ASbGncuQ3JlHxD9C2+Wqb9OUWhNWNUYKxyN48M0RgVzkxHc9W58iMiLlzDypobxE9QR
	0XJyP8Sz6KBQtqQq+CvRRHXOB8LAub3fjrjrOYnvnC59/IZLUYqHvTrnf5/DnCENomcLbxnO79x
	Zh12rU1/qITlL7rCLvTyZtNP1mMCKljmN7+srW2TzLgHuNwGP5Hd0ciK0uhAAH8LmLwunEoh8T0
	yet7+7yBSezy+7QUuR472I4RE3QqugN68e7rbOZ9pq0TdKn/CSMpCaf9XYd3KkvOmWGhGrnkPWG
	OEtnmFGop8rQIvunWzKH9QGeRKJICHAZSsD/Ayl+qVzc9V2uqHNSZxKVfP4vf1oG7CxmSftrmmp
	JVx7Ofg==
X-Google-Smtp-Source: AGHT+IF99FEmd4+HnT48VQVFxt8qSAjbLNuz32CzzcVxyXVFq4UqEBgPPDrLMMIibllTXmE4pPhWUQ==
X-Received: by 2002:a17:90a:d40b:b0:311:f2f6:44ff with SMTP id 98e67ed59e1d1-31aadd9cf3bmr32562144a91.17.1752001542023;
        Tue, 08 Jul 2025 12:05:42 -0700 (PDT)
Received: from [10.230.3.249] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31c220bc5basm2982376a91.42.2025.07.08.12.05.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 12:05:41 -0700 (PDT)
Message-ID: <68de77d6-1518-4b19-ace5-70cdffef61ae@gmail.com>
Date: Tue, 8 Jul 2025 12:05:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/81] 6.1.144-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250708180901.558453595@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250708180901.558453595@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/8/2025 11:10 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.144 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jul 2025 18:08:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.144-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>--
Florian

