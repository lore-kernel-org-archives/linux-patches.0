Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17621E379B
	for <patches@lists.linux.dev>; Tue, 16 Sep 2025 01:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757984728; cv=none; b=L8AI1kJKy35ZSbvBXuOD9z40lMd+Qf8vuysnRaplSrZO+KPAoy/TgUcdIP5m821R6AxtxGBEVB5r4tHFVjk9ICCqg/lIQ2yP+ctFB7qDwcXw0ZEC8hDq7/1khqRxuRlmog+cxHL/FDgIWfHkb3Z0cf/OMOklx74rVGOCZEWcjA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757984728; c=relaxed/simple;
	bh=d4rwn8y0vRJNvu8C079VdIgUQlj+kBjL5HuZ7smgp/E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SfitUdFPu+H2skQ7qybvigddpcJ+sJAQX/QpQMo0lSKn1NvczV33UspmFQafLwdpA65tU3UK05uwnfzx8PsTyZi3GuEo/sFviZZOmWPrgVcWe7/8iqvEHSyVzcUYOldd9ATfva4Rmq4+GWtSF6XC8eg0c1Tv0Wwh9QdUXB1x7ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dCiylnmk; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dCiylnmk"
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-ea3f0d9150eso1951875276.0
        for <patches@lists.linux.dev>; Mon, 15 Sep 2025 18:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757984724; x=1758589524; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d4rwn8y0vRJNvu8C079VdIgUQlj+kBjL5HuZ7smgp/E=;
        b=dCiylnmkKEBUpfyZZXdzlu4I6PxulfCLuAEeG9jVGv/DEBKecLTXXtcFWEYTXzDYhg
         GWdd6FxCiC5BL4V2F5hGkD9IW9okGdGPu1cq/ha6NBK/N6eCIvffm/LheiYKPnAhrL45
         6HaNc1r3Y5Kf0pva0uFX+stacOddLqdCJOd+Wmsz4TjtLyc4ZnuHnm0CQeR/Rp3xZt0T
         KNIky1Hv3YiccHaCQkVxwlX4WR4wzKTD97YNnTGXZSqLk30lHGUX/6W94q2IDWqQCVrZ
         ZP8NRLp6nCNMn29qSN98EuRSwOdB1f8B5+4lJyXoQEcs1Zl+XuMQLCbulfgQNu6TuHmi
         +JWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757984724; x=1758589524;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d4rwn8y0vRJNvu8C079VdIgUQlj+kBjL5HuZ7smgp/E=;
        b=gWPLsOW+PdYVBzBmaiU1ta9GwKKqtM1yNeatPQHMup7mhUMEGPg7x5ccNyEEyT2PqC
         AGHrN0H2WZM7lp7IDZiYBfvsfEzOxJDsruMznkHLv3vn7rYJXbofvwywPu6sTZgK4PXT
         Bgug3rdmFYjiCIAbyivOgCYEM1B9vOWcW8g6daeusmC86jxE3UsdyMBeswxWHPEuoO12
         f7ngpoQe/B5NdJKdbo9nIhm8+6CIJdYUK7b6qh9f5EFd08fgCBbsCWo2gUPc/FzbWUDU
         14DVOwSyqRNukWi5abAmjqth3sEQligAL0pW60Bo2mhuI5/KfI/BqjVtkikxXkLBsBMM
         UYjA==
X-Forwarded-Encrypted: i=1; AJvYcCW8D9EQMcHHn+rLgfPaXoraR2Yh8csFBKbwDhgily/2MQZ4z0KkfAKh/cE5aXAA2JH0E9fadjaE@lists.linux.dev
X-Gm-Message-State: AOJu0YzubtxaisNqr45jt8mwYltKgG/mygfBkP0b4ssS47aLQfHOsnTj
	Cyg7/tgJWvg0fbtfeykiZSrX6u4Z9HjQlhZSo9VBzvxS285pwX3DwgULl+4EpgFqCWh+yzNA32t
	jVjPjuRMhyKQaLsIuHuK8vMM38Y+FVZ8=
X-Gm-Gg: ASbGncta4uDtlp20eFwLzNXlTn6BE4uDtVcT98g4Bxp7DfVE16LuDH1m62wdnjyGHpz
	BNmdtOCH+JkAVBcLIO8k7mcC3eCQepq67eo0U19TZ7JbtLV2UFlbLE69xhe3JTCb+TyoFpCg8jk
	W0+HqVYMX9F/GgIOpD0iwci+M56JDHtWxWH4BCgIHKLFz8xSGUmoJRB4WFpmLAP2B6uDj5gsrxJ
	dyAr59GyAx3jSlYFw==
X-Google-Smtp-Source: AGHT+IFaJEo1gVHkPCEaCD3vWYjtreYFiQ2WOrRU9CIpbMyg97OVJtr/v3uxdpG+fiXE68E0IfjXLuECnr1bsw09sPQ=
X-Received: by 2002:a05:6902:2b02:b0:e98:9926:e5ca with SMTP id
 3f1490d57ef6-ea3d9a6c911mr10729577276.36.1757984723469; Mon, 15 Sep 2025
 18:05:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250913003842.41944-1-safinaskar@gmail.com> <20250915-modebranche-marken-fc832a25e05d@brauner>
In-Reply-To: <20250915-modebranche-marken-fc832a25e05d@brauner>
From: Askar Safin <safinaskar@gmail.com>
Date: Tue, 16 Sep 2025 04:04:47 +0300
X-Gm-Features: Ac12FXwuxsP2xoupllcCoDiRw8q2uuerrvP566PgC2Qr6qfMP36Zqdrto9P8zEU
Message-ID: <CAPnZJGAjfpHZn_VzU3ry9ZV6OUS0RN2iWos153_oM_PhVbMgVg@mail.gmail.com>
Subject: Re: [PATCH RESEND 00/62] initrd: remove classic initrd support
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, 
	Andy Shevchenko <andy.shevchenko@gmail.com>, Aleksa Sarai <cyphar@cyphar.com>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
	Julian Stecklina <julian.stecklina@cyberus-technology.de>, 
	Gao Xiang <hsiangkao@linux.alibaba.com>, Art Nikpal <email2tema@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>, 
	Rob Landley <rob@landley.net>, Lennart Poettering <mzxreary@0pointer.de>, linux-arch@vger.kernel.org, 
	linux-alpha@vger.kernel.org, linux-snps-arc@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org, 
	linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org, x86@kernel.org, 
	Ingo Molnar <mingo@redhat.com>, linux-block@vger.kernel.org, initramfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-efi@vger.kernel.org, linux-ext4@vger.kernel.org, 
	"Theodore Y . Ts'o" <tytso@mit.edu>, linux-acpi@vger.kernel.org, Michal Simek <monstr@monstr.eu>, 
	devicetree@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <kees@kernel.org>, 
	Thorsten Blum <thorsten.blum@linux.dev>, Heiko Carstens <hca@linux.ibm.com>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 15, 2025 at 4:34=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> Split it up into multiple patch series. Send a first series that
> focusses only on removing the generic infrastructure keeping it as
> contained as possible. Only do non-generic cleanups that are absolutely
> essential for the removal. Then the cleanups can go in separate series
> later.

Ok, I will do this.
I will send a minimal patchset with arch/ changes kept to absolute minimum
or even absent. Nearly all of the changes will be in init/ and docs.
Hopefully it will pass via the VFS tree.

If it gets to kernel release, I will consider sending more patchsets.


--=20
Askar Safin
