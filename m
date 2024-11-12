Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44BC218956
	for <patches@lists.linux.dev>; Tue, 12 Nov 2024 23:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731453182; cv=none; b=D7evxTQDmyaWHWQH04plsowQQdCQbAv/SrTDOjUq3xUPzAIXacmMfQpcB3l55Og5mpfBMwa12YsdRVv1Hyfz9QAs2fsLEkzJXssMUFLrCzBEfZxD/IbwjXLPA8T1eEExCOCwXE1ytsF5FwHxK6pruh2IBL2tVy0lora7MlF8Hqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731453182; c=relaxed/simple;
	bh=M+LlzL6aw+EiSnn0bxaD+l/N8DT+IZRxn9GoEcxMNhE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C+W+0L51s0WYx8wABbRWCVnq4yl04V6DG2KlpW35Fa9qwy/jfmZpLkIn1UhTG2vvzUzvZo45ik1DlyhsCTJNwuKqMzkRIznoGREXsn3kWxHMac1lAXDzF4Gt/vjsTtSxCnst88VuVV5I/vwcWkwB6RAcfWyP5IXbRbLXRhJeK5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjRv2e/V; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjRv2e/V"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-8323b555a6aso335710539f.3
        for <patches@lists.linux.dev>; Tue, 12 Nov 2024 15:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1731453180; x=1732057980; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X+4WyyZqxm62aiyO+CVKXzQhKbvMWffzEQ8gIImHR1c=;
        b=DjRv2e/VMp/2xPDYP2aR8LWByppMstPKO1ZdXQfPM1cYXJscRtgEDJEaYZtPzH+hhr
         XaqFKPPDlQJ6YNVDNG7iyNQ1G4B6ZXddR2UFOT3mmTJcF5dSo2h7g4+h1vrs7hp9/HzZ
         hFuL3g1OhPQ9XsP2730/rdshE0Y+bXrqiZ1js=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731453180; x=1732057980;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X+4WyyZqxm62aiyO+CVKXzQhKbvMWffzEQ8gIImHR1c=;
        b=SAVZtoomg3eHpx78HEbThUA01xIPW/dPIJiAHEgAv3oZ1dVCgpshZ1bAUm1/CrIIgn
         78Wk3ze1clYOo+7Rg/1I4f4LSPMEpOEEaF/MTsuJp949A7/20Sw5gor9MF+uR+PycAoD
         LTS0jZp8+Vf8bBm8p51X6Tf6IN6oGgyCO60LhKBxuPf9GZAzpTTY8RE8PfPgPJqzdVTX
         DziNdoU5vr5cb+n1p5wuJA8GAa3hFxT9HlF+8PI3yTA11P5i4UMLklYVWL+pUfe3t6vh
         LLevoZHeCHb7rHbYRQ6iamocLilD71Jk4/UKAzFhnYZJAV+b8C4GMHxzgdacMWy41kmQ
         dicw==
X-Gm-Message-State: AOJu0YyEqU0lu6KLensQ+p+MAueF3doUqRmCioK3zsuxDaiGL3R5Tsm0
	swQNecqzWc+AG2g002qIEinjngPdVpX1LfQaI4Si7PixMy7xJTGTU9JdQHqqsKI=
X-Google-Smtp-Source: AGHT+IHS5lg0H/ukiayJoHc0vlP5PuhGydxkV5Y4j5BxvOfzlZpSvx6PeEtPlcigb0LVgLizi6lbfQ==
X-Received: by 2002:a05:6602:6b10:b0:832:13ce:1fa3 with SMTP id ca18e2360f4ac-83e4fad06f4mr118666539f.8.1731453179664;
        Tue, 12 Nov 2024 15:12:59 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de787f0addsm2438058173.125.2024.11.12.15.12.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 15:12:59 -0800 (PST)
Message-ID: <33462ad2-98b7-42ae-99ff-757180e3eb10@linuxfoundation.org>
Date: Tue, 12 Nov 2024 16:12:58 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.11 000/184] 6.11.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/12/24 03:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.8 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Nov 2024 10:18:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
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
