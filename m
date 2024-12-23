Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC4C1D63DC
	for <patches@lists.linux.dev>; Mon, 23 Dec 2024 22:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734993908; cv=none; b=pq2D+EGgKxmOidOWZaA5KAu5pImJrYFJ2g14zZfAyrbTzLBzjYeaek303byZDqJJW4gTFbEESn4XxXCB6W6l86hp86t9CVPs0p8vBZ5OeofwRDtIEuIbaj70JnnEk8Ahk/yMiaBnhQF9gV8NAnqVyY+DuVJdD1iu62zMgF+6vO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734993908; c=relaxed/simple;
	bh=gXgYLTW2OlqNBRzgIm+KCT5ek1lwbIb3/6bFTqw4BAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c/Z1gOpaGQUt6iGnGXHQckj7tGD8GRFx0vrPX1QR43QQr8yPBTOoRC0EcBY5ja0dDaWve7m+x33iaaFiDnGZY9fYe8rlhSOKe5QC5ax9TRiT6PtaahGefrJYr/iDkronExl6bvIEey/2uP/MaWKHO3Uz+iPnTC2wfT51fcLojTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iv6iMldI; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iv6iMldI"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3a7e108b491so39313925ab.3
        for <patches@lists.linux.dev>; Mon, 23 Dec 2024 14:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1734993905; x=1735598705; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ykv+m6hE0b6l5KuV64IfjamfHxSbG8uVgMPxgNA9vlw=;
        b=Iv6iMldI0aK/K+naZ1Bx38omBz1L5ukCOcB0ZzOWDNL/q/yXFq2z0KkXYUmZgPnRzv
         i09WLWO81pVdlIsT/GBVFGLdU7SMDohJWCK8xtCECFLuABtb6pmM3bqNcxA36VJOYmyn
         nWBn3FupOa2q4V/Dh2ZoTI3CgQ39hU3cZeMAw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734993905; x=1735598705;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ykv+m6hE0b6l5KuV64IfjamfHxSbG8uVgMPxgNA9vlw=;
        b=K8DJlDsT7GLMBglQfClNNn2QkBK0ZKmj7zn54cdiqlum2yAfww2ZSlFfcl2E+SDz1+
         tmF7W+RrRTBRtU2SwNyTU/TOXzTgQug0QNVribqKZ7rjsLX/7pzf0k0HmklVPWRjUUiL
         kwuriAale9Wx+LbpMKIh6O97jjC44Gy9voeJz76v/16RaKWsD3RXaHwksNWvANQq2PYT
         gt/wigL5V0iD9WH6iKJmfQ0s/PjoMUdA4S89v8ESENheQNBGit7pFAxs6fhS2Omogipu
         NFMDcCTe6o+LhPXr7ahjaSuuOQZVSPKoHUQC8JR2PzkAa19I+FyufNjRh/g19THq0Alc
         QJsA==
X-Gm-Message-State: AOJu0YyGFNWBN+iFRo7GMgzD8Vx8zucyAS83omosm5Q0n2Vl0l2kgH/F
	LC+9j7utWF1oWP46bIQ76NKFI+dHHn4C333f+wNCjHmfVH7Q4b0p7x0uj0LWfivi590SieDHlYz
	3
X-Gm-Gg: ASbGncvQCTQxFRGjNk0YMG72t7htNc1kq4GV+P/wr9ugBI676NL53O4HCsA08z943wT
	dNPutXew3ZrTaIIzpwYTmHlWTj5MRADFPUdV7xhi1rR+pPDzbf+GuUoeIrLYBMKGqBz+c6Lfy0S
	WLgl76U21UCcrODHTxnNVhC3hpSgnoSf77wM0/WiZZtZMY+kJbmQfFTq402wYjeM4sWb6kFtajY
	AOgYrDILt3Ujll0QwtmsCwYrIJC7XE2Hl1shTpoGuKDrGEpq900Kx1mk6LINmOyJCFn
X-Google-Smtp-Source: AGHT+IE2CGApCfTRTDZMLgjiim92aA8fU4tL9kj1UWudaba6KeAadozE87gCENq7lVJ0eGfZdiCPHg==
X-Received: by 2002:a05:6e02:17cf:b0:3a7:70a4:6872 with SMTP id e9e14a558f8ab-3c2d257934dmr140260555ab.9.1734993905514;
        Mon, 23 Dec 2024 14:45:05 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68bf4f378sm2356808173.2.2024.12.23.14.45.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Dec 2024 14:45:04 -0800 (PST)
Message-ID: <ef977f63-1932-4b93-ac75-ab46f4773e3d@linuxfoundation.org>
Date: Mon, 23 Dec 2024 15:45:03 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/83] 6.1.122-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/23/24 08:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.122 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Dec 2024 15:53:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.122-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
