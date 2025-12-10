Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C3E21ABD0
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 13:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765372726; cv=none; b=c+r6OpI0arEiv7su0sc4l7ShBwF1SCDeDnxWARdiRnUFCFATfaFJ2WtC+kHiLjuW9YakmKXQgT1Tml/7U5kG5n0qEsUSd2f3Ujj8vZLE29lZFMKQam7BSXTs4n2pttXw5wFfVtW0I84PT9t3KFKSdr8ULby0iNd0EmgX16bpyoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765372726; c=relaxed/simple;
	bh=OaZ2MRStedNYhARK5ORn3uHEPYJ68aLZv6sH2R2dr0M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U8MGD+oVy9q3uY44gjobM7pvXSKxAzhe2xew5nthS2gaDrCvdiLXf1S+zb6EM4DmiU5GIDbbx0ltdz1WlUJcy515v96inH0TI4wcaDXz4pzljZMNRcz8RFYBTCylGCjPMcc8pUxtzqpYIcEMepOFlu0vNUxEUz1BSUIhbukT238=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=mfZtGMDn; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="mfZtGMDn"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b79d0a0537bso888809166b.2
        for <patches@lists.linux.dev>; Wed, 10 Dec 2025 05:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1765372723; x=1765977523; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IUKRQZN8is04ZjTspSWXLsy53w+dt0YEDy823e8wJuw=;
        b=mfZtGMDn3fz+IoFfxH5IpI/4XC7QWcus4o0L5WaFaLyu328XGln2foV7ebxi7ICBlI
         VtRw2/0Ql+7lfczCHnan8bjHgqFspKXuhU9BqaKDS2q2aXfeZ22FVqlCn26KkTEvxsl3
         3BLkzvpOqYfQhl0yuOxapqZdewVIODXbPdIk8/uNS7enbhm2XFGyqg++wKaESa4Ekl2W
         VgtYT/f94rl7Znx7CVCVAl1eTQJ3t0sFMOgB3PPLsikzgyODcN9kfctA4/sC4jQO+iZJ
         8xe9EoWGcwenJnNbEro2wf29i7TD7XCb3GvkCP3yv8DrgacfHGxgYIeFECm0+ILNyQSr
         KRDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765372723; x=1765977523;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IUKRQZN8is04ZjTspSWXLsy53w+dt0YEDy823e8wJuw=;
        b=muwSxa497MccAuaDmHs/Sk2jAhVEl/bOt4VRzremwi2xY2ztaJGnEsIe0Ei5rBXdiu
         /48QbGlhrCnPVxYE8dw9ilTCENtvEnHwPuLxiuHGqZKlJtMAySxEKuEnghgRAyUGdprI
         8smhRzhgtT2CdDCfEGeL2Jki/180YgluEwHjhqhUDx1RJ24+6744xDQ4WTd2L2yfi1ol
         d4xmJnrdbhqyOjLHxPXhAxOjPz5x8yhpFJlMGx96nwBJpxmevvqBGRK8Tf0297bv10mE
         2C/iMnadIWDWe9t1Y7fSquk6YRFRXJZETPU2FGdO2Lcnnl/hecLelQZUMSWLYhkma3P4
         j97A==
X-Forwarded-Encrypted: i=1; AJvYcCUdLLbWjdZbmxiQMSbOwSCtbBiJr4VCaRsZ+kjmz2tt80pIgBxa3XpzWdEJ5iBlgIDZ276dFFge@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9iFvvflV3IkkT1p4RboeySeweYYUMT//K8mRXfXX+pxBjUsbP
	iUafx/SlXq4FYBqfDZ89StYbFW5SUGIWypZavPj0j2MyY1EONJaW8vE9EkdA+b/7CQs6BPD+aHK
	6jRNBKny/KzEt48NbMu3+Bq9hwpyjNnxLI/Bo3/Czeg==
X-Gm-Gg: ASbGncvrYUMXA3C7bJ+hx13G2zW1zUNwFgyZQYCuIgRiOddhe93zwbLmHlhS9sdEIB6
	ewVJ0Vz+Z5Z3iDZ0+YNZN6DG9zaHus38AR61ZzOc9DKZ8/YpTAHJ9rimKUV9p1KWeuM8+1rtyx7
	acT1eMOiYxTVIwRrrX3sHjIDNwLAvGVq4AuY0fsafi4B2Ry5DuzLq746W7v88lwg3UCRIqsSEJw
	lSfIbjL+HvcNpmRE8NVU0B329NCZ2mM3FRRjqxpYm3aTWPcWIaGcaCE84kV7YhhURVbTck=
X-Google-Smtp-Source: AGHT+IFQis+sgENnCf9q/e8gy/hdLlOHnnAxvt0D9dfQRrKQbvkyA5aeTcioxx2rqHLHnWKlNEiha2FUNAAjbbi84y4=
X-Received: by 2002:a17:907:868b:b0:b77:1a42:d5c0 with SMTP id
 a640c23a62f3a-b7ce844cb6amr254069666b.43.1765372723378; Wed, 10 Dec 2025
 05:18:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251210072944.363788552@linuxfoundation.org>
In-Reply-To: <20251210072944.363788552@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 10 Dec 2025 18:48:05 +0530
X-Gm-Features: AQt7F2oCV2mK6R8SnN-AbSkkF8a2RzvZ5DPZEpb9rsNRB5GyoM2Beu1eu4X_NHA
Message-ID: <CAG=yYw=14sxEdq7Vvkjr=8vr9NYiG5jPYXw5sXcqC_6dS95W8A@mail.gmail.com>
Subject: Re: [PATCH 6.18 00/29] 6.18.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 compiled and booted  6.18.1-rc1+
Version: AMD A4-4000 APU with Radeon(tm) HD Graphics
NO typical dmesg regressions

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

--
software engineer
rajagiri school of engineering and technology
