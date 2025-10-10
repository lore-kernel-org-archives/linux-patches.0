Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EE52AD31
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 04:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760069382; cv=none; b=po073SbFVVpjl/WV8Rj8UDFC4uN03bk43Iq4RlrnQL4F+vnQu2KRSMyUpnUq3eKmCC3EEFqGzgqluq8zJ47of5Dcdvfowre5KbsohW3KkKWEU3tpbxsx+CI05pCVd67qBDzC9Y0Xf0hDHA66NrQ/IWeh9qyBfITQe2VGdO9TbjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760069382; c=relaxed/simple;
	bh=QekwWSNZM13jRboBgI+VcoYsXugGuoxwasNpiteDkcg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NDGmlHw8OTcWu2JZzP3boY8EIydOy5T5UGmD95Zcuw2yOifvCU6bACGvRcXutFLx0yRZqUjLhiDJeEiZw24XtX53CFW8XYEgqRvBk/uaQmR6GWH/g7m5WNkQpmykEcQOX1VPD4SaAXhA7mZQjCe+qYOl72t9DHzsS227vc/+x9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BNy5bENw; arc=none smtp.client-ip=74.125.224.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BNy5bENw"
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-6353ff1a78dso1599555d50.0
        for <patches@lists.linux.dev>; Thu, 09 Oct 2025 21:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760069379; x=1760674179; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QekwWSNZM13jRboBgI+VcoYsXugGuoxwasNpiteDkcg=;
        b=BNy5bENwT91Khf0uzBA0w6xbJbnXrug6gdAPf0ANt5YEg2mYPko0STmLZ8NkX6MyWn
         CX1x2QtI5CQGruWcfbNoyDRTF88xXU+OunJBuGIkRKcqv5BLvtYFdro8MAZpkgBEFlXC
         QfTSxI7lJ6Qt3H8zXBHmCPnlKxVv+kNXVOPF92j7utgYlVm9BCwiRx0+sec4ahksZnqS
         pgmc/R+MvD47v2DZwK87MaMWw0xoIq7/UFr/3obPf/5V2sJyiwhBGaPlQ82Lb7XbbHUp
         zyl1bJ4KUAMF360kls4gJFDeCnnNzgZFK1zxjSXhqs7/kdIrOvlmSNzeGNapKmSequb4
         KZBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760069379; x=1760674179;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QekwWSNZM13jRboBgI+VcoYsXugGuoxwasNpiteDkcg=;
        b=wWxmka0050OA1ZTzKQ1mKT8YBQFE5tvB9rO8HOwhswCfvr8qPzAgRZVoEX2WZ8jsq+
         UGTeFQaf13It+jwZYcp3Wt+QZKe3K3muL3MXBo1k2wDwiKRVHvcffQKoozYPILrjsPR9
         /r3fAOL+emQQ8msdvPFkAyt0U/z+Eb43Mx11ezBcv5453P/kVkLyqk0SabCdCkMHJwxw
         7o5i6MxzL8I97aKzqNc/2nZnUOAiFEhH9kFI9iU2p+WOy53cboyv+SumbyupO8lqUT4s
         +bVOT0nOCxd3vk5xD84FzUuuhi7/sg7lQ9zq6C2+Ps5Mb5LsF/xWE7rPZ05/r9PpbPzk
         AdSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBvPajbyORdl4CmyE09cuCOilWl1LAlbbiNFX8kBgm74NGLxb5Wtt0YGjoFbIp6cibH4lJTd/j@lists.linux.dev
X-Gm-Message-State: AOJu0YydsPXwqaVx0QEP29RMObIvszrqgIl3cCIgX5nQ/cYc/DCcpr7b
	h42COvxclda65LLebMwBC53aP8rwXE4cPC4gC9SL24y2uToUEZAc7PX0qHPeOAwNpdfwjXgMFBU
	23V2X+Ev5S8KI0sEOOrbJVuYkdXANi8c=
X-Gm-Gg: ASbGncsVSp3KVND1TkOqwR90yZEbAgLngPK/irjoBufrg7QH8WOdStoOe+1E5lCIBqf
	W2awS5iRXbcFXi5pYDBUUcQCoKITywCDY4n3Y6LsYNJjG6yRi45zuARdTmiaL8bmHTHEW7uMg8w
	jKZZTBkwwFXXRC2oAWd5pSpjQhwtthaDWFgSnrU2rO9vAP4/oPn/aLeDxCQqmJKhDAFURrd9PM7
	sJicELLj3bQ3LpKPVVUKE0deFY5RcNJR7Gp
X-Google-Smtp-Source: AGHT+IEKzDZJ3mg1FFWOqowFJqWLj/+dmJPdM199pmmtVcavFH/YLuoH0hEdsvn7dHSOiTNw/3Aomiv0DcOjJivXzrY=
X-Received: by 2002:a53:e946:0:b0:636:17d6:a30 with SMTP id
 956f58d0204a3-63ccb82410bmr7618496d50.15.1760069378763; Thu, 09 Oct 2025
 21:09:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250913003842.41944-1-safinaskar@gmail.com> <A08066E1-A57E-4980-B15A-8FB00AC747CC@jrtc27.com>
In-Reply-To: <A08066E1-A57E-4980-B15A-8FB00AC747CC@jrtc27.com>
From: Askar Safin <safinaskar@gmail.com>
Date: Fri, 10 Oct 2025 07:09:02 +0300
X-Gm-Features: AS18NWDxe32nrD4BfQQFhIe3tEEfxrwgJsYQo_BWhSUPsy5CceSv7QOcZ20roI0
Message-ID: <CAPnZJGAKmgySY_RK0kmGTgwUh9hw4FSrVR+LoJCbD_RmJZe6RA@mail.gmail.com>
Subject: Re: [PATCH RESEND 00/62] initrd: remove classic initrd support
To: Jessica Clarke <jrtc27@jrtc27.com>
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

On Tue, Sep 16, 2025 at 8:08=E2=80=AFPM Jessica Clarke <jrtc27@jrtc27.com> =
wrote:
> I strongly suggest picking different names given __builtin_foo is the
> naming scheme used for GNU C builtins/intrinsics. I leave you and
> others to bikeshed that one.

Thank you! I will fix this.

--=20
Askar Safin
