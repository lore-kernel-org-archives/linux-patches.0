Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400962F39B5
	for <patches@lists.linux.dev>; Sun,  6 Sep 2026 14:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788706031; cv=pass; b=ZMR3LLaQNKxxtQ9Y7LhZJDr0A9cCjqVIKibGcgpWd7kjGnxmY+2PMJZx7lPNF3JaNgpRoATkYIm0d1r1uT2kYBSR0kW+v5SFfdgYNKEj9waj0vtHiUQR63mt2Re+UQy6pnpgWTBwiG4iGR8l7VaDEwNkHR9wtNX6p5SVyEMzKBg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788706031; c=relaxed/simple;
	bh=DBqqHAGSczpthp7loMH7wLmtYZ/JVKvH0RGvHHoN8+w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ayOTSTyLbdFZdu9ba6xs65CTFmhNUEkC0sdbwGp6uCxpx9c9fvCHut0Mj4270Eyy1UQpsEvs69lcCm5TgJgujSrvUGNpBuI0qzE9Ux1aNPNmBM00FaQ+uYdmZWsNGfXxXc2pmvDzsnWZFQXBuN9zGKQE01/9ccI/tOJ5ihG9wQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b=mtxPBovH; arc=pass smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b="mtxPBovH"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c252e703fa3so396975066b.3
        for <patches@lists.linux.dev>; Sun, 06 Sep 2026 07:47:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788706028; cv=none;
        d=google.com; s=arc-20260327;
        b=ocU9rk/875LEqFIwAGV2P1wphDj/ELuVJZGY5QiNHwL3dFpeqho+DarH4rNb+bvxMc
         +9jmSUviWhWXCuCd/bGi3xtnqpOdrGemyr2XDSnrt+5waby1XIBkbbDsVcB4GWfvKq6A
         gFVPQQtxy3tBDVIWS3Jv6dIRjGJQWCkPgit9GOrR7hK5454HHMHJNsU1e3Y+Xebc8Fvr
         wuUV0EN22zeHicNRG8kixdldJFZIYFJt2o+qBt7t6z5bfIPS7y8kqPTZ/XU2OKQ8yu4y
         VELdY7wwQD+Cs+i0p9+JsEdQ9EXHW/z/S2yyt7H+w/ttLM2D0pvUNp7kbdU0eaNpHIaQ
         SQ0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=fMw2a7h4FJa1ynMxKC2OZdTyNmHlbWlyFXY/M2wRjrI=;
        fh=au4ZWRl+aG6Zhccit5L/XqdU16fz9bjtx3uApWJcT98=;
        b=KBWXurI62p7I1YUif5UTSN5hYbLJYExu7Fb4k03QGxwRCfVG7S7LBcxIfIEaExZdtB
         b8LpGdrQK/RN0qKjbTndcUeb83QNLGBoyFI+1N75VBjgz/sHufVTpnhRB9S5fCZKEcnw
         K+qwV5/mWcWqLFDUdWB530rvMDOKXOhoVN0b1Sv0hpPyPQuWLK+Fem2VyuxrdNl3U3xd
         wUKUdOqGF6ZuVLUtRfn9yhjejfSRVjkGI8llc0HVbm4kZoTrQ55JErzUWh02vSOs/ewk
         wRNl24HlRT0oJd1iOeCpLokkrcPfAa3ReU1SOi8XFUZyH/ATZM3akvPle3eXmb3Ny0OH
         ReFg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20251104.gappssmtp.com; s=20251104; t=1788706028; x=1789310828; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fMw2a7h4FJa1ynMxKC2OZdTyNmHlbWlyFXY/M2wRjrI=;
        b=mtxPBovHFzCrOYvVhJgcnaCYMpFs7ALSexA7oNwqT7Umj9JlirONqVnPI+MlZMRwDO
         A2I2fIh7YBhTQGV6WG5gtVTZYiI1t9CDkN/sB+7Y9jV/3lC2CicJnYn/pjFuX0rSzXvm
         bjuptVQSJ/AlCCxObmZykQYkT4E9q6OgVJrUnNbf69oNSWhDwWXK6jw+l/qASrAOQM3a
         LdMYoManE//SydDaYgnfJpwoHmtQnfvaeZfgHeL9CvSSHObjIh6PhmqCPTd2PAq0/IIN
         jCAYoOcj74W/vZsBPRXOq7+oyTS/QIPmo5NezoLwY0kT5lbz7/OMydVXnpjOUDXnBeG5
         Y/SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788706028; x=1789310828;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=fMw2a7h4FJa1ynMxKC2OZdTyNmHlbWlyFXY/M2wRjrI=;
        b=IwXu15/pgSShl2Imi1oSVaun2HJokLMXCrt0BdLIRQ/McjTl3esVYNnaAisK49+jyU
         ikqHyC8tUJhgsphwmMrq4XBcsUrLBpi9ipvLimTLhcBv38nGOof8+NDp0wRV15NsHt/0
         pAO6BTIfYR8qrgBUsBFLIvml9s8+irGdYlwEJuB+NqXRslBT3cyJGQyESumR2f7YUG8V
         g56BBSl/Mp6fgTB4lv54x2JK6g4OnjfmmtDx6smwNcb/gJIlE/ZJs76MoHrLVv41D0HC
         jR97s06PNjYBGsC6x0Q1zfJy2XfuRYgeao18J34Cbsts4xdu6RKzzhaH4E0hAiwgbvnG
         Qb4A==
X-Forwarded-Encrypted: i=1; AKwUvBwgqxBQJ6x4DldCQ5Un5KK+VJCQFywUr9GmPEvdb90yHbkfyQ9LZztikXaGxCLbuyno74Mvedbh@lists.linux.dev
X-Gm-Message-State: AFuF++kMvyPh1Jm56Seq79y7oPNo5hP7gsMqz7S/Bdpb/KVmNk6va8LW
	foSiA8bHi2uWbrqiB5nRjo7l1DIi9eTmEO/zMwPn0EbczDPVmcF1Z9Wvw3aiAcfvVxezswVmscY
	AHb3GiD2r1Bm5z9GBbeTo5JHsMc2i2QCHxsn7wRBiO9aCODZ9M9eGOqg=
X-Gm-Gg: AYBFou0va1Sf36gqAv0q4o8298cOLivAEiAzc7zh1GF3xDQCrw5uiujNkwTxL9bdwNQ
	c93GSGtQbmzxlIuRWDbNo2y/wLcZ3IIL8rA0WLg9QybiKe0M27dCnKEDXM18SGM76GIACjce3oi
	44e9ED4t1xHDAK4Aog+6IAtqPi+D2BFxHZgERSowsNe7JwfqhHgprlZFoe6D5WEmmsX6vwjYEdo
	FKur6txYY5T0uJr/uDgi8XXw4Vs5dPQuvKebuJOGvdkO9Kp06SJIy0nDceZP5NTQ5NCqhXrotCi
	p3sfCyCVgrFGpKiZh9XFuYWW2KcKDhNesHSPykPjUTLt27RCiXKWm0/AfVVWAdc5zWxAAN8vQRY
	3sJt6Y8NJCKMIlkx/KWylJTTQ0E1HIaeKvyWFPdtmW3RIt3WrjcAdG8qC7CtdkQqiaY2HFtfKf3
	JXICt43slxm4A+
X-Received: by 2002:a17:907:94c7:b0:c21:4393:c41a with SMTP id
 a640c23a62f3a-c260c9b556dmr671749166b.11.1788706028458; Sun, 06 Sep 2026
 07:47:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260904045803.810145556@linuxfoundation.org>
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Sun, 6 Sep 2026 20:16:29 +0530
X-Gm-Features: AcwNN1V3DdZWjKZZI59W-lXeZk-QDF9YMp4RrSPhW5D9Euh9iW7L-2IdybpMmLo
Message-ID: <CAG=yYw=4c2nQXppcKfCv01om-zohPbZoafSfhFSCgOu4cxZuVA@mail.gmail.com>
Subject: Re: [PATCH 7.2 000/713] 7.2.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

  hello,

 Compiled and booted  7.2.4-rc1 (using qemu-system-x86_64)

No new typical dmesg regressions .

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


--
software engineer
rajagiri school of engineering and technology
