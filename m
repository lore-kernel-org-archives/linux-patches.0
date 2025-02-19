Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129DD1C3C00
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 14:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739974472; cv=none; b=qpRdTTAuHz1Fsc/ZKGsCVs8xer1Zw5XPyIHt5z5vRWVhcTwi9zNyaYTbnimlSk1yDogzyFUZYWtaDZ6ln92RbhE8/J20aq8l59Q4jvxyA1rSRFnNDQkjqNnSRV0fZOyo0K3PFiMSteD6EjiaBZU2apWulcmJGfmosAOxkxMKF+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739974472; c=relaxed/simple;
	bh=K2GkpiSmwUXetakePEBxwJPUY3CyQYChySFJcaeeUw0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uwfai0bUMK+I+T6afnMcKNCx5B6nl506JXW2RZLAe7vt0/b7NWEvlhwGV0FTbWnpw1SO5BpKq2i1QFJO6Nz5lam1PDk4SPZijHdUZk92w2nx/lezivAUQegxzebUnXibP/hYxyhOnCU3SNSqIm5OUCEHsCmoFXMgHYBubnW/XHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=H1066oy9; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="H1066oy9"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-38f22fe8762so3422350f8f.2
        for <patches@lists.linux.dev>; Wed, 19 Feb 2025 06:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1739974469; x=1740579269; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wf2RXYvA/APdQSyRpEenuian9qv6Fytwij/nbZajby0=;
        b=H1066oy9nd6BMYbs7O3ZS7Q+IPBTbMHlKhfSorfl5/Y5Y2+GTzOdh3GD/Ep7WGL9tT
         E16rLCJmBe5dc8REIiHcx4+qBYeVoOCKvWwTmWFLHfNIkOO6CFCue2jr42Odv36yR5Mv
         Qi5rQ7ZuolmoaW9IonpIGaYEr7XOln4uj8wAYGCTxa1PtHr+bm7mpkFwnBBtANJpP3TM
         wkB71dk1HqNQpLlo3OMb77sC7eJyTGwy6n4ny5MtmWD8nY8ZLe0dWuNF2GU1nHGVhYx+
         hxtOejvsq4PUFIcehWSoCVHPJLd+6ewuT0Si4z+PgqdWBIf8+lVoP15ZhKPYP0ltjnjI
         EiEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739974469; x=1740579269;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wf2RXYvA/APdQSyRpEenuian9qv6Fytwij/nbZajby0=;
        b=leUqwm7c+bKXnqD6ncATTznyQgjBmEVwUkZTwFRjTmOxGGFNTk+NCLY4TIKj3egr4A
         UjqviBr4QpieNqz1A8Uh0S1Mm++aDFoGXNxBUuN2XXZsq1Sth12X+Il3kAu4b0GP02Z7
         I60P8v1tlJ9Rcj5t5HAZ8PRPmbQPmbVnf998W3rF0EV2YgYTUSymFGNmsx8d+Ssm/+pd
         VLxvhq9RMI41mzMWQy8rvz9j4dxrzfS9DbqAK/AFckGhyGZodmdjX1YCAkG/JeO6rjWg
         kEJYNvCQzcDvPB5zW/mqGmRr7aVZmnOxPE3f4t5VjGVTIoafSJEHqRchEM4+ApK0zl3v
         /OIQ==
X-Gm-Message-State: AOJu0Yzw+JeBpDjgL2llt3uKivCG3W782+rDfjcCuSEg7o8UCP/tnFEK
	RnpZxkEyla+PH+WitM8CQuK4aMe1uh1zeUuy273K9k6BGqHdJkQ=
X-Gm-Gg: ASbGncvRIWpwXlFfiKBqLkCjS4DL4dQWlPBmXF6z0/0iBqDA8xoLF1HdL8PwGclE617
	KtpMGkIhtV96rT4+bncX5FdA7uXR0+tWte8OY91zlhPTR/z/mwVdexcCMum7yH7I/IWABfiSzzT
	cNcBTCVejIAWkhXMxpq6SUTWHQrOtlH7d6zmpeAaqOXGrL6WQ0cTnbW9PHwh6lHr1riKADRnS7O
	NpRWlEtWRdT1y0VW9XXxE3ssgWEBkXXRXAmNZ6cRDsFgG9jr+gdPlv850/WUy3XWBE9V+B0LBQa
	CNfr//ROGfVBQzG6VHt6o0ABSAYsD5MYIhaInIYwPHBuMg0ELvH0fRVZVZZStqucVGPX
X-Google-Smtp-Source: AGHT+IGJCZjLQcnPr2FENPcGiOBYdO/PPeKRrRs/BHzgL5OQKx8IJ/h/Nhze42GLkLBaoXpzjjssEw==
X-Received: by 2002:a5d:6daa:0:b0:38f:394f:d83 with SMTP id ffacd0b85a97d-38f394f9d8fmr16805665f8f.48.1739974469096;
        Wed, 19 Feb 2025 06:14:29 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4e7c.dip0.t-ipconnect.de. [91.43.78.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f25915719sm18171435f8f.60.2025.02.19.06.14.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2025 06:14:28 -0800 (PST)
Message-ID: <9354d8a0-e264-4675-abc2-c0940d814437@googlemail.com>
Date: Wed, 19 Feb 2025 15:14:27 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.13 000/274] 6.13.4-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250219082609.533585153@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 19.02.2025 um 09:24 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.13.4 release.
> There are 274 patches in this series, all will be posted as a response
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
