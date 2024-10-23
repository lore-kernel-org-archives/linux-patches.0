Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5461CFEC7
	for <patches@lists.linux.dev>; Wed, 23 Oct 2024 17:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729705568; cv=none; b=n+9FCK7mFKbxyLIDmvWfFilHI4hOcW3T624/V1iDvF/qQRlFXytVf5iEmMbn2OBeMQx3M9Dt2E2p9v1SACJE0gHF6TIu8iHbC5E1lb0YOdfbK5WA4ACyyO1Cih2jwRW03F42Pgb6LRIv4RtzdF0kiDCfVOGDMofdMbHZB8NX9CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729705568; c=relaxed/simple;
	bh=HhCRM8LXsD648EezB/Ag71ruZTVUBPWIrjPd9FGl4yA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NRMOzhwOFKD4/TMeoF/voli6sFin84D8btIlGyHQ4JBDzdXRoE048reSJQZhXWKaajipaA+VAwSexo32if62OOEeyIU80XcFvKGVKtCCUtxxq6oro92TequHJhLC1GgcRb2tPAwKc4SJ/cti49D86rNwHkQgi92yw94H0TuA0jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PJgjW3f3; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PJgjW3f3"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a9a628b68a7so932106766b.2
        for <patches@lists.linux.dev>; Wed, 23 Oct 2024 10:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1729705564; x=1730310364; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FLwni55Q0o3LkpPoGPWHU+nZClL0F1PcEd+W91uMukA=;
        b=PJgjW3f38NbD4IAFKSA7enfkLdule3dTCyC+9axjbPMdNP+n2BkScSW5r+n6Qkdnne
         VfEL+J1kQYS6xGgD8q9U5kNcGRL1UGXMcMbEaYrLu9fbDj6DRgm68mVIrwHYMMJTV4XH
         8pJcoQ7x8f9wbH09+alKfwyKBOudZg3coDsIE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729705564; x=1730310364;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FLwni55Q0o3LkpPoGPWHU+nZClL0F1PcEd+W91uMukA=;
        b=mwFTXXBInjy3DrlEBbEA19sll2axBxno4BsNlUUc609CgtecFEKKlZwjXEoXrVAerv
         AGmv8z7XCmkTsSVvooN2JyZ9X00b+WvGZXfd/aS9cF/g2krN2tAoESX4XzT5tfFUSTqC
         +PLvMcVM8H46sHIbgfCBF8Hrxbeg17X/CVlecGoQQ8/gBx8bWLl6/gxHwdTVedTOZsdb
         00A0QB6tUE0HLUIsXLDT5NucnZJkU6ubyhqQT2r542KjYDHHr4yafZRSm9KE5BSFUbQQ
         O2eZzfSzTM4AVuStfjVsZx5++9SvxN1JVjnBOPvxEnMRisjLZ/2JYSjxllVUonl5V0dn
         aVcg==
X-Forwarded-Encrypted: i=1; AJvYcCVvaTFata8Ripj78bcMJ9kb+DA77+lhLaN37cB/wk42gXZ+5TO3gBY8B0IqfskhkccTgHGjPX0L@lists.linux.dev
X-Gm-Message-State: AOJu0YzpcExhOA8lsng2P+/sPwJ0FYZE1ziyP9KhD0UOSBWjKRjQ3gRr
	MwN4mUpbEIJU/c0RJ6OZALnOZAYGu8b+ZRZJV9lae1XTdVoPXVWg54jOoZyQ5XWiCZJ06Ht8/nf
	o+xA=
X-Google-Smtp-Source: AGHT+IG6GP0RhJHHg4wK3pr/EtQhzh4pCxViaRbvRNfp5rAGqHy+xqn8fAgcTyCtqq0oHDDqFVAUgQ==
X-Received: by 2002:a17:907:7f15:b0:a9a:a5a:1d47 with SMTP id a640c23a62f3a-a9abf84c7cbmr296192166b.2.1729705564493;
        Wed, 23 Oct 2024 10:46:04 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a91370547sm504150066b.128.2024.10.23.10.46.04
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Oct 2024 10:46:04 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a9a628b68a7so932103966b.2
        for <patches@lists.linux.dev>; Wed, 23 Oct 2024 10:46:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWuOjPMD7NCKifgMvjlhk8jZ1naDgCoOacRAEMXS6vXWO77/wuewfIxfhKADK/+BA1f130uCa+0@lists.linux.dev
X-Received: by 2002:a17:907:94c3:b0:a9a:8042:bbb8 with SMTP id
 a640c23a62f3a-a9abf94d4b2mr369489566b.47.1729705563762; Wed, 23 Oct 2024
 10:46:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <a08dc31ab773604d8f206ba005dc4c7a@aosc.io> <20241023080935.2945-2-kexybiscuit@aosc.io>
 <124c1b03-24c9-4f19-99a9-6eb2241406c2@mailbox.org>
In-Reply-To: <124c1b03-24c9-4f19-99a9-6eb2241406c2@mailbox.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 Oct 2024 10:45:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=whNGNVnYHHSXUAsWds_MoZ-iEgRMQMxZZ0z-jY4uHT+Gg@mail.gmail.com>
Message-ID: <CAHk-=whNGNVnYHHSXUAsWds_MoZ-iEgRMQMxZZ0z-jY4uHT+Gg@mail.gmail.com>
Subject: Re: [PATCH] Revert "MAINTAINERS: Remove some entries due to various
 compliance requirements."
To: Tor Vic <torvic9@mailbox.org>
Cc: Kexy Biscuit <kexybiscuit@aosc.io>, jeffbai@aosc.io, gregkh@linuxfoundation.org, 
	wangyuli@uniontech.com, aospan@netup.ru, conor.dooley@microchip.com, 
	ddrokosov@sberdevices.ru, dmaengine@vger.kernel.org, dushistov@mail.ru, 
	fancer.lancer@gmail.com, geert@linux-m68k.org, hoan@os.amperecomputing.com, 
	ink@jurassic.park.msu.ru, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-fpga@vger.kernel.org, 
	linux-gpio@vger.kernel.org, linux-hwmon@vger.kernel.org, 
	linux-ide@vger.kernel.org, linux-iio@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-renesas-soc@vger.kernel.org, linux-spi@vger.kernel.org, 
	manivannan.sadhasivam@linaro.org, mattst88@gmail.com, netdev@vger.kernel.org, 
	nikita@trvn.ru, ntb@lists.linux.dev, patches@lists.linux.dev, 
	richard.henderson@linaro.org, s.shtylyov@omp.ru, serjk@netup.ru, 
	shc_work@mail.ru, tsbogend@alpha.franken.de, v.georgiev@metrotek.ru, 
	wsa+renesas@sang-engineering.com, xeb@mail.ru
Content-Type: text/plain; charset="UTF-8"

Ok, lots of Russian trolls out and about.

It's entirely clear why the change was done, it's not getting
reverted, and using multiple random anonymous accounts to try to
"grass root" it by Russian troll factories isn't going to change
anything.

And FYI for the actual innocent bystanders who aren't troll farm
accounts - the "various compliance requirements" are not just a US
thing.

If you haven't heard of Russian sanctions yet, you should try to read
the news some day.  And by "news", I don't mean Russian
state-sponsored spam.

As to sending me a revert patch - please use whatever mush you call
brains. I'm Finnish. Did you think I'd be *supporting* Russian
aggression? Apparently it's not just lack of real news, it's lack of
history knowledge too.

                      Linus
