Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6E1481C4
	for <patches@lists.linux.dev>; Thu, 11 Apr 2024 23:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712878701; cv=none; b=XIaaEGY6GD122DP+bADsfmHe2PGQoJACT1Ms0KS8itx9f7J49Y2nOlYedmP5Oa/G3GLBQY3Z7Cve1HeAUeNHYx59ZiDtgJqyEM743EI+YyGPGhjUAWrQd7xOo5PMxYnuTDvAwRSUWUFceYUQD3ElrVEtlVagpkmbFE/JBzWPPMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712878701; c=relaxed/simple;
	bh=A5/2+I2e6Nc70pGxM00MEjaSowLN0ZxEDmyNCPx0VN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iAi8IGIiP4Rhcern/P2dHEA++/cYR9i3IlG1bush35HBLGh/ZAYUPW/qFpMI1Ir1Z+Ezv3hOuysn/IkRIKLkzhhNhjUcNCF0KBdvFxnCSEmgVmgXVTZzmwuISzqKhaO1NCAC+lsyw/PIZhiXTEEytec6JEssEN22qw+I0GWDKxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/CaoO9y; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/CaoO9y"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-36b00f8fbedso564145ab.0
        for <patches@lists.linux.dev>; Thu, 11 Apr 2024 16:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1712878699; x=1713483499; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HAzHKVIahMAAQYuXrEXLm3Ghx8zr2AF9oIEq5k/AJGk=;
        b=J/CaoO9yKzPZm1ZEcn4pbv2ufTjHlIXIdl4P5mb/72T4ro+C/uwZPNTz+WzOgX//jW
         1mmbzu0fTxGSM95JJffdQ5rQ+2T0DvKpNGYIRHf+rZ3ImrRcuUJpUBW39jihGM5Z0PK3
         vSMvWEV8KOL+4kafS03XzkirZ5RB3/EmfJgIU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712878699; x=1713483499;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HAzHKVIahMAAQYuXrEXLm3Ghx8zr2AF9oIEq5k/AJGk=;
        b=h9cJUgQyFNJCKje9JGX8ZlLheVPI7yENkh6qHZ6HfZOb94vCh2oUR6gHMja2svhD1E
         y2H1iuQbORMfXhLa5UZkMXuwuQk4Skv6u/SmBtmbmEaABcNZ1k4cc7fkcU/w0QsMg3Ua
         pg8/VClPOhSfXCcrwlNg4tDgPTSA2okgyD5OE5ccqJGsJ5ewmHY5NMMz4dUwCIkBp0V/
         t3yt2HCSBT1947eTeKUv25zmmQCPXaSe2U6OIdVk5S61GcQj+rWIujmdTT4/+31Pgo80
         wv/eXuDXAm0IGuDtD6XJ56xwUfstS6eyndi+ycQ8MiPA3io+9QvToIXPhpcrjcirvjtB
         9awQ==
X-Gm-Message-State: AOJu0YwQXVzp9wYw7JctRw0gPUCEeCxVcxmxC2X3z1OCw/nICxGb8eCN
	B3+c+HTX8u4ZvYJ+hE5qliw+AaPkNKhXaHiGzII+Qibw2Hv8CpM5VYJeD6r1fvk=
X-Google-Smtp-Source: AGHT+IGkHINz7dPYIPvNPoQg3hxjSUHSNt32HD/vaCd07WzPU0j6nBda9WqeCIZm5NUrqv1S6m3kRQ==
X-Received: by 2002:a05:6e02:c8f:b0:36a:f9aa:5757 with SMTP id b15-20020a056e020c8f00b0036af9aa5757mr1122549ile.2.1712878699144;
        Thu, 11 Apr 2024 16:38:19 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id m17-20020a92d711000000b00369fb9df9fesm650283iln.8.2024.04.11.16.38.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 16:38:18 -0700 (PDT)
Message-ID: <f4255e0e-5b1a-4501-bc66-a47471f80c87@linuxfoundation.org>
Date: Thu, 11 Apr 2024 17:38:17 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.8 000/143] 6.8.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/11/24 03:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.6 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
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

