Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518FC1AB539
	for <patches@lists.linux.dev>; Tue, 10 Sep 2024 21:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726005148; cv=none; b=k5HyjrOPFegElIToXXCq4JkxN3HhLiR94v/JCnOyJQ850n+X+Gc94+QbYSTbUrfAmIxonmQHABus/ZIDuJjGQOaz0o970ghhnXJjwIqHNTkFbO+AcTu4sdz+HkK7V15VAE4vijENCDXyanPU1lsIISNHcEHY4watyUWb+kOwk2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726005148; c=relaxed/simple;
	bh=o7Tu9mYqHRDbgYmvkBxNamIkhzplwWFRVT9ee/GSxxw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JomHmxYXina0sbSq3ux84um7lS3627ntDZ+XYED9m4jhp2UP5/zDOggY+qzWrJUjASHQuKG3s1vhkdufgs3ckODpM0CxdgbQ+OXLtmrjxVjNAqanGHtxit4irb1o/ueXoQ+XoF/dpKqxYyy0zEMpdvOWmVO8lI6H0rZ4XxEIwVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DcslQy5K; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DcslQy5K"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-82cda617e1aso251201439f.2
        for <patches@lists.linux.dev>; Tue, 10 Sep 2024 14:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1726005144; x=1726609944; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=biEgRbHRVhw3nwgyZGGNW3o+GtO6iD/wAg+Ct4J9y1w=;
        b=DcslQy5K8RImelTlXLtngxIYgeo5lcidkthfMH06T4EZvuBJAqHBTOESM3wb1vT4tL
         djf2oPupJrfvahtLi8/JQKWwHZDubFUUSEAN6akq3rICb0mFns5O52eGF470VxnWgG8h
         BBpU6tSQ+YaelePuAty3YWEWaESn2Bs0+8FC0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726005144; x=1726609944;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=biEgRbHRVhw3nwgyZGGNW3o+GtO6iD/wAg+Ct4J9y1w=;
        b=w5TrSBFbNnVFhebDqAhID40wcsZjQO9iKTYg4sQIRNKvsXcf/m4NuYEsrHxjIN2BE2
         di5rCyZKilOEgZOxQ9s+l7GKGV4bHjMBzZkgrQSVnIYMsm6KV2x/VnD4i8Ig75Jm2zxI
         PjqF9vNe5wSwI8teP2lvFvCQeV5KjwmRGCua3xTmaootZKJjCKECRM2R1WRmjp5eZsMp
         Pg33qC2UroYiU6UBoFywGd70jzObtTIT/XysYU1jfr68FwyZzwQ9R9lr+px5FMiQkyvc
         XzEcWVNzYRcHZT/TZrRCa6U560tMdmAi5ebU1tQbjO7hrteFji62CIfTXoEOzY8Wrl8U
         nxiQ==
X-Gm-Message-State: AOJu0Yx+lwGJcO1SPLTaaKFC5CZ6EoBZXML7jPLCilE6EmW3Ohvfp23E
	yOtuiK0J1KgZbuUCofQwAbm0YY5N+g+ro9r3JRyY8UV2e6P5FEXlgfNFW4jRrAI=
X-Google-Smtp-Source: AGHT+IGJ5zHUhuJP1QGNcsOVIZgc07CdIrjuzckmsmXc99S/dy+ed6BTmnTwBL9Ks7USOrCpKnsE9g==
X-Received: by 2002:a05:6e02:198b:b0:3a0:468c:8e2c with SMTP id e9e14a558f8ab-3a0524a1ca8mr163016615ab.24.1726005144238;
        Tue, 10 Sep 2024 14:52:24 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d09464b955sm1807894173.135.2024.09.10.14.52.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 14:52:23 -0700 (PDT)
Message-ID: <ac0c439f-86fe-467d-95c4-b4e9e294010f@linuxfoundation.org>
Date: Tue, 10 Sep 2024 15:52:22 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/186] 5.10.226-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
 <39d69408-b8aa-4829-b85d-ecae4fa8f97e@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <39d69408-b8aa-4829-b85d-ecae4fa8f97e@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/10/24 15:26, Shuah Khan wrote:
> On 9/10/24 03:31, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.10.226 release.
>> There are 186 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.226-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
> 
>>
>> Guillaume Stols <gstols@baylibre.com>
>>      iio: adc: ad7606: remove frstdata check for serial mode
>>
> 
> 
> Kernel: arch/x86/boot/bzImage is ready  (#210)
> ERROR: modpost: module ad7606_par uses symbol ad7606_reset from namespace IIO_AD7606, but does not import it.
> make[1]: *** [scripts/Makefile.modpost:123: modules-only.symvers] Error 1
> make[1]: *** Deleting file 'modules-only.symvers'
> make: *** [Makefile:1759: modules] Error 2
> 
> Same problem. I am building with this commit now and I will
> update you what happens.
> 

Not so easy. Removing this commit gives me the following error.
  
drivers/iio/adc/ad7606_par.c: In function ‘ad7606_par16_read_block’:
drivers/iio/adc/ad7606_par.c:40:25: error: implicit declaration of function ‘ad7606_reset’; did you mean ‘ad7606_probe’? [-Werror=implicit-function-declaration]
    40 |                         ad7606_reset(st);
       |                         ^~~~~~~~~~~~

thanks,
-- Shuah
