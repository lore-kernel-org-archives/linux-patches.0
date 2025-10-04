Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F89727AC28
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 16:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759597114; cv=none; b=XIS4g7r8gyDtIpoaD/fKzESKkKuSFB2aac9cVdxGzNcZ7qm77oTze6kVIP5BAwuj5K+dZBFrnsefZfUQznfe2c5j2z39VV1SM6yZTPAc6PYeCLH2VSQ2hgXO40ydxMeSkAKzcqQ4kOMZTuMiBZbtyX/yJ5q6i0sp+DJf1QJWzdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759597114; c=relaxed/simple;
	bh=K9vC458WseZ+t5Qy5yDU9N4O2xS+IAk6v0rfKcmkCkU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JoTkdpAvRa0g56XvNoVSWW6ka6Jl7geRjMIlDB/ZMap6PBxkFVLws7hsssIWiNOGr/ELgFV39TCTDEP0m9AquEH3+M4npmXgRRCZPouK6pYyR7Huq/q7ei5XRcfI7c2sJFOEnzoesqQQlndqTZoXSBRZYRaiO2hU36G5oixPHCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMpAscwL; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMpAscwL"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-4248746aabfso13407275ab.2
        for <patches@lists.linux.dev>; Sat, 04 Oct 2025 09:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1759597111; x=1760201911; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YKCXGIJ/5BK0XkF8KRZhRh28Rfy6IWFA9g8zjTx/OE8=;
        b=SMpAscwLTjDxE7gqthzALVOhjdvHAstD4GevmjPdTv5AsfwBzepzC0uu93SaTx7+xP
         Yb5pBm5dLNpCiEFau3fgCK074d6QvspMIUFQ0FTkOO55VdT5BLsVrX5nSI5XkYMNlEqH
         mnXSt7q8KLD1owP2tFvGWD897rtPx2BPT7hwg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759597111; x=1760201911;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YKCXGIJ/5BK0XkF8KRZhRh28Rfy6IWFA9g8zjTx/OE8=;
        b=MOqnYnxIYWEAhqCk34JxZidHCgH0ipL/c7+mfxzXswMH7OQ1QGGWOLbQ900EA3L26r
         ckYE71pf7sVgPf6UgikWG48qK/bFW4XzrLNY9PROp2qMJn13PzRz+MkhlUfrU7SIeFtl
         ONlEtjs9XcloDX9Oof9aT4c2mH6PnqdUK3B8WjOWo/leSy9uLfhG5AWLqlw5aNZ7xJai
         C5V+enknnPth5iV2OSTQcnw8WLw+MsLQoqcDLOt1Q7rON+33rApM2yulR6qxentIRnrU
         q/0+GwbySRC35ySp2WVV6OMMs+cpg37yyL+9cYqLzmKibWsRP2ZozGb6TZQC9XD+2ioe
         0hgg==
X-Gm-Message-State: AOJu0YzLrK3c8rCx/8QnKYuje+4R9UNFRBMdsq4E67jhgv0crpXow+b6
	F5iuHQqqLw5+ouGPDcSEF8wp2AMUAb4H8EFu7NofFfmr42GD71xonXf/gUOuz4gQwBY=
X-Gm-Gg: ASbGncuiB4h7MNIPOTah7s5wSW/5m55Zvl1j3a+lVwNXdOeGFi/tsgo0XAAWNRRZkRM
	SJaJvEIwe57nBOoal8fiNWhYBJNLDMdePofJQFy/T7uDtOMUC+kmBvNdCndAqBiRqM+//mSLNyT
	ZB3xv0e/0enWg8SQdoEobOEDI3jpqwQacOPARBVtaG+g1us39tglojpzjDJOLcg9IXZ4JevwJcE
	Rf9rX04eZhIgiA2t8gIsG5hvE6ZYoDjYFjBnSuLNjbCui+2vnDnZzeuOsO5OMDdL5NhYadVsWlo
	8mdC4IjOx2r7AQmr//81TbT9EAiEs5jkBrgsP3GN11wIMjX5lZjJUZP9dBTRNLFeVQ1lDzX1jg5
	Y9vzal1x/ao1KPHv2YJy5IzVcM6jV3Ik8LadPcxXkKjPmqP0NnL8axPEKUUuKG/C14QhRow==
X-Google-Smtp-Source: AGHT+IGBk0KCUm6TNrRRCC/kGTGBW3hhMrS42dCtvvENIAVPXJcG7xcFtOUNCLRzrIFUnqtmgp2/IQ==
X-Received: by 2002:a05:6e02:16c9:b0:424:b860:7d84 with SMTP id e9e14a558f8ab-42e7adaa636mr84992425ab.27.1759597111493;
        Sat, 04 Oct 2025 09:58:31 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42d8b1f37edsm34479515ab.5.2025.10.04.09.58.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Oct 2025 09:58:31 -0700 (PDT)
Message-ID: <df2f8664-cb83-41b3-9094-ab2cd17fe531@linuxfoundation.org>
Date: Sat, 4 Oct 2025 10:58:29 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 0/7] 6.6.110-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20251003160331.487313415@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251003160331.487313415@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/3/25 10:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.110 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.110-rc1.gz
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
