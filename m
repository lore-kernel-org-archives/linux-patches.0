Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91B4199BC
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 23:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760396569; cv=none; b=ZpvlbeD/Q0yRTGFduCOyubuRVaIVFBYaR0mG3up7t4sWs3LTlTA7dMVj/NQnwTdNQtd6nwZ8V+xAK5aA3ufiACSqy6AmPmltoBlYH8ljJvmoLF2B+cNzqEZNnbNIGNk7P57vr/OfMRscqCGo+uSp+XBOz0spwKAvqOdzWYYb7h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760396569; c=relaxed/simple;
	bh=NN5Uhc/H7ql22G1CZ8MYhKGMzprQGvu13nPfy/soR6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tkSY+RSV5/1ICGXS2ZpXJ0+zWmjHIVAr3QzwRCmF94B1B98YW4eMyqE20ZinHW9Wi8c0hq4cA03xmRI0YZAUwbd2I3y1bI8DFDKiTZetubTzsmM4LZjsmhDMCFml3RiouuxKjvdVav/0yVEAQlFO5330KMqsSnURjx079Ts/HqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=knAaYQtw; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="knAaYQtw"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-46e42deffa8so44338485e9.0
        for <patches@lists.linux.dev>; Mon, 13 Oct 2025 16:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1760396566; x=1761001366; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I/couXEdkLhLPr9L+MDSsns4M5kv4pWx10gdCua1dck=;
        b=knAaYQtw3s7aqrAusX3EJS2VWiKgAOonuCBkegb3Mutk1zKssLqv+m1T6tPZhtrCt7
         X6dQu0GBjQ77FpbwqfzHZI5fg2WtEYYXVnaRfs4TCJ37qUIXPjSSydMYs1mg0eCnmEm7
         7VU79LPUJ/9kDWS2lMrKhUoaR366F3QKYLVYaYSu5oBaBeEzzJ6b5RMce6o+lKtrdhQz
         YXJnZIm9MU/R4nDWPjm6yp4gca5suBvUeLi8p6ASToNTak/yn5xoFvyDL4jTGHQH546Y
         tiHi9jfC0y/8KjlNs5RAbpiMvb6jb2/Gjdqh8+2FyoRud+2b40y1KnwWOA812AhGG5ML
         dnXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760396566; x=1761001366;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I/couXEdkLhLPr9L+MDSsns4M5kv4pWx10gdCua1dck=;
        b=lT+WxqWCdfyC9Fw4KS8IAqjluTzDfiQGSev48acRRosXYLsjPFY6ZO2K9QwIljzoX9
         0h7D2eMLOkx6pMDI0G+nHCDwyi3Mgpt7jY0DU+JHPSu0dj8BdmYoAZgn/8/J7s9W4V9l
         WrgPrTygD4F8AJpzQxx2wKNJeeeh3HZwQ+CYkd/GQ753uvX1gLilUcM9t+pUK7Hj9OJu
         +3ih7tBkppbXsgmQdxR5gHlG5VWzqzk+6mYfaqgtf2ghEUv+Go8YuFEAHucTHFiOdP3s
         Gcbv4qdULpxMkCxX7CP2aLJvH4kyin02dXW5b8W/P21QHJNtf3yO430oJJMXKpoDl4fC
         vO6w==
X-Gm-Message-State: AOJu0YzdeSU/adksFMnvKlT5Bb3Jk+nWtOTaa5LcIgqeaNb4GsPtBZnT
	WKQBEBr6eZUPFsXzoXNYSvu7u8koHbCM2k28j0/KMOXtflE/95C7jHA=
X-Gm-Gg: ASbGnctg1LU7VH93HKgOUQaDNpZPhsJrFXXTeOED7w+TN9aTI8Ffcd4iWUtsftlD86Q
	LwmnM7bA5+0qcFMuhJjzu3QHfsqTpY1ip7ErUrC3QBEpx2PuylZW5YBa2NM+WmVoMEMhh4ubIaP
	cTzvefbyG2H+LQYmvWahztPGwz9+XAwDsxzmU0a6LaC1R6mvVahuJzSHfjOPGeI+V3QnCdR6dC8
	uLLsEpQoRkqHs4v/YHF0cdcAtXfl+TmbfpZGnFCjZhrRZJj53ByR5HUG1VC8fyveecZNCanRFWZ
	4HdcpYip1AfURnCHpbWpyFs14rzmOT/yHdE2rn7+hGSn/ZqR5pQS4ccKDOg92L4DCUrKWWYzVzI
	caePnwL1Au6zPDQyN1bkDoLcTQjeGhArFt8ZW2QKKBNJ4XJMFx9t42JotUASuvm4mdRztAQTfYr
	tdX2NsZxC9/CrBBxHEEdQ=
X-Google-Smtp-Source: AGHT+IEvSuL2pcLs02ff6tDICDiVy1cIZRV5hog1G8bH+8Au/ePi0Nv8ATYYDvBtFD/LFI+EZGN9Og==
X-Received: by 2002:a05:600c:3f08:b0:46e:4b42:1dbe with SMTP id 5b1f17b1804b1-46fa9b075f3mr172090445e9.32.1760396565972;
        Mon, 13 Oct 2025 16:02:45 -0700 (PDT)
Received: from [192.168.1.3] (p5b2aca8d.dip0.t-ipconnect.de. [91.42.202.141])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb49d0307sm205739165e9.18.2025.10.13.16.02.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 16:02:45 -0700 (PDT)
Message-ID: <13ca47ef-e5f9-4339-a94d-0eef595d3fb0@googlemail.com>
Date: Tue, 14 Oct 2025 01:02:44 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/196] 6.1.156-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251013144314.549284796@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.10.2025 um 16:42 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.156 release.
> There are 196 patches in this series, all will be posted as a response
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
