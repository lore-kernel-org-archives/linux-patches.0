Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3D53016EE
	for <patches@lists.linux.dev>; Mon, 19 Jan 2026 11:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768821830; cv=none; b=Cu6/9i5RF1Yn98JNNWu/ZaQcvIgEaZnwax/27TsD3zdRXvRj23Td5IXkX+whp6RE1TNPwNIiO3HeGZ1NCTtV+HSCEqhefBvSMUBS1WpbEJPo15KZcD5hbywPbAokEQPyKXJyCvGC/Mfg7Sf2DGwe7qJVVFEM0p4qWm0Ai7jRTiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768821830; c=relaxed/simple;
	bh=o/RYM5xvEYUmeBF3YHCsajzHuBcgtSD92WjxeVw5NtI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jAJw6MLPAGUjYCPAOdc25yD2sVkIXGfgivGZ4c9RAAzA7U5ojm5OOw+n55fE+jF5WEIcwNaK/3xrI5Hf99mpnklfZPVUX8f65D9JY75JM5H+PYm/a5kYWK3ESZxtzLvuJMs/HUSKgIMt84Io4emaAIL2fVEhr5qQrSYRqVu3Unc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=3DGpzMhG; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="3DGpzMhG"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b874c00a39fso741039666b.0
        for <patches@lists.linux.dev>; Mon, 19 Jan 2026 03:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1768821827; x=1769426627; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ul3fTjOzec1NpKK9eGRnfPR+hFQQzmswH1g2E9134rg=;
        b=3DGpzMhGjSP6zmh7EoGstSSxiekyytgZ9mHAeIoUs/P/+DS7JSisxmtNogIGIOV9Z+
         6qtsqrJv0AgOfx59i+SbEp9BlMQ+yWry4NPkRXCDKzxI/hD3WTcLuJ9wIK9p60PJQxRF
         r87PoCC8RyGhQlQNJ2pgoMW+7MUi4Cdh4ZWUerez+e1K8HLfnGb2LnquEUyGwEpVDQ1i
         ZKc+4F3CKDhEtlgph2IAuc7MS9gwZi4GtzByLPH9uMtsd2adZz4QgAlJ16G/VvEYmxNH
         gPYaNOogqC71csmljwPDsSM0WXEr/+He0XNB2hdcG+ebMUjWr8YjnZuZpTLvAFwMvyYh
         crgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768821827; x=1769426627;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ul3fTjOzec1NpKK9eGRnfPR+hFQQzmswH1g2E9134rg=;
        b=WCwrSc9XGCJV3IlbIJIEueUU2gljFKf5DCDR/dOZO5hM+9nDdyYNlsOM2O2Lm5ii4Z
         TQ88Nd6kegIRZaN4yHtKl0BcrtuT8JypYi8qSmd3pEXOWanE4uKChY0ueHx55srDZ/x4
         CL9d71+gqo9GO3hYDVrelKbCfBXqZvJQs7u9smwhPWWlJCYiTHMmEXUTXSLAzaZq0754
         4fJ4N+a258ceY77SJsfG23igWteMdE+bfMk50e4/5+7egXeo3kEXIbGOD/ceDYDy9UUK
         IY0ks43s+UU9AFLTo8VEKFOxo/8rXfuB2N2yiZ++4rsow4ncQX9GZrPcXLrAwrR7KPXd
         vgsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBj1bLK7xy0elYufUYAdduHj1lDuD6t3lpjUSv+0OXwsT9WhdEs9H8/OkyXSK1e755qvkZNsjB@lists.linux.dev
X-Gm-Message-State: AOJu0YwyoMmNkfRlE8HW24PxN4+7U9/IWt6m6kio45EHiGfQ2HuxwcZf
	nWSmTikcZIVfj3SdT962dQ3cm8kMmesy++BrH7eZthn31ZYpNXTVKEzT6NTwfy52l3+1Muq4B3Y
	1qX/+SqQ/Fpb9h/GTP5vijOC7nZvsx+pVqqSbQ+5HBA==
X-Gm-Gg: AY/fxX78Ls7IFMhZCS1nph1NV+D3C4hH23GoDV3cng9TtOgKNvTOv8oHz1c2i99c0BB
	irTgnLGKskacN6KPXuRccsJsFjU/QTreCiQ8mgpVXt7xepwVE62UFx2tkLPkhnMOr2hw0OamJ5X
	9THHWu2mWv74E6f9XuPfOMPeXDkMUyefqUVaDOPTCbddPPG0yPct10VWaFAXTlVps4XOK2svWA1
	3BKO1qntJ0gHH40jS6BfvN2CfWwqwB0FThangj6xD4gm3CydANzGj6Ri5Pov5ctXuEjbqFDBo4Z
	1eVZgmOt
X-Received: by 2002:a17:906:9897:b0:b86:eeab:510d with SMTP id
 a640c23a62f3a-b8777bc5e2amr993800666b.15.1768821827422; Mon, 19 Jan 2026
 03:23:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260115164151.948839306@linuxfoundation.org>
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Mon, 19 Jan 2026 16:53:09 +0530
X-Gm-Features: AZwV_Qi_pMq36xGNJ7azJZTMio1xOQE0QgqPG5QQX8XVT8FumhSOBc7TvPxZekA
Message-ID: <CAG=yYwmwwFL_LcGfUN8bBnHSKUhtMUcK0kKcHA6bSZE6yR5sKQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/119] 6.12.66-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: multipart/mixed; boundary="000000000000b212d60648bbec29"

--000000000000b212d60648bbec29
Content-Type: text/plain; charset="UTF-8"

hello

Compiled and booted   6.12.66-rc1+

dmesg -l err shows error. File attached.

As per dmidecode command.
Version: AMD Ryzen 3 3250U with Radeon Graphics

Processor Information
        Socket Designation: FP5
        Type: Central Processor
        Family: Zen
        Manufacturer: Advanced Micro Devices, Inc.
        ID: 81 0F 81 00 FF FB 8B 17
        Signature: Family 23, Model 24, Stepping 1

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

--
software engineer
rajagiri school of engineering and technology

--000000000000b212d60648bbec29
Content-Type: text/plain; charset="US-ASCII"; name="dmesg-err-6.12.66-rc1+.txt"
Content-Disposition: attachment; filename="dmesg-err-6.12.66-rc1+.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_mkl2thqf0>
X-Attachment-Id: f_mkl2thqf0

WyAgIDIzLjUzNjQwOV0gZWUxMDA0IDMtMDA1MDogcHJvYmUgd2l0aCBkcml2ZXIgZWUxMDA0IGZh
aWxlZCB3aXRoIGVycm9yIC01Cg==
--000000000000b212d60648bbec29--
