Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4854688
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 21:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721252989; cv=none; b=gxH3VahH3NqGhGOoBB929SGsd9UQrZ2zIWaEJTEhLEL3jR8ETf+ucBTfNadxT6oVwr/vBEt+XvQ+yJqKFsv1TrhDoVXpAXHueLuaoGhIGKibYTgx4BemciEYo2X/WRRCl1rQy7Le5PjvQ0W5fWvIWwzTKk2RdkbBqrQEqPzuVNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721252989; c=relaxed/simple;
	bh=QFOExT69EBDwLwEhYgwDDiGHy4Dcq0F7/rJKgS7aDxo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gPo6j6MyhCMScxvYG+QIFKUEav8uTkgVfwuF7qZ/ZFk8rpgEuPIU8z/aC93pYNGHzUHBRxju2z7Ra9iuOCreD6hoeAiinddz1oQF+LgXK8FCrWz3Fd6XFpVQ19kzlg+VmGoOEQdGdm+7WSblN7QZ822pupKs6SSr7TQHBHSO/Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i4ISTh4w; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i4ISTh4w"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3d9306100b5so113124b6e.1
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 14:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721252987; x=1721857787; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0tY4vih4BGe4SNwmppAmDnFfqNDtCozDKcV6EqhYE6U=;
        b=i4ISTh4wRK8VnzDcojNcBjaTSSHKM6LoE1pi7Acryb3xKtuChjHcu+Vs5AzlvZuc9J
         5FyfwdAZqinKA4DxnwXWglgx/a6Ftr5f/grMg806kaF7iQhtZz4kFOBfE9cZqL1V7I4Y
         b5qSMSQ3CByIIZUctdeMpGxsYR07+30oTnx+iLWsduQWcLDj7RVcqkTx4N0H3PDiOKwH
         srZPrM070dX7wTlthCDI/k3gVkkjerPbmlqdzLFkx0ZflWXTEBH9kGeJkRR39NQh9N97
         1Z9uEv3fIZJA7im99O0Clr0r+BZYBnh+iltU1HvqJ1ZzeKReJTmubC9hMnQJ2K/5YkNO
         xKtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721252987; x=1721857787;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0tY4vih4BGe4SNwmppAmDnFfqNDtCozDKcV6EqhYE6U=;
        b=ZFMyDHYQQpFNYbHALNjvIaUE36qF5l6Au7aqMDk8lQC4hKy/seet2eZZb8EBdsiuGP
         76KrNTWk6wBIkWXWDK1DAd9Z3DyCH4vsUcJBSRiLi1FUs+pSw/zMnILRzwrwwnCM1Xdl
         GZqfiUiiPcad4OfQMuWg1bmRUTG1jYvHgW8tzLzP50tRY0I/Nrjncg+yrd4xn0ll4ozw
         VgHLOjNi46FGlO5U4dMTcZA//ggo/Ox2Qok6lriQOFmf7HEwgrXr+JxEXe1RkuWVlAIC
         aZgZVqbF5BF02VAL09WzWypuOivP/P2hz0s3VanuWJ/1NRHAA7XfTu5lhWORUadoljcw
         cTmw==
X-Gm-Message-State: AOJu0YyImqldmiHDjGji2vyThPIu6qS9fNM3okfFjYH0zqML6rNeMqCJ
	CcVmbzcgozD3TTOp1YS6EXpma2z3yMqZH5N6Z4QbB5VDPP5nQ5+f
X-Google-Smtp-Source: AGHT+IGv8uNuuHK2Xq3XPE0HAXD8ULsfvxWxAPtjXbd7W7I6ydBw77Ez83xGyEEqSPWWtgCLKZT+mg==
X-Received: by 2002:a05:6808:2225:b0:3da:409f:46d7 with SMTP id 5614622812f47-3dad7726525mr1117033b6e.30.1721252987130;
        Wed, 17 Jul 2024 14:49:47 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7a160c88dbcsm444932585a.135.2024.07.17.14.49.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jul 2024 14:49:46 -0700 (PDT)
Message-ID: <f80960fe-24c7-4848-87d7-11bc565c80ca@gmail.com>
Date: Wed, 17 Jul 2024 14:49:43 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.9 000/142] 6.9.10-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240717063806.741977243@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240717063806.741977243@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/24 23:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.10 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.10-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
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

