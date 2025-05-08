Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A232278E79
	for <patches@lists.linux.dev>; Thu,  8 May 2025 14:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716016; cv=none; b=b38AASsWmY0ZbW36EV8Ua8sq4B/GDnPdqBclLLXWTruUZ2TlbnflQ2NhInHbA592RnFPXeNs3mJJSIHentRR1IsNvd+Nttdja7i4rMHd1eCTiywO/89EGEdkravgG/ZF+85gA+nNwTkGIxJwe7wKjTJAsrqesPlh0KFWGKasHPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716016; c=relaxed/simple;
	bh=odtgSXwh0bCzCfLwxDrlyXiDnmGY2jKlNaMTO9n4Odo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CiNR1Zpks+G2j3mIRaGjrQ/nYeCfSt4zbNntZz4vAwPUwUIkjfCiKRhAdBN9i6PtKsXxsNLgRW+zMqG2Gxa5EB9tCf6aTcSgmmv4kKW2jC6/o9OdEZKHHfr19xGclIvQ5CmPGVy187d12H6KqGcX3l0gq8WMp/LzprtQYPNS1Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gn4AOl/a; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gn4AOl/a"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-86135ac9542so42805539f.1
        for <patches@lists.linux.dev>; Thu, 08 May 2025 07:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1746716012; x=1747320812; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gWrVVNVJo/P+Yuo62NX1HsdonWLhPO6Bwy/uZRZodUc=;
        b=gn4AOl/aU6hYjlT52EnEOlUle3ml78hgc4DdUWewNVoREtm24um5Sz2KXeTVReB4Or
         J2HkVPxQrrUSWaBOwIoJQw7qAXXAy46Z3k5qHOsP4/W+AcRM/avpLR/wMnrW1M4EM4X/
         7uVTT2oxN3OcVMr0dHn1klcPunXbfVgA672rk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746716012; x=1747320812;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gWrVVNVJo/P+Yuo62NX1HsdonWLhPO6Bwy/uZRZodUc=;
        b=cgUP322GFXvmXsJlBPCzX1CA/qq5mhM3nPyseGzY6Unas/Pt6NZa3iqnWk86Mgb0xR
         3VILAdO/IjVHjyPVfstjrtjwkkhkPFvI3oLgqLOf067OSso/M3eoYX3zQY2Bu6VlScvQ
         AeGTMpMvBAqqqb1jCpPZUWTfYrXWoZ/l6CcoONNv/8/SvtxodN7azFQNQeaFQJFooc9O
         F38hUQpoqKrpzBiIFGxQ2F9DjT8W2GQfZXYkMcPXtCC8mJCDSDDu1n1r2Fy1UruFOP83
         CiIV57zC46XbVuyt2LmcYLUe1lYX1v9+guWxG9QUhzPfhvAI5X+iX2ycWXTDz5eAZzrB
         yB5g==
X-Gm-Message-State: AOJu0YwHgrogOLsCmv8HbBzkZzgEz7wgBmZR9XNjvkKSfjhqqiZ2EIhD
	4VJ8ximPOhuIMJJrZXUmWVp61DKMyqBDue+rE3NzAJgig6gdJBskDAnPVneYc9Y=
X-Gm-Gg: ASbGncuMiEbgEcyK7bebDFiUczDLRaz3C0KwsAnKAsjfyriCGls3KF+rFiHbZjKE5Lk
	lze2BRpkfAYSiblVr/XuyPmoLtb+x36/94lRkT+jTa2RdGiSSmNNdPlPvtzLtFwjxFPIKtggJak
	Ty1aBAVYqzJatF98edUteuYAi7p2bC5IQhXpBCefXbgcXfTdsNjBTYA3FDbSWxv1+iYzzfglF+I
	o011YC3I4TPNOlPC3DUAdSafXLm6gyItiYx6KmAqpFbhrJFb/7YftCxpA2l715MCl7sy1czo8pF
	T/GHYZMOpa71tUpG4vsz7rcMb1kJ4/EKjooM1jDKwB9EmtfdaNQ=
X-Google-Smtp-Source: AGHT+IEwWmhE/+y7H/n+FT285k0C9IJ/JV2prQ46n2CbFOH6T/B5DegUcSij7J/6yY3M2ZKgO7icBg==
X-Received: by 2002:a05:6602:29c9:b0:85e:16e9:5e8d with SMTP id ca18e2360f4ac-867550e2fdemr524506239f.7.1746716012533;
        Thu, 08 May 2025 07:53:32 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88a917564sm3250822173.49.2025.05.08.07.53.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 07:53:32 -0700 (PDT)
Message-ID: <62541900-5287-4fe5-b2d7-7ae182d22331@linuxfoundation.org>
Date: Thu, 8 May 2025 08:53:31 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/129] 6.6.90-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/25 12:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.90 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.90-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
