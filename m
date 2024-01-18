Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46982E627
	for <patches@lists.linux.dev>; Thu, 18 Jan 2024 19:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705607471; cv=none; b=PG3S/zgQncLXpBDbrfRmQ5CV6hhCUaYCCJn0S4Z6HVcmUftXm405br7PVV20uHGyjt1syYaSbjfz/7eDuwqktRk39uXIZoPlhUunHfVLROsoSEBWQeWFP5qhHardTrHw0VZnmEeFZiuNrHo+cK6q/wbfK37WKEnaQaTf70e/Vok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705607471; c=relaxed/simple;
	bh=zpB1vJKPFUrLosU/KAweJYdV+HjG58GHXZeRiTmNml8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=duophMOJfi1pmHbrV/cQTY/p9EGJRdrlpJcteqg6QW+KUKevKWuMxZj/jd1k5jLDgP59LHcd3eamQup3d7ep0jMLd9v+TKu6BAKf6z2ev0HgedZdt68c3mKPxJ4PFOoA7CK7L+CTWqlqNL9VpM8WYpSbR0CEja4N85jwuG1F4E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fyo6wdO4; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fyo6wdO4"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-42989a64713so256721cf.2
        for <patches@lists.linux.dev>; Thu, 18 Jan 2024 11:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705607468; x=1706212268; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BTvQsNfYLosp4zMJSEtUdKK37sRRAVysKUE3QZOulFY=;
        b=fyo6wdO45E4nwdWySMlQBDLpbaoQMGC60fobbOKqdCMklQvPLAX0c03TzWTT2VKuDZ
         6IF1l0o9KdSx3TMeAk8KQrSDLLNPhqyhzWQ/62a5ZC00XpCznyx2uPNIPFFJ/W+nsEfq
         gShXNi5IJTRoehBVFjL9eNo4ylo3gEhGRRnpSFJZXmseI5jJ062tUsW/DGlp8JxntYa9
         jEbGNKO7g2h4UwARQ19m9umANaXj97N1rlRYlUtAK1UkA/moUh57mcACAVcOuTScddl4
         wGcDva6L9rQpRLeZdDNmxYG1hoBcRupRTxQBVKCkHLb7cvyMChyNJeQCNuKRsLJmvh7C
         8iPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705607468; x=1706212268;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BTvQsNfYLosp4zMJSEtUdKK37sRRAVysKUE3QZOulFY=;
        b=Um9Z8s6jnu3d2xCYAkj9dEAPu0q8StA20e/R4OXFY0YBE5iM24rCGwMdZJkqhGUyOh
         8HQ4W73SCcCop0Q6f9nqJd6K97qyGBthMFCAk9REfWdKPM9RXT+HaQ/99xolgerJW77v
         ixQsvmR/OpPPkgfoHEG9aat1s5RD0ACKi+mixLa7Xgcwe+iBoIGT2i2+7wjiB2x7IITH
         QYwXDAtTRmlLBzgRf4rFSlS44X4uxROiS1hpGwfYRqczaq0nk17N+Bn5CpA1j6wuLAl4
         0xoMm/3s4L2uigdBbs5rw3mYfQcjr91j7zOj6aetHJ16kGB1FdU6bvedwuhGF1LJR3V7
         Pliw==
X-Gm-Message-State: AOJu0YzRkSwDia6LclkSyc3rWOlux8Nt8MjxFm5Nu/IDX99Y9B4wFKB9
	MpeT1Up9PxOamoGGsFHQKJG/JbEy6HAabVOsQKHw+CORmVcjT42H
X-Google-Smtp-Source: AGHT+IFuzwMJ2IKpO0vPscGpujBJTJMHffiNlful/2XZ3SiEHAezwmJr9V7vyeM/KC94kkWc9UiFVQ==
X-Received: by 2002:a05:622a:2d4:b0:42a:212d:4a30 with SMTP id a20-20020a05622a02d400b0042a212d4a30mr494962qtx.29.1705607467542;
        Thu, 18 Jan 2024 11:51:07 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c25-20020ac853d9000000b004283695a39bsm6944302qtq.94.2024.01.18.11.51.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jan 2024 11:51:07 -0800 (PST)
Message-ID: <4c0fd569-3381-421a-82de-4c85b8a4cb59@gmail.com>
Date: Thu, 18 Jan 2024 11:51:01 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 00/28] 6.7.1-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240118104301.249503558@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/18/24 02:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.1 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 20 Jan 2024 10:42:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
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

