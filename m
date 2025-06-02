Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB0B2C3259
	for <patches@lists.linux.dev>; Mon,  2 Jun 2025 18:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748889985; cv=none; b=TUrgP3WdQFFkl2+lWz+AS15h5/FqdW+fIPQwU18Hw44N6d4ekq1yBHbjaAfW1HXSPWPGZuegwFhtHIB9UNfQwxnlMuJ7lGoVIzvLDzfoUlGtkJA+r3z6S852UEEPn/LK6OudX5yx7x4zq1EaksQDWCV266miB1YHwxAX1HKUqKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748889985; c=relaxed/simple;
	bh=t7PWQIROnj9O2Qd2473xwHXz1p4C86Pcz4bK/Kwvu5g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L9OUh3AvAMxum3XZjY3/VcqqOetI1f99epIlBlq7E2qVT0/bLocaZuBtQM/lwWX1/71ap46ebkInvplJsYCOchEPy7MkdZzdEeBDKHHreRLu3vTna6JIjoD140Zos4I05lumuXO0XchN82Un9oHrKalRW/KRNu656xRlWhjo69Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=SGmA5LhW; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="SGmA5LhW"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-451d41e1ad1so15808005e9.1
        for <patches@lists.linux.dev>; Mon, 02 Jun 2025 11:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1748889982; x=1749494782; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DQgE/th7Y6NmSXgegzh7ifR88rjm7OtqqOUWoV4+ZsE=;
        b=SGmA5LhWguwDS2oR288utRQf9nfPHzy9Smgrb4xebUyPhbrE4YG8/n8OPzO+Ayys5w
         HY8W+eLn4ejkzmsoz3YsKFTUMGLga03zL+/LPjd8xTTlgfXGpMcYUfg+AV4AiQa5TiGx
         WijGlSdShB3ksFEg5dkChnLpXllcpMXgEMjmkrvqWLkW4u7fD31HdnPDvFIOM4oe3T/N
         ORBCrVC4rPzPUlYqj0R6kRI5nOrISgtSCDFiUrWMIfYo+IfiSXyoVbOcg11oU83OJNwR
         /o/WlD2HzfQVWZgxD45XVqQPj5N6hvnTOvwo3Jmw7vWQZKzNDGViwVZKtzQ6RggoysNI
         vBBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748889982; x=1749494782;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DQgE/th7Y6NmSXgegzh7ifR88rjm7OtqqOUWoV4+ZsE=;
        b=iefVhhFwec9CSZiacG8pjVUM2SPnSLbgY13THYt9z15nGyO5T1Evh5hV7CJQDZy9Iy
         JLzG2RYcctGsnTP39uCCIc0DV5e7U3lByveTYItOtWxCOsyOTbLFMPQRyPQt4OjUwhIv
         yoaKatafzsgT+Qs69bQKG9Jg1iCB78VypI2g/EewIvGtiVAHMZC5BXXoASlMMcqBKUBA
         Lrd+QEcTS3QeoKdZOQgHV6DP5qgiBfEQwvMqdghHyxZOjNtmr5pLKLSKQEz8n0r5dBDW
         qJsFw253I7TK32oGWnUy8jYTu5HJqYR76BS1KeVldALYPI4kQzvL4zfMi0StZei/GBI7
         zQhg==
X-Gm-Message-State: AOJu0YwDP71CPXEBoFC89bvZxAtcRyoy1vuDdyARzFIMYmqZ2qO934k7
	AbXHrGzmUC/Np9QN1pcWwevoxuG35y3kK58SkQbLM9MWNzg7jt3/bJw=
X-Gm-Gg: ASbGncvb+CXh7fXUlkcHSNSXmp70N57tlTI5L9/+zrFw5/l3O1ueMj1+YSw0/at16gs
	vWjFh+9JYnVqXEmDdQkMg6z8xXbRAEDNGrMiuT3FtZE5GA0JGuFjrm+C0UhP71MB+DrjkqE9Nw0
	SFfa0sBb3vlmX7ETbBvDzRzQEpqsC2hT6I2xPujQgt0er0IsR6R6V7PCmY9qK7lFacPON5bZbyF
	kQIjnu8VmgxvJ0OitH/mC6PUja4wSZXyLMrZ7W5Qo7UZq5iLR3XSNmacINbV5xYkifZ+Q3y6p9+
	ocZxoXZZinFv/QxDdond4J6G/cpXS9FkvqGkU0HRHKERG27g4/hT4aAYA+chBDjlXghRx8e7lks
	1pT5evdLTb4NlW2CPm2AM5RlkCMdhQyToB/qehWFS8Vum1kYe
X-Google-Smtp-Source: AGHT+IHJw1q7LezGoIk9SASABKd0sGNN76oputOfkAU4vVCaSWWo33UrhTOa7JcV5gOvreKvCke50g==
X-Received: by 2002:a05:600c:3542:b0:43c:e478:889 with SMTP id 5b1f17b1804b1-450d64366a0mr153427605e9.0.1748889981690;
        Mon, 02 Jun 2025 11:46:21 -0700 (PDT)
Received: from [192.168.1.3] (p5b057d53.dip0.t-ipconnect.de. [91.5.125.83])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4efe6c738sm15366037f8f.24.2025.06.02.11.46.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 11:46:21 -0700 (PDT)
Message-ID: <6117e660-bcba-4767-ae98-60c71e422169@googlemail.com>
Date: Mon, 2 Jun 2025 20:46:19 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.14 00/73] 6.14.10-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250602134241.673490006@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.06.2025 um 15:46 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.14.10 release.
> There are 73 patches in this series, all will be posted as a response
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
