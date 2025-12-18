Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FFB2459D9
	for <patches@lists.linux.dev>; Thu, 18 Dec 2025 04:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766032059; cv=none; b=Os3GhdLmPLU9zmP9QDlczBqlDvyvz7B0PYmbRx3KWtL9hyQjUeGCtgAYsnkFPhe+KUyKc84KRuwrHVd3KwvWmxJC31SRni/aGNs8Fz+DY4FFISTqhiZ41wCp8dXVkNNfqkNyOQEwkJouhlxwXVkr/W28zVZqMAfFndC6nTOl4XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766032059; c=relaxed/simple;
	bh=A15OPCRGZIJerJ1BpTiMy+M5eIcexW7rO+e7dVJ2RlI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VrvYOh7XI7xylDspq18FQTkrchzfo1Fh1+XdkNbqv8luL4i2VPRG8QkU8oaOLqo0SUrAYRwQIBDr/z6t8QX0LAM6CZblAFPYlekO4Ls9hkdHvwyqyB1Q7LO5Y0XqcYtLAVwO/oqdHvGKZ2I15h5xVNBX8GbFVu+oBK/nUctNlBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=FHM1mmIg; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="FHM1mmIg"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47118259fd8so1571735e9.3
        for <patches@lists.linux.dev>; Wed, 17 Dec 2025 20:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1766032056; x=1766636856; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gtZ7fSurlnkVytJ59b1f3UpXuglou2FwKhDHbnKcqSU=;
        b=FHM1mmIgNopHrxfpBhDAim5cg9+AqJOPMrQ4yB3r420CH9TipiD28dl0XZv/+eTdkB
         PMnDHYTOecQXLNpR0RrzhanQ85HeV2tmpWK16q906UdNJ4DUdhqNTaCbi8YJlhbW4BfS
         Y4HU+daerRxNa7jSFR6CjP5dnLvmexFMnhT0JYdjtBGUxUf65E55ij0b3gZPV1g5JZdz
         RabfJ0sjjgtbK513I6tZUEgi7PeCxkQUnQia4wZeTFe7OkGbMGchagm60syGlggPaTKc
         LS9oKSjhe0dI2npt6S4GeOzEbspU2dg9qEyuOxWsQM5JiwRZECv2X48JTtaJHSvcc4pm
         Rj4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766032056; x=1766636856;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gtZ7fSurlnkVytJ59b1f3UpXuglou2FwKhDHbnKcqSU=;
        b=AOfPqy552vyhFqwSfsd1VUIDB5QqZ9IRyQxpi18ayeF5hDdhlU14JpPPLF88Zd4Fg5
         OIiswcWil0BC76/V+ffXEV7Ps3+BCQleP85ZUCNvrjqEmpwH5fRB/7xjcQdkdKK7etp4
         penm7K7wkkUErV4KscAf869nEcje2FgxOGcdC2L2XQ5IcuW1D1dlhNPd74Zl9GC6lAWl
         PLPN31G67hXe8Dc4WPwB8bq17TFGsh/zfq4rhLwi+uOD5r2pbAzb6rRf7qvBfrOn0t3D
         RVAKqgwRb26TqpQjC0NFEnpbRFg2RttyZYJWLm6SfgrSYsf6fIQrBhOe8wI2hgE4T71b
         /gTw==
X-Gm-Message-State: AOJu0YzdiHxH2BGXov3/vxLa3OTDac3a0WEDm5ptj/WgJh4vyWvJC8wK
	UknQwqz4kwMrGvUxSOSg8tTWiXTh4vYi2hUvKMqppUOpmFcXU1Bv+Vk=
X-Gm-Gg: AY/fxX4g4xb6RI1GDv72IRBKghMdjL4fqD9ij8iTEJ9y7hHhn3xP9MCpHrVU3v96FEW
	k6jOYH6SxYr5l30m6Lu5Qmvz6enSYMuzsMSKIcSxMlw9qHZ5feOH2kYrp8Gv+axrio9e8TPoVqj
	eZOlnzPS+dvoIKpt5ObkXKtb2PNexKf9Nzfey88S73KkPBQUtWSaaQgRZllaUHgJ+ck9mTS9fF8
	4FaTHZ5Q5soD2ZD/SYGI3af6hfXWnNQ0suw+4AdBM4v/4jp56GoNaGGHWRow/nb4sOv+qFjhwFh
	AlY9Czx0krlJo8iMfmZllglW3ru1l+YITHaC5m3IpFyfjqjhr0/pkx65qN7ilZRDCOiDO1owhWP
	L6P/cBHW7g1RGXZobcTa/LRmib5GIrsjizQbiz2dgHS+mHc5FfUncRxGfIvtvWPYIxN0s0Gq3iu
	6KElK4RI2o2bCzQVj37OVihdjNLXsYl6TveIV0vnrMkSp6XOjsaW3pSQHShU9gIVk=
X-Google-Smtp-Source: AGHT+IE004Pthl97ocz41xl/+e+FDIlGp7UlU0Ni94x1OIGlN0RVzcLlxRTwcBzPg/cyfw8gcodUTw==
X-Received: by 2002:a05:600c:190c:b0:479:33be:b23e with SMTP id 5b1f17b1804b1-47a8f907d4cmr230638775e9.17.1766032056406;
        Wed, 17 Dec 2025 20:27:36 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4078.dip0.t-ipconnect.de. [91.43.64.120])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be3a541d6sm5534185e9.8.2025.12.17.20.27.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 20:27:36 -0800 (PST)
Message-ID: <79c6617f-6ed8-4bdf-b44d-aa2086a8c5b0@googlemail.com>
Date: Thu, 18 Dec 2025 05:27:35 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/614] 6.18.2-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251216111401.280873349@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 16.12.2025 um 12:06 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.2 release.
> There are 614 patches in this series, all will be posted as a response
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
