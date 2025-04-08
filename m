Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF181DA60F
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 21:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744148495; cv=none; b=MzV8ejWiL70T5y0ejmmHmn4/VlkUvAMZHu1cc1D9jCoqPT7qQ8nNCNa1DzirnUwIf7RVvEBxCTik0fIYNg0wfuNOH/3qU2s2O3WRMKgDps2f0AJyFDDljx/P9bM4cO7TzAQaQgmIDvTzdr1SmySW+W8sU4fkW1Vxf7MM3W6s4NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744148495; c=relaxed/simple;
	bh=2/x7nB9FcPK/2dOBsaqrgTy2A/Pwt6KSdCUdypvBcHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ltF0I8+Jrl/Q521I7vGbz3kPZIJoHBsIb9VVElQTwElJ6EANdlA1bNE+FZrSOaj+PZkSBIsG4koIVk1/8D0fDwqJmycjAUsqMlJprufziWjkHdc02bhTOLbT232plgkapr6nuM1npEIN3//NVxzChDTzPAqvKsvCK2sehGuVzIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=CdJ6/nZy; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="CdJ6/nZy"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-39129fc51f8so4957503f8f.0
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 14:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1744148492; x=1744753292; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jujl/3M0d7wSLPXvj2IiLotnILIlcQaO5JF5yueWAPQ=;
        b=CdJ6/nZyq8uH+svZkXjvlc7wWHICLrhr5W+jdBnqeOhFFB+M182jFECeU6QYoGrpTN
         5yL0Lz1Ve32trkT41pT0Mdrv3A4BzzFBfQb6ywR5m1us/VJ7qUKiXTCdAw5eL5jcwyWl
         WmrTktX2e5YRLF6nlB1cWtmVQrbxV06BnuMPggGF2/5PuZLXeispEyF07jPOoOki5QzO
         5sPunZZsK5wEcfsgSjn2ai/bUtdirqUifaqlDX+mjap8mlC8lUhJX3rLNwzH9kxi8jZH
         185SgiF8Fh3qJReyjBoWF5ux8eTd5wRxJ0LWZetN79pHEaWdBkNMVd/88wy6GoeTjLnU
         vWbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744148492; x=1744753292;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jujl/3M0d7wSLPXvj2IiLotnILIlcQaO5JF5yueWAPQ=;
        b=PgjPdqSjPBQprLVZPfivniGrWQbpRrLh6th/2a0lKMu1LfpbJgNVUWgKF43tKrU/mt
         JX9dRzvWpRrxFS3JkxFrBhBk5M0EpmjaChiR4oHlJpUV67onZQ4MQGVCV+AGMosU2Y0C
         VquZMxWccNoOuc5GHoTR/gWRUh1tih5xlaFvcXiO6+xtL3Ci+0IikP1zwxGieVoHAISj
         wtEReX4Zqwo+1VI1O932zEVmDkYcZxS1H26NZoSY2XWfaPrS+E4yGT3qz0/I/+jOJR3C
         jC7+0qR9oC0aMV1gwci4X3iyVnzC6aDwNCK73fHAecqQISP7gEKf3Jv41yF3Av39kCQM
         BhDA==
X-Gm-Message-State: AOJu0YyNwlLh1/EtgRtp0OhJpt4UUT/oUimcIjajMtgdbI1rIYHKC4Wa
	4JccK/afo+AZGjdp3AJrI+Z2Mgpd7wKVcsct7igWMH+1q2AMqRE=
X-Gm-Gg: ASbGncvq4E+gJ57cGXDcavHWAPsJsuGHkJe+BCq2UfIrX5x6AVyT8r5jGWVXuJveSAT
	QifjLPVsuc1dAIq9UPSEjZRzrPjku6mgB/8oDhlx1+mSF5t6CTBnjMS7wgRNiC2zHxIl73AuFDx
	RWOb9sxIJkjlaeAdgFIjeK0qHe2uCBlxHkTcSGv7ZVElUoW+TUGZ50jwwK9QFsZpBmxs7U6a56r
	KdS4vob/K4F1aNz9V3dDfWMInLZjsVz747RJ9WzpoLn714kte+rFALltTqAV+IfHVhczHCDXDD6
	HAJl9jp9FpMMIRLMq4ASitEom2NQWJFn07DoG4mFa9qn4/pgwlmq/4bQGt9PEvkDuQYTQdLJMBv
	Hjr+L5BGmXyzLlXI3qcL3+g==
X-Google-Smtp-Source: AGHT+IEkH0kKV4n5A4/YEBKlji9xy9QOjToqAkLTDV4gJBsJfkJ9CHmu96vZtemcSy34BPbUEz1PwQ==
X-Received: by 2002:a5d:5f46:0:b0:39c:13fd:e50e with SMTP id ffacd0b85a97d-39d87aa55ccmr559130f8f.10.1744148492212;
        Tue, 08 Apr 2025 14:41:32 -0700 (PDT)
Received: from [192.168.1.3] (p5b057de8.dip0.t-ipconnect.de. [91.5.125.232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c301b69c4sm15865791f8f.43.2025.04.08.14.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 14:41:30 -0700 (PDT)
Message-ID: <c29e00b4-dd67-49cc-8e46-da7161ab6773@googlemail.com>
Date: Tue, 8 Apr 2025 23:41:29 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/268] 6.6.87-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250408104828.499967190@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 08.04.2025 um 12:46 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.87 release.
> There are 268 patches in this series, all will be posted as a response
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
