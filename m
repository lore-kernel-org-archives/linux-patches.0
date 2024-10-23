Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABCA1CF5C4
	for <patches@lists.linux.dev>; Wed, 23 Oct 2024 19:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729711199; cv=none; b=Bvc9K4CV/tjoqmxddoJ5BzPiksLWMPRZ6h6SQSIo1WoWYpKM/1RLP8MqNWOoQTCaC5wKHKDDSAkj0HGWIdK/Vl7Y2VX7OvFBknnfwvb0sOO3jem9mFhRZUjG/pYigWoCjmwBsQkPw3kZb+a4BcLSMrbEEP4x6orhUWcIAZaOuAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729711199; c=relaxed/simple;
	bh=jVfaEMDiqxEbMojHP9PBFB3cC/z3et13Xb9WEIyCI8k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U0iiwYcG86tECGeVGeyHrvRF9NL13rV6ijCmlE7p7p4DtIDPLYDSMB2YHsdEe8e5kxLV0M4Y5ivekjDqu9F2OBwRzJe3Up8F93zWsn0WG/iM6m6vKN3h5w8MND9zHmu42Kn7tdsXuanLL3k22hekoyLIzeQbZGBkz0fkZ3+WXKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EkDwdqBz; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EkDwdqBz"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a99f3a5a44cso6935366b.3
        for <patches@lists.linux.dev>; Wed, 23 Oct 2024 12:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1729711196; x=1730315996; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hmLs1fnyFuhch9ym0D8390T3Il2G3hywHxmDwOxNics=;
        b=EkDwdqBzaL2/pzrsM6xKWMlayYDwWlNuAhRUZK+j4fMBJhVPDwuZFK44FMLmlcsPVN
         00wuJYCrzTNQRPi3ZYklp/bpoR398Xdq1NfTGDNLG1lFiWVYeMm5sTM8Dbh74EUrwfll
         ojsSgcre/jZPAvhnfSONuNRYfTjWWFHvLWkBQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729711196; x=1730315996;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hmLs1fnyFuhch9ym0D8390T3Il2G3hywHxmDwOxNics=;
        b=T+bntZGiiPReIcyGjfgj5LoqEwNrejolpFaUylBWllS1R6Vt13iINFRugFHr9oN6JG
         quLKCEzClDmZr0ZXVHSSGTYVL1BfcP2+QPg8arGlorOm+X7RrA8470YbAhmLHpIg4G18
         Aocgzbh9eNR9FWzROFvWo8hpqaMiEM8bsHlEJ98LJXhISu7xePGSFbtQeAFBPVI3AKqg
         AIh7c/LiB/hwV0mmb5tRLOXmVqWaIQSCGGWTQFzb+r4R5sF8/Fqo1+fvcT1OKm5IAGKn
         PR4LGS3KEkmhkbiaF5EGm/kwmgRwiBwslC57+JXGEfiwTaVilW46Au1u3mX1XbddGlsA
         iyBw==
X-Forwarded-Encrypted: i=1; AJvYcCWDHp3PRx8HSHMQGkmdv2QLyrHQgOj1gNDuo/r1zO73jBDvQSFtIibt0yt63JtywYVzmssyh0OH@lists.linux.dev
X-Gm-Message-State: AOJu0YxQrPQByUUFxbU+Gs9g4uvSD8PcWzDU7qndlwxzufpy2Jh2TpF6
	u1BXW8YMBqT1UINgaRmohJtpm8AG9xES6eQi4rCVVSvdh++P/qnAmJdcadgArFdm+9sN2PUBTe5
	2gWpxHQ==
X-Google-Smtp-Source: AGHT+IGxGb64sv0CtV81d8KFRbuay4gfgcBxzt4f/cZvIaEkmXQoXh+AA5KbAdh63Ptyiv1ANMv65g==
X-Received: by 2002:a17:907:ea2:b0:a9a:1f8:6c9b with SMTP id a640c23a62f3a-a9abf8a4fa9mr357475566b.37.1729711195940;
        Wed, 23 Oct 2024 12:19:55 -0700 (PDT)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a9155a1c9sm514231566b.129.2024.10.23.12.19.54
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Oct 2024 12:19:55 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a99f3a5a44cso6929666b.3
        for <patches@lists.linux.dev>; Wed, 23 Oct 2024 12:19:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU/TSyVGZ2BQ2MQO6+S138L4EAAdZlPkSkiY9jFpTp8BiK3TNeNKjzD567iW8Rp+STAV6Ls9JD1@lists.linux.dev
X-Received: by 2002:a17:907:72d5:b0:a99:f4be:7a6a with SMTP id
 a640c23a62f3a-a9abf91ed4fmr407338266b.47.1729711194415; Wed, 23 Oct 2024
 12:19:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <a08dc31ab773604d8f206ba005dc4c7a@aosc.io> <20241023080935.2945-2-kexybiscuit@aosc.io>
 <124c1b03-24c9-4f19-99a9-6eb2241406c2@mailbox.org> <CAHk-=whNGNVnYHHSXUAsWds_MoZ-iEgRMQMxZZ0z-jY4uHT+Gg@mail.gmail.com>
 <e25fb178-39fa-4b75-bdc8-a2ec5a7a1bf6@typeblog.net>
In-Reply-To: <e25fb178-39fa-4b75-bdc8-a2ec5a7a1bf6@typeblog.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 Oct 2024 12:19:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjw0i-95S_3Wgk+rGu0TUs8r1jVyBv0L8qfsz+TJR8XTQ@mail.gmail.com>
Message-ID: <CAHk-=wjw0i-95S_3Wgk+rGu0TUs8r1jVyBv0L8qfsz+TJR8XTQ@mail.gmail.com>
Subject: Re: [PATCH] Revert "MAINTAINERS: Remove some entries due to various
 compliance requirements."
To: Peter Cai <peter@typeblog.net>
Cc: Tor Vic <torvic9@mailbox.org>, Kexy Biscuit <kexybiscuit@aosc.io>, jeffbai@aosc.io, 
	gregkh@linuxfoundation.org, wangyuli@uniontech.com, aospan@netup.ru, 
	conor.dooley@microchip.com, ddrokosov@sberdevices.ru, 
	dmaengine@vger.kernel.org, dushistov@mail.ru, fancer.lancer@gmail.com, 
	geert@linux-m68k.org, hoan@os.amperecomputing.com, ink@jurassic.park.msu.ru, 
	linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-fpga@vger.kernel.org, linux-gpio@vger.kernel.org, 
	linux-hwmon@vger.kernel.org, linux-ide@vger.kernel.org, 
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
	linux-spi@vger.kernel.org, manivannan.sadhasivam@linaro.org, 
	mattst88@gmail.com, netdev@vger.kernel.org, nikita@trvn.ru, 
	ntb@lists.linux.dev, patches@lists.linux.dev, richard.henderson@linaro.org, 
	s.shtylyov@omp.ru, serjk@netup.ru, shc_work@mail.ru, 
	tsbogend@alpha.franken.de, v.georgiev@metrotek.ru, 
	wsa+renesas@sang-engineering.com, xeb@mail.ru
Content-Type: text/plain; charset="UTF-8"

On Wed, 23 Oct 2024 at 12:15, Peter Cai <peter@typeblog.net> wrote:
>
> Again -- are you under any sort of NDA not to even refer to a list of
> these countries?

No, but I'm not a lawyer, so I'm not going to go into the details that
I - and other maintainers - were told by lawyers.

I'm also not going to start discussing legal issues with random
internet people who I seriously suspect are paid actors and/or have
been riled up by them.

              Linus
