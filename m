Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A22813B5A0
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 20:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722026250; cv=none; b=ZC3WnXs8YK41WMRmXbseFa7T8LfMuWfXyMVruq+yTv7sg2caFhL/0rV9NTrxs88T1T1Spx541PzG8ng02DsjSY4BEbgO5kA8q3X4ud2fPvb+AiVkjbTpTWvUi1dgc+LDJi4yrdtZKYBvR0XWSxF/5+IKgDStozq13DKeG044PTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722026250; c=relaxed/simple;
	bh=uWBUHLN++fFLVc8VGhHcKdEKbNwcnzqj1Ef+6lusonk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gOYQV2eOcPwYG3Zf9+9TJV6pCAerzOQtfDHCxN7as8zWLgfRu+aepvqc1FGgPHx/LCAKhl84JuDwGfzY4IC7mJcCbkMdtEcNWnhN6MDwQgBc/cWsuh+z8/mM+8PHF4tjILTeItDd+rbu0U8UwwyIrJZFwWL1bxK6YauLgF4Ya34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PcegAZIc; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PcegAZIc"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e0885b4f1d5so98465276.1
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 13:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722026248; x=1722631048; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7kWEZ6NgVlVpoQaTTvdw2+TWHYVF29fS2zjyGtUPgyo=;
        b=PcegAZIceyZGXnSgI9kqyk7H7ldjNYsFd7RnY5LnkmYbVlqnoVy3kVF9ouipcNPeiw
         s3FuoU7PQ3COrAEVNritFza7/NXzmQsoZiGziKoQ7r62icz+oe7VUrCq61t7rBhYJKhb
         mB8Mh2ClXKHxFXdc3ORZQSZMeOztVFnLgCoo6AkxFCwh6QcQeJK7tUwuKF/Mnl8mC4Mr
         86Qd1TW3wQP9S/ZupM9ePbOHv8ldSBKAaIaR5FNBoiie81q3DhxzMk1w4vBH781qQanm
         LlwSUzPOwUb/VUPz6+6CZ5DaUvv3ZD4qxy3blZWV7ZWrP2SjRi7tu3IMlA0fYbxLbPXp
         M9gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722026248; x=1722631048;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7kWEZ6NgVlVpoQaTTvdw2+TWHYVF29fS2zjyGtUPgyo=;
        b=tZOGJ+mD5MlJpKfk9Uh6UuYqyTSTIMnqIKw+Y+GRtrxdmq3qozQdgkPwjn3hGiuwhn
         eHHpKVFOs7At8VbXjQqN8t63z5BPMI2pCFH7lKf4ACk5+2iwGzwha6F8DywvbEY2z/jY
         h2pmx0C0wredCsFXJGnrbCMfAVPAeH1t+foSuOOSdSRYHD0UUVhXrTU449sKEzP3WaLg
         zEioXzu05bVMQX60SeOm6E+bgVMmpMJH4BIxzYvgZQ+cuhudDjNgW7W6nGhDQJTGXPih
         +lrLTvU+viMAE/Bg5dJSQATdCSGHW7nK7/has5q6thRzC3FDeWcDqp9y30salX6xlOug
         V/xg==
X-Gm-Message-State: AOJu0YwC2W0poCj2tw4EJSXXaYy3LCGrrmBsmOG3EFYw8TbBzyzll+p9
	lBACHM4EBhcO33o6xjBpnDHIaWgrFBQ33H8j8s9QTOPeRjmlkQaq
X-Google-Smtp-Source: AGHT+IFNhaodW351fInS0gTk9F/KiQFTbb1U/E7OYRCsIfxlD9sQtsc+29bcqRAo49m8kr1HhU3rbg==
X-Received: by 2002:a05:6902:1029:b0:e08:7950:5d2c with SMTP id 3f1490d57ef6-e0b545e3cb5mr1178338276.49.1722026247972;
        Fri, 26 Jul 2024 13:37:27 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7a1d73b2036sm210087885a.38.2024.07.26.13.37.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jul 2024 13:37:26 -0700 (PDT)
Message-ID: <29df5bc5-6515-4fe2-a248-1f3d66a6581a@gmail.com>
Date: Fri, 26 Jul 2024 13:37:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 00/29] 6.10.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240725142731.814288796@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/24 07:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.2 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
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

