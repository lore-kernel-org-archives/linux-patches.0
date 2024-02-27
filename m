Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF45D5102A
	for <patches@lists.linux.dev>; Tue, 27 Feb 2024 18:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709060228; cv=none; b=XFX2UbzC+v+sz9gcG5JlZJSJoi0dkFZIKMb++sMZTlr01rIO2gdO1FZM9r+LZpjXixAMBeRS/NzWfzY7qXjuQoJwT27aw7aoHH7RTeVT1wvBA4/+DouP5IASMGsgZ3y2JQNzJbUTH7Js7bYmGJIF8yTqu0/eWkPKqay6dsIbNCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709060228; c=relaxed/simple;
	bh=AXBz4kP/7t6J4fXp8ubc/s3JFQXCzQmYnOb11VgiyRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SXEuV0/qelKjagustTmApvRmEAs0JaWi1goP3HgiKgib22GAaiFIW/NlhxBwrg/j+GqATiZHrOPBw3GoQl50NqA+99RWaTMFTvC8CMMAOYzSjjmzPy6oCVl1Zb7TnxyCDSBQa7MExUthcH1PJsX8wcNCvqoHBi83SVUjyaiJA/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q5Y4MyLo; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q5Y4MyLo"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-42e7f6e957cso15673281cf.1
        for <patches@lists.linux.dev>; Tue, 27 Feb 2024 10:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709060226; x=1709665026; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aofZpK47LiWa/UYtovSsW3ZnP3gthntCOqymhA1/Enw=;
        b=Q5Y4MyLoPzCkfBKMk739G7DDmC8VRJnQP1gxYIgPPD+0DNc5d48iiaSmbPlPYuJOV6
         VWUrhIM9rJxAYbWkZSczVPKvxAN+Ug3IIKmiI0YPtohOQm7Nf+fg3vboq44zUdWarqAu
         gFr8ce67oMCA9US9nHE18iMYjvVo/KxXGR8PmnEm3rvJSq46xfugr0Ig0G91vt36q80a
         cS5drHSIhzgffSxmqhmU9LoX4JX0nD/Jzr2wwjbk0XoZnVSnZQYtJmEjPYEL7m2U+Jb2
         c9mOOyBei5KgQ42zzoGs9QDFYJNejUv81KLQIfInHM/B4OiGA+W3ETlnr+rJCXByQO7T
         BD5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709060226; x=1709665026;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aofZpK47LiWa/UYtovSsW3ZnP3gthntCOqymhA1/Enw=;
        b=v+pqxJdop/BO1TjrWUlXpwrbQAkrsZSA7Oc6J0KbT6jcVYdE1s0yT6/gUBhlBR2Dy+
         ha3rKeII5xhVgxGw/7KwD9IvpjbdPJ388V/tSeFR7KgkOfaqEFHpgLvA9mz4puNhHNQW
         MkfhJCeQgwgIuWswAufwcCSB58MXazDShx1m272VseGf4lyj2Juzpt5/joDlkN6qL+c8
         SkaR5KvRZSggFbMwhX+bmtPgzJs5xfIRSzdy70XhOSieLbYaL7Eg8IGjw4qz3Mkn4rH6
         pEreO7u5PH6SYcbTOwCCW4R+P+cIxKGSSTL3l4dmJCkTwLbJl7BZaLvCJVM2HwNgDgLp
         KaSg==
X-Gm-Message-State: AOJu0YxcQVbvIOdvbBj5mU3tBCZZ6I0P58dO2elkRwh/rvzlxZ/Reesg
	hR7WgwDelLCPQVg65n0+d6JzaJoPz3tYvjUfPTwoMrX9ye65XZVP
X-Google-Smtp-Source: AGHT+IHCvAE1GdoCqVZ2Blvk+6lIcF6dG122oZ8ChHD6bqcyd2gpEzRHTb+91c1EpoxOktev/F2QMg==
X-Received: by 2002:ac8:4888:0:b0:42e:6eac:12e8 with SMTP id i8-20020ac84888000000b0042e6eac12e8mr11012928qtq.0.1709060225672;
        Tue, 27 Feb 2024 10:57:05 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d20-20020ac851d4000000b0042e0620d2afsm3816973qtn.72.2024.02.27.10.57.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 10:57:04 -0800 (PST)
Message-ID: <564975c5-3b91-476b-82dd-e1821c25cc0d@gmail.com>
Date: Tue, 27 Feb 2024 10:56:59 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/122] 5.10.211-rc1 review
Content-Language: en-US
To: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, kuniyu@amazon.com
References: <20240227131558.694096204@linuxfoundation.org>
 <0b1b1523-3f26-4ce3-bdeb-4df3c2a8e685@linaro.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <0b1b1523-3f26-4ce3-bdeb-4df3c2a8e685@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/27/24 10:56, Daniel Díaz wrote:
> Hello!
> 
> On 27/02/24 7:26 a. m., Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.10.211 release.
>> There are 122 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.211-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> We're seeing new warnings on 32-bits architectures: Arm, i386, PowerPC, 
> RISC-V and System/390:

Seeing the same thing here.
-- 
Florian

