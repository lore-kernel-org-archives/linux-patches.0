Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE1F2DE6EE
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 22:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751581147; cv=none; b=cn/lkgA4IXm6iPQ+kP0dr4ahGWHoVQBPWAqykn5FrC4dfIbkC0ugYsXQTky9zIYS5G32VSZ8uZIcT0onNVSBLhhbZ6+JPlE/KCr4MceBumMj8WDvqkK8VKlukztDZKPDKKQ+cqDzFZn+yTeF/uFUptKv6f8FAsjlkJ1MFaGSohU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751581147; c=relaxed/simple;
	bh=bsQzXNp8DClq+bAKZa3sdGA9BUSFmOPEFWdTtJqquII=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pVRwUatGhg3aVM0h+g+Tdd+04f+m0FqHLF58r0u6w2h/BFS3LAOJ3xifn2FHYE04a7bLcEzJ/bj9w3o8vWJbKLkgDhxeN16vOrEJ0Titd3No46+3JUOwbkMrGzdNY7jNg55d9saiIUFzEUyoyIgWFZ8uP3i+c+CB5Cq3sZuLAWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NXTUmc9k; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NXTUmc9k"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3df30d542caso1969705ab.1
        for <patches@lists.linux.dev>; Thu, 03 Jul 2025 15:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1751581145; x=1752185945; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K/ohUAJwNxFFjxA7YgIpc1NqK4PGnlTrw2zPL9RW/ps=;
        b=NXTUmc9kh2SOLFo+zhZkRE0JNiaJ85MaJBNZhLWuN+HFYWePc1UwfS0qTPBfEWLE6I
         fE8gZWrF3tDoyVdXlvdlOCnqpVX6CIyoWG2Fd0nP0zni+ir0zMEgRssIT+5vERv5nUIP
         yvz4RIWx2l4w/jPdTd2QdM0k5DMdUN+oQh4kg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751581145; x=1752185945;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K/ohUAJwNxFFjxA7YgIpc1NqK4PGnlTrw2zPL9RW/ps=;
        b=iNPPG+CQB6KV3xv+d83RXxmf0uCXJDSq7RSMNAYyPgmNGUGnTT7tG3rgECoK+29C8l
         YqxtJLUPTqlbZZTu2/ROGyejyNv1dnZEvf/G53YH/rIleWJx3Q7pZKzY7zWasQlOjXE9
         qcCcFEIlQp/19tF0iCzWHr9GwO0PXZZIOm1TZDZlnMqXw04lq4aN9M9zq4og4q6GA7pP
         VamhIED5/r528nhJ/eVvrEqnd5uIj3b5q/h05kHnskkEc2p7Gl5gGNXSEWdqndP53oAo
         8Rh/J0xrrl9mlSq+KqIDoPZTliOGnWJ/SMqVEUgJqpxWwpE2ZNTRjEIXLdAJZuYZtlb8
         pjmA==
X-Gm-Message-State: AOJu0YxekIfmVqcajNnYRZVQOvZa3sulKYvpdPTCZE1zm4Ya0EcVHinw
	Es5sbV75zjLzALILpstC2zc4sLSDv5MibKMl3nyQgjuWAxi5kenj9jzo5Bb+4VuCHOE=
X-Gm-Gg: ASbGnctNV/lWpMXKOiWonxdr5WWjZ1FZGhE+T7AAOmDMCrTeCPQJKp1GOVa/ADsL4/i
	Vj5UnD+KloEQuXKniPFyFSB2xFNVu3xa92vAgVYJGUQvLrY6AThTsrc2gs0bZpclIxM+LQVO5FR
	udO24rNs1yMalnX2WkslX4TNhjzMzhEHig9i8nDlu8PW1Yvl9QJDcHkmkxTFU4wIQ21aYOD2wJT
	qU/dwlTmZ/gFCL8a/KYMGwpkWgYPZuFwMRhTfELiRTIZFI81iNz6Df3k+Bq1TcpedHo/+iYg58R
	0uKjNAYpk152+DIS/4GigqWdZLz6urMGnHsWjzQDEsLUJCVMG/q/UFNYElQ8lKW6eKnq0BxC0A=
	=
X-Google-Smtp-Source: AGHT+IFkjsoDOoPrzIbbcNU8K6UylrmjRvuaaN9lDoZeoFFVq77lPnUcgvPUJ5086KzCi0xghesVaA==
X-Received: by 2002:a05:6e02:2189:b0:3dd:cbbb:b731 with SMTP id e9e14a558f8ab-3e1354bfa00mr2010855ab.9.1751581144798;
        Thu, 03 Jul 2025 15:19:04 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-503b599a3f9sm160059173.12.2025.07.03.15.19.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 15:19:04 -0700 (PDT)
Message-ID: <70155955-936f-4280-a0ae-c1e48af3ef28@linuxfoundation.org>
Date: Thu, 3 Jul 2025 16:19:03 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/132] 6.1.143-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/25 08:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.143 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.143-rc1.gz
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
