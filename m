Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FF51494CC
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 04:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760069263; cv=none; b=sy3UzVEdlADtf3ASmVz07lGnfT6S5mcwNMAWgqQAB8rAAZmRDk+VNUYxm5ZVT4n2tcWZd+T2Ob3JCxP7kDYtnV9KMI6LMLpe47C9VJ3zdbwswRWrcRhNKsFwukUIBRZANHlC8pOcpIeZU+P+AQac/eV5oq56Guihva2G4ZtBNf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760069263; c=relaxed/simple;
	bh=zKp2kw3Tfj/wI+7DBmKCMChAalHVoRdliS5fwx1zm9s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mD2QQEJEpwNnU7V/oM5bxAezbCEqeiqUdl5w4olmoc5vM5m4x4HtQECjOdSNYYlf8MJY2iSknNeAVCV3qPSTypZg31vDEyzEvYcNY7mokQasff5+KzKojuQ59Ljvk8AvQdxBXCFYZTDAQfaDa9IYbuv/eJnM4dSlAZekKq27EPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nUKReZR8; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nUKReZR8"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-723ad237d1eso15366317b3.1
        for <patches@lists.linux.dev>; Thu, 09 Oct 2025 21:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760069260; x=1760674060; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zKp2kw3Tfj/wI+7DBmKCMChAalHVoRdliS5fwx1zm9s=;
        b=nUKReZR8PMKgq15Dhg13E72YBY+3LVMHUvPm/2q9cwxoRUilHEj6ANEmexRNzVx8Br
         41Rnyyy9J+Q6cx4exxm24SwSD77gwN8mq/Hf2vfL587QHqQGrLk6xQlp9/4M8GHvWTvm
         drjlvu7R6ZjOYVVqo/+TfynRRTG1lwBQBioikcEZGOHNKDmJ3Dwu9rhduzVBZ1h7G9sW
         4dM/y2wpDij6wm3uf2ijEOxRJFM0QoimHSyEUPW+YnK9j0/hUncbflPbJaKhz4/rJomq
         QZQGmU3SUmhh7FvCvpkGr9/ulnjXpwiSLhltbrp+GPU0RoJT4RBkAXVZOmjq+hCMlvZr
         to6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760069260; x=1760674060;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zKp2kw3Tfj/wI+7DBmKCMChAalHVoRdliS5fwx1zm9s=;
        b=WlFGObzIB+XPQw2IqRdWBf+fOGJfy8uR00uOZ9C3ToSXRDPE6bCmLs517XffNcM0FC
         3wNaempSqz5Mpwj3f7mOXrkmzlfdKXNmMkpx9ooH+ifHA87pyJ5HPK9QE+lJpGEuNEJe
         hhRFdzYb/dchqzPTn9KJN2altYZFdCQbVkyepe7QUcSQx51xlTyHVXpmm9wZ7bSRxMF/
         BHaR20rxUXK5oYgDwH380D0vc9QHe9CSvZTnLUvOkvQrjeFGfrUyky/fpoPmww6DOTqT
         +oAoLrAIlXWXHeakq6kpxvgVG8tK2r8/Gko1x42vSYxN2QnhtOJOC9004MY3C/HvTPyH
         ev3g==
X-Forwarded-Encrypted: i=1; AJvYcCWZ0aljDT2Sh+1/DT7/s1czNzPq9MPOnKsT627AWpca9JWjsyU1r5Jehxp9lyaiPbbBXxAdFYtb@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/rLMaxz1jRhPnQLRToyMUQqs/jTQ8761TBUv5DOK7xaspfj5q
	5Agld+UBHT9gDrDwQ4pY6seYV927bW4bNkeUT6MsN4nrQgWXkOWdYnzQc/2K/THTiMsQ6N3UwyP
	7MB5j7ZVNl4Z/Sw4zkHTO2+clILWorlM=
X-Gm-Gg: ASbGncv5LxAv3I9UWGDJeDX0E2Q7YEDUmxFk2Fa1bfDIKrbcDMRKvBBjo/xWLFUG8Gh
	2EEkVjZAX1i/jvZsVtQGhCcE1SB4fekpvGnNjpUU95RkD6bC3bGsLtmuAAe09ANKOwS/t4Q2Ge3
	WWPaVtXOxPTBkwa4TLfMEeRtRa8K5imxu/UolIX9VAhE/PtROeR08Pck3KoidzQtPNwEM3457NY
	NqoLiskQunBCjD7x3v7pcF8Cg==
X-Google-Smtp-Source: AGHT+IFQERg8mTh7nax6OaWavJ8DgllCOHm5p0zLQR54uFFNlwqM0wGCA+Q/Rj/bdvDMe/rRbnhyAA7hAcefbtq0UHo=
X-Received: by 2002:a53:ca49:0:b0:633:a883:3d1b with SMTP id
 956f58d0204a3-63ccb87491emr6995599d50.6.1760069259733; Thu, 09 Oct 2025
 21:07:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250913003842.41944-1-safinaskar@gmail.com> <20250913003842.41944-29-safinaskar@gmail.com>
 <20250916030903.GA3598798-robh@kernel.org>
In-Reply-To: <20250916030903.GA3598798-robh@kernel.org>
From: Askar Safin <safinaskar@gmail.com>
Date: Fri, 10 Oct 2025 07:07:02 +0300
X-Gm-Features: AS18NWBct1j-7S8OHD6pljCYd2aEZxR7vcCRPjZz3T1pRcQcUgdDoCBWxEfbyM8
Message-ID: <CAPnZJGAvQirGTJTiTxumn8sAJ5KYDv8+MUTBmEW2fYX+r2RE3Q@mail.gmail.com>
Subject: Re: [PATCH RESEND 28/62] init: alpha, arc, arm, arm64, csky, m68k,
 microblaze, mips, nios2, openrisc, parisc, powerpc, s390, sh, sparc, um, x86,
 xtensa: rename initrd_{start,end} to virt_external_initramfs_{start,end}
To: Rob Herring <robh@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, 
	Jens Axboe <axboe@kernel.dk>, Andy Shevchenko <andy.shevchenko@gmail.com>, 
	Aleksa Sarai <cyphar@cyphar.com>, =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
	Julian Stecklina <julian.stecklina@cyberus-technology.de>, 
	Gao Xiang <hsiangkao@linux.alibaba.com>, Art Nikpal <email2tema@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Eric Curtin <ecurtin@redhat.com>, 
	Alexander Graf <graf@amazon.com>, Rob Landley <rob@landley.net>, 
	Lennart Poettering <mzxreary@0pointer.de>, linux-arch@vger.kernel.org, 
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

On Tue, Sep 16, 2025 at 6:09=E2=80=AFAM Rob Herring <robh@kernel.org> wrote=
:
> There's not really any point in listing every arch in the subject.

Ok, I will fix this.


--=20
Askar Safin
