Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E45171D2
	for <patches@lists.linux.dev>; Tue, 20 May 2025 21:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747775685; cv=none; b=VjjSc7fdjlQteI4AemDFrInM3fe2fgKNhH43U08ygs5g9VE3ioEbJvVGrpoMvf96DoxOca2s+II9Bh5apR1MVo41pWd/XClhtIms56sBEZKasFeStJ7L9I1N6EokCnImOTMf+stp1rqwvegegUUuSaEDKAREcRWONa4GzQQtuRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747775685; c=relaxed/simple;
	bh=zojOLtY76gZFr763PmUNcvbsKlkE+bDQBNyoxBicd40=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e2RUPkMFTPfi5rptXUHEjwL80MM8yB+8vcxVdB+2rdlt6XB3KO+pbMvr5vKhM2Lq3VYjkDOo4CJpN3MWTGGv9Op1ww3q1BaVOAZtjmsePLzy41cOLYaRXUg3noWu/ijfQYohUtSRf1XUNrGfHxUaZhfuivI3Jmx2jU88BynJE7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMv7cFA3; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMv7cFA3"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-85b41281b50so203314739f.3
        for <patches@lists.linux.dev>; Tue, 20 May 2025 14:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1747775683; x=1748380483; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fIN71OkdIhhPkkUBL5dzqoGGUrchQUGD2wwVLvrOvHE=;
        b=JMv7cFA3SwZ13fCW6SAcAxHjwGPD5tF8oiOANfvMtnqG6u/pCISzblvkVeBXtg42si
         /DU5XOic+eJyapqOZcLJC5jHt4OJDJ9KFO6Pxr2JQFjzggS9304pXpOiGFPmrbgEWe59
         Ia7X+KF3nmAm+OpUd7/bXM9KWtR5qtjSDH7l0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747775683; x=1748380483;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fIN71OkdIhhPkkUBL5dzqoGGUrchQUGD2wwVLvrOvHE=;
        b=FkGGo/9vGcEAnKR8VOo0PK9r+W4eVeR3o6JJR/+SZKgKu1UiZAw5i284K/y+EW3vf+
         6aHlSD3+C94vRt2fmgqE3ticdtm6P1juMqf/juMtdEouUBLwy9TVjllxftgYfs3MEnjQ
         CqLTwgear1m0WMWudy/IP3SAkTesaLQxyoZbGxNxIiNjt17FYq9ANGh4b9zO9L8XCp03
         rkgz80sreTA6G+hVKPmgQXFTW3uu2xdDDq+cPKkafvUJHdWrLHXj3SElF6NnvqwAUmRG
         GSM4nsUJ5O+7gaywka6kRRcFsOVvMJ0D0ihbfXso4V6fo0DX2gm6KIC9BIi/Fh4sr5s+
         bRxw==
X-Gm-Message-State: AOJu0YwtvNHQ76kmepeQyLlqttYLBD2xetLmMfMyjdLqCAQBO2/knwm+
	bK47yaDHGRKgQ74oSZstQuPxhikVk9OmJx9MoRkLadf9xEVl6IRG68kzqwloqpguStM=
X-Gm-Gg: ASbGncs/J8Gm1TRw9uPJGXwuv4pbe5wcV8n2KWQZTEIPvphMZMGXEnhPCRPj9+gXs24
	WS7a1DOJoJBJSRqGqKvypQRkwZDniLNjeqKSGDDB7KKstLN/KtJc7EiefCOwh2oWP6wCJL/KN2N
	XCY++yteAd/aeLbmbWRvea71keec3IjOyGrtQQ9WvQmLH3J3DpKhZM/i/Lsw7VanaCOyOOKGQzK
	ZisF4b1RuGbH5/WpRcjYnJfymekUBveo0P3zz+4cVn1yAHVrctLuGoPkJpHr4Ux8a/UbFkzQPfS
	ThPOw+Z1XtvK+80m1PIYCSmAEV4iSe8q4On2IAmO71ki6im9zIo+UCWfhwPfQg==
X-Google-Smtp-Source: AGHT+IF5gRFWN0+dvmw2Qvtr6a2oalq16YVeLrmVGDkTHf9V1z0FLFjowunDN2PSJeB2qQecf7b4bw==
X-Received: by 2002:a05:6602:3991:b0:855:5e3a:e56b with SMTP id ca18e2360f4ac-86a23256b96mr2323304839f.12.1747775682783;
        Tue, 20 May 2025 14:14:42 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc4ea966sm2393379173.138.2025.05.20.14.14.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 14:14:42 -0700 (PDT)
Message-ID: <f9779eb7-9a73-4f1d-90be-54bcaac26bfc@linuxfoundation.org>
Date: Tue, 20 May 2025 15:14:41 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/143] 6.12.30-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/20/25 07:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.30 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.30-rc1.gz
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
