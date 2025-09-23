Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE5217F4F6
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 13:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758635253; cv=none; b=DJEXx6lapLXURfvuXh6P/70ly0okhnm2jzhOUr9XWN06BAF2C8C6vJJ8Xo2dFvM6AD7Gsh35DMFlJWIuJV3WSmA5Iwe7mtML+Wd+peYKiUOehGqShHa0NbUYv7LyMDauh/RxBsfBFdaf/BL0BCaS4mFziiTpBde+JdjpbtcdSk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758635253; c=relaxed/simple;
	bh=fEMX99a4LLdufdD4JU/OLopt+VDI9F3h9V5l+JeNSDQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IDOMFLWFwwKoPSUJij19f8NiylzgyGLttWss9ibmnYVpE/Zx2wiwFmZ/JQTPA6HmC1kSCRximctzw4v/FjH2G0SnvcEkjhjoScazFHeTar23EZLBYXx2ueZY/zqhUxhk00/eudAbyFp5fUM+JYgp9ngIKVqnELvsdwp24sApDvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=IlpOG2F5; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="IlpOG2F5"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3ef166e625aso3061088f8f.2
        for <patches@lists.linux.dev>; Tue, 23 Sep 2025 06:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1758635248; x=1759240048; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=28l1fEqACwCBZqKhFY3KyPqEpdAA3HLg8xJ4dHMoe/Q=;
        b=IlpOG2F5gpRnrD15cjfmeK96vUOpFf1Lb4SR3MD85PjuA+MbLFYxJO0porfz1xNkpf
         inFRhNsNLSWlUsgo/dFkUHPWzlXXJ7ZhdzOB2Lz/NabmEdrS8dkltfFXqYQAv9PEJurH
         vdkFOzDCVORz7BH3ItOKlYTMxPnf1xmzUrfNzqB7epIPcJB7wdGd7sG4yXcX2OPDcT0x
         vvI+h8pIv6WIy6VkcgRMlesYsCTj8eyLW4QNxue9i/1vICHfAXUUz3UvFKjKbFFt/1TU
         bG2E/L3AS138Hnleozw09TtINXaIrtIT82MYGUhyAlxjcsnDeZRkl1GopWbnI+rzLilS
         8+Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758635248; x=1759240048;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=28l1fEqACwCBZqKhFY3KyPqEpdAA3HLg8xJ4dHMoe/Q=;
        b=TYMoVh48lfcSpF91rHzNtyydv6gcy8R+f4HrMwJ9a51F2x2GZpmWOoZP7AxIqAJ/a2
         2NBGrnbyU7loDRrE7MW/GQni+Ub/HOaDNBYB1sYEYuWZYDcQDmz0jVFqR2F7wJuRszso
         TBqdUGa/NDd+9CqBTBNOCC9tS8GC9Q5m1qMWlKjgjqcTKWoU5ZpyZAxT7z9TnF0Wzkdq
         BpsYOJoqIivLLJw1q+tXUvLuIJ+JBkg+5Qj0WIu1E4LkuFE+Lxv2iAheIffmnCPQb4YA
         43AthiP+ygqxx9bGuY/aizHSxN/55s0dUNlUdPvrs0QBVCJYquIEQwrZ9jvjP83GDLQC
         X9bg==
X-Gm-Message-State: AOJu0YyOyD5p/6B72gGggwPAPwfvIU5IrMAACmdanISThCZBWye1OIxm
	V/yD+D3DKop6SAT4dSWJ+ZBaRjHz3lyVpJGlWRp5MGoFEvF/wOppzSo=
X-Gm-Gg: ASbGncs15rCZOmxNwOvc9dQt5t+4kWlZyOfeIbbGb2TEMYj6NztJyN1QVTd7ZIfFBVk
	4dwWU3fsjjZ4I5N1HR5OdieFYUzV12PNZxVXXzUGUm/5S5anEb5WXCzJlsekelmryJp+uwF+nKe
	vomKQ5MqBs4Hxb/SfjpTrayOkhdr6OWEwzZLhnEfohgoMR6FnbRdzmgFO5OYcecsuovkxqkEXe5
	TizPGg23grDt65fJ4D/dcibcs1kvLsjn3FM+OvBEVghPF5g+sdWo6QLz+mBsQhje7iXMN48S3Du
	55n1Hv0W9k6E8S0HA8LEKFgwGlDfKuh30p6/pon7V3mnx8jlXd72MT8C5BnTUn0GoJCZJZ0jl6S
	tXr23oZDQ0OGu72wxxhXGB9vTaOg8FKd71g6V8cYb/Byih6tTJ+lAkjbd7rwjHaISbh3fI45+FC
	vH
X-Google-Smtp-Source: AGHT+IEz0/K9oDXr/zLCHQ4dVkUmW53CD8fdbE0aFuXBqjyL0D4mn9goYVNMKiHIDqyrqbQhLjRZcg==
X-Received: by 2002:a05:600c:4692:b0:45d:d609:1199 with SMTP id 5b1f17b1804b1-46e1dac9639mr27593965e9.30.1758635248308;
        Tue, 23 Sep 2025 06:47:28 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac1a7.dip0.t-ipconnect.de. [91.42.193.167])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee073f3d73sm23740097f8f.8.2025.09.23.06.47.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 06:47:27 -0700 (PDT)
Message-ID: <4d2d7e50-9853-4c8b-8a62-52c37004f4e4@googlemail.com>
Date: Tue, 23 Sep 2025 15:47:27 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/105] 6.12.49-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250922192408.913556629@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 22.09.2025 um 21:28 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.49 release.
> There are 105 patches in this series, all will be posted as a response
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
