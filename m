Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735C527281D
	for <patches@lists.linux.dev>; Mon, 18 Aug 2025 23:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755558814; cv=none; b=S3KV9ioYTPMPZWHk/ULu0isx0XgsIKfAhDWKml1koNmRWmrx5Ld3dSgMp5Xmp59FlP2mt8Nx45qGslDfZJDXSxW3mON0pUJNewVqEVQu6+QOZku6KmLDMeVegcFWbBTlb0OU15TtNGY0XrmVcQqKsbxQ0aRE5orm/LODRHoH9P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755558814; c=relaxed/simple;
	bh=c8HzGd/TDaCgrjaWIMeuTNCXcuACmbYECvWUUre4PIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UY+TYXUpYgbX1Z2HJovgqmBbFFw4vE+ijdf/587XbTfZ28KJP85Mep5Kthh0belhcSM65cPpfEoUYQx1yaOs0lgScm3ueojn1Wq0DnB3AV8snnx0h16TNvm8pvjRtxVhawW7SAsOiDVC4DRW0YTgeqx8LYKoE27O/j/BHosd2F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=fHR64anw; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="fHR64anw"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45a1b0becf5so25136185e9.2
        for <patches@lists.linux.dev>; Mon, 18 Aug 2025 16:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1755558811; x=1756163611; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mnq9RhUyvZf92U8sAKjR3y1PDGecrVMkyD6LjbdWrCk=;
        b=fHR64anwCgsnJ3bYac6UHzgJw1PnK2p+jhSfqoSwm++7SoTcKdR3M0VNcFNgsCeREN
         Qn42ZPEqqmJ1upVEucsEighYLPw3IywHJmxBHQgi7F91Vw9KD4atc0LZ76dbQPNgk4uu
         PfYYjxe56kp7u8V7dUcyeYAO2oFaGVpvokvmOJtRAfgPTUsa8UlVYxoiXQqhV61f4WlW
         XMiA/YVy74X4h8SuyOkPrd3W5UwdChkjg9twgfvZdHuPHxe7LjVdDaWa8G6PrCuCud+x
         pQx10C8dLq6tuQ8q6CfySqq+6RyjqraD++VLfih6SL2JjKWZ6dwY3sawjLW4fyX/gLdZ
         PA1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755558811; x=1756163611;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mnq9RhUyvZf92U8sAKjR3y1PDGecrVMkyD6LjbdWrCk=;
        b=OExo9uk3jvfIxSGijBpqnRLpeoS9eXnj76u3pxS4kNumlkDy1mh5k2Sbt2qvmPBMKT
         6MeQVH3y7OaruP7cQ1A/Js58EaU//6amAF3tfpyw1TQpZ9a2MvpnZD59JX3wJOLX0Z1U
         avKQu40IWLSHTInzFOJf0Bh+PsuZWsc2U0+tgTb68jmH9Mtp/eD/SetIIZcWjQpxTa41
         /i1OzkWjDM1MF/oWdZ1+pBkDrmLDoyWKBEy7U8lm4JkM/qTwdmhzJcCeJvlAb43Qy7Y0
         eOQQhHpo9X2D+GWRIEW0QOMybzEDu83+KhPeesL9Luf0UAtJgkbFofHd8O4KtMHThFiZ
         TCMg==
X-Gm-Message-State: AOJu0Yyy1LsPJPtVmXqEUcsVavVUfCf7HbmtdiFkDMRqHrqtEkXaKdK/
	isV5Ms8mDH6ItrccDAMZH/1YQ1cJyHaM/LJmx5BCp8cB5omW3qvAZDs=
X-Gm-Gg: ASbGnctbpSdqpIyR01F98PchJlQlhCvZ05J6J/zL/Twu9obzFjt7VnLsCafSBso/6fL
	A4yFl254Ckag072puO9IuAxhczHUEw7D2KwTq5rRDmErO5n7EV8rnQqnhO7I8AxPIRhlAynYTh7
	0L/V6UksGLsmMsALW9Fj635ybiMwRPP354gDt7Zb5IKG0xQb0gTjEdMNsi7ITILqHTlV3euuGXm
	9+GApQj1nNJ+AmAobaVeHag9Z5knwT4286vgLryjJMAPLTAfIkGsMnsyRUuRqZGG6SUal11JsbX
	gNovWz/7+dt3BdnV+dSzQ9/+wVn4SpmQbtskPbsFuR2SeyTf4W4QWXc0m3CMAzgs2OJ9/Ucl+p/
	J0r+JDKAAD0u8hzreT9nS4EurIAleeCAdSNdpV+l+SdoY3CfNE1H/9PMz7yR9guuAWYMaABReBp
	4=
X-Google-Smtp-Source: AGHT+IFqtwFtg9Rad+LKYSBINL0XN0Q32hE+79dF5jl3tp+I1u2wZ1gYBLESupv7TuKefkG18KJrPg==
X-Received: by 2002:a05:600c:4587:b0:459:d645:bff7 with SMTP id 5b1f17b1804b1-45b43dc654cmr2368665e9.12.1755558810606;
        Mon, 18 Aug 2025 16:13:30 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4eef.dip0.t-ipconnect.de. [91.43.78.239])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c0771c1708sm1169163f8f.38.2025.08.18.16.13.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 16:13:30 -0700 (PDT)
Message-ID: <cf35c5d9-643a-4dd5-bd1d-45cccb64de61@googlemail.com>
Date: Tue, 19 Aug 2025 01:13:29 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/444] 6.12.43-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250818124448.879659024@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 18.08.2025 um 14:40 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.43 release.
> There are 444 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

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
