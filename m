Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65861282FA
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 14:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744986651; cv=none; b=aEDaygi6DqTIGAYNMPrXdWT5bZ1n/5Wk6FLu9IoTq6I5RlqQxYZU0+D2oG7nzEb89veMWdwjwjVDoOC6o/gmrscBM5byHaiUUXMl5R2LxFVmumssu+GqoJBZoKzGED0dRJz7jXbcV5vGx6z/m4FsYEG+64gKwCOmWGR3NhXfzsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744986651; c=relaxed/simple;
	bh=oVL2kU5gjstzBGfXvp9kTBe+PNQYdWCgXca3RUgd+N0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZZBxSnm00u/zawgbhP+IGRQ/+X89r3wcc6cvXm7gegqNfRX19rrJF+0GkL/hGW0pnvDVQCtm81DAwnATdJhtHshHBa/kniL9OIzjWGTDhRBF9W/F0wBjG0JGR+zK+SlFVTRQ7Z5ZOr261Ou1n94KEwTj6Os1lYQLHg7CbMIUpIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FF5vD540; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FF5vD540"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-85b43b60b6bso54586339f.0
        for <patches@lists.linux.dev>; Fri, 18 Apr 2025 07:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1744986648; x=1745591448; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G5zbYlhCEZEOrkhXJJRlzWrW7M63mHM4S+7WR1Jrdgk=;
        b=FF5vD540KuwqovSjhErq1iw+il+Jz9ELJcjqGUqZ0J3/NNZfPtpFkiwyrqCDLNox2d
         AJvOkcxw3Y67em9R+GWGOLXdeOcbl9xDiHjdQYcBoQ6M/Nk5N8Ix/afHRh4DYMfmcUV9
         iDdpWkqniIbqm5FgLXxQ5g+i7Gradayiwz0so=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744986648; x=1745591448;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G5zbYlhCEZEOrkhXJJRlzWrW7M63mHM4S+7WR1Jrdgk=;
        b=D8NitZRJ48WaEWoueb2+VfnMxARNQzD3dQmEC6uMip6v0nhEtL2hr/cJAswLj+z4a2
         ECWdf3fst0BUCASwBI0O/luRteM10tqO+tfkc6vktq6qtkzPvRuDEowmuq490s88tVcn
         bRoHZ44Ied0HbC+ZqyKLTKs/DwD6NCAghC31zthyRSjkW4lqt5K4Hdhlq6mhBg8UxHp8
         r1c8/UmrWMBLYZGxEee8xkl07rhllpR921jCltk8zoTYOKHvDosi+oTKOauqCpdVrrTH
         LheOhySmfjJvJx8F3wpXrX9kEJ4svhp6QsOCFT9XYEkPN/GllgV3qtVhfeuYYP8unIcZ
         uNzg==
X-Gm-Message-State: AOJu0YyK2H4fM/4Wko9tqBCjKe/0uySi/G0uHbHLZrhtbpt1c5HNXB1E
	Hojupm8fC9JL2R0SKnh/Cy4KWbmY78SlD3zLBUVrtvBqI7c98ffZF1440pvBHC4=
X-Gm-Gg: ASbGnctg3R4/ypQg0OYg59KFL0wSBNd7q+Xxg42kI3UlGMfx5vMviSmOEIcb5KcUoVD
	m1xz48GRqJey4RPO8BVayRnbb5b8VKaMLxwinE3aZkohvpsohESrGyC6ZR1EqizthBKtXSOD3nJ
	6nGOOX/MMx2zC9x8QInqcYJ7W7E6R8KjZ0C1TyylPbm1jvCBt78b4TlqPhC2pKPLspGyoJW+VJb
	kPuZqM4kXqxwrEvRaV3pJsYZiH289QdT9HJx0CzQawGDRxXPu8OwkFGySZp04dtMDWD0qGRSX4E
	FkzbrcIq0lWHEoOPreQke5KDFsmCP0DRdbL4aai8qgoanW999JJRAGP95xapIA==
X-Google-Smtp-Source: AGHT+IHg6AQYt64hVTa2MyJj6PvmJcGkPqJ51JrQFjKLFrY6PtlcvN7ICxYBR+rpFCkNIDuYhjWG3A==
X-Received: by 2002:a5e:d718:0:b0:85e:22b3:812b with SMTP id ca18e2360f4ac-861d8a19580mr353447539f.8.1744986648413;
        Fri, 18 Apr 2025 07:30:48 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a37cbb44sm468122173.26.2025.04.18.07.30.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Apr 2025 07:30:48 -0700 (PDT)
Message-ID: <5c0ae486-f29e-4a7d-bca1-434c82d06b23@linuxfoundation.org>
Date: Fri, 18 Apr 2025 08:30:47 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/393] 6.12.24-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/17/25 11:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.24 release.
> There are 393 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Apr 2025 17:49:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.24-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
