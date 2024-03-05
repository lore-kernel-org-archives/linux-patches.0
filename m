Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BE27E56F
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 23:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709679997; cv=none; b=SZEZgrQuOGpjagCOovz0EeU5H1ZjNo94WIfwgo5EHAXPWYBsk3aXsyf3Fefcdb47AeukeCy7dok7b4fhkfoDJQsbZU1V+miWO5D3zNJr1ycqwDGlpAZzQDpvy1GDYUX6+KmYo85R1VGpM+fLXybh5GXWebKhLuNNkd7EWbUMMmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709679997; c=relaxed/simple;
	bh=YTtpCG8yLDYQlDCH454jlYbABLTnRC9zq2IxaUTjdr4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sIIoXwetqhcT+PCOOrck6qfEdoKqGG2ENfpiDpYd9p+SgwajMAob2pfOcDFaBO2GRwOV+p1ii+4g6J1RPfYO6Q6C5Q7O//9R+LZtnCsIVe8BAx0lS/Pm1DPPZSlPr7QM8UuAirnCQ+cW1eQN11Kz2ZOBbi00vxtnrsbeOZuEJD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KYFO3mbQ; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KYFO3mbQ"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-5a17a739935so127285eaf.1
        for <patches@lists.linux.dev>; Tue, 05 Mar 2024 15:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709679995; x=1710284795; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cevpF1BZFUtfs7XjcRFcHcD08DG6ELAhoOWrEllOay0=;
        b=KYFO3mbQDAsgZ0dSayty4jjGLAprVMMj8tGkbAtb5tV9BG1y1KH/uzmfV88QGtGzlf
         QAL7iROg9D9mfRX34/Tk4+vVfmvJ2ksIiy0x+F6UEzAsFrKP7xXSKi+k+cVA1TNNZJvP
         KxZmupgKMe5X5QniuIM4LmHFRMAwi7mOrrlULkHq+jTYoc7M3S8+WftNsf3hb4ixDtQI
         x/sgg8Frxnw/kCJSxQj80VDFT2FxMK3lO5ZkOCTQCYgBt06/neU4IuPpjxOG6weBEx4G
         bYWUw/TVlYlN0tHAkZRGGzPUf5BDvg02yAMoXaHW0NtRFO7wIzflPW7HZBLb7TFEvUcg
         bJEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709679995; x=1710284795;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cevpF1BZFUtfs7XjcRFcHcD08DG6ELAhoOWrEllOay0=;
        b=k2TltyfD+7JVlf8uzE7hEjKCBQcxS9nTw7Z/yej9/1cN0LxzPC5t1rkMXN6QsyQUSx
         lOcrFgHh5HazUPw01m4aLlvsAg5JE8j+LJQaI/np02hz/QaxIKSoRusQpM+Wr9if6Zue
         HEXBXsmWsgWUonrbdaT1TbNmz/9QlEJOolFGgSPUJFklMFWfh5X543mv3n3B/TD9GpYG
         LkaMxnUupFkUH59DnR5QhvL/MO+vh4Iss6DRL52ORxGJCgugQxQtKAuKSNdMcDnWxTq9
         P0npdNUipRVyTFaCepEh4HIwVFxDN9TbVHUGhrd42NTptLwb30BuY+OtGmof5EOlOEn5
         lEPA==
X-Gm-Message-State: AOJu0Yz/k95/vzBGI2bi5gp/fibEt/Q89vqH+m7lrmxdUBvgXdpBZb6P
	61TrlgnKcgTeaK7idzLTdSR37xgLBh6fBi42D7hsBo5CdqO5b2Ko
X-Google-Smtp-Source: AGHT+IGs/vlJPLVVwCDRUjVLZh4t8NOqV2Tmf8QSHPN2So9mEF0BvcyrHVH0gXWrh47sDgJUBamTEQ==
X-Received: by 2002:a05:6359:4103:b0:17a:d4c0:d59f with SMTP id kh3-20020a056359410300b0017ad4c0d59fmr3861708rwc.4.1709679994927;
        Tue, 05 Mar 2024 15:06:34 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id op29-20020a056214459d00b0068fa815b517sm6736815qvb.6.2024.03.05.15.06.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 15:06:33 -0800 (PST)
Message-ID: <d2884c34-fe74-45f4-b7f4-3a096c9aa64e@gmail.com>
Date: Tue, 5 Mar 2024 15:06:28 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/143] 6.6.21-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240304211549.876981797@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/24 13:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.21 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.21-rc1.gz
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

