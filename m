Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE87374C2
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 10:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721212832; cv=none; b=Dqli2jnZkbfP+3HcZpx2LL30rQ13XhRp32/2HAAGJf08P6LfYuUDk0rkhfD1iMA5iQYGOB9jGM3EMNJRL51eAOLuhl06V1ECJQ9N8MmQxIj1gGzhKodzc273fqO3Xy2hpPUmxcKvUR/ndDYGMkbfY1xU4sbgDP/kdwDRCcATq+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721212832; c=relaxed/simple;
	bh=nLG7HzQccjTqp4Lu9GgprSBfB6cJU6QMPbFU6J7wqV4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QLcH8Zqkinx54Y1G16mjOaZ0aC848VwWxZW6wSpGpqleaF9ibI8hSHYcSdHfKFKghV3kPMhPMS6qcpQiq2KzHUs2qyADkDRLS0ncgV4gDo75jnL9WiYselfyHblUaBRiOnXIVaO9Pj+gclkql3/r5cMCJdWvI3E24ebQjyWCDPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=miEu1Pqu; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="miEu1Pqu"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-58e76294858so1246484a12.0
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 03:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1721212829; x=1721817629; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BeiA4+yCeVCI23SPrGp8AYyUosGnfCOYmYJM+U4xtYs=;
        b=miEu1PquBMqI3d0+MmJn4VTMnw4Ngu14FvufjSnMwhJWf+ToRQBKK5yzBEGyA72J4O
         BrolcNLRZkhKACquY4XYRb67hSBgVGS14o69oqLOwa7uE/MM4bbYR2OcKiVSXoObr6Vd
         2wCMA5HmadFgcMAdOmIovF34YUbU6DwXBUbd5Y0HCzpma8CDAhpxWXDeD6SsYXF/XgVI
         ZclQbIW8Py/3rW8DQlsuIvCD9REFdCwY7qTRqmOD4df0CoGiI+5/pYHGaMkbF/Z5tYmq
         m4KYYUTnABFwUpzlQldKjWa1vOp/nd12rbGBeuNwse9bwJb+kVTxEKC8Pn23u9QEeCaK
         WEzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721212829; x=1721817629;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BeiA4+yCeVCI23SPrGp8AYyUosGnfCOYmYJM+U4xtYs=;
        b=E0k7yKOIAScslwW5qh3C7tdRLj+qUxBv7O0+qr7ZF1Ay7l+4C8a6hwm7L8/3V0PJ3T
         1POhTe5xSSGfg7+42dzwHLnUdn+DxsMP9GNS7BflxOtei0nelYJvJT982VsM2wQAHqMk
         n0HEjENRJMY4zsA/kjlwaGa1Jf+2tE+kXBGQe+A/aXqiIaAAuLG2WIhSee1D9Lzw+byG
         JbYcSyTmh2pN6ZC4O3PAjNRqDhj7oLWKGEegAtRgRtK341TpD+IKXEq0xs+3mADZKSVl
         ME8wdzGfa9HcN1oEinI1KXW9emLZrLYfYbtzzh8gsL7L8kKSe3JlEXNfIodaesQdeT7M
         zg6g==
X-Gm-Message-State: AOJu0Yzxn1aplbE+uYI3S8wCe5c2ENQCs67LcV66xyASy+z5YnDP8Wxp
	/sJwQOFfzdu+JlJ0GYNgwf0IXPmSwS0N/ZmlmEEG1fzf3pOBF/2I+V5tjjY=
X-Google-Smtp-Source: AGHT+IGPRYWY84cF4GKQ2fo+yH21EEObN21ZhtKUWYglYPTJwNess4mMJnLwjb5N0xFC6XWB6hbAVQ==
X-Received: by 2002:a50:8750:0:b0:57c:b82e:884b with SMTP id 4fb4d7f45d1cf-5a06a475fc4mr1217233a12.19.1721212828702;
        Wed, 17 Jul 2024 03:40:28 -0700 (PDT)
Received: from [192.168.1.3] (p5b0576fa.dip0.t-ipconnect.de. [91.5.118.250])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-59b24a77114sm6820425a12.6.2024.07.17.03.40.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jul 2024 03:40:28 -0700 (PDT)
Message-ID: <eaa61714-6326-435c-9786-08884bfd1d51@googlemail.com>
Date: Wed, 17 Jul 2024 12:40:26 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/122] 6.6.41-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240717063802.663310305@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240717063802.663310305@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.07.2024 um 08:39 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.41 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
