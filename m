Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8A080621
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 15:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708529995; cv=none; b=sApy5ermXBqfn7h6PQ/RuoLodXRS0whZO1XfIjQUNGpHq7stmCL/ISHpL3B8vI8we/QHoUUDFWLDzt23jMOVmkNH8xF0lNjqyWuSvXedw4ztbjaPZjeJnuS4d96PBR9XsHqILmr6TCwD6BQkPbU9fTPzkdVPW/CDHpEG4LDlshY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708529995; c=relaxed/simple;
	bh=/hWKAeRud0kuMn433Dl2jo5S7vqk594oIcvCbmHWLfk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kY6XzVIkV4eOv4TZdsR/ONyBlqNqVdGacjt3N6b9mg2JyBEtHfr7SWQJvIt1LTFDyjDPmziJtdMcmelbk/Ne7HIHahdTCv8Q8mJ+pnFNY2ucqRpHCziRqiHF/IpapgtFf3Ps2GvrefrI/yyRDm1i2aTXj5/XU0Ba0eYe5EVu5Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9jfo9ut; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9jfo9ut"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so60158939f.0
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 07:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1708529992; x=1709134792; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4ihCoGD8YoiAtANW7gUYHEwJtMSG4/0XxP+tNu2DuZY=;
        b=c9jfo9ut4f8O36vJtu80kAnH/trxRqL0CvvieSe1NXq3IGHEfP7mSIoaNTe9mi9/A+
         rXM3I1kwXNo7m5qmLNM8PQYA9zVvaZTOBCsxmXU+rDuZA0Lyyv+8pTFigxOyqVoYkCUE
         yBr9aYjRBwQxBzuYmH26Ih+jGPVSzLuOZbmfQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708529992; x=1709134792;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4ihCoGD8YoiAtANW7gUYHEwJtMSG4/0XxP+tNu2DuZY=;
        b=jDg6ZGuTbbjrDU4DenN9XJDAxxoz5G922Cl+YJPvBnb+vTaS05XBads79UOGJFGdJ2
         kZgzgrrguiMZvJ5A7bieJKJVULsn6WgKRahym0bGtWUHAu0ZiQ/a2/VUSqVfDx9KBB0I
         jERy4x7tyB/BGKHc1WwTyNk+R+tPgrsQtag64uJyRwaGtPEtxCDUIJBh6EpwJBCT5WYn
         /udXvU7MaonI6tzABl256+r1KTBGE5qlhH+W9N5xTF18+QDUhxsCHs0qDqAGCd/lkMly
         fm5bt/8wZ+g1iWx1N9xOAfF/ePbfnS3zLGIMdzZuhUqMiDx7FQfRaCPJOOENtIQ0Yj4U
         NhZQ==
X-Gm-Message-State: AOJu0YxIyVMizmu/c8IeYrMmUsPiu0mciDO2z8GKivlxaIjC8DBv/jy5
	neBolgb6rq6e+WaZCe14DN8I/VEQ/venK1Lv9u5xl2U7hLZNEy4edXk9Av5+ASg=
X-Google-Smtp-Source: AGHT+IE40mVcFx9SdHZh/rfdZg9KERS45XtNgRegwEDd/xTtiSrXpdBzPTYo06768NFczi36UWEffw==
X-Received: by 2002:a05:6602:f15:b0:7c7:28f7:cc81 with SMTP id hl21-20020a0566020f1500b007c728f7cc81mr12863789iob.1.1708529992670;
        Wed, 21 Feb 2024 07:39:52 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id et19-20020a0566382a1300b004741e00a5d6sm2159096jab.63.2024.02.21.07.39.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Feb 2024 07:39:52 -0800 (PST)
Message-ID: <005a3dba-4092-44df-9544-7366f267de29@linuxfoundation.org>
Date: Wed, 21 Feb 2024 08:39:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/197] 6.1.79-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/20/24 13:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.79 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 Feb 2024 20:48:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.79-rc1.gz
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
