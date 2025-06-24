Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225482E2EF9
	for <patches@lists.linux.dev>; Tue, 24 Jun 2025 14:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750776206; cv=none; b=X+cDshAwuKCpInpaLXZupQMQzoMJjkjLkTPAmgHCyG6JvW+FTU0RL8WtDMqeTp71uBjDlt66l2uGaa8x/kwoW7hfeRzFq2qP7LyF3H6QtFhGL9bQQyI2IFAKyJS/TKJ527NPic98vxlga7wIY7GKZOcZ+Rwl5vpXyb233AI4cfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750776206; c=relaxed/simple;
	bh=DctmSIX4517I3MA7ZTbTzD2Ov8TWIGaK5Jvg0SDP+i4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o3VQN4TDx3MqPGGZYQE0mGbAu8otZqyVVfuCmEBBeKpvfr+IqvCYklzs9bJ5arVMS1x2gvz7yk6TnxJem/JxD1iD/m0q6inA0oMHz87sLOqHtBktdJ6GyeF46fCEp4QSHlBZuPm51TqFxC2or3IHMKUsp99pteWO7CcH0fV89Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Y/zhL30o; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Y/zhL30o"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4537deebb01so4722765e9.0
        for <patches@lists.linux.dev>; Tue, 24 Jun 2025 07:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1750776203; x=1751381003; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l+71XVf5M0IdQ6sdhaRf75cgMjNjt33ZDG+WbL/ULBM=;
        b=Y/zhL30oxKcxq0YorhrwzrwSCm+OSENZbUqVSidef+1GA74F/H9N6sskW+MYhMoa3Y
         LReozCBNCd0gDfdDBApQ2fgHVwUrH9wq9nkAektC7/CbPUVGVotV16dLP54zB1Oi+hiL
         KBtaXlzOftRvyE3R5dFikUIK8wKCiYnFjdM7L+DXMmCckH36HRJtyzy9XJEXv0wB12mr
         OnRlFSkFp7bfigjrx67+CLSpENzqbQLJGe/qDGWDaPHqC5YBDqxgu0rf3Iq1ggoIOYyF
         JoP6EgUvANjnM8Jx600SYeCluhshIF/hkCUzGusMaqqafWsS667edXTiuneKwFILZGsH
         o+pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750776203; x=1751381003;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l+71XVf5M0IdQ6sdhaRf75cgMjNjt33ZDG+WbL/ULBM=;
        b=w1NpNhifk36UXMaZ0Avwv4F6LQxl/lzEEOB8YaNkmKAc+lj+mUUp6uVWkcO8681Y40
         8GV6L4iDAegmcSzy2+ag2nMC6dikz/y9T8VZZ4yzXlIbLPJClUo3m3GmlO+qmWJI1RuM
         r9bOJoUHbjmW5VJOJl1/lK6o1mOhmM9Hi7hpbkQKgLtq/S86T3vyX9q/TibP7S/WEv6E
         +aRG66Oj4B02yo13CPpYs/7tKfWwiOYKBstqswpJrxsnsymPCmiHu5Re+RNYFEiFFRpG
         QQjXZ5aIvJ7722oLaje9KmvuIVizKrH7W2wlHsjPC7e2AvDCld4uWXrxUDHnVxz9b1+K
         Jxyg==
X-Gm-Message-State: AOJu0YzlSlHsmnxETngFEkOLLbN9lAJdZeWzav3oMg9PuE7gu3DxjaOq
	1UjmOEw5GWsHgu2aMAUlxCLu8mEa2p9rXHQmj+avqg+GeY7jjXNLHA0=
X-Gm-Gg: ASbGncucRGOdj2p5gfCYk02i9uo0xWG8o0QdzuXxng5+y9yuq3bv6Pa0I4sK2K4OIKq
	x0OoIDVJURkcgrf1Z72gvTHO4d5MV1OCVDwA9MZMdif9lUAVJV/mj+jLCUwuyeyvCOTINZUREOM
	uA/qlhxHl2pQXOZkb6L3p5O1WB3aN+SW6Nue2KH/160+omoQhzETpond9xpa7InxzBXFLtTvrmg
	BYX4NZbVVws/gVsKAFzcBKMXQai0iC1oZQFga0lldiQLZx0nUXGP6/XajaurnZBa5bas+gquyp2
	wd01vDdBTNnWSAv6GRCqkxtYTy8/0Hu0dkAodIgMd6b3VnEnZz96jF3dDvR4ZD4ClZQRyXobzoM
	zv6O5rodAX6UtC1nPq82dPbJufH4Jaf++AnZPMNo=
X-Google-Smtp-Source: AGHT+IH1AKZv1w2WizAwNPmvpDCWlcbWMt2nr5hpnlM9rZmI0Nmt6pxF2lAWecQ2nj2UxxcruNtEmg==
X-Received: by 2002:a05:600c:34c4:b0:450:d30e:ff96 with SMTP id 5b1f17b1804b1-453647921f8mr191327955e9.0.1750776203409;
        Tue, 24 Jun 2025 07:43:23 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acd47.dip0.t-ipconnect.de. [91.42.205.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e811049bsm2112651f8f.88.2025.06.24.07.43.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 07:43:22 -0700 (PDT)
Message-ID: <5a417344-fa3f-4806-a39a-ae2ce58b19a9@googlemail.com>
Date: Tue, 24 Jun 2025 16:43:21 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/413] 6.12.35-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250624121426.466976226@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250624121426.466976226@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 24.06.2025 um 14:29 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.35 release.
> There are 413 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 
server. No dmesg oddities or regressions found.

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
