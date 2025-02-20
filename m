Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B41212B01
	for <patches@lists.linux.dev>; Thu, 20 Feb 2025 16:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740068146; cv=none; b=sdGe7nKVzmD99p7ZgdHIziV0AXG47CvSeqydtTi+fokNwwxKJMVHRCesIIHTjiu67/97d5NqB2PK/CS3RRXx15auHDoFyFEp7fugU1TOf0nsSljxvVaVQsCYri3QQdJRm8OqYpoNtv6oHAVMzqLDcaDVjXqOuEYNSQCCwYM82Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740068146; c=relaxed/simple;
	bh=TP0WVW5YkfkBapgEr2KnnnXFYymHavrXUZsKj8G43Z0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Icm4VwAy/0GTLn9TZKJIZCk3EsmHIwDhMb8CTcHBZpYuAe7pklNgqWSkb+BmKEMKXtFQBkikAV44orSItpYC2rHic4cO37YCiBzljQWl0t0yIytwmfNcd8rBlBhP5bAGbx2/msbc7P1HPomtXRsknjPLBjGpKsoYdk4pfhA50Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z87Th37K; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z87Th37K"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-855bb9fa914so30570139f.1
        for <patches@lists.linux.dev>; Thu, 20 Feb 2025 08:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1740068144; x=1740672944; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jUWqvaHVKogMOF/6atNtzte45Y3jauGYwzzDI4g/w8k=;
        b=Z87Th37KOoXKk1bMpVrHdR6x11oMLeGOphkV5wkQGkC1bvRjKruKgTRmf0jdOQ21o6
         ti2VUtr6u49Hpd3FWmlPluzWKuXgfwO+UsuY0WhcOu0uD5fzKcfsRZI7Ud2H92wNt1vG
         2q6aTPVgC3iNARr8O0tWmo//Y37tuWCuheX/o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740068144; x=1740672944;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jUWqvaHVKogMOF/6atNtzte45Y3jauGYwzzDI4g/w8k=;
        b=cIAJSkrJDaN71/+2N9wiEW0LXM05P4aL8AWO0fs2OY94ksgU7XkdNcrUkvjxnSVQlV
         ANqEWL3qwvBPDsR8+SHPTAHHFtsJEkhgztJYzdA+J7HV0nR8fUv8GlvJy4+Chi2LOrBY
         kGeV66RkuiGa4sYjeay+Es1FfhiSx+Jo7mSKk6E2m2mjofRoA+X0a9c/kaK/m+evVirO
         fuX3TdP0+za5aH/tkbbFa/6yO7Sc6vtwLhlr2jn/9uy0Y2vDMlFa3qVfj9TyrB8U46op
         Lea0zr0G4/0ZlpuPkzayI7tb0i1fUgIM9Grh78dV6c39zsAinURA2E4brNWPLO9nV/18
         /eUw==
X-Gm-Message-State: AOJu0YyqITJizf4m5oQekCXlQiNkFVphFrFQrtD8xjt+exqJ3Q4mRT/0
	kvFyem+pvNBn1H5tQDKXojz9XpI5/9XilyHefF/TGUY0uYw62ia8qtWntDrncXA=
X-Gm-Gg: ASbGnctsUhvHSMlh8uN5iWCi/00c4ROl7JNEHoSMXm2j7BC0AgXPgbPkz/7MSuSlqru
	nyvTZO4NzYHtcQS1YRUEc/8tqTqae35ZW0NguGd/pi+1dXkg34jH0wCIhcLcqdV6eOhEusR5Rnh
	63oKrd0cT5WyCmEL/gSC4T6jvQC3KSIgfKHuMRW1ifHQHW0kfjcYna3+DqJPkzxltmhvCQCwwjR
	X/5Ixsno/chAGODc47tn5TF/B23nRlOAIFXa93En5HdLC/GPEUN+tGIjAOldueoK3Ks79YFlGhH
	QI1zX6+AfsO3yZeM0dtCYZrd2A==
X-Google-Smtp-Source: AGHT+IGQfgp9kEAPuFuJ3dTKK7tSi6LyAWjjoabJeKiSVbuCLsWQ1N+U8jlefoqgkObX2pN2M+3XKQ==
X-Received: by 2002:a05:6602:608e:b0:855:ab63:1b89 with SMTP id ca18e2360f4ac-855ab631f4bmr913625339f.11.1740068143751;
        Thu, 20 Feb 2025 08:15:43 -0800 (PST)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ee9c71d225sm1983789173.122.2025.02.20.08.15.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2025 08:15:43 -0800 (PST)
Message-ID: <73312b28-c050-4cc6-8155-c5fbb5f285cf@linuxfoundation.org>
Date: Thu, 20 Feb 2025 09:15:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/578] 6.1.129-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/19/25 01:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.129 release.
> There are 578 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.129-rc1.gz
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
