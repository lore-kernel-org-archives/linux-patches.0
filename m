Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C00161320
	for <patches@lists.linux.dev>; Thu,  3 Apr 2025 22:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743720020; cv=none; b=f/n8pm5WgcFALJsXMhw9097/QlsIh1OFrG3Y4FKCe5NlF+DcDjD9WZNAgzvZoi3LvNsHO9Pmo4y9gAzN4Ub/8vfR1eI/KSF6pys/KWAE1owbkM73D6AmuXSwA+rVLC90t+KbnVxX7PzloVT5NOgVc7Lj5w/5drFzig1HO/KGm60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743720020; c=relaxed/simple;
	bh=C0vdjRDJZakc74qJQQwFBMNl7Rcg1MWJAF0DjtgwOlY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eTLn6YGNI2Ph4Cqw0ynujQu0mOP69oViIIiV6kIU8i0zUchcjYo+1nLlvsXLey8IoSd5H1PVzvbpwFTELz/BuKJ6vau687Ty9aWUcK1WJe+EcBS6QbHXs6RJonBL6Vfw4J9fRtb19qUnw5h08UHcUFLsFQCXn7qrUx1SvR4QWp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=gv3/M/mv; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="gv3/M/mv"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3996af42857so1730118f8f.0
        for <patches@lists.linux.dev>; Thu, 03 Apr 2025 15:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1743720017; x=1744324817; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1OPzpbeROVt3iebNoDgfJuVub0bw6Mab3GZ6fxFNwb4=;
        b=gv3/M/mvmP6k4GD9ZZkQygfSBncj+CMQXEELtowr2W4cRQargXyqpu/TWxdc+DrPp9
         fl4lbGg4fl840flB0xNVxmr20yH0XQ0Q7poPaCq5N2RSBxrdURMJfvOUNg1J0sAjr6Q9
         Kr7YzJStdbU0sfknQyLApDLLFodXx7r74kymIlxJRNYMTVcbQR4uVvkY9DN0CCY/tuss
         QPYAKi5Af+CJ20yaoiUNhdjuxDLzFU32lfraB5IntVqZH7N4A1BiGNnZ0UwpVDl0gud2
         ivrKjSC/2lWw217+OnqNTEBNJklMDsZ3fC2ZgLq/vkGFeZHHAWfdi0PGeWGIEVDMUwQz
         0Nvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743720017; x=1744324817;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1OPzpbeROVt3iebNoDgfJuVub0bw6Mab3GZ6fxFNwb4=;
        b=depl90i8px7lD6oB+fTOJtx6V+XgGVLkT3IXQ8FM3GXLvIamlHuwpQM+p015ZzlMkT
         xunFjQ7e3BciHujjPvdY6DlRSc8++6xet/tOptyePigjdU63l6WoXPIoTsiihDzTKlwi
         fbRz150cfON+srlgJBH+LvsxYZwOIeUxQk5WwGYT6yBbr4/QcZsTDFKxAPIdelBAH2BJ
         ZpM0cNUZNje/8akCfpBRxosGiDs/HyTvN676psSONXxl75LZ9un2aHgDbzNZWNiyc2IS
         kCGj5XuPkmDvxDYgxGdCp3oAyqXTJUrOVDni4++0KxX4Hi5K+kqD/blVrTLLkHwE0vbh
         YAzw==
X-Gm-Message-State: AOJu0Yy5Bm831NKfuHGymxS12yENSgbjyRA8cfwON2wdu7ftRvxuji4p
	MIOOB4rHX/ruiwIlRsH9LAWyWjx/XstMbMXW8m8tshUmeeNjcHA=
X-Gm-Gg: ASbGnctLTI1UgVYL/9ZSNslfJVHBPb7bkoF0j3p+CJDsGvSbN+EPpafseUuL4SMqbJE
	VLvATE22lXxhUH/zZ+8zmw88HoMXfcC4Ua9hpk9frgCTyCV3NM0/Fnbq+A15OCNZhmd6MD/bqFY
	Lj5JLvoQcoU8MUZCO4qMbPYaJdbHSxlWxt5W/AhVOt00iE7NoOJaQ6ax6Sr0WhKgihmrf+lSNwE
	ENDli2uzN3iwZ8YyrNqbFxzrqg44Y2RdGi97qWrnlS8qmhcMkU9um8KLK03h0q1SlnVKgPBHvpB
	FjPw+doCsOKSW8kNDD+T3McrT/H7yjc/3vUnzbLTUF2+MlMv1A7kcmtAi+XlxpGQ0dNzuRyYN3J
	ukR7vmkyUNO6ZVuGF84PybDA=
X-Google-Smtp-Source: AGHT+IFOb6izVa62SvLGubqLsioOz8B+D5IB4XXfBBTooXiRS5/iI5bZDjKC0LfOU2ryXUUnVZHr8w==
X-Received: by 2002:a5d:5848:0:b0:39c:1efb:f7c4 with SMTP id ffacd0b85a97d-39c2e65a54fmr4290054f8f.25.1743720016962;
        Thu, 03 Apr 2025 15:40:16 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac393.dip0.t-ipconnect.de. [91.42.195.147])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec364cb9asm29384235e9.31.2025.04.03.15.40.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Apr 2025 15:40:16 -0700 (PDT)
Message-ID: <e4761e82-52ab-42a9-ba61-d95f46fd90ef@googlemail.com>
Date: Fri, 4 Apr 2025 00:40:15 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/26] 6.6.86-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250403151622.415201055@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250403151622.415201055@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 03.04.2025 um 17:20 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.86 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
