Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793365084;
	b=o760jtA/zRB+vpKWkUjbnlKkyQpwZhA4/O/OiA6m44QL+kYTPEMnQqmdjOemnn+YnfIc
	 bjhYysu+vcdZQ80o1ti94X+CuoW7HPVR+nsRfcwjkRjXDjKgDOeX0jy/OMoFW9gTpXVmP
	 y/njZFbx10keVVl2OWfZ233YUnXlGkL0WsZyhVeNMTqGT9TwLckXl16WKz+m4VKH+WixR
	 kwvbZtnMJbs7kk5TzlX4k8AznoNZiTrbtI3ediZd5n61PC3icAftbdnSPBYjSCBjfxW8q
	 q2gE0Sje4bXyCDWdeWGS8QBCOqkiSCZ2RUdEDGtNxBK/vPEsIt7f49tJkn2HhPAOi6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793365084;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:Content-Language:To:
	 Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=LpHGJG4BEsUziEetvXn6JA6Aaleh7lKdquZ/MLf5ANY=;
	b=RcC5GKgN4wFtHNrkw2FO6gMnDZ+2NNXGdRteOsdTvmrAAZ3rt4pg/FseoaHL7OQCpK0n
	 2eEJJBQWEx992TT9+AZaCMqYnWs4ZdczAzECDhYz07RO+xt4HY3dXIgq0yiisJ205ptkh
	 fogonRuXtA0YVrRrbjjmlTWWRMFHXjSnHD+fwMVgoZnCAtoaDayab0BQcx18gaczdazw0
	 SH7yMeAKz2nFOPZwUXQtaDpoLmgTzb/i4YBPbbeqzuWxfD2H/OelZE0q/1iu68ybZUdUn
	 IcH3aNBIlFsV/dNsex/lOAk/wrsON5sMIYbhaJB1kiKMNxmp7chxPc3zZI1aIQbFI2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=fxjmUXMA;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4630C606A326
	for <patches@lists.linux.dev>; Fri, 30 Oct 2026 12:58:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4630C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=fxjmUXMA
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a60f9474c4so7122055e9.0
        for <patches@lists.linux.dev>; Fri, 30 Oct 2026 05:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1793365083; x=1793969883; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LpHGJG4BEsUziEetvXn6JA6Aaleh7lKdquZ/MLf5ANY=;
        b=fxjmUXMAsEfqR5MEGWMZnTmst6YBDTMFglkqTPPS2MuNa2A13fnVRzflUJPedX/o78
         EDYmSuTuuWkMmF7unR4h57vOhPqaV2yUK4RE6jCsKweRwkWMSl101PhBVWX6A3eqUbEb
         ilGAch59qZa+0Yjd3cwr12/iE+GBMwMXjhi/NBq8q0tkWGdWUSUtdjPgujxGZlzADe8F
         X/boUI8toG0kD//RF99JefAcIFxo0B9c7yX8784BJmx7/wZP7oW04jW+Vn0jshK8NFOz
         mtSnjwQq1jcNGvJb9jDeGij2zHt9UKyIXokZkAmb6Kb4dye6yJEKkAGsM8f9N+N9J+yG
         sCUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793365083; x=1793969883;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LpHGJG4BEsUziEetvXn6JA6Aaleh7lKdquZ/MLf5ANY=;
        b=Omia5szG9ymAplTRUvXyuA6j063qXPMDajL4iRuZxQiEvNOO86xy1AYpGHTYkZWnlL
         L2g6ICMkzBR2IWyN01AQUrUgJixgfHiF4v974to8yp0IMgAqAnOagCKs0Hzr/SHXKPjO
         /cJ6TnPhlug3sUH8JtO3+FuPd6AvNAi/h2eJl1viOqRlkjRrVQyyHRnpb9fzpAiuq080
         x8cQPBAbvqAiYxiaLzWMDUutcKGOJTRw4vwhgGJxz6w+hftf/3x+rAlOL5TYIaeDIR6I
         MDHRjAmQO7p4LpZed2eVY+z31wQgOxRhmqSukAv6BjpnN2SQTa6xyjOZ1yLNOQNfpmik
         LhKw==
X-Forwarded-Encrypted: i=1; AKwUvBzNkaSuGSPYczGjPH6YApqHsnsNnHrsBuNU0nogh6i2aFiVApKhGr52UqdBWEHmj8M/+XVV/cl2@lists.linux.dev
X-Gm-Message-State: AFq9FYL/o0l6phP2GUelwqFbdCK/ZIqDfGncEDRyy4heonEWB5uzuuIJ
	h3oN2+6QgLVAXWfU1cX34NSE/HGE6IknNLbB6wiMU5dSxjFWO6d8PDk=
X-Gm-Gg: AYBFou3vDFm092TxXSB/44Dwc5yAXcLSQhMaRgySn4d3bzqyXIxE3Cpy+J50fN1+eau
	KWQPEWiys7/eHzO434h/raxMTe2fe6+V46IR/q8DahLjW1+u+2c0skp8Wh/eGIhFOzf2MOjuYp9
	pkQgKns1ESCqna+UNrDvxKwITA465ljRZvRPFFG+/6G4kNkUj0mt5antaT8esLCU6gx+aAHee5v
	DGi5FI+N3Xs5ZZtckNpe//q7qsj6jkN22xiogiqcsqGCjCI+gPEkRKCJDWxPhSaC2DXcYnvWEWn
	cxmGl1gC+1cPvy7QbQt9hMky464ouQS8yAKpcBvMyJrjBt0ju979XMuTyuLrD2LL5wDuM5elEsu
	/dgYs/EYC0jUXXNEskibLI8oJMFGIsQGWqfbNsB4BKdyAtxzpogMEESxVzzkh/SHP+40OBXA4NK
	nPQALs4bz6AhQY6ef4ZH+oi4PcvzWWfeHp0TIRhekuHeGAlXoeK9I0BUDjqwcZSuPrtDCDeZT1t
	IZvgZ5Y+SyQUpdW++ZQmvygYIIcrcZQHg9y414cOltvkp8wXBu6GHEI95D5lpoKafEtz2biOa3F
	pOtF5zcMiCf18GgIrrxQcdz724XMWQ1bhPxFTZidNvGBC8RScw0q3OvFJzZFxOqNOZGeAZakGRw
	OreM=
X-Received: by 2002:a05:600c:1910:b0:4a7:4697:dae3 with SMTP id 5b1f17b1804b1-4ac17a360d9mr51142165e9.24.1793365082439;
        Fri, 30 Oct 2026 05:58:02 -0700 (PDT)
Received: from [192.168.1.3] (p5b057761.dip0.t-ipconnect.de. [91.5.119.97])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8bd8esm3027169f8f.42.2026.10.30.05.58.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 05:58:01 -0700 (PDT)
Message-ID: <9a349321-21eb-4897-a897-74d6d4416138@googlemail.com>
Date: Fri, 30 Oct 2026 13:58:00 +0100
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
Subject: Re: [PATCH 7.2 00/10] 7.2.15-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261030121255.257615100@linuxfoundation.org>
 <e24362cb-bce4-4a9f-b9f5-040aaa2823e0@googlemail.com>
 <2026103019-badge-android-5e34@gregkh>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <2026103019-badge-android-5e34@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.10.2026 um 13:51 schrieb Greg Kroah-Hartman:
> On Fri, Oct 30, 2026 at 01:20:49PM +0100, Peter Schneider wrote:
>> Am 30.10.2026 um 13:15 schrieb Greg Kroah-Hartman:
>>> This is the start of the stable review cycle for the 7.2.15 release.
>>
>> Three minutes after the release of 7.2.14? Really? That's, well... ambitious.
> 
> Yes it is :)
> 
> I want this to be the last 7.2.y release, and everyone move to 7.3.y
> after it is out in a day or so.  We have just too many stable kernels
> "in flight" right now, and too many pending patches based on the huge
> number of bugfixes flowing through the system right now.  This is an
> attempt to keep on top of that by reducing our release load (and your
> testing load).

Ah ok, understood. That makes perfect sense.

I was wondering, anyway, how on earth you and Sasha manage that immense workload. I guessed that you must have, 
together, at least twelve arms and five heads to be able to do what you are doing.

I have to say, that I am damn glad that I don't have your job! 😉😁

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
