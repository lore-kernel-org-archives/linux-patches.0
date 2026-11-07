Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794070646;
	b=gOhtq7jtpvXsg/dvZKMLnF3SspNTkk0t0bDPBmpvmu5AMTCdTAbUKBOc7c9PELmNFwLL
	 jqTguDmyncJAcw7kR1+vH/alZS9AAP7E3T7eRYiVtAsGNVDOplReMKRSF8xax3QxYsxJf
	 I+UQr3nTNOv1uORYZ5E9KrkMZghogNMWeWj+vQcoyiSPPM8/S20UC5lCbjgSFhsxBur5x
	 nklvVCcCFSV0i4gwH4s+pZwv5e783OOk6OzXgFqhN94H0qlmfYb4KTyxyM0pTRJDs2gTJ
	 Ht+Q+czefNgvfxXUq0ldiGb63bigLPQYcILkTihMARuy7hOTK/lt6CjFwvfJHXlHQnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794070646;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=dZ/CQYskRN0JeHdAleff1h6SJqJJZnuoROXlSHd1Wv8=;
	b=jy7ZyJpQ02vSySfDfUUVOmeTRubAjrOlgEcLIVSEmuvTdYtkyBoWQoQey8qk/E5NiaJ/
	 fWbmC4iYRY+ZaQLQPtBfBPvkn//resrUSKnWGVWSnl8trr+iW2YhynmRqRj5phv+HiO0R
	 2ioqBl3PLgXN9MSa8HCwJ0mL9IbkLk9mgMcW+wzAucDuQ2h2mAir4s+FdygdrDzwPO3Hi
	 ZqOo0c1xWj9OSW29zFMeiAIQcEzGPDlrSyIq+jftAT7Ndxkr4feiyiJVWi3H1S/y+wcI4
	 4hnNdqDGPny21reoobJaFEbIFaHZrEBaL+aiWcF9P4iZiADblXSFX/y47vsEnn0xnig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=LBcnEPia;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3239B606A33E
	for <patches@lists.linux.dev>; Sat,  7 Nov 2026 16:57:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3239B606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=LBcnEPia
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-491971ac844so1423318f8f.2
        for <patches@lists.linux.dev>; Sat, 07 Nov 2026 08:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1794070644; x=1794675444; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dZ/CQYskRN0JeHdAleff1h6SJqJJZnuoROXlSHd1Wv8=;
        b=LBcnEPiaQlzCsjdDIWA2GTs8f/BqRXzfkrxlvfSemQZtZ5Z6ZntqDlx+85gcueiU5k
         oorBka0z/dokN/UQ7T5H0Ogll454ukqsdVJHYOyPf2o5Xj2RBSKK71hzm9aszorqwyD/
         sRRvfDXdzZH1tiMIVksiJrZ9KqIYMkqo9qLjtpa8oXFH5slzQCx5KT3IJfJxNuvkV/iF
         DZTBWxdwSJ7QpPYPYSuY8mVjelKbjHojRu8LXHXgggrF3Q89spqfaAJSihss+c0UVuc0
         qk4KzKxClOYQciR4p0PqjnW+N6qupRWHg5baWu3i95EmxfgGybrBdIOJgV89TTyZcpgQ
         ODKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794070644; x=1794675444;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dZ/CQYskRN0JeHdAleff1h6SJqJJZnuoROXlSHd1Wv8=;
        b=0guC7AxpU4S9l/Wja/rB716JgR3CrmAqhpgzlhRpbWskyce2Wq6O75ojH+7t9MQXx7
         zB2XJs8FHLbpoVPMMv0JkJnwgNZzz00SlBxCGdO5qGIUvoBxUGDQPBNGb4J7u9YZsDvP
         phcSvgvDsvkZxZ4zWvVN8DltoW846ytWhe7zid2QX0rOmTpFSQCIMLLEgzW5byMVSFmH
         tcj9RIlJVT1abK52TKdmsz2Qpend9a5Ft3QBadxAIrDjsJKKzruFTNcSSvA5i2Gfc9CR
         KvKVE80Wym0APL35P/W4BuhhAyz07IW121PkmtZQxSwiPM9VbFooOby885XtcQBt+/Ux
         BWFA==
X-Gm-Message-State: APuU4Z/+aX9MqlWQf8KzmfrLXL8MaNaxONBDsXtAQVk5opK5l7jJ084R
	98qH59+A5nU7FBYrLOQhVXCSmmB7EaAQI16db3SAEzneyqLxn6L4kgc=
X-Gm-Gg: AYBFou2xD7C5hv96xbgmY3zvUdpxh4mj+rg9/He8OvRo+JDlK9I7VPFuTWiHu7lT/tY
	AZPKq8USUBrKptP9Ldp2RA6Jh+t/rwCeS92mv0Cy8uOBdYw0VeABhIAgW+V5G/0Raz3zEk01lcR
	zFdjgsgzEsdeV1IQ1nJwg5jfg/zn6dPTjTcWpG1dzG0wZO0I1X9NTo3Uhu0DeCKXl7J5LrEc3HH
	IjJYjaCDTQijVwjZpGKjo9tm7YNYQh7S2mHSoUb4ZSJYV7PnYfnyx+p/+Xq6Mxzkj/mX/eVNGll
	koSN6L9DpXj83GdVwln2DiT+rnn6dmvx6mjQa3RK2Ehpt/A1tVp5741MwXE5A11ZvCrmeHbM+/T
	Ba2BkyJcQ/q46o4hVgcWKO5xcCJ/R8CTPym8XTeuMgRywmiqL0sRNL+gRIMHLO+YexFe8+LbvDk
	lFP+Ovxwaak2T68hqXDcMLvC2vSAJpNbm32HdbdeJs7I2lsqXmzcC7C/gA5oU8eAfgefjENDExW
	CdPLrFt0Mh2DzcakZFjgWs9oVyHmWNxsK+2x34BIBKE3GobgKFWWCLvOn/remdfqLtxH/t3j3Pe
	SnTnygQTButoXpeMZOogpekRuujub9qzQ1O2YN4n0V/4HfY6Ao7KQ2cxTYaXb1nTJCBaW2/wQDo
	bflk=
X-Received: by 2002:a05:600c:530f:b0:4a2:133:45e1 with SMTP id 5b1f17b1804b1-4b6dfbabcf9mr95721785e9.24.1794070644434;
        Sat, 07 Nov 2026 08:57:24 -0800 (PST)
Received: from [192.168.1.3] (p5b2acf48.dip0.t-ipconnect.de. [91.42.207.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b7efb1547fsm144188195e9.11.2026.11.07.08.57.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2026 08:57:24 -0800 (PST)
Message-ID: <2401f130-7358-4797-a872-592674a1888f@googlemail.com>
Date: Sat, 7 Nov 2026 17:57:23 +0100
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
Subject: Re: [PATCH 6.18 000/869] 6.18.63-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261107134852.069646174@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 07.11.2026 um 14:44 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.63 release.
> There are 869 patches in this series, all will be posted as a response
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
