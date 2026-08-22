Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E5E391E7A
	for <patches@lists.linux.dev>; Sat, 22 Aug 2026 11:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787397826; cv=pass; b=XA4h0W9wKGwHVEwdrcGpFswiOcMQePMwDOKkU7vYMrj4GFUBc47OXAwbDWDGcMYZmy+H+/+z6+rzUBhSN7bEPGmCeVYdO3r9UkWTTe3aKrn8rD799r1BGuEkXyCEapQtInGuaeV1U2ubDWl3d9HhT8WGELgT30MOz6IIzJyqKpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787397826; c=relaxed/simple;
	bh=KsycAkx9ZIocqaOJ3xoXKL4wv70MFfNTe1zuqSRoU68=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ILHLxBSym02xhtcSkiJR8z+Xe3hadarTb0qQHG+gDmLlBAQIDXlPKuJZbOq8R2UFShITpyBSFJAQE8j9aHCthPYPQ3pC4yp0zL/hsaWSLxKwZzNxuYaaVfC54EKDYhh82dNgVkqTb+UIQgee1ALx8Y/HoNviQMVUH89xl/T3yAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b=EalywtOb; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b="EalywtOb"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c2055573c8cso279205666b.3
        for <patches@lists.linux.dev>; Sat, 22 Aug 2026 04:23:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787397823; cv=none;
        d=google.com; s=arc-20260327;
        b=LUkwb5XIf3Ysg2DDiceK/JPEPEEhIKH6G0s/y1+P6MyPD9+JST8oD1t48Zrk6dybaX
         P3g4hX+FFAEYPIl2II8RF6CUw1aDnc1Lorq+9AWSFfZZA+TLJzOkNvsUFN72mpoOa2dz
         UWlLR00ESQd1oBGDFpjuZPS5+NjLhtlayO9YkFDW9ke6Y7aL4jT3VBG/ZWIBchlSGqYu
         UB/RDWFGcGCUAGZ0tqGTK+9AEobjrqUACgJrOm5lQ6EvueQ/AAcGC/cNtxSPoY1n4D7k
         NDfku5NfA7kAb933hGqUEcQYCcEKozj/lRYlrZvGxxBtXfbE5+CGjXZrLIrsRIbAJw/b
         1uKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+oioSyEnPpQforztpGv2/Sue2PGm2iOMt0YGvkfoWek=;
        fh=Y7WKuWDrEurBQ5cz1JSlvZhPIevSosKk4ipAQAk5KQ4=;
        b=rnjzcdGPEe3nE2qXuSd+w62dnFKL3+4gdIAq5v9eqBDA2UJgVVolag8lWxm/nv6FRi
         lbpSXU1d3AagDJ1+FrTpmPm1pTC1kqtC7Lry1axD8e8Dc5zpAinoV53zq7pqvrBda3YF
         5YnCI8GzXmwPzHciKO46P+Y2tBKkPoOaq44QnAsx7Z+3I956TzYVTbXyQMXad7stNbg7
         xZvej0E3sQn9mVimJPH2RVgnWBNXvwdP/imApP6ZEYgULaAcFjrCV6kH7t48C18q5vux
         ho2eNhxWdTmxsveTgPFuisWaWJeyyyvfeH2G4C63eYXS2YfEqmfBlapOcSzf3xthcmsw
         ljTw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20251104.gappssmtp.com; s=20251104; t=1787397823; x=1788002623; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+oioSyEnPpQforztpGv2/Sue2PGm2iOMt0YGvkfoWek=;
        b=EalywtObaCvEh60jASgNzUlBsJw18zjW9vvr8g7ZuKIQIS36mtFAn/Z+AvGv1uNhUo
         NW7sa3CUY0oEwcBn3GqYOQp887miqXlce7Nv1xy81ODnROjJzAbPJh9SzyBi/7QzfzD6
         MMFZNAXMayE+47Gn7lPI+s35hb1aeoZCPm6SX/f9uQJf5km93UB7hUogtL4cawOy4g7o
         1SnaWKY0M0XnpEIzaShzH/pj41YlUNbDqpM4dWMKkRPmIj1gIFmS+c3Km0tDZycmb2nO
         LP7Ds/wFLj6KkODU3VLqWKYjpLjtLe6Ou5svVaCAueZbgiCIjmIepnezRs0o5voiHHdW
         bEGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787397823; x=1788002623;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+oioSyEnPpQforztpGv2/Sue2PGm2iOMt0YGvkfoWek=;
        b=aTzXU+aJepejRcsKyFO8O5lZ8fYDtGgl7itcc22CxFvpbUyPV7YHvg3xlnDMOZieOn
         cUm9WYdwRnbw9wbYoKYNUi+8QypkS/TARWhqcaKlGO2gF/fgJOk9KWauUSZdTC0Uu+hJ
         2E/WWjVW5D1Zm567WdWKto5xLMCUIqKp4VPLSmu1NMGq2Dy7xexI60l8vpXYcYV/sQK1
         kapz5Ims46VOZRMw7DUMNMM1KJsGKO98wutwkdkduyj33aUjmBsX96wtUUgobQwubTwQ
         cyCeuM7xCs4lhxWbq57jfLynx4rHNdQM13R9PU1i6ph5zxQ6TznmXkfPN9yPOfEKDVvT
         kx3Q==
X-Forwarded-Encrypted: i=1; AHgh+RqxG71MFtyg8tKnonJB7OEbx7Iui9tZk3nVUt4EnDUwxy8PlAsaYzGxy9VWbsy9WJpPA41T7lxh@lists.linux.dev
X-Gm-Message-State: AFuF++kqzRT43HB3CRGsGFBM5cnEpWq2WSq7sj/Dcicql+KGNK5163zl
	rSLixVe2x6vjRL/I2ElXOJhf9AZRl/2rXfDiaMzFz9PL6Eghk+sBUes/1iqEHUsYpWUI2XLpCjA
	myWy2Cc4tHy8Bg7tJngnVUMhu1SIRMyMVoYRg0vdTAQ==
X-Gm-Gg: AR+sD113Jjj3sfHZB5q9FtehS0wI3ntz7WAAnGH3/yDwRTxoq7E9pOJosgmLXubp0LD
	Czyp+t17CFN3imy/cHNzC41iXermutLBuBFnjdvgiFNgX4tNYUdPr2Yz2NQDqfic//T27XRqW88
	md+JRPPERtnwZEKf5MU4fPEfS7psOZVRgvwmLfhgPyNC7uGsZWtdwlYPt2wtBjgW12JofPmAUR+
	Sq6XNd0W11iqNGVJC6FCLZczl37RxHHkpVF3LUT/FALjRfrzL8rxMOMleRQ0qwxN9jkSe0ih9Xx
	djxK4fa7EFNd33o6kSs2vqQIQqCfjX8djhSancul+WGK4d5H1XWdleKCR26xnw51pujVuBgqoay
	f+APZxjnJMFmmV35AvPbSaqyGsvD4s9UKUHi+kx2YVOnOii3CWngfXoDRWUZPUsLwEbdAWux4cG
	z1iIHQTC9uZZ/peaT50l1QCcye
X-Received: by 2002:a17:907:944b:b0:c20:23fb:bb05 with SMTP id
 a640c23a62f3a-c24926a1cbdmr566541166b.15.1787397823424; Sat, 22 Aug 2026
 04:23:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260820145244.450574346@linuxfoundation.org>
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Sat, 22 Aug 2026 16:53:05 +0530
X-Gm-Features: AcwNN1WGeBnoYhB_lqBVMGt6wzNqX-2N3ScSbhRcQjjFZWrFEibQEHqoPnk7yQU
Message-ID: <CAG=yYwk8bW=5u8GUU+m8J9ZJBAAxFoTMHR-+G3WNU0YcN8L34g@mail.gmail.com>
Subject: Re: [PATCH 7.1 000/228] 7.1.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

  hello,

 Compiled and booted  7.1.10-rc1 (using qemu-system-x86_64)

No new typical dmesg regressions .

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


--
software engineer
rajagiri school of engineering and technology
