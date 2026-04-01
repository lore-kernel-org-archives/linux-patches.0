Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C112E22B5
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 06:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775024516; cv=none; b=UmZxtjweYMbNPLoQk7/cp98OZ6LBVGCJenjXHYYmKqT3/5W5sITRuB7da+TDT1V3lBDUhpwoMQm7FfQOEZn0EAvzs128nDu/JVxf6ylWrOX6VXM06QCKRz83uKFF+CazppUWbVcMAHyvFzXGYI5Lci7vD7tsvolcqP55nEYaMRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775024516; c=relaxed/simple;
	bh=vX3FhxugoGwWypmAc4zoaCcyRW91U5MazWulxptjW1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ggcauC8stiazzRLC+wzVe7GaLuG6i0f6voNy3m67b0G2vvRP0aLmAh8zv/DxRD6BsEbxbAQRq2BrQdD0o/733xsUOXh7m1lBDbMZVCVbp5lq2p7WGSotXmXDo2zgr8FrL6+nRaZYxl36c/iKTGZ+/x3dc/+lH1jDjREmXeRAjo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=esuX4qaK; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="esuX4qaK"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43b9d3ebed5so4807647f8f.1
        for <patches@lists.linux.dev>; Tue, 31 Mar 2026 23:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1775024514; x=1775629314; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9jPg/zlaU/rwkyn2oC3DH9mo1UfksYtUHwnuv0z/Jrc=;
        b=esuX4qaKD0S7WLfMcT3/Yoc9epUnzpFPofdfir3dElfPgS74SkLDFlg8GFcp31vrRp
         It4HrQO+NsaC/bGoNj8+OIU1K9lZYhQF37/XkiiLHiWa8R4qL2jE7O+sSRGFtVrHJ3cK
         FnqDA3X5BEJl6/BHTNaz88pjo63+gBlKb3VWXIy9gGW1aaBnUtk8JFk3/hbW1GyP40fO
         5APhK5oqIl8EDIBbaYsYOMkZzqzgk4NedJ1L3zxX9h1QCIvcJ/Xz2+UBb2s0+Wrh8RkU
         BFznpqyQT09ZmFBeYvAQDdZtwkY2glCiIj7ML1BguyrCEcqXrKbRsG7EV8iFNnyk+CaF
         3GTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775024514; x=1775629314;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9jPg/zlaU/rwkyn2oC3DH9mo1UfksYtUHwnuv0z/Jrc=;
        b=Ce3jzjabCJi9lxAS/P1z9TD6uorcJ9lw8/VteBHjrix3zYvJvOpJiTT8Y9eCF7ttXK
         pgIV0HPMqHW4mPAvMv/13lDNesshNos+MsH9T0WtUeNRSapUl5RvcyQ/1x4vBO2yi7Ua
         dUqwOBVg3uEGcxojs1Vsrf5AnQCnfY6JsF/5XKs8Nijc7PKwKwUlUIFOKoNF+x0Y3n3I
         RYfbFS89CNT6zkGoqtsp6JO+ceAVc35Ueb+2J5aYvoWnBXneTSS9ndJve4NEk1yaw23y
         uDFwNNdYkSL9babQRYAhVgIZ1otuf2wkOyT3fmfLpAa1iEsjPfN4Is5Mn27p2vmZJtkr
         cMkw==
X-Gm-Message-State: AOJu0YwXo0rjpmkmbzC1drQgLwTmSkDMJmbFlovmz1spYgzVCDLzQDP5
	24TzvIwWI5KVY6VZtf0f03geeXGbRqTcR3BnVgqCtuyZzkbRnO0Y7uk=
X-Gm-Gg: ATEYQzwF8DdbPj345t9iBE6XqoWsIfi8YIBaIj1x8WJ6Q5LfqZeE89xkEdOco/dZ+8O
	fb4o339jbg3Z2DQT6LWi2y7s32Pz37WND2xuXD1Kjxg/5hRgZpKFgPCbWepzi40EZ8PNxessY1Q
	5d23HlA4awkbILOWSYqgF3rXJ6dNE0VTORSbigGdpNVIEy9BTBrTZXMhtlZnAdPo5T8qMsA25GN
	AB869PBVT9YxysLWUqwQxqRT1O5C1ZL6OaKtd00k8Uu7i7+1q3PAHQJQv/T1h8H2hk8iMTAPLn7
	gYPoXyyrzKlhiVMnrMYlTX7oApVpVLvVyCylg1mctU+lJnviPPE9HnusnGM4EpSpteljB/Nji86
	WgyvQpjISoBIiUYGpEm8ZSSPKPMZQmv2KKuVStNp6Cdov5bVRYn76uTgnsk4y+KAe/PSKsKsyrV
	Xilch308aFkE9Ap7QeAqrNm4UQmmi7t7A6sOdtxIi8OS1P+fxH4qfratLbbCIkR4pltUnCb/duv
	w==
X-Received: by 2002:a05:6000:2912:b0:43b:95e9:4150 with SMTP id ffacd0b85a97d-43d15049ecdmr3953798f8f.2.1775024513595;
        Tue, 31 Mar 2026 23:21:53 -0700 (PDT)
Received: from [192.168.1.3] (p5b057048.dip0.t-ipconnect.de. [91.5.112.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43cf21f279bsm29769357f8f.16.2026.03.31.23.21.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 23:21:53 -0700 (PDT)
Message-ID: <d3225542-78f8-4efe-882a-665f233aabc9@googlemail.com>
Date: Wed, 1 Apr 2026 08:21:51 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.19 000/342] 6.19.11-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260331161758.909578033@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 31.03.2026 um 18:17 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.19.11 release.
> There are 342 patches in this series, all will be posted as a response
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
