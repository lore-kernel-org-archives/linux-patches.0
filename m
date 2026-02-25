Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A212438F233
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 14:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772030199; cv=pass; b=mBKnbZLcUGEw4q3wnawEh3S+pa5s70VTZBGCrLuogiSWz/y9N/UGnK/8U9Ogpog6PZusQs4xZXAmllMyboeJOnFkryQjX4Z9tanGcwS1WjGcVHIE/iwFRBsLsTPM5FV0uOsdonJD0Mf4IdVshy2dNRq5x07GyDcgbiKGCEVDook=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772030199; c=relaxed/simple;
	bh=3o3jV1yPotn5Ay2C7EwxJyn8N/Xj/yz6IduDQ0zFG74=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DR6pK1JAh6t1VNI2A8kipVMFV3Pg6ZmvwI4h6AjQ0w5okosU2V1FKxtIDuBNJsJzwkrfMHiG9KW01J24h1gtZqHBVFPHhgbqqEneo0sU2FJTldnEKYgrELlaEET4lyTlkAIdy/yk9X5XEsqx95vexE623KL2jy7fx+j6thKKuPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=IxEJ1pTY; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="IxEJ1pTY"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b904e1cd038so972177166b.1
        for <patches@lists.linux.dev>; Wed, 25 Feb 2026 06:36:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772030197; cv=none;
        d=google.com; s=arc-20240605;
        b=ZMPuJyIiLNIW+9m7W/FlGALI0u04pX4uwZkk2nl/Xm8lsY20I72mc1ylD1BRYNcNFW
         KBdIFLupBRKaLDxmntvMVmv4H3LR2uRx1FoQjW5x0Oojb8gcRgwIKE0b5qBPoEb/Ytxi
         ggHW3ejk5bf4EEWMcmmm9lEQwK1FyBHj1xIlfXTMiLC2U+eGQbjXTSoUdixhLC+veqEy
         zbIFfJ/ZQ/ICYLL4ClrIWstTT0mJ1LDhTMRWxIGPj8gQajGcN+uA8plWTYUfDHOmkYqC
         J44g1qWPXp83iiOv+e1UwETm7wdX5KG7VhunboBliIMgnnlLI5jxLZZraUiNbBdVG+X3
         afjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=zp5unT2XQ1YJf2wpzP11qQXI2wzEEGxzhd1xDPuzeN4=;
        fh=F1XDvAwu34m/2PZdsur7PWqUDMgYJV1k2nq74u8dr8M=;
        b=IPvxyTBCgLVv7093Lvz5CR4YnJSLeeUwd3jQdGMQDWDAVDmlL2vUgjsi7ZSRwSKSFz
         ItjF95/Iw31gXvqwWRZsE1gkf79GaJK4jWabqVTSjl69h3hGg9Bc9MwRTJbm3DEal6sg
         tvOmEGWAdP07YLN+NaD36s0cFQrabcEbCH7bySZ25gq7Sxryo7lOKwdU3UqP9viCiHru
         VCDzrxV/jZcmVCQSrL6z80JkMmaGvDGyNde2peTupy65TF/2dlGV1tqICpEAAZMgCre7
         lA2PH7+J/xSDeeF5tKLmeLTrQVGEXrCEcC/ExtZUi38HrJHQ1d8igGrBbRUIsWCtrCpI
         YuTw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1772030197; x=1772634997; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zp5unT2XQ1YJf2wpzP11qQXI2wzEEGxzhd1xDPuzeN4=;
        b=IxEJ1pTYpJVXIbjr0JPAl4aBMzN1JELqLw0TrckSW7zIz3YjZ8DftDH6CdQ3tU3PpP
         mcTUij+bP5mseAak42zsGq0kMdR36fePWwjagebJ5T/YrrbBCW3tCH98C+aFt0f68RTn
         0WbKAcye+dDQxXwAp4y8TI04YkhnHVuU2+QO91Bq8AOeNl9enUl3ViDhIgfB1JtIEelQ
         DKw5ds/6HRwXOcWiuPNigGpHP6cRQiqHI6mdEde+3jYDzuXYgdZmaa3KhtZtLb0mR548
         n+AZGi/ZPrTXk0okYL/7Et4+LBeblWOrMLtQxC1w2lGPnwzFPZ9AIOTqgsv9FD7v+s27
         1KsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772030197; x=1772634997;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zp5unT2XQ1YJf2wpzP11qQXI2wzEEGxzhd1xDPuzeN4=;
        b=Ve3lugkYc/Slmw1Fy4XVIKiiHAsL7YO8IvbLIUYGqQyzMEYyTXFuhm9Hq/CtJk5KKZ
         B7Ik7nohR+k4m3p7yj2vldWAxjOF3xHlJAjsn9eVGpcP37njEhzDdv9ITa5giiC7DYtr
         cUQfzRVdQcLWew8i4JTeo0tpgXq/WhMAzRqZCIPCYJFI9YQ+9uHbK2zz1td5+NllvbJ9
         VZ1HMjcdjRp1Hp8SkWiT9P22D0+4i9EEpWn6cHF7XWHIZ8G1fJSq6DUWN1/JvUKcXf+P
         qq+H19tQGBZXZSxjMhmpbv2IdVjDkJbdezDw5IU6eyiYKlAll/+WRVdSa5j06jqO6TWr
         ddTg==
X-Forwarded-Encrypted: i=1; AJvYcCUBVRVygjqKUWBDowBlg+JjDQEjX3jtrkBf1LOwUx8AxflzXFg6PWo+lvMql88/NWmXmFS7nHP2@lists.linux.dev
X-Gm-Message-State: AOJu0YyLr6l32uChy5l/mgMIATR4fYgRopDaaHa9uOFkCNYGZhkFHZbR
	wbfd283cu58ISnHJmH1Njnf4wp1iTsnzWkHsXjdBwUwwh7VSVhGgjCe9NmH/3RABLosEnSiCO8d
	ix51sTWLTSerM0Ifswl7d/S69sk3U+R2b6dJpRHLjXGtU6Vh4EtZ3dzv30w==
X-Gm-Gg: ATEYQzxLQUTovJhBJxpg5mCIiDNV6sK76gEGqhjnb2Z/u2J04wrBN1BPmKYqgZmEh8+
	xHnc5AFxeA8rW+NOmVBXzbad22GqxFu/sNacVFHb13wZvMnfJEB14Hfq/9n6fbBjzRpF1vxF/Sv
	s7kvCaFOCewHavTRxV35QCJYxdUzYqcZeEbyYWYXqGT+6N/8Pf81P0ePf8AXvuvFPZ6DrwA+COs
	gRWvsDiMEZO4Tv2MoryoZoPM6pD2ot/bWmkN9j9uPXxIb5RKuzXvGKV6fJGqqoo2Jqdhp7mEr25
	IVdoGbULKh8L/AhEE8pM7tqKhnRwMoa5c9qN57CK6oXGgVQb0x3McBmaH9L3LxB6MJNoDpY=
X-Received: by 2002:a17:907:9347:b0:b8f:9d12:2390 with SMTP id
 a640c23a62f3a-b93517ece31mr28684866b.58.1772030196916; Wed, 25 Feb 2026
 06:36:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260225012348.915798704@linuxfoundation.org>
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 25 Feb 2026 20:05:59 +0530
X-Gm-Features: AaiRm51dFPxFAjtNDltCSh9T-PORoFUyIe-AxoTdzJjCL4PMD3axwmNmKN25HEs
Message-ID: <CAG=yYwmBmC_eT9iFznY2OgmZ0yaZ91GAkvZTxoJHb00F7W+6Jw@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/641] 6.18.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Tested-by: Jeffrin Jose T" <jeffrin@rajagiritech.edu.in>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 hello,

Compiled and booted  6.18.14-rc1+
dmesg related error

----------------------err--------------------------
$sudo dmesg -l err
[   22.068694] kobject: kobject_add_internal failed for lp.0 (error:
-2 parent: parport0)
$
-----------------------err-------------------------

.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


--
software engineer
rajagiri school of engineering and technology-
