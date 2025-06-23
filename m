Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCCE1D88D7
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 19:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750707989; cv=none; b=sQYT7QextSZj1tkWxombvWWWYFmi0cw+2Ao4Aeg7hqiIbeLqJ6LQ9AeHzasI0ELVJiTjcYLkoYu3EJYZ78qEM0ig9J+h3OlPfkPH1KolAu2iLRvjjtBn4kO2ovw9t/4yRKdp8XdH6zbK8q3q8IfyG/UCdwdLzl+JiRTCQezQGgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750707989; c=relaxed/simple;
	bh=qNtX7HOtHPAZ37bzCwU2x94iYElxKJdWBv4q8izut5Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tJbmNTVE5VONr12bXOMtZdox1pQumgBtUAJJQ894NC5j3E/vTQkbSO1CyR5nCkB0wCC56b6qy/naNbmo3vSJYa7nkVcsT+PqUR0HzJgdrsam0lcXczNqsjyUbxYmPqhyHwAS54JE05N3TIm8IZ4bp0PQu0++o4yn8oYkifEr91U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=AysUALmw; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="AysUALmw"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-453426170b6so33244285e9.1
        for <patches@lists.linux.dev>; Mon, 23 Jun 2025 12:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1750707986; x=1751312786; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HEGyrQzRFDGKEhq8E+Hk5aKFGbdt1Msuid5ULByX0HE=;
        b=AysUALmwjKHa08Twb4D0vS0ZJLIm2pOWyQe0wsaf8nprDZwDYx/++v+SNp3tKRdXQv
         rqWkHhgyau2gHX68J4sLBmlBR/A0O9IjqD6mEMTUV9jA75GjVWZ//CiO6rWyscYwBCel
         T3OpYlDWDqMLgg1VrPuL8mZ8+nWG6Bh78QdIxLRGG6bfj3IZgufmkcy1lf60v2Go5yEc
         hVWhq51JVtyICOIv6D9H1z2bwNO+iJtotxdY6sAvL9rV27p+RD1s7pQmo+gF8z1Mb3np
         1jhA6Ef4FVlo0jpPDR+xTi1jKP8jTuMKzX0IeUGKsYfATdkL5f6RcJWxd90js3pzOURj
         JJTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750707986; x=1751312786;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HEGyrQzRFDGKEhq8E+Hk5aKFGbdt1Msuid5ULByX0HE=;
        b=IonahIFjtbjeQnupnQ5sNehhsN3s+tGpjwxAAVM0Ja5yfYozahaVDnt4Paad56ZVfd
         q/xK3OGVuYZe+X3ycz5pu47A+2vrU/0ucf/INJMRk/FQj1fAKSpKlhczY8NxIXQLFj76
         KoZgEcLbiYmqqzmazmpWdbeclsublJrWm52o46GUum2mdaibZHYm7gDNYyLp1hRHUdIZ
         09dwz/jM8tcJPskMvD3mqIsERls7PAKjGtrAn4BbnGePuO5rlgaM7vbfJYYsXnH/0KIe
         3iDVTrSdDnzTUHnnE0yNAcBblgsVzl0bQCsE9aMK3YgtepZ9PNzhu0+7161QgjEtaGl0
         VR8g==
X-Gm-Message-State: AOJu0YzFGi8epfiyWk8QqoBPSdCcM7jj9lgA2btXom2HCKn0MFadL7Xy
	r8a1isjSjnKqa2GkVqOfnOJZDWoA+IQSGKEZmgt7paEUYpZ9/YaBzxU=
X-Gm-Gg: ASbGncut778PcqxrgbB3k3eFhfj/IQSSHKF45Ud7425rRIi5tD3vPRaAStQmkbXRYkc
	05UQySZHjFnmADkcZId2yQvTwYfxwNW2Ya8n0dz0Hzqm8URNWoHB6+mxAuS5lgUuYwVZAu+6SKz
	mp82RcGm52HDE0J5HFBldLm4MKEY5EydNp/aSQq9Snm3suCx4xdMG7lAM/IY29pc0OW6r5bQktj
	2cdvJjcbH9uuwceVwsELtG9jXviHZFoXL8dU2M0bS6HUmoy8lj6s0aUvUpJ/yfeYDsG7qD4L+hX
	GWUFgZjJAFYwKnY2jpmov7CI9Wtp6Wt4rc/P6oH0DLlsQrzoY1Pf3EGMmUp/LDO1gUMqcg1+rjr
	fRcXHyh4z29lYU+I/kqhNiPnIaiT1jMW5cMYq5Yxx
X-Google-Smtp-Source: AGHT+IEC3oCTdWFz7Fo7GvpLWVJrW+JtooF8zjBoWDJe0pgPBUTFLBci6fXO3NhGZrBGR3uLXCD0TQ==
X-Received: by 2002:a05:600c:4706:b0:450:d79d:3b16 with SMTP id 5b1f17b1804b1-4537b79c3d0mr8441305e9.14.1750707986182;
        Mon, 23 Jun 2025 12:46:26 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac778.dip0.t-ipconnect.de. [91.42.199.120])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4535e97b501sm151363115e9.2.2025.06.23.12.46.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 12:46:25 -0700 (PDT)
Message-ID: <9c093c7b-5b38-4865-ae01-8c97943db05f@googlemail.com>
Date: Mon, 23 Jun 2025 21:46:24 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/414] 6.12.35-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250623130642.015559452@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 23.06.2025 um 15:02 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.35 release.
> There are 414 patches in this series, all will be posted as a response
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
