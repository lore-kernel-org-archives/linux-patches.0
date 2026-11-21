Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795237733;
	b=C1HIdk1P5ZxYN5/36Dd6Z0OzLAnzawxywF2cGAg4ToUmvdGEoK7X+AInEN3pYjpKwQ+h
	 KRPsmTT/JEQ0sCZEgHVfaRlc4GLeHTb8n9DnZknrZTL84uduTqZ0WAkZSWlNsWik1Xain
	 yuyKfAYBj8rWQnfcHez1qhJjpeL8qPNj70d7kTI6km4bLGDhGfYbKAYr6RMcFWW4M76VO
	 HE+QXHOLafKaINHSlCjyO0lMeXcSOTaJGV68Gm8246v5GQe2BpFeyWFsXGJgeardEmVK1
	 O+tguEsmabtqDmUL9zSutVGJATQSN/nY2yUdQQDjOBPYJHsszRYUqVkj/kHas9idoUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795237733;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=zq35YXCPx2V3r1wIC+O3B5GGrUsSEAAKs34AuDkQiBE=;
	b=vIUMNSAH6lir4mhlgGQ01ckOgzYhmImo9BdS0ufTucO+l1tjyeJuafeJz5bnOeQsiTY9
	 niAFQYfhg+ooFaD/mc4CGJV6vDbx7H4VY+brH0uQQwiDP3rTu8F+4qQocDYMEBdesk572
	 XZADve1xNHQfo4PiSO//CTeKuRT1SNAiQD//jDtiG4rrozZDtecqVqCKb3xkMR0oyzaeY
	 Ual+Bz+vP+34+r3+2H9gbB9u1XTpJRt43CXOEAgZ/3x/k05c1hBOKpxGZg4KFYJWD0+Dt
	 sHGJ0AyWk20S+0UBYa3hhaH8lzXFKHID/UdY6wtSL4AlvuNfi0UtkYPGNX6PDwhtWyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=vMutFCHH;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D42E606A696
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 05:08:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D42E606A696
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=vMutFCHH
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4bb6c7b6dbdso14985095e9.0
        for <patches@lists.linux.dev>; Fri, 20 Nov 2026 21:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1795237732; x=1795842532; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zq35YXCPx2V3r1wIC+O3B5GGrUsSEAAKs34AuDkQiBE=;
        b=vMutFCHHeM1AQj2fBqu7dGS42HQtBXq8JiG2ybM/OU7vqBs9TPFn0BZ2/0MwZSLqWm
         oIYr0smfOQwUq+TShveRdzaMy0BJ/auuv99RBLbiECSJLkxo5jWmkScCI5JeVzUuEX25
         T4mRzX/KUiA+GU4yKTOLC/DVy40ly+eJEGtfW9Wa9FAa8UdVcToZ+iiKbMwLeha39U4h
         Ch1lr4aVnY+uSSapPVzIk7rur83dzb1jC3nvdEnhR/PLDxptcQf7zO+pZkH5DYMTL0Fd
         64irAjMkTgt73S+G3fvpAKmpBvuwmziXRBgdzeTgtx6CVTjLr7H0ma5M8Iq0Lg/Gd1Pr
         9KqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795237732; x=1795842532;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zq35YXCPx2V3r1wIC+O3B5GGrUsSEAAKs34AuDkQiBE=;
        b=EI4fIWiBxxa0x78USDpT+Hi/pSfEnvE/GWh7PqHa1+DbHpt5qzs+1PxyfJFMaeDLC/
         hufmH/tGvwF8GF0ENNHvs9leU4+xZ1alqsj9wCR7EMtnc7jwNdr3UEtQYQFmZyAwC7c6
         VWumi0qBzIBCdaxQYVbzXkZXUWHp4BYqqSZed0bNy3VASTXdhwurlE+pUDLRp7sXON9d
         o/grBuPeslEawl55pTmgPxyc1SKSQZ9ygsE8ouSgP1deXB7I1NKlKvLx4spcvJdZGcmX
         IxA6kEPoCWw0p17hSAO41VIp5eyCyptwtUHaB1fqv4KOTL0hdglB+ZQclR0t7AlInthq
         eWWA==
X-Gm-Message-State: APuU4Z+0WnSggfYBCzjYTMF31IksB2tWCqaqvK8FYy3/tLMImYIuatjc
	36L7dtdom0f+utANDTETOS+/F1lA1uVhT7Mb7wer0md0xALkjOGTQPs=
X-Gm-Gg: AZFdTZdwwqxw/p6L5Wa5BuqAqKPzbWLHMC1JjK7nNlPsFXetwX2InjhFA5VI3O+eL2G
	5Xm6cGWf0ZjDX+m3SRCcw5GV1ejQvHo7WHgBzC8Ku3z5jZFhfptzccssgntaNb7W9ZEPvTZfouH
	dKMSq2l02al2T8cGuZ6QRmuEZWeGc5OzuHlJ6OQZ1E2DNTE+pGOS3svkls8J/pUca1g9CUo5GWR
	gyXQTcx3nEPkrmU4vlrhhyR0Lt/HA3iOn8rbFSK3MyNNxgAb9QmYWVpfdqJSUwaYBCSCvbwzNza
	iKLG5ZY8ybqqgHW2Z7Jnv/w6yhlOrhzLB/SWfqxg9LU0HmKH+hdNOCqyhw5GcvCfiK48WkKgjeb
	qgw4kE4pByVVmDrf4Z8zrCy717Y2YBiUcmOU75fqAb58ysdze2prDQ7fQJaZbp/rPyY4kkXpG2D
	LsWbK8gN/NaDvRYz26Lb+FjO0DXXFwz8ZOHr4yMBjO0yQINmJMyidJ0mhpbpulJDS7tRpY7UlGR
	L+cnHznSkHJ5WqIxVOXrgYLVRD+6eNi4rs5eZOhnpBUtoTY+BCjxoArZH58edeWpc3YklK72bL0
	vDah2YHPTQqrkZBEl3lS+waJXoYlKdTrDBicJktJcS8e3rZjl3BZ7XuWbnMYZ+a6ZFLdhYNjoYX
	+LX1GDw==
X-Received: by 2002:a05:600c:34c9:b0:4a3:5d64:df91 with SMTP id 5b1f17b1804b1-4bb88810d28mr123194735e9.18.1795237731809;
        Fri, 20 Nov 2026 21:08:51 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac65d.dip0.t-ipconnect.de. [91.42.198.93])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b8429sm222372595e9.14.2026.11.20.21.08.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 21:08:51 -0800 (PST)
Message-ID: <4d8acddd-10ca-4630-95e2-ce2adb76c689@googlemail.com>
Date: Sat, 21 Nov 2026 06:08:50 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.3 0000/2642] 7.3.6-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261120055248.913352689@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261120055248.913352689@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.11.2026 um 06:58 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.3.6 release.
> There are 2642 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

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
