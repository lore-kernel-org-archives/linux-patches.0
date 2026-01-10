Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABCC29405
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 07:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768029457; cv=none; b=RDvsi4eHvm2pr6VShOEdn+OZRAzX2qKPkmMAbsmlBuOf84loEqbEbaQu+mvvZAJs8SdFgZz1Ob3X+6onppHcsF8dO4YRyy19sR+OmDTTQ8maT0JPpyAGV78zJXBVpQeMtJooJOilRhVqx3+bE5k+Jqf4NqHbMr1Pdl9h8sO27xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768029457; c=relaxed/simple;
	bh=ZRbLxZqJzAxtg/FPbWfw5gS95DSw9Y7wa5SX+g9CA0w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ekmKlCIrOzs1TJH1wKYRARdqxXW5fVVT7ng0UtYnDrAlAXl3EOZfJIUpegSsz1JmWM+jw6plhLZOzacHkzVUCfV57BqbM5rXXRd0fNhGkqs8btmi45s9motyI4G5c832f2nohF3vQUh1SMfalJTrIQ7PVGj8eQr0D7h8arxtr7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=cP+nh7u6; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="cP+nh7u6"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-42fb2314f52so2562057f8f.0
        for <patches@lists.linux.dev>; Fri, 09 Jan 2026 23:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1768029454; x=1768634254; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J2We1YT8B8LvSN1lj9wbGm9Offrxdm4PUs+LKbXNl9A=;
        b=cP+nh7u6I+MxdmSuAAY1D7fyf1CzmxWci1IGOUKvaQZAV/tB1rkXVqjwLdyQZYuzbQ
         0rM37eOb4Rr+FOT5TQTRuaIv37R0jBd5D7226o5h5PtXT8mi+7Do1KZ1Qjwg8whZ3r/V
         UTyC98h2RnMsG9PoL+V01zsf1R7+nZmwYTuwN6fjCKtFi8ev00/Pjpz7N/++B+XrWi6W
         ThR9R2qMHg3aoCPpLsorVq3JeBrLGWEQ8bio13LOX6rFjgrHB01JeqXfwCHjJhUiCxd0
         moYtZxN7XACf2AUCyquq7rzGfBkZHGaS6RbDPDDdh+abAu1g69skuCzGzHxuIfkGlgtH
         h4Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768029454; x=1768634254;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J2We1YT8B8LvSN1lj9wbGm9Offrxdm4PUs+LKbXNl9A=;
        b=eGW2R2xV1lWm8tSM5CrCLah0J18I7B/ZcMne5p/mJxp2WL+b0oKff0FKOHz+fGipUN
         oZOB5vACshlBQWdJkIl7BLkTOonUrAecD1igjHGGOG5yfR++S3wUhjsoGht88g32l2eo
         2psOgEREyCgwVa28HWqoGIMGxif6xIbouSfzn0cqVT0DMMlivgx80g4s+bf+riGRZ2UB
         GvVXcsoM6KVa9O1ur6dUqlMW1bwf91sfMQAih71JKXmMPohj0QrBpXoJtlNuWRuDhOar
         jZHgn6TdRkagkF7R8Fg7HGDj+6xGkk3bqoSBdsRrMJ5/pXQnmMbN0ylQEueGurU040Ag
         SVJA==
X-Gm-Message-State: AOJu0YwzCxbArI7gohTZKg6B5VJH/c5jLG+NgB5Hl3eJ65pfXQMrEZCZ
	eaK8ZePE9GymBU6ugxrcu3rPzTU8utCUdjzVyF1JuEaKkfYUBwkVkRA=
X-Gm-Gg: AY/fxX6eduebaJc85yrNgJr+nppffCZ0qsDnsLit0tson777oYikZ+wshixM8uoA5Rk
	BWiBOUs/RdOD23vH7YqCstnhabtYzWtphP4w9/G647ZZxz/8KH8S1wKJOOpFIiW6YrJMV4wjlZI
	bkxUqYAayHpzVvQ2yRPwTGwxpXZDS6Md29JfleuKdtP0Mu0E4vlp+cbazqxMnjaXwqSTS+PfFV/
	2cy98CkMJAyS1VB+GGoQi9Hhn4/oZ6po58ggAY2nGHYJGl1cmgcHeATwVYMbAzzIvjiQClsvz5B
	aM0qTkoh+3osJ7tEWirJ/IwHackea8UOc+w1LZI4LJ3VOZMO7Ng+kFXW9tKTAc6sd2XLsOZ1ntV
	MxsfEFlOIoE36E/FN7HEWg9Elag8I73xmOk8DsZ3ErZzvcwCaLaEd7NkBXUBh2vacgmn/qlzBxH
	//v7HEEUOJuFzOUBXDFVy85t+os4891M+hIVhnBLNQeFefvyAYFyWyjja6ejynbdE=
X-Google-Smtp-Source: AGHT+IHrcnHp4O0WLmnSxynBGk6R74ASSMyDXIY+R0b/oomYF5XBwohUX6UCnaO+bSRXp6ACnKV9MQ==
X-Received: by 2002:a05:600c:698e:b0:47b:deb9:15fb with SMTP id 5b1f17b1804b1-47d84b52c67mr116346535e9.33.1768029453667;
        Fri, 09 Jan 2026 23:17:33 -0800 (PST)
Received: from [192.168.1.3] (p5b057af3.dip0.t-ipconnect.de. [91.5.122.243])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f4184e1sm237681125e9.4.2026.01.09.23.17.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 23:17:33 -0800 (PST)
Message-ID: <9cf79cbf-76db-42ee-9084-9e2adaf8b35e@googlemail.com>
Date: Sat, 10 Jan 2026 08:17:32 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/634] 6.1.160-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260109112117.407257400@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.01.2026 um 12:34 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.160 release.
> There are 634 patches in this series, all will be posted as a response
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
