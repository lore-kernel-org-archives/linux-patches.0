Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55882DFF33
	for <patches@lists.linux.dev>; Thu,  9 Oct 2025 11:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760008784; cv=none; b=uM96V1Cow3VcVLsOc4xRZi0VWjJbrpKYge9lDB5HtJa73oSnx5+wlpJPG3p/w8UAgkbscWyLw9zY+e0BvnfIYZOn1bGwi+63fpBM3XdLAsa2ZpNaS40ZnkYJsPIN1AwMhUqTZlH/D1QJcpgbkC4yHzHHl3eTdxoDKtMrJhtp8uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760008784; c=relaxed/simple;
	bh=mzeWOdj3lBj+Ke0QviDFWI2aF1kcLsskxWN0A79AnHU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YXwfF5ownZwPeBVB93kCipNIujQMBa3+eksIMLaMhSd6GCPV+8T0aaQvjIuFfSnLM26Gi9bu0WtBg1bB/mcDV46w1HQobaKz/dEkFq3MDcDYWBdewA/EjCLbvEj5W9a8KZEROGwdUJNqDA9Wcu4uLJwJD0X9027i8PIPSu9IVcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UuhHNbmh; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UuhHNbmh"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-77f9fb2d9c5so8835987b3.0
        for <patches@lists.linux.dev>; Thu, 09 Oct 2025 04:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760008779; x=1760613579; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mzeWOdj3lBj+Ke0QviDFWI2aF1kcLsskxWN0A79AnHU=;
        b=UuhHNbmhDg5hmigoR5H6zMqr76D2sggOmEeuRZAuTHL8YUE03j0LVX5yflV56yBiw6
         cj8TkPn7hgo52dwqZxupgyJNq4OpxIcmT7NYup+vulpV2VJxPfAksPa1LXqai9lozbd9
         tPiBOXF+y4j9DQ+7HvoaUu8mYuZ2Mw9Z9RCaVFt0mhfU8o7FyYXR92ZyAGj4dqzMhSnr
         hFpG/cvyqICum7e0LjHudAIbl8gxpRPir/+vgbmeazgV5J38aRxBq5g31hcxykPj2z3D
         VS4yczuEJzEuHW93bzZLm/dfTTBentAflwc6J+H1MkV/+WviDW4BmFrwYHdBLejh47LR
         cZ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760008779; x=1760613579;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mzeWOdj3lBj+Ke0QviDFWI2aF1kcLsskxWN0A79AnHU=;
        b=nUTyHZ9orxUq/HyuZyf6YlJGbhmktwt67lO4rOHldnK6FUrSOjGxskKsX0Zgq4HtX3
         eHGg+qzGsV6lwTUH/2kvNQltkimljawo9Kk8W9PwewcvYcwsii/osJA+Iyp9/rKX5Wkm
         PbHXh/oael8088XQ0zzZ9pn1jgJk3P7NG0DTOmq/2jXqQSSO/G5wnUQ8buZgijHbHYy+
         gsbR7glJsvKU+bPKh/tNvb9YSy0cT1qS5tJZroC8oqevX86rMKeCFGVHCq34TyOFCJca
         Eq0XpoUePzc6XZSw9QeJ1lhPWPz/iHgTETnj5p3ayYEy+HQAMw/3cvau6vGTCg+km1Fv
         q5sA==
X-Forwarded-Encrypted: i=1; AJvYcCUJ5ydkxcZnpCn01GCkcNyMzyxC/sZ+6F/nK8yhx5bAYspKiZoGu2Q5K3JY4dIJvaTjZ62W/uOf@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8xcmia6y8zmgXvWi4b+TnxLFkyearkdLKoB8Q/MyN86z806x1
	NIe8KOn2zfEpMah2DFcYSHWQSUQEXv2xSH8xcxj69z44uKLjOLYMJ/qyU0QKfT1/2qGVyYa+gSC
	AmKGFqvvmmn+hvEESymQCsOyEnDisfgc=
X-Gm-Gg: ASbGncv0DpYTbUJFtA2In9Ajic3tq7kl+nbixLE5jCocWdzFVi+HXgmDd9wWxfOpZ9Y
	MZqdmv9yhkOgIr8HFrtO9M4CYtfZmhHjdJJIbVC4cS4n8rzXLJEcfJ4Ott6V85Ib2Aa+cpRnUEV
	03Uq1tBoCrgtAaGSk84nOVhS33xog+iE/gbqD3GCQHtlqDBEre3M0BfCdE2wQMKP8wrk7Is4FsF
	K434m5h9UDG0xZLwriQSLOLFXnG0Es=
X-Google-Smtp-Source: AGHT+IE5U7JyGi1AmeLjDi25hUOta+sU2hpJbVTN9Ai63ARDyOdLqRjdCN3h5Wr4u+tqZlHZJ+/pg/7Xr5jCWFq4BIc=
X-Received: by 2002:a53:d048:0:10b0:63b:8e80:c017 with SMTP id
 956f58d0204a3-63ccb672a0emr6807745d50.0.1760008779377; Thu, 09 Oct 2025
 04:19:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250913003842.41944-1-safinaskar@gmail.com> <20250913003842.41944-29-safinaskar@gmail.com>
 <20250913054837.GAaMUFtd4YlaPqL2Ov@fat_crate.local> <20250913055851.GBaMUIGyF8VhpUsOZg@fat_crate.local>
In-Reply-To: <20250913055851.GBaMUIGyF8VhpUsOZg@fat_crate.local>
From: Askar Safin <safinaskar@gmail.com>
Date: Thu, 9 Oct 2025 14:19:03 +0300
X-Gm-Features: AS18NWAGN6ExXhEWeXK-ERFvGpf6JdjWShiWpIPYOnPjMCR9bXVHwIY8E_1WxIc
Message-ID: <CAPnZJGBwFqNAybORpTtRfjtGwMQiBtd+rATD=mh8ZgE3owT_ow@mail.gmail.com>
Subject: Re: [PATCH RESEND 28/62] init: alpha, arc, arm, arm64, csky, m68k,
 microblaze, mips, nios2, openrisc, parisc, powerpc, s390, sh, sparc, um, x86,
 xtensa: rename initrd_{start,end} to virt_external_initramfs_{start,end}
To: Borislav Petkov <bp@alien8.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, 
	Jens Axboe <axboe@kernel.dk>, Andy Shevchenko <andy.shevchenko@gmail.com>, 
	Aleksa Sarai <cyphar@cyphar.com>, =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
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

On Sat, Sep 13, 2025 at 9:00=E2=80=AFAM Borislav Petkov <bp@alien8.de> wrot=
e:
> Ooh, now I see it - you have virtual and physical initramfs address thing=
s. We
> usually call those "va" and "pa". So
>
> initramfs_{va,pa}_{start,end}

Okay, I will call external_initramfs_{va,pa}_{start,end}
(after I will remove initrd, which will happen after a year)

"external" means "bootloader-supplied" as opposed to builtin initramfs.

--=20
Askar Safin
