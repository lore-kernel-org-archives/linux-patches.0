Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6EA3BB59
	for <patches@lists.linux.dev>; Thu, 25 Jul 2024 19:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721936050; cv=none; b=oyUrF9q8wqvxAfBa3TCsn6MY3pfgxKB8I9bVfze1dhtdQtVXE7Xqf4yaHlNuKMX6hwBzyGoXItu/S7TEfNrzm9JFEeHHWNuEX2Gh+YKen/H/yRQbZqjQ+N3cUxIHec8ooVYhiEK9HlfM3Bz5HLCkCIKsksAXaLq93feHFDSKX1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721936050; c=relaxed/simple;
	bh=nuEF+ueY+qCaR3wxBl2p/zP9AodnMWWVUdNGyiE+bZE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WVp2jtR+jqNBO+ia1RGxXoiQi5C5IDvt7xrXztgfX2P4ObQjlYXh1A7Lob6mroDlb7kYB8UX57OdejJpJ08q8oAHblUSyQtLnn5LOxisuRbRnnQJe4JThyG/y4qpwzQsilE4QJyy3RAwt6VIWsxToBXXAeSjJUei21rTZe9ayKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ek2oWJag; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ek2oWJag"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a7abf92f57bso121652866b.2
        for <patches@lists.linux.dev>; Thu, 25 Jul 2024 12:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1721936047; x=1722540847; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TKzRBcLxbi7v8r8TixMv8QpP93n6qhBc8NhHev7Tm8s=;
        b=ek2oWJagoTWNNT0SiLuWzGJ947Y7iZk7qXb2haeoMu28+68YthvCSje+7GQHcGnKQo
         zScTASUx7pIQYkcrLElrsqrNp10UTT7FBicT3nIH5BdcUJAmu7wQpK6A6ZaBQlpTEvdO
         E4cUYLyU2LfkUBXedPktcRMgqKBaGUC/wcG+OcmrCzBxls3B4X7tuHZv0m0eduL+YTXH
         lGgdn8/P6uQJNf9/4i7htirWo4LUZl0qYZvsUPDKbixBvptVdQ4I2cC6buiHEVvKgGnq
         bSTYcCFxGEadJqeL0k4EmHIDgpMa3Nn0yAzLdB4gpAVgVXxUVsdEdh44ok1EdH28XdXK
         1O1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721936047; x=1722540847;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TKzRBcLxbi7v8r8TixMv8QpP93n6qhBc8NhHev7Tm8s=;
        b=oR0a1ptsGKNn2Jteh6K+3iwmrYLeQOjBD52j7cNJ6O7AcIoeBcaDFsmKmcE86/phpa
         RuVUgFoRZTchC0R9gEC5it4YBlIhHc42wqNLn+oAm/Ynt7+Icep2RaOJo8OQRlfkHZDw
         0IkefMgkywAW0LG/tnvZavF5hZc1Oz3IjBbi6uo31Lf/KYgQgGaxaEMxNNbT/LFtITDM
         GNqZxx6/tv+9SeYLA1CVu0F9BiQ7Wp3XcxMERafg/EDteCskDVIdpqaFML8hjD/+G4go
         kfw2iq7XUJNH6mQuMoTnQmb+maAFkekItM0OPVdFQ3F9Nz3BhsKHspXoymX1SLyla4ob
         WQjw==
X-Gm-Message-State: AOJu0YxO6i26Z67BuG/MmzExBKdgPfaExZChL9/UAz/Na92mpfyidokR
	eYOgoieIFP9hp7eysQ5j2p7JzwbkBRXiUENbDgO3A2R/A1CxL3o=
X-Google-Smtp-Source: AGHT+IHQ9DgSVLg0SR11LNVkjXGrRNnTHeo++3Pv7rbWxm28x+Pr+e16khg+pAl2PQKF+OgNJjy+8A==
X-Received: by 2002:a17:907:7b9f:b0:a77:b726:4fc with SMTP id a640c23a62f3a-a7acb39bf39mr289925266b.1.1721936047021;
        Thu, 25 Jul 2024 12:34:07 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac836.dip0.t-ipconnect.de. [91.42.200.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7acad9127esm102302966b.149.2024.07.25.12.34.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jul 2024 12:34:06 -0700 (PDT)
Message-ID: <88b9b0be-8c70-4c68-8dbb-a2e1f262b67c@googlemail.com>
Date: Thu, 25 Jul 2024 21:34:04 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/13] 6.1.102-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240725142728.029052310@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240725142728.029052310@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.07.2024 um 16:37 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.102 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
