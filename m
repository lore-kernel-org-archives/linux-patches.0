Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC5054BD4
	for <patches@lists.linux.dev>; Tue, 16 Jul 2024 18:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721153375; cv=none; b=bHWQIx6kDpTthvCK6ujmC6nhMt7ynrK0QebGpQdif167+exR3cD5mKomjSOgTcr3W9Hh05p/Kui7AmMrR598jrrYFldq0AF+UHpCM+ahjREQMt+6NIhw3EfT3weZB2DQPcsuEEChD/6FnRiMY2KZNuM1mxAn92EekbbBliDiob0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721153375; c=relaxed/simple;
	bh=g9CfOXkLcan6WBgXvNGE/BIOD9t9bAsaGP4P2EQXzqg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LhGCQmEB3aMpo26ozlaIsT6Yx4eo+4BjNJN89hRi9XtJZg/IgzzfUhZ+cpn7/10OjTy30XWEY64UfDj4sJMo/9HLb9IhOshMXm2BRxsRRWngOS6DD8usiRnEFKs41eETwGuF5feF4zFCnJAAdcR5GhY7V04By3YEMopqpgtlGK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UwvNLfMO; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UwvNLfMO"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-5c661519bc2so46693eaf.2
        for <patches@lists.linux.dev>; Tue, 16 Jul 2024 11:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721153373; x=1721758173; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d+jvhKyrOsm+zWY2YedScKUBxcdQMCOw7qzfz7YdD3I=;
        b=UwvNLfMOje3YKkTnzvnRkSebZetMBSJKgQL6X/65SH+5LBRNInC66C+ljLgrn7E3pL
         gphyahP09/a052omcEBgQy4i3HHtn6318KiyBtQK7yXyNopPeYGFzxfRsjbHezFoTHjX
         zODNd0YilHLy9A7j8YN4d0cxKKyMwJ+m7999Vy3/xavOSj86C9K1NK1d92a9i6EMT5/E
         RQzAykTkgCfW7If7y/BL+iVyIAZQhI5Ws/ZLk8TUce9iL80yrm8UUd+2F7LDXeEk+UEQ
         n7XSrRUCMhnP/YIWT7nVqZ5vCjWBJwXwF3Ar9tlS3lVGTSMZWdxqm16csr08CeoVupCl
         yVpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721153373; x=1721758173;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d+jvhKyrOsm+zWY2YedScKUBxcdQMCOw7qzfz7YdD3I=;
        b=daWw4F7+THRhaa20d3NkuKUONwG9jvLcKXSjMgw571ErV3AvLFiIZWtggyglzJtvHs
         48kwHdfeRD7yUWznwlBp7Ynk6Ld6jKvBBpX4uCMdrl5AgGURV/KSjyWPjMk3u3A8rz1k
         piPwBxwRncpF1NlkgMW3d5P0nN7llS/QRhbui08UiqTI+YgGfyFtIpSfEk0hYgIhsU/t
         XtEILMpMa+jTT5AAfssV6GfqaHKRtpdU3JaxvXzoTSJUOmk2rDLArk++Dg0grX5LciPg
         Vq0Z19M2eZuTB8B+tu1npD/dYpeImIiip3UH7Prvt8UOABjIuFciseKNp3VtSyvdOJJw
         cA8A==
X-Gm-Message-State: AOJu0Yx0edemifSYqwp31RtFBZlKc6ltT5ho5RMmauVWfCR3FTLeYa7v
	eny6+1H/W8/LSVqZ/avGbTOkISWcX7nTmIlSGa8TWrChpVVtsltm
X-Google-Smtp-Source: AGHT+IF3dNmLleWLkSbEQrh9sPKL50qMCpAsHuIjsxgfCe1EA3kyx+2RHXisp7kDG0a4e6w2IIsi4g==
X-Received: by 2002:a05:6870:7020:b0:25e:1be2:a163 with SMTP id 586e51a60fabf-260bdfbed0amr2327263fac.47.1721153373304;
        Tue, 16 Jul 2024 11:09:33 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-70b7ebb6ae9sm6639931b3a.78.2024.07.16.11.09.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 11:09:32 -0700 (PDT)
Message-ID: <9fc222c5-2ecd-472c-9890-f109a34bdb09@gmail.com>
Date: Tue, 16 Jul 2024 11:09:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/108] 5.10.222-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240716152745.988603303@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/24 08:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.222 release.
> There are 108 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.222-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

