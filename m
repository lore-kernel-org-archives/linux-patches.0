Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246661EF090
	for <patches@lists.linux.dev>; Fri,  6 Dec 2024 23:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733526510; cv=none; b=qBkHppHEdX2CwXPAWqlc1jiVvXVoKxKf5LBDR/NcCrJNMldAWDLNLbYunoZX4d6OeYV0ZGIEr18oAbhsfbYH4esFOrbD4hP8ImvI7dGYaU8xxgZTVcFzQSubxJVzml4Z904lqOfgS0JPzMtoRYTnBmU73mainV/xC03D/1CF9Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733526510; c=relaxed/simple;
	bh=UdJB4NOdD03mIMlFI3KvTkawd1NApMWOm1l0WYxfDCg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fAXCnCbBXW8GACccnh6xIFhkSbG4LbRSP0KHSe3agA8QCngAByimRpXUhH7i0SxGgU8p6OoDNye42C5I2mro5rFbVCZXUlIzJlGDu/CA//65r3Arlulan9IrHDkbLHfHo5FaS1N/13FO0HqKWxlhqrobBr5vVXRHM3VpCiMylu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B6Sf9PA+; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B6Sf9PA+"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7b667d2fb9dso141314085a.1
        for <patches@lists.linux.dev>; Fri, 06 Dec 2024 15:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733526507; x=1734131307; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=GOmtcYVNkXjkbGxsVcQ9CFaM4givmxA4y8dgXA1sotM=;
        b=B6Sf9PA+RDB1uFt+mKGYbb8RrcMCqBsWC8zltoakJYdqqstCsZ37olVNpMgAcAPvWT
         wHi8ADkZQcD5pYhfK5zeM3wWCyNsVTd8/ldLU15XdjNDqY4YaXXzW8jRTtsMsueQzpQb
         2tFEjGYvYEIm0OcZ9WEaOFTd3QiX6QBM/wjaJDnOdRVFVqObjyDyGCqajkUKPx6/zgDE
         aNQSdKkGirC42G5zdYejHADc160iOTTSVl5Xuh3/D8xBMfs49qd9a4/7deATPEZvuU/b
         ugqYUu9FO+hNG4cXMTSzWph9qtrVC/sxRR/uRjQ+3KF0XL0EwbnbQreE1FsUn+h0p3j3
         4G2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733526507; x=1734131307;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GOmtcYVNkXjkbGxsVcQ9CFaM4givmxA4y8dgXA1sotM=;
        b=oLiKdYF74q2sVjrBcLJiPDI2pfjFkam3ArkHJQ16zpmzI65XPHYTW1czo66cjPT+Bc
         y0AT4PI9O3ZYDGOm9OIzmKsDrBT8nXlExQLFwGCI1+iE2wV4DsUxsOfNnc6CCn1R6wll
         B44ZxeWaamSVPAD3wElFvNc4mW4Z4S+4BVMAK80jC1ULrbDOuR6mDjr0g8dFcEYxTCtO
         KXl/Q6Hq8aXVTO51nxkHUFP7o3JFIgF4xk5rwVNzDucg/lapWjh3iiDHVdmDWACFqJDo
         Igj1Dj7pXvFEEb2L/NwjkkqQMGsVOEy+MxQ7/KqUmzngtegc5s3hdDjtV6qHaLmJkLb8
         EeSA==
X-Gm-Message-State: AOJu0YwoGAaMgcNRNpNXGJFfcsn6Vp12xIKYG0+g1zNzDcuOljRXMmCU
	8aJ68FywgZqTveoGwDuWnJbKFk4e+GgpCzfZreJLiK7U2rmmmwZ8
X-Gm-Gg: ASbGncss5fV/AKHF1Vb9/N0Idf+YIlPyJP8zEhtzoDWwoXdRh1PAtbZZCdOBBJiqxHG
	kFo70YxSMfExB4QX2m+sZtRLOHITT7kaYX/CL0PP1DIpeyuRiCYE2Hif8OdrsOFQGb4NLyg5pIe
	bBNsJND5ki8M80l4/WIA9vNjdRD5N+m76rGmbcjzypq0C/RFAwERzNhap61S1CsXrE/vAgJXm86
	/vbQ6dIu1yHNnn9wmIsecMvPYqS2M2n/Fcs8WDxWlwvlqKtVNbe5g08mIH/i+ky+sGv5IHZE0Ze
	wg==
X-Google-Smtp-Source: AGHT+IGedO87fn9tnIvq5fIh2TJ1J2+3wLqu++aJkLUrnSfZiHAkNz38tgFmcHBv+xNSZ1Omagt6zg==
X-Received: by 2002:a05:620a:271e:b0:7b2:5e0:c439 with SMTP id af79cd13be357-7b6bcaedba3mr659146985a.30.1733526506916;
        Fri, 06 Dec 2024 15:08:26 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-467296cb364sm26191271cf.25.2024.12.06.15.08.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2024 15:08:26 -0800 (PST)
Message-ID: <0558c0a2-27d8-47a1-abe3-91ea4ba946c6@gmail.com>
Date: Fri, 6 Dec 2024 15:08:23 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/146] 6.12.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241206143527.654980698@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/6/24 06:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.4 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Dec 2024 14:34:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.4-rc1.gz
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
