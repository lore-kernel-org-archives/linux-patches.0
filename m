Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C76CA5E
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 01:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741741281; cv=none; b=ur8r77pYjbkKIHU9QoVFDOoQd1c+RAs1jfWLEP4s87DhPO0OUNFhrQiByd+j5uiXKme7tbhCyF7ojtHkN1rRZXwmrD+c1u+Lx42RCLASXjpuaOId4szYIILavQdc0yd0IfnGzs/EK+9yPuI1/aoJCFENeRv9MO8b3vUGmKPkJw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741741281; c=relaxed/simple;
	bh=pqTs6PSez0/L6cWDvEZMc3ndJbwA7vVw//pZkJYuDZI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K4JUtzvCLBaKt1sOfWRSX41LgwzJNC5kL3mf2hdT08TloTzPrsH5qufo6VWn2337dkkKD0s1jp4ETOrMHqJOyaQkCjnh4848LjCjgr3Dq/xnpqCMhZLVbhQqfX0SbpAX38LYQjrT7iqBcPdjwWAhtVB/69Gr406W+v1K60aVnZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EP2GvjkU; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EP2GvjkU"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3d44369e87aso1505855ab.1
        for <patches@lists.linux.dev>; Tue, 11 Mar 2025 18:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1741741278; x=1742346078; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JkhqhD/I8qtsdXa25766C/WcZA5mOA1TQObYPvGOQ1U=;
        b=EP2GvjkUyM5CLHTmry10/7scdZgBaRMk8NDzozVFWM4/dFBUhwL7mUQJwpMP3zm1hd
         notr8GTKDvaoeKqdB2jPTXxjMefubwkzEszZKImLGx5lfEeT6l/doc0j6EUOPRR6aU7m
         vTUiuMCgHI9+9fZTEDueTqWa0D+u4EliaPwec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741741278; x=1742346078;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JkhqhD/I8qtsdXa25766C/WcZA5mOA1TQObYPvGOQ1U=;
        b=KMn/tVL2iyqwRwJmE5k4GRleCajvgwdoJa1l2FeepPn1wAoBYHWqlifzIur/9pC/Tg
         p2MR83Aoei5ufAnkELZNegsUpOri5xKx+ZsihLfL+6YKa2RX//T/lK+9ERMjOJeEmfDF
         wvR22QPQtOcKg/hn14w7IbPCKt8jHZvVw85CLbYYJVinzDWR+EAPbTb6QVuy4oCNURfI
         Ij7CECUwfP5hFxgwhfUc1Rv+wrtz8IVrgqlsYScNSyf0FQsl3uZF0WZnWPH7RUY9DOJQ
         ayPLSFpspps3/n1+PAS3PsrbNUE98AAdcomtiwfvUqzosDUFVymyqkzzK9BFJ8XqAwCm
         rm8g==
X-Gm-Message-State: AOJu0YyfKvEboTSMNR8UYvyaZ/2L2yZRow9OgviqbPMf2lUJC0+3ZBO9
	Ldt/SbaAwxttybdd24N6pglszahCi/DFvcDrOpxh92J4RKn5giZzY/N7WauS45g=
X-Gm-Gg: ASbGncusYXhvH088rDqwn8cGdpGeLE1YHgmqv6VpfS6laJBgpFZZ35AFfy7WiDPoMEf
	Lp+PvpGeuFE6DP6fY2h4JN8Y/5FFOf7ed9zDSpqlJdhZqqVA7C+2t6GcjEexNtRpzJZ+OMna/qR
	D33xfH7YLHq26SP4zdzgd9tgtoxENdH/KT1J/J4oPf2/54vsVh80RASK7v+rL72wsuv94BO8nsG
	v+2EFN//MdKlXfb2s3NfICMvpPSsIigefjWK9GFQ4edo2rggtIABfSo9wTkNfMf7Rwe88Aj2Mh5
	1fvRKoXVD7F8SSsiHQEVMri1uvAaMFB7/sFSeYXotHEix7fdnqOAkw9Qm9ltGQdDiA==
X-Google-Smtp-Source: AGHT+IFwl/yS9RjSTW02QbwqxgrQUdpwIRAbglibdgwGcM7oscbPj55DnQ4Alu/un3yCdOV/hEuAjg==
X-Received: by 2002:a05:6e02:3683:b0:3d1:84ad:165e with SMTP id e9e14a558f8ab-3d4691c7983mr57874765ab.7.1741741278248;
        Tue, 11 Mar 2025 18:01:18 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f209df4c5fsm3045120173.1.2025.03.11.18.01.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 18:01:17 -0700 (PDT)
Message-ID: <bd63889b-7b7a-40f2-9236-3dc974221723@linuxfoundation.org>
Date: Tue, 11 Mar 2025 19:01:16 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/328] 5.4.291-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/11/25 08:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.291 release.
> There are 328 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 13 Mar 2025 14:56:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.291-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
