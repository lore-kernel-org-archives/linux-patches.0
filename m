Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997FB19D89B
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 12:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734523920; cv=none; b=JYJnlj+yezFIMDJLTepBF8C7meQjlLfolj0cfSgLjigl5feWVTqXOSP7rhFDVpnr39VfC6WSHx/KWoWhtwPml0pfjufzbepbdCpRUuQ9lB7tK5ShBRscdIZZyAa+NL8omTSvgf7Ot7qEHGmMNvE0Km3dq/kVTcf4qgeylAlv4r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734523920; c=relaxed/simple;
	bh=/zbA8ekfT6Yg7vwovRTCu2YheY86bmXdbPOLhlF6tF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iNEAe+5nCi3axtVb4M49rhV+A0+H3s9r0mqgbWXIjpBh3TDeMGWBNc1LX+vu7kA6RIdIabcbVX1jE/KNKj5c92lt5Yhx+/leouzvwNacGWK+W+lKhFpmKzWboFQoXdIsAPUtka5wpqC7Mu/5P3xzjMpXkVnhqHMIIo9fwsjG+Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=neyTHQes; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="neyTHQes"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-385e27c75f4so4891630f8f.2
        for <patches@lists.linux.dev>; Wed, 18 Dec 2024 04:11:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1734523917; x=1735128717; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IXOgkLY3QEpp5R6E6oIMp3ZgUZIq/BejK1hXGswjBa4=;
        b=neyTHQes7eRp2p7B1XOtkdkFj4fDEA9o7XTwaurd2nb07yX54c0sQUAskPPE75amoZ
         wZ3O1F9HKOeQqihz3eq7vddRjEwsEUM5SrXTia+OxR2A3a4Vt7Di0BTKqlkUzvR0CgJK
         3Lt6dstfNzOFwCm0Mx63wpjG8EcQMnGbZsQ4DX9328XpnhBJUnw0yaW2vBNMY8lES2q6
         dM/f2zYn2N1NQODOmr6Y1/0wtf4PXoBnxIyWlJyT+QilzK+796aOVwRJTIlVK9/a3s1T
         kfmwA8CEqy5hQsajCSKTPEbXS/aBbRpvr3vaL4TKZrG2Y4ZT8CUs53W2sZu9y1m4haUq
         /UpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734523917; x=1735128717;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IXOgkLY3QEpp5R6E6oIMp3ZgUZIq/BejK1hXGswjBa4=;
        b=juy0vHCCVuFeLPeKltLDmouGbXocf0cx6G2Z7nAzpHuxPkX9V4pthn/fZuYbTXunTR
         f4bW73I28Y11Kn15RD42rzT0l6JxEY5MYutYJflK4h7hBTIw/QsYMnebJTSyqj25qwuU
         4jQZuce6O8BFrudL6UhAIV8BU/k9BOuFWgziugL7YIlSd1hZ/PpTQIs3gd5CtYFFum5X
         tgez0buEbJxqQf01u/CjTlJqDFH1IWLd86dwax0jms+f8NiZ55OWA43Ji1+wGyzko6Fm
         3Bc/41eNdN5SZiTysXsVa/DrCeKml5KCgOY20TmzNjojCMrAkZTmflIaknyecxVZOpoB
         R3MA==
X-Gm-Message-State: AOJu0YyRkpbZWPZ23isyXGrjJlnadnwWjvJjFcqnsoy/vR4p+5L/oXES
	5qDjYCw5itiVm309QdPMt/K7N41e+6Ny6yJ5Q3ZjfP+dr2WQ868DHgseqdw=
X-Gm-Gg: ASbGncsBPZR4M4/HcskwvfZBTwAg+nDYj+R0UhwUu4+qbcDLTe1+p9en5unsG8TZpbE
	CXzMxLN6N0f/lpEFhW1NL5yMNu50RVShGCpT5RlNXBhOIeri4p4p8/ZpJ6aF5b3/JKx8Tpp6nP0
	owfVMBkvIV7ucEvghjqVFqczCFX4fr/i7blMNmn9bu7vyHi57DZ+tUGNHKe+Q5xdXW7tLNaXSJy
	rLVfT1J+xzOK0Kus/b+E2xStYoZHJc753yZpyQUYWZ9YaWJFyUrdM1u43eoegLltUgZW3gZaGcC
	FB7v6c5+kH7j/YyMUBzjJ2WObBcLF7+7Gw==
X-Google-Smtp-Source: AGHT+IFlWDbq2DywACRzxSiIgR4i5L1qMIy+ni8wBkhorzSVfjx85HF2OOLHbRUAT0vspR1hAVX2bg==
X-Received: by 2002:a05:6000:4615:b0:385:df73:2f18 with SMTP id ffacd0b85a97d-388e4d9c44fmr2410030f8f.51.1734523916237;
        Wed, 18 Dec 2024 04:11:56 -0800 (PST)
Received: from [192.168.1.3] (p5b057eb9.dip0.t-ipconnect.de. [91.5.126.185])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-388c8046ca6sm14102477f8f.83.2024.12.18.04.11.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 04:11:55 -0800 (PST)
Message-ID: <e532646c-70b2-45c8-a449-841fb9daeab1@googlemail.com>
Date: Wed, 18 Dec 2024 13:11:53 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/109] 6.6.67-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241217170533.329523616@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.12.2024 um 18:06 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.67 release.
> There are 109 patches in this series, all will be posted as a response
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
