Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A0F333443
	for <patches@lists.linux.dev>; Fri, 21 Nov 2025 17:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763744767; cv=none; b=O5MtFNl98jq5aHZ09WcNazGx/1hUTzQ4kGvdWvItlmJes09aIqqn+FEQocApwTLkg10Fi9OYaBwwJ2otj1cqaslCKY9t2OzrqfJbc3GGUumAZjFq9P7AwnIhY5ND/C2Wrqe5X1Lq7+yDD+FF0ipylwnqZ+GWKFGDk3q5Qe3N0hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763744767; c=relaxed/simple;
	bh=FeJ2fGaQAUSB1Deo06QXTAPTwysyboXCexDx4GVIIwU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BdYtUz4jeukTY0zT4SmzhIQ1Pk6LjObexYFEEUewvwe9E4f6+FdMBp702EzZo4BKs+KayMP+/XbYfbQuh4l+CsiHt+kZcZJry2bq7w6io4b6bC8qFcPPZ5KkVbd7CABMx8Um/nVHPd6MxTbzeJ/A1Z3HcENPfrKbdCiNMFKUzjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=o4wsZ9Be; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="o4wsZ9Be"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b73875aa527so360329466b.3
        for <patches@lists.linux.dev>; Fri, 21 Nov 2025 09:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1763744752; x=1764349552; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MxgDUTwug61hJ/BPXD7gvIWYP2aKjb2rzB5ZYzTrVqE=;
        b=o4wsZ9BeT2s40m2tNmIJKThmPFUBIvWWCRcnX4cCxMi+rX6u3/tOICf/6EmdRIeh1u
         6ezlU20lInsM3hVZB0nY7HY0K8zzUP7ohEDkUY81Q5c0dt5fZmLtocCCzqaOsIdIa7b4
         Et8ylI17UfuZrVn82mzJd0SbiRf3fvSGtZoxXYb+ZjZ4ZSuYRShHNhAbCmztzR+CDvuu
         eNUaLdq1IADkvLhwSnm9fvrxYngo5OLnUraZmwQrbrDu2NnFTcWgY6I0Q4eqDuI2o/Ml
         VrnS8bUWxlByOdR4u6ZMRDHClPoyVAtiiYYOAYgSFdoIW5Vgjjtk75UywMk9ifWba4LR
         MlmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763744752; x=1764349552;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MxgDUTwug61hJ/BPXD7gvIWYP2aKjb2rzB5ZYzTrVqE=;
        b=FandYq6P59v9vxR7ZZlVyxNnP1AypeJ0p6tZDsg63UXz2zdZJK2PBlyiZYaESVeTTx
         EVGavJ2F/scT1S/L/a0vFb/G6cKaVkydIrccwlKFwuc1gGGfNbNrjVq0C7cAjGqKRKWX
         K0/rSJB8w9HYAFzb9Bev3sPLiy3nK9Dy255CV4avxgUvzST2VUkjnAR0BexOtPah3Z05
         2oGXf/aCmK0yVRzWUe7NQchrnDrcRiYCtEFsPWGj55SgqBd1YhkaxYmto9jWP1U2OxI1
         uf7OD1c8u0b/7k2/HG4+RZK6kxeYmcN80HOemaY2VC89FUZ7GVkqC3Ta4FzbAcPPxSoF
         i7PQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCKugDSnWN7In/rpY0bk+iKTefT7HdwK5Cr4owRcy7AOR1+Nucz+LqcCWDhYSo2wdsGLDxKTTo@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+xx+yvnO3PUuqn7zGv9HeeTh6jHXfB50DjEit+HH4cy15w0ZV
	y1dCAm2sn0O5VA0SPosSH2xlK+RXS8RZfOrJYQVZSpDhEZa88vZf801cUUkwbIfi4PDuL2EawEl
	vVpG5D0YYIBMGT8LdMLol3OjIZZRNgARzRJPz/onZLw==
X-Gm-Gg: ASbGncvw3CRsLPSCEPAayXWLqoUeaUEk/6EKgvyTkxtL+VvD1nkzPCCDEDpb7Ib+aOs
	aU2mITIdO2eCbGCH+31qWAvi92us3RzDg4GQI/MPyh2+gTRRi7LKVL8LibeqDeU6ob70MX0Iq4S
	BAb+5/JoaQLnFTo8unR5gjI11KoxxlAK1Cv6iN70Op3lKR1zHs/bsm6K1ag4VjDTyuVYutX5T8d
	MUtbuVurFpNRRSzN7cJeJfc5r1lpbRQXTDciMd1bF7gmqcgbtBWanku3c9b84DMfcxdETc=
X-Google-Smtp-Source: AGHT+IG7WH7x9X2+I2x+h5fNIsoM+zLlcF6TG5fRXP1vMU/kCM3IkrfIk1asJWWAmcRFSxn946GwPYcXpA/un/l+e5E=
X-Received: by 2002:a17:907:26c2:b0:b73:8639:cd88 with SMTP id
 a640c23a62f3a-b76715ab98amr304627266b.22.1763744751694; Fri, 21 Nov 2025
 09:05:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251121130154.587656062@linuxfoundation.org>
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Fri, 21 Nov 2025 22:35:14 +0530
X-Gm-Features: AWmQ_bnkJ6yrdoEu2g0362Q1Zy7TWNbX6RphkpcUBU3ZmCPk6bDGstpKoP23Jgo
Message-ID: <CAG=yYwmPBiP-pT1Yo9Yym3RMnP6BY=yjx6UE_qH_t1nCe0gdAA@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/247] 6.17.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 hello

Compiled and booted  6.17.9-rc1+

sudo dmesg -l err shows error

[   21.490792] ee1004 3-0051: probe with driver ee1004 failed with error -5

As per dmidecode command.
Version: AMD Ryzen 3 3250U with Radeon Graphics

Processor Information
        Socket Designation: FP5
        Type: Central Processor
        Family: Zen
        Manufacturer: Advanced Micro Devices, Inc.
        ID: 81 0F 81 00 FF FB 8B 17
        Signature: Family 23, Model 24, Stepping 1

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

--
software engineer
rajagiri school of engineering and technology
