Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19001E3787
	for <patches@lists.linux.dev>; Fri, 13 Dec 2024 17:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734110846; cv=none; b=tFHxbsZykYg2TA7gedBfSqTTM8E6ix+KCGRKo6xRBeGWrFSMgpIc5RYWjlCjeiteEK8GVwiHRWpDP4K7pzlwMj6u3Hklqz7dyFPE7A2dUFSteKuPqEHTD38fxpD/+JmcumV3JPDmwgifW0SN0Q//wvXiHZnPtjJs9ThmVr08lB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734110846; c=relaxed/simple;
	bh=MwpY+eaTHW6ZPilONEG0CjNGfxYk7BcIdF5jRQfjrkw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jxrLw/gs92UYTH2/+VwRk3aEnpgChGFHfGymeBt6CLjH4QTLaNVqaem9yUB6Xeia61BfeF0qiCRu4Bd2lImTT3m+erbImW6wnzQ3FClbi8WP1jzda862TSntcPGDDz5UBknC8QAydYaHGv4RSX+JlWsD3wYfIhIsDkN67SamC8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1LZ94gs; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1LZ94gs"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3a7750318a2so14655545ab.2
        for <patches@lists.linux.dev>; Fri, 13 Dec 2024 09:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1734110843; x=1734715643; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UZ873rr8z0y8ShQd+LncMxaWKOoC4jcirXRjLJy1nJI=;
        b=c1LZ94gsLUMe6IYL+isZfQe7r8ymlxyyY7tSxdXd3uYwTQgEiB+55+HPbJtsjTPfmm
         aFShpV4pybCxZcdovBWMNPaYtcZg1WwvYL5lmDT1gZk+pAV8OALhLZ/t/YvMf3CE521F
         WumEhk8g0SIRlXsebyVILmqDYbC03SceYdky8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734110843; x=1734715643;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UZ873rr8z0y8ShQd+LncMxaWKOoC4jcirXRjLJy1nJI=;
        b=PK85frS7nVyhDU7yL3VyEkVd7wk/x/k965BOgCLOEjACGfZghag+2bTB7zHIEm64qK
         iF5c4icxHKGwvqKQXCaDAhZMVkQgO5EFRmQFxywkryn55vz3zCxR2+LM/3wf+FR80/ko
         85R7LvYDNEvu/YJtd+RMou4ypsrXUmfpXfVuiJGxCADGMPwMsjxKn8Ca9pa3nyqo+fuA
         RWLMTZ8Mc3QSs+YI+nv60CkCYumRKd1txBwm+DSQLsipGSosg11juGwI/5WJw1LM3Cjv
         hik4HS1odgGLdWhb6DRvLpy1aWmkyM9n1v40LE5R6jqXc8F5djTq8glHsMt08Aw4Ar9/
         mVLQ==
X-Gm-Message-State: AOJu0YztIz02tbJwG3lFZmUziVyFwrPLgb9f0iyY5Jijt/uMNihRL3tB
	qvWS3Z2E+gHdeOMPXntRU0SRLK7no/2L0P3kDMjhu0/HllFrE0jg9PNgVrtBJQ4=
X-Gm-Gg: ASbGnct9d4WlDp9Cc2qV5cFEKyanoQML50z9j8wci3vJ2oDbR/O7xnBW3LcoxR328yw
	f5CoQZzca7oL81FBVv4LxJ1sA5PiBflh/IQWUzfM3ZFQyAViM55rBWvkyvhidsPCnigzMe2fFFU
	o/za/hkGBLo87mkd7H8TQN+RCIia1bsWUodyc7vh9atIRP4bf5/qFO9B7Cje6jsklmTXzvDWKGR
	NWKK/kcir+5E8FiFfwgULGyOrZHoxvNxJa95kU2I6m3nk70sAiUmJylVSwDpJbbEAch
X-Google-Smtp-Source: AGHT+IEMEr3uAWKMVxI9slphjbVdYchSxXggpcr5ca9kl39X9OR4taB2Resxa0Fh4jOpJvOjJQ1o1w==
X-Received: by 2002:a05:6e02:1ca8:b0:3a7:4674:d637 with SMTP id e9e14a558f8ab-3afeda2ebadmr41301295ab.3.1734110842854;
        Fri, 13 Dec 2024 09:27:22 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3b24d8dc980sm84075ab.67.2024.12.13.09.27.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2024 09:27:22 -0800 (PST)
Message-ID: <e31df167-1a15-4015-a6bb-85ce29ada6fd@linuxfoundation.org>
Date: Fri, 13 Dec 2024 10:27:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/316] 5.4.287-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241213145847.112340475@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241213145847.112340475@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 08:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.287 release.
> There are 316 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Dec 2024 14:57:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.287-rc2.gz
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
