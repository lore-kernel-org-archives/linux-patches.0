Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D1F2DBF76
	for <patches@lists.linux.dev>; Fri, 31 Oct 2025 22:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761950250; cv=none; b=VBG3ay4dQAury9qvBSSVS8q+EfnuRUQzVP07xfMbpEI4WdGUUIGOxDbM3ndvCbeZvZyhywhJCPFwaejhg1z5KikEjsmL6UKAgQr8aDql2+pk5ohzxE8lQLrN0S3wu4C3jsdIx8msbui5vhAhM8rXDzza7TetY3CQ7VtUSYuWzrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761950250; c=relaxed/simple;
	bh=lyoMRXm6f9/VrNX6C+nyCiEeZEgKdKGMwqial2YdLtI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lOjvl9nU4l5U2diiFuCQvgpx40/qey+NcZCekfHnpCiQS1OkB55w5Hrys745nHLpICBvPubMYIXWtHu3LiaFY3F9pNSWUV+IiYnxuvMJkTNVvrffnCfdNo5er5FnfXky1pZz6qeEy3tWmFx+apDTSAq3GQzRP4ekbm4KuGHSs+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aKumfs9I; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aKumfs9I"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-430ccd45f19so26493395ab.1
        for <patches@lists.linux.dev>; Fri, 31 Oct 2025 15:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1761950248; x=1762555048; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sYZpsZRI4LYROmtgQIPxauwwjRjZshuAEYwDGnWdS9Q=;
        b=aKumfs9I5cNb55EmDnJdZ3/nKuoCQg1AA2QA5AeXWDXLtU3wFkDgSde5kBxcvl2MYz
         jGk/KWUyfnvbtkw8hwmWtVF/457xRGJFm13QQ4KS/gAk+G+89z17L9Dzk3SOsdWKb/H3
         t+Sy+fCFCEpn895cfGCeUA9Fddd5GHvTamTTM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761950248; x=1762555048;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sYZpsZRI4LYROmtgQIPxauwwjRjZshuAEYwDGnWdS9Q=;
        b=wP+lKnjMfq32k9iOLaz+5Onf1vyScYqhS484CkxM8duLK+sbdKoQWm7VNyi8Hp8uD1
         cPeaYbj4TXncQX1ZdHJjLSq4Npb8XqVuhji+7xxS5HstrV3+OyZTI4V95mAxwIPoNeAg
         y9Lp1mbYqb4JG1HIXUzjo6TkgwFrx9VBHljru1PdrDafnnZuzq6A+jHL53iEvS/mDmPq
         THVENu8HkD7OeRlp5FEE/3Zoc6bEwiBjNTR5D5/aqep/4DE6MVLqhZ619av1RJsCFbxV
         LjK+1nPcsvaFZq4OZZJ4KEXcJcsjXURxHcweZftX3OOK/6uIR/05Hjc3FjNKEyNDWJNg
         eQHg==
X-Gm-Message-State: AOJu0YzwhnGT0nHKSgZiFBAHH0uwSp264fLYw3D5ImyGppCN4wBzgLT8
	+8w3Msa4JNmzIVypgGrR16QwHCW0ClQ8VLUNx6jCOx9U4ENrvsftRRVnt4lZjHfD/iYuUSHMxHv
	5fSaF
X-Gm-Gg: ASbGnctRNgjthf8dBqpjl3HRDwzTKdvh3RZfbxXKKYHkx9Q66PtnUklsbdepypx4ak/
	2TkStSAYI8LGoWGk/oPHC2bHerb2048LMtGLE0c+vORLlNAADGfdRd6Xsyi6UdWwAK5xvsBt2DR
	tLE9ZYMxpDsAFkHHQ1Up9YjAHSmz+nlszYp/OTAKq6N+EtMuaZ/nhlZddb0pPptyQhyBXYhWA+E
	zk4f7wlLP9dRpvlNM0yuDKSPHzpqLsH2S4VbGNN4U42/d5h9rX1gDbYgpWyVEzrDU9beIItu2ln
	qNOHwSNQ5SIWyK7zX/QnDkV64oDBeSQNiCBBlXFcSwoK+y6HtOuvsId2AGDTPs+B0OU71QtnG8/
	edRHR3UVQJ1wKbbF81vm2UDqNsefNSMdotPWzme3JSqp24WsKp1FS8DkWvBhSLut6qzlC7wCYg+
	KpFk1BeGcAsKh3
X-Google-Smtp-Source: AGHT+IHQbq8xoN+qH3Deos3yPtiJSPDT57c1SPO4PDOvJb5EBUgTWDF+VAiwrMirbjgmdTNntAVEoQ==
X-Received: by 2002:a05:6e02:3397:b0:430:9f96:23c8 with SMTP id e9e14a558f8ab-4330d14876fmr85117115ab.14.1761950248190;
        Fri, 31 Oct 2025 15:37:28 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b6a34b8c3asm1161665173.17.2025.10.31.15.37.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Oct 2025 15:37:27 -0700 (PDT)
Message-ID: <993bf106-a8e7-4f71-b340-7db170ad10e2@linuxfoundation.org>
Date: Fri, 31 Oct 2025 16:37:25 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/32] 6.6.116-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20251031140042.387255981@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/25 08:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.116 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.116-rc1.gz
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
