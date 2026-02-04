Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2CD18A6CF
	for <patches@lists.linux.dev>; Wed,  4 Feb 2026 22:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770245352; cv=none; b=gPm0PmwdbZ8HAj4ihfU1YW8V/CVu9ZIbtwKomt+DJX9fnsTmezHBJNBDN6GXMuV/5SOqQXl3rlT+JfNzRsrNsEhVE+TjriZPHoxE+mopB++w8fTRrVjKxeA+I6pMAR9E8hepUZDj/meJMgrsBUhL3sVbbkHA92aD2god0aQ96Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770245352; c=relaxed/simple;
	bh=K8Ia9lTuVxFlAkgP+U+4P9KlYj6mtvmDyAoZ6tK7wbg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qhRhRoAGHouKzB8VcocaTdh42PfS5QBRHTat+lQpZggaBAJA3+DUBR8L/9bOJ7H0ntQ25Lp46vRt1B6IQF04bnUFiMpqJYaGS4kN687MjrLshFn+i5PdbXh6rTu89epT7gPfn5/6ITE/fULxb+hGEVj4aaYvL3xEm1o3Oke15pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Upw2ONyP; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Upw2ONyP"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-480142406b3so2371675e9.1
        for <patches@lists.linux.dev>; Wed, 04 Feb 2026 14:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1770245350; x=1770850150; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uFSXRzFkvPUDEYf1jFMVqisnrtt9GSXABprqdw3T+io=;
        b=Upw2ONyPibwABjEEB2iSB6o7+rBlZeg1u0p8a5k8emETxQNErRSjuSfcitqVy0gHhA
         /uOajrSvPYzzpLq1NPElW8GutAaSZkRjCynim9t3yuk4D2J1GoeCHMErTOAO5XgNdeAd
         t0ygyfI579s3YA9yl732J2CR4p6VDxjxNr9xvDAcSKzOVabcNqdxGiQlZoaH5t4oWOHj
         TBXFgf1UcVC6BHUl/+3MdaLGzciQY56XwEIgqlT84kEq69TN6gkchXpsFoD1XHMJNtO4
         iOiBMW3HqBZgzonNR0c0RuKEa1GXtaGpONDIRrOz31eiqBZojMlDvvfq9/HVVQcNT0hA
         mjrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770245350; x=1770850150;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uFSXRzFkvPUDEYf1jFMVqisnrtt9GSXABprqdw3T+io=;
        b=iMKKh2P+bPdlKIq27e3mbh2NTWQUrfNNMWTXbLVCURWXx/Rd/Bmf3cZJA8rdEXsqB2
         3x5/F3apocwJxPD9BNvuXPctlZ+p1nUCzS4nfacS31zIV51/OhGMQiVYbY+nn8vUilQn
         bvYXN+ZqNnu8g1H9CUTNZJxq0zqDHaJEZ+ae3i+TwnhBXEsC5havbiB8agSl86HPk/uR
         Dd4dYkLK/QvmCDEiJofT+gosZoJm3YRiKT/gZQqdw3yBtctd+IjmHL7OIy7Jwo4Mmv2B
         K2Fsb4nrWOtGg0Xzmzcy7AUQqF3HszBjkBvSisEugkIUmV3YLchYBVwkxDMxxNycj5Wi
         Zbrw==
X-Gm-Message-State: AOJu0YwUXbaVHNrVLB5yxnLDN/SmUTaFUYso4yPcZKsarUF2mQpB5KAf
	tCKy1lSHXHVygq8V1yXXh/qvAL7As0PfDnjxc4/vqg7dPRkAlvPbmNQ=
X-Gm-Gg: AZuq6aLOcQgJjfrMiTSAgZWa/i5uFg6qMzQ8QkFJQoW/P/tdHDb7RzJnUexFFir/Q+j
	4laCyjAReFmz4vWHDMZ2iNOisFnyzpMz8POv5iuYgBivW5CNh4iQbtrFw9VfQmFiNkDsikeqP/w
	6f12rhs3I66p5RM25KZaHuXGXW3kb/VbFQF+uKVosSb2+gYVteqIrBkbXe/zG773pfzPRqU0wTO
	LJUeevH5+hxCa2pS+G3ppWa/xWxIzo9phy11vWoatcP7glEJP5R5VlOUxuHz9Ufcvr/WsYd96IY
	mPDMtIXM+No7ZoDwUpNJhnxcMqqlb1XnVwIgucUE3ma+f6hOoY56IlgH1d+izCyL5G95q01C6MG
	Rqz0y0Yk1cCSGQDqWQerZqHUrpTwRmJ/2uTn+ec+4N3/fAddkEzl56PM1f3ln+ovlYel4YeI8KU
	ehqs5yL+m5OlD83lhUJyorOgWiK45BbOnhZseQpvkiUjxJqNBFyRX98/oExCiDOQ==
X-Received: by 2002:a05:600c:3b16:b0:479:35e7:a0e3 with SMTP id 5b1f17b1804b1-4830e993349mr69936875e9.30.1770245350163;
        Wed, 04 Feb 2026 14:49:10 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4d5e.dip0.t-ipconnect.de. [91.43.77.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4830ec4a5c6sm43932035e9.2.2026.02.04.14.49.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Feb 2026 14:49:09 -0800 (PST)
Message-ID: <ca2f07a6-c098-4274-b5cf-008692949c62@googlemail.com>
Date: Wed, 4 Feb 2026 23:49:09 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/72] 6.6.123-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260204143845.603454952@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 04.02.2026 um 15:40 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.123 release.
> There are 72 patches in this series, all will be posted as a response
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
