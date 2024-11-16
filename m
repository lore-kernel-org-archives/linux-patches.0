Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D302F19750B
	for <patches@lists.linux.dev>; Sat, 16 Nov 2024 21:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731791429; cv=none; b=Yw/auz0n8wYoieXIWHGZDqOcG8AUIGlMYrzZp4SWG9M7GV8RzNOF1rc2Lq9cGaMUbTvIliYPQCIUcECEz1Bxg89n/SF1DfZGOCsv7BhgYrgyY0M1wyE/oxV9FZ211fVRF/g8eKVFdUTAgZCnobsLLphSE6X4hIlxcm6yD+tKWIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731791429; c=relaxed/simple;
	bh=eJb1HN3fwnkvx2NdbSKfI8Ywjm148cLmw4I9CYv54FA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kyvZVM2IA66OF7Aral3o4GRtC7eULhGwLSSwkeOfzciPxQaXMdHK4vbWsbLWDxk/RSMop01Lk/e0BMlAgRf9qft9Uo+rAV1zKKj+DCGADZnV1+r29ZTbZsSKF519mAeU3GcFvNWHauPYRQBYHpJ1CeW02b3C0HCIGCvsPZlmBD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6WZWi8t; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6WZWi8t"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3a70315d38dso2242725ab.0
        for <patches@lists.linux.dev>; Sat, 16 Nov 2024 13:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1731791427; x=1732396227; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DbBud2naf4JubCnVmY9ZpR/bTsHDUJktK177sfeaBcM=;
        b=A6WZWi8tB+DH8NtZ7DMCImGq76aiiZDDiF6BP8F8+sXdwnQ48Z8SCEPYzTL4qF4Fv4
         ceuD9iJAGzxIO+NtswoAahmVp27B94RT1CSMi65zIHRRLqOmKQSywnY9XI9xb0QeDV/M
         blC4bgRYohaXNVv4toY0z3uMJYNAUHPfgeY44=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731791427; x=1732396227;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DbBud2naf4JubCnVmY9ZpR/bTsHDUJktK177sfeaBcM=;
        b=lAfS7viTOzBPintcEmhkn8BeWk37n7/x1fNSAGN80QBknkzv2J6K5WyIrDzZON5JF+
         xw0FFHYYm/x1f+yQc4OpVH6jA8JyAoorFbRhdlQw4HaXPBv2GFixU26sf4ZVNl66/Q3g
         KttqXw4m8KXoaolVYbCjd45yC96FdwrwT8kT04clglVsl8M1F/hyVRJmsTDEnlhgJvKD
         /bU30mVZI1jyeqvc6gzCc6kGqm/i1V+xyiEQb9qSdulzpDRL0Yv03C5Ff+9LP2mWoPPd
         G78c2e2XfjTXQARV8bNDn+gGE8D0B1VoT2i5lvp2jxF1wcjKtWDfNtbBB0uXm/1yC6cD
         G83Q==
X-Gm-Message-State: AOJu0YwPJgcuZygU900ts0fjuxABbRrtiSYMJ0s/ctJwxekDBTAcsPQl
	pF806a2Bv8qscm+hC+tgevYQJcbQvwe1ftaJKtP180Qyu01h9FRhplDE4ip5+B8=
X-Google-Smtp-Source: AGHT+IGv8usQ9MgOT1JphpO19XQbtTjj7RUcbeRCZ2oDOI6yUyOM7ELGdnc3WoLZny6B6hwElr5thA==
X-Received: by 2002:a05:6e02:b21:b0:3a5:e1f5:1572 with SMTP id e9e14a558f8ab-3a7480d4ademr52241665ab.22.1731791426914;
        Sat, 16 Nov 2024 13:10:26 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a7481159desm11603515ab.49.2024.11.16.13.10.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Nov 2024 13:10:26 -0800 (PST)
Message-ID: <87ec0578-5355-4a1b-8271-8e5734aae626@linuxfoundation.org>
Date: Sat, 16 Nov 2024 14:10:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/39] 6.1.118-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241115063722.599985562@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/14/24 23:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.118 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.118-rc1.gz
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
