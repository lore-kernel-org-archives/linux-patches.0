Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4983D60
	for <patches@lists.linux.dev>; Sat, 15 Jun 2024 02:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718417355; cv=none; b=ZgB7ruShDvx3FRtqelAW8wSmK97oeQF8PeEqUo5q3lqlgz7cJKT2Xdmfu0Mg3N64H1R2wa35J7EbAkTjqQZ1l4ANo+inRAUYPElog+kpzGYPcUOAv1vcgRt/UdcuuN7DlpgYlJmoY3z3CS2yCTvjJtrEsZ2h3E52anpziWNzxmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718417355; c=relaxed/simple;
	bh=Bl1NUlVeOWuUMu6QmHn8l+0I/dzadz8WMKIVI1FfzTM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YbzyuCyHCrvFnfY/8BeiRVeojCuCTdnkHXTlZw63mW42zOUnDOsEu9956ZkjzGgBLhpel0uJ3b2wydEgURapGxXsOUNIBOxlU8YX5ncKGj2D7EmUeF0AHft/DPxW7/ANdTo50raKal4dUsqSDNkFoQsdNF+vFF3nFWBoFgzqmzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBLmKR1+; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBLmKR1+"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7eb8075db92so11387739f.1
        for <patches@lists.linux.dev>; Fri, 14 Jun 2024 19:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1718417353; x=1719022153; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/AVLkF2MndaOt4rbGUZ4MbY0St7TEQ+T/k21n+LVP4g=;
        b=EBLmKR1+huP7lJursVCB+4YpygwcOzutTSXqXsa7uU466S+Sol0GyIelyr1TnVS4FT
         06fJ6xhERqFO2eAiCe41UbvM0TuQ5ICmXWf2PD7m9sH3hBgCTJC+XQvDX9yY8Slmrv8y
         KfLR+POqIIE/ruAlRUV8yv+GvRUGSUSg6vtAw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718417353; x=1719022153;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/AVLkF2MndaOt4rbGUZ4MbY0St7TEQ+T/k21n+LVP4g=;
        b=Z//YlwGGxwlcI/qHkGcZvG8ZwPYOUqvBGLOC9TRMdz5yzSULKB5BHoo/SPvpi1utzp
         hLcMCWJGi12K+NZ1vsHSuQHF3Ro3jpEx4744Wtwja+MJFmqqVOLMvFXZcZjPLN2XC+vj
         AlYQIasrwfnbNsLut3lKx7TPkEjsaWNexDdyRNeNJ8e/JdBpPKHXEdb7RMr9D5IQTYe2
         MdkucGBmxfPsucsU799a+pV66k8rzZMa93bOKFB6jBC0Gi6oAit5gaQ/CpopxGb1ADlJ
         GEEK2h9zEMQjyQQs56OGmnMGwjFJdOBOWYa9ElzODPJlniBZ6Pb/WxHnkhSDqGeSRVZG
         X9cQ==
X-Gm-Message-State: AOJu0YxbTEXgnAX3VrBBQOB2fIJroHTd1JFoTLWcIBz78TmW57XvHN2F
	13wVA0NE/oQ+N+0g3rPapPE0mSMs9eBlz+xSJXS0nakng8Rq4oXxo47wBp+Blmw=
X-Google-Smtp-Source: AGHT+IGtnUSCyRuHRSzlM8/24/qqOYSZbzK+R5CzvfHQKmF0Tmr39UIsf3EFxCjz4DcL+Iw1thc44A==
X-Received: by 2002:a5e:dc48:0:b0:7eb:6a6e:c830 with SMTP id ca18e2360f4ac-7ebeb627c7cmr445203339f.2.1718417352683;
        Fri, 14 Jun 2024 19:09:12 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4b956926b25sm1211310173.57.2024.06.14.19.09.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 19:09:12 -0700 (PDT)
Message-ID: <9af06914-b5a4-4667-9e9e-b2ad8319977d@linuxfoundation.org>
Date: Fri, 14 Jun 2024 20:09:11 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.9 000/157] 6.9.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/13/24 05:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.5 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
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
