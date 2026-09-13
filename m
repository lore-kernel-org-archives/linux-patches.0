Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D075238A720
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 11:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789298558; cv=none; b=Q2bCuIuptCLFmdBvrWeqKnVD8djY3zenWuuH2Vf3BqBAR6VKmdUGBZ47tGR357BgQ0gMdgzrG9RHeG6ronkAeXD4oVITUIv+WQZmyn5ZpYoFmoV3apJ/yPDoQyLA1oeLmBr1d3Oufjtn1a6PzKXvbxKpPpcrDFZgWS5UEhGkACI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789298558; c=relaxed/simple;
	bh=zgYd+/+OrMtAYZdTW6ALvcgwYufAYjVhQV5KAyT2rEo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=biEOZ6NaVn3mXXrBx6wc7A2rHys9KMQ7fAPVONTb2ud07ut/MzMPI0g49tr+jabo5KNROKiwlJkuXQj+B6VaS8wIP+9oYRU6uDxjVc6sj2TCIP3PCmonCLsVxFAmA6DTVdTepMnHN2CEcjlzUaP7zbDNkJraDgtUakTJAkeuqRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=nX3EgBtO; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="nX3EgBtO"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d822dso7727535e9.2
        for <patches@lists.linux.dev>; Sun, 13 Sep 2026 04:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1789298555; x=1789903355; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wECUEybq5CkpsVtthy4SjiDIXRDYyDXHnZHX7Ni0Em8=;
        b=nX3EgBtOwoAfbNRH2VS+zOMICongtoRI9doisRYe/aXSo7CVzfCzlVtvRK3xqNbr5z
         VE2eX2k3oht0wRVcEFST6KQCBu2g9AdA2WksaXtRlvf8kSmi558w3OAm+SfpadM0Dhzv
         bZfKuIAPa8tk4ZsJyOS/dk6ljqkrYcchLF7o13wYIEzNpAH/zJy0cvlTp0Dtyx8NmFGN
         t535qa+uoZ0J4zDdsBKl8Juvkm2ZEFf/pmk65kPo7/Km/f5ALh56AywXK5qFY9/ja1ss
         bigK+dZSDEBzOU3WKiCkv+i8m8GcO45s6awT+Zvcd7PAcUNwbepjneQF/fmPXZ0k9hoo
         yuLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789298555; x=1789903355;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wECUEybq5CkpsVtthy4SjiDIXRDYyDXHnZHX7Ni0Em8=;
        b=Ln1rNLG3vnC3n2GxHD7sNSPMDyATtfwmo4RCDCqfoAhciA6FS+BfZqCKnizqn8PF3K
         nIteNDZEF9j3dMizYwa+5p8vMfGROm4FErBJi4Gze2AZ1P3zutgK/2X78uSFMhguvgOK
         zFHz7C+Q9o12/BBcLJqxkwLhhhJbOSFR8FbPtJEscJkCZ73c5rwjo/lT+ZUIRRNd7het
         0aNq/rSi2aaAEGniayijMxTaS/V1iZUk7lcXuKSlCc9VMU7bAamHOw6BsyJDZQSzJnH0
         /mHlSIAXEuRqiIpn7F34VTSN3I/ImaCx2EbSCQpBSo/zM631pzQ0OVKRU4EToAu9cQqH
         P2tA==
X-Gm-Message-State: AFuF++n7bos/HdUP0N8PnsL33rf+GOUa1uClQJyXbiHM1hKXx8GKxNtM
	0BOZQw3L2ko9hYYv0/vN4n5pdzmOW5ihO/JRKgbS6HZVuYBUObpQA8o=
X-Gm-Gg: AYBFou1S5ADC8gsbRaMTNWRP/OyODvwQKXSDwK9jmuvSD9ch2qunP2S/eLYhz/UDPZE
	pV94crdKOh2x+xuGNk19IjhXwIwctYGFJ658WQ1ZMPdMHAy3jVKFR8BZbAQsyS9qgD3P8ymq2P5
	D8c7Y3C2w9un40JawXiaXbuqS6EnOV6kfYI7Xmz7jk1OtZMCJlLj+lkBxZk4Ohw2xJjGHOiqgON
	h+BQHCSJcGZoIXdqoB9ZRPuPasKsauU+kVE9xWIRpEUXUYkGZeIQHGBROHEFeWM77F6oVgs0ss3
	YTV0tIuu/+3pzABoig7NGlqh4jY8IUM+DIwFO81ZrZ8IRaKd/lCKPC4vmseSIVDo18Cp+v1HF9T
	gt9MNSsgv5WPFTK52GjCqIVcUVEBgGR3KUVx3dGl418ynPeulV5uHyXyejRmsQj6Yd1eWvYLGw1
	f6FOd8grm2uDtVfCTnXulF7Ph9ZHWFeyz6Rx4ClAQYmUb3OHx4uB+K6EW52UKbnkqc1wlmwrfbO
	oihrXL989rbgY2l5fU3z2djPNDmVYob0M7UrXLnxQh9WfJcog==
X-Received: by 2002:a05:600c:37c6:b0:49c:fa21:1c8b with SMTP id 5b1f17b1804b1-49e6cc1a4d0mr58613765e9.32.1789298554999;
        Sun, 13 Sep 2026 04:22:34 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4716.dip0.t-ipconnect.de. [91.43.71.22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d26c39086sm282128375e9.10.2026.09.13.04.22.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2026 04:22:34 -0700 (PDT)
Message-ID: <2b7c10bf-d08c-4bc7-ab91-8d0e8621887d@googlemail.com>
Date: Sun, 13 Sep 2026 13:22:33 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.2 0000/1815] 7.2.6-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260912065648.999753832@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.09.2026 um 08:29 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.2.6 release.
> There are 1815 patches in this series, all will be posted as a response
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
