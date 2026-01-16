Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5526032860B
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 11:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768562610; cv=none; b=p1urZXla61qPIUXbiOq6sOJpM9nsYrZeGE7P/83TH2NYoA3OVunErYTTdT5gzPPLkkj/8KQwT8d7soq5K3XeznO7T7zlBj/tVJzo2iOywkeTcmtgmjqCPoGfHTjRmOvuTrGtZNKVaTgILngLjjnpUsXzguuWYWrTO4MkkEf4JB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768562610; c=relaxed/simple;
	bh=DU57XOxJdlBprV6mgMT57VeEOn/qjLaetAEwP0bfBSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gPFku2+dUkp4vPOZueoBJKX0yGmvcEScSxcv86fhbdLfOncI59YCNMhUiRErCcCYlDuHnojzS5XRJzHKi/t/nPmgMejjE9LhFBIGCvIRJQ8X5qBB8WT6LdWGhTQhyK6QiaLAwCos0DFc7sVArDCKa7mmXwLJ5sHMAWesd6VSpG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=D60iBP5w; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="D60iBP5w"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47d63594f7eso12908755e9.0
        for <patches@lists.linux.dev>; Fri, 16 Jan 2026 03:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1768562605; x=1769167405; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kVre84BNbV/mzkw8hJClwy3HqMHWh5/7KfER72W09Tw=;
        b=D60iBP5w6YuefjVWShLG1P0aVxQ91SQkFO8xjwTOb//1w2mJ+3JH4KPxT+Ao+ZX8QP
         WhSpNCd3Gh1P6d/jIV3Bocgmm9geAp65jjbuoMrAWLgOysYI/Mq5/wffeE/tVhlI+haT
         x4oli6fy3UzX0G8WmEUyAgM2YLxytEjpHXqmHfqbT7ZTQVvA55VANeV/guuWBA+PjHEt
         hJUpzxYJg+CsnamtLP5V73TveXrJPRG7hIXzEUx2QsaPF2mKMsuw4ZXKj6lrbYD30hXE
         C+79ubLQ01DNRZVK++7hUUtRNGLuqufqoLYmbbnE8AwG1vT8kt4GJ/rVCgS/UCGTkHsh
         A4Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768562605; x=1769167405;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kVre84BNbV/mzkw8hJClwy3HqMHWh5/7KfER72W09Tw=;
        b=rpSSr0YfnMx3DkGf+dw2/YiCCIEM/2Hgo2bkxxKkXedzzAPfmeFAfulusGnBwwuwIC
         4XCNRE+mRm5NPMHfPq9Nd088P4tbKlb2RDKrpIcplomCwBKmfzqG8JdfZxvuaPti8+DG
         kuwKJNbz9tJEZfPWX89vPGdcgKC11Jet8RD0yjo/yv9SvgVuBl15QEX+BKHCi0tcITtw
         iGwzhESji+NeBckueycIw23XVXW6RgdcMoerMTznwh1rxrBhlEooG5xaIc5oFzdBCvWO
         KDQRFi7sJw0+ZxKb6oUUV5lXfO28Nzrxs4f9R2IrxEyEdI5uuKFyLoz8SmlvdvtH7MB6
         k3Ng==
X-Gm-Message-State: AOJu0YybhnQnrMs6lEEW6W3cLuATaYQJV3wcwSnvsinfreV+U8YdjuPs
	lX3trVlyf9aMGt3eiKbcgvd/K3810Jh1bqHvmrjcyiKze4Bt8/t1x48=
X-Gm-Gg: AY/fxX73vzLTRxmKMzLS6htqVjrTfMEB1hgpMC7MpFCV/Q4PdCgTaBRtSkjhLhzsSJg
	YNxmeJX5VK6zVILZJ7vIlCSEYYJlSVS6hPjV2ixcCw+rYt/Hg/2KYai+9A3Zm1ZxbwnI2DXuJ2n
	UcmlNenhlbvtc1YeJKi9XKduxkPxA3WPYse9lbJP1zR6PAMAlN8p5XW7u+BEqcEu0Voj0qXj1TI
	rXv9HVkBkJtcjm6E5H4XQho4f1khLmwgXSiiqSVkaWB9iIfZaOwF42NpKGbnzQ7OXIN30trHlp1
	FnYTjt9ZDdJtS/lHdhCR0rBJV4fFGd8rPn0bGe4LIjo/m8ltu5kOmYircan23rurQzhpFrXNm+a
	oK0QNIu9BSpcc8BFY9W97vSsXC3EzfxCTzs0IHYiFzUQUFo20GqNPh0LGuL4sjCjp5EZivC0asS
	R3L6gOhdwEzWOEl+88mdiPHHOpodOXA2DSuKMm+6XMZP7ANxNBGASusVg/i/BjIi+W
X-Received: by 2002:a05:600c:1c13:b0:477:55c9:c3ea with SMTP id 5b1f17b1804b1-4801e34fab4mr33658435e9.35.1768562605138;
        Fri, 16 Jan 2026 03:23:25 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac8bd.dip0.t-ipconnect.de. [91.42.200.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356996cefdsm4617486f8f.24.2026.01.16.03.23.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jan 2026 03:23:24 -0800 (PST)
Message-ID: <520a8e4f-35bd-4b49-8b7e-78b2552961af@googlemail.com>
Date: Fri, 16 Jan 2026 12:23:24 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/119] 6.12.66-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260115164151.948839306@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 15.01.2026 um 17:46 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.66 release.
> There are 119 patches in this series, all will be posted as a response
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
