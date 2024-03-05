Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA92112A150
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 20:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709670912; cv=none; b=hlSHvlJ39DlOoGVZmuMCWI2AYEb2akTgKTy+ySwZB1orAZ/IwiWB0mMimxJx4AQLWUZQjKkB1NlJyDBmAVYjitSdbJke4pvbwnVCgre+Ti2ycAo1QSHjVk+v3OgWHPN7y7p1gstZkoZ0sflk888mEIrZiTu3p31BPrlfGgewnNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709670912; c=relaxed/simple;
	bh=JF6fDApDsX++KtLanJ/r0alLG2Z+uQ27cn/Q5oWN64w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gmxdI5H2pV7HTkY8Cj6kH6Q1W4HJNCn5WNZQWUGNlpKrPDSaPEnOtohxB0v7JOOB8i7jh6wakvtavrrgxOtLm8Vz1Kos1SSJELGSh0dIr8gDLBAZbRJ/uX/6n78hVIIgOKxpO318YUT/hAB64wEylGVo4geIyWJFJmcgZy9wIY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=chHiEIml; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="chHiEIml"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6908b5037d5so3918546d6.3
        for <patches@lists.linux.dev>; Tue, 05 Mar 2024 12:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709670909; x=1710275709; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1FrNURxI2AhHY8M3Cu8OHGX+AUp0lYpynoWd9QA5tDs=;
        b=chHiEImlpWbboTYpnPDnHBK6BDIs+1LjtIdA3caaawopp3cjlOyCtiN0P6zEfnnisM
         YjMzCSQaomrioeJQxb8C9DbKnRfybIEAQMHS5D4f077CwS6l2Tu3Mx6JpnvTZP4Mw65g
         wyUPrqgi76lFnnJLwI43yVM9/NNCg46to4ErO9RhfDPQQnk7Ux0AnvYtwUc3JQYRRP4b
         sk3noOYRpRPF5sVvICn8Kdh+tyUk+DWRwxWB2zUwkXNhfiw/EJ0TcYlHit2UutvAJUOw
         RnpDL88a2VxFqSCUu//4q/KMQYPL4qiLCAoJI8hv9oQwzglu/8U2Zolpn3ZIV5Csm97c
         qzvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709670909; x=1710275709;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1FrNURxI2AhHY8M3Cu8OHGX+AUp0lYpynoWd9QA5tDs=;
        b=OdPwZhh8MmrlJtzFb6HnioOO7znW4cKkDBNyBMZ6lzRXYPjXX57N5+wVhP+7WHDZGZ
         GLn+AU0q0Rb+n9eANE1tDVOSwNv/uvxZP83HoV7ZPdHZFnCiFBjkXt4zUoXvYK/y8Vs7
         Clq5wJfBuUDHhganaD32Z220KOIj1X/ccQJyt+qKTGzhWs9c90Zi1ou4lZZ+9fH879gc
         cK0yZh1mXu/TsKDPIHX12pkhPriLJrRPe+MRIM+3RvOpzeVUtbnlLPWEmibtiv27NRb8
         Dqsay4zLAH6MRp+YqMyduHXA1ULx4Y7WKqOpwSnVQanwLaygD7+NnI0Fn8UdJI3Jzqxr
         MzKA==
X-Gm-Message-State: AOJu0YzzsDsvJrzwuT1Ka/C4esEoddk2HJh/PTVKuGSo8viOr5MXWDHd
	Dxo4gWHrE0OPiImHnPrjVGIsnkE2QdTXbCJkkFFrPDxJ4exXQ5aM
X-Google-Smtp-Source: AGHT+IHHlW2xpDPXU3vukbWNxCLqNBXdnAx3IgO9ZDNUY6PrEtww62MH4TuIY1CFsEwW4k4fmNf2bQ==
X-Received: by 2002:a05:6214:4953:b0:690:74a0:16af with SMTP id pe19-20020a056214495300b0069074a016afmr3792962qvb.50.1709670909587;
        Tue, 05 Mar 2024 12:35:09 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id cy7-20020a05621418c700b00690796f7f3fsm2297986qvb.28.2024.03.05.12.35.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 12:35:09 -0800 (PST)
Message-ID: <ba316f6f-4f77-4b75-a5c5-eb128568fc87@gmail.com>
Date: Tue, 5 Mar 2024 12:35:04 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/41] 5.10.212-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240305113119.020328586@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240305113119.020328586@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/5/24 03:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.212 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Mar 2024 11:31:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.212-rc2.gz
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

