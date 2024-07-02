Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF64158853
	for <patches@lists.linux.dev>; Tue,  2 Jul 2024 23:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719963861; cv=none; b=gr6AHCmaZmTYW9D764mfCrYHyk0k/fL0Ok78qgk78JjlXD8gqFiDg3AyRy9cRGJFIqss0fptgQbunFLYcI2pV20Nok5rZwCP4qRES4i5nQYyBp6JpWDuGq+8tmyj+mhrVmqlDN5PsFQLccvjNJHh+oPSLVfOw/vzDLX7ExlWHMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719963861; c=relaxed/simple;
	bh=nugYxFvqkZ3GdtJPIrAFiDsnYPiIlN3gx7rBB0rx1kg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fJxScmG4miSgeU0f0/KhENTNeacPGIs1D3asPqr6b1Jaua1Kegh9Dgv/8Ywg+Su6xCNnclUnoG45UZ7jMWilpFr4LFJfziz9k0o9v6etAviHeh5qMA+7zZ5oOu/LjCdTSu4/7KH0H3h2mXJPiPThxiVl426mwgqDLW1tHvqTZjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkprDJNO; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkprDJNO"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-24c5ec50da1so693249fac.3
        for <patches@lists.linux.dev>; Tue, 02 Jul 2024 16:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1719963858; x=1720568658; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pm45MIjIaeWm4BhjkbsfpReUNUivy1UEQs0ZvejH8fQ=;
        b=UkprDJNOMcN8k9JJiO5cVb/yL6l2WmN2vrElvPViIyuZhKky7FIEftIGd0Zkja3K/t
         DNvVKRuo0bWT+MZGJwGVsgmhGXcjT7fyY7755JTTPpUrv1ThenRK/u5m3aP1IxbgwJX0
         RN2XeFmMBUVXgggTCwubzRHdWP1kynL3zBm+o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719963858; x=1720568658;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pm45MIjIaeWm4BhjkbsfpReUNUivy1UEQs0ZvejH8fQ=;
        b=wYts+obRIz6Ibbdm+OP0hQURWN0WAFuZoJPAtDEWk9+Z6C11I8/VjuA3RngOtGuIfy
         7Sl4D98UBipQaC8lAgkT1T17sF/PbEI2INa/yORwOQ7UYh7lOK/vDnnetkC6JteE5gl9
         djxJ1zvixg52YyYa3s6J9tfS6PiCYGtxgQcV6RwxOReX1uK59v1xLpL3rvwDdTQCkjit
         igrAGrXPVBJmE1vBIt58lqEg0sAxiDCFA/vBw0fGXWQ/nAFeqvlT+s+RQIL7lbnBWAz1
         Zr+86ULJIiLq9UpfUbDQdPQmp/35papUV8md7fu22Ygzk4/czWPtjOATUhK9tutEcTt/
         1VXw==
X-Gm-Message-State: AOJu0Yyk/UUxBHcnBChlOfJhub3bFVHGtsWCkUTtzbY4He6ThjEFNOTu
	GdlVFw4Y4yPFAoO3A4rvQBfv+u6VbrMqqWFVn04lOYbbetaK69HiDKfEynqgJR0=
X-Google-Smtp-Source: AGHT+IGmqmuHlWuvkaXE07Rh5CKoFmBmZoQmtyD6UtHJqCbjW06Ub0MNM9EHQlJGbJkxvCbgPsH50g==
X-Received: by 2002:a05:6871:24d2:b0:25e:180:9183 with SMTP id 586e51a60fabf-25e0180af8amr2263497fac.4.1719963858211;
        Tue, 02 Jul 2024 16:44:18 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-25df77cef10sm434167fac.19.2024.07.02.16.44.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jul 2024 16:44:17 -0700 (PDT)
Message-ID: <bb8f0689-0989-4c18-bc75-f73ce6743c22@linuxfoundation.org>
Date: Tue, 2 Jul 2024 17:44:16 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/128] 6.1.97-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/2/24 11:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.97 release.
> There are 128 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.97-rc1.gz
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
