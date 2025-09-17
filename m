Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D722FF15D
	for <patches@lists.linux.dev>; Wed, 17 Sep 2025 18:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758132048; cv=none; b=fE9y5wBKGP6DYqo3VKAwWUobno9MG9cosa8AAOTMJsPwMRKurcCJ8Uz5Ak6JVxX7IsNXudjVdOeNihuE2R6tF89RfXvRpx9utnzW2ol8KiV+n+W+CaXHpSuCiA6so7X1pnVsNxlA1RzobDGajE2X9rPLXsxMr66fl0rABthKWRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758132048; c=relaxed/simple;
	bh=DLDcGQ3mu3T/MPVKq0NF9V2I5Jn6ILZwFaw9KVQfhOo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rbHaR1aCxlXRYIv5IeIA8GWTXmABF61UiJ16qD5JgLW6tY/Gcn+nFqQOl4ojVuRp+VHsFRYMJ5Y8V21eKnFmYssYi47NRnU3JeieC8QIxqPFw1bYHFDz9RtN7W7njoNCZPwURuNZPTUBMT+dX0MaET7iANbw18eouN/ErJj9mhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b=0/5NAZ4c; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b="0/5NAZ4c"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-577232b26a6so101905e87.2
        for <patches@lists.linux.dev>; Wed, 17 Sep 2025 11:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20230601.gappssmtp.com; s=20230601; t=1758132044; x=1758736844; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Pv4dFUExNQfPloEDat7jfEF9BkjeLOy7zrinjdnc80=;
        b=0/5NAZ4cvChlm+4GCcsKjNL6HMLwPRQF1ViPksDED5eDzxMu9ZxsLsGHrxYjS5WDSj
         j2MQtEHjdK9qp0YtXtK/TdNJ0DHIB0P2tyH/FGjsQhF4vaa7kd7fgI3XdiZDSNallvDN
         8pvqib4GZiVxlSVlX7p3pWh89l1r9siSbpgenEStMyGDfMrAGafYNf/0zxSuTeLfRFDO
         4E7j8qd8M6IJ7oK6nL2x1VXjxvYp7n+21IaznyVsNV/Goy841DI3bZKtB6fc8nfiQZDd
         Rv1d8rWO4ucz/EurgLOnxdoTKe7w3ZAEqmy9PIo26TevFSZ06KGBh5cTIZFIxetsBhcO
         6LTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758132044; x=1758736844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Pv4dFUExNQfPloEDat7jfEF9BkjeLOy7zrinjdnc80=;
        b=ELfB4Em6pkT/up5JjI3Dgp1xAlXfTTIQp0X3avEQuunGQiFdjFOIk2jdgzCFmFWwPp
         wEiw3fa2cSyNfcdVV2uM13HjdzxsLALRTt6vSc19KCDwZ/Jg28K5YmAyLs9TmqVns5xo
         3MVHdmMrEpS2jdrxx+AmFWPCXsxw6De6AiPfWqcaL6DId67H1LvHY4ynHjDhpHqM0IlU
         RKESHe7DBxnBrBg1sFu4OgLp9Tnb/Z73Z2cenICSoySW0IFTI3aX9vT/0J/WFDcn5Mo6
         u8mT9dgPE8cuhzztJH1dcsFopHCweKMDrn8LKM2M864zrKdcgoOMJTcw/xjQPxYydFof
         n3rA==
X-Forwarded-Encrypted: i=1; AJvYcCXP/HSWls827tMwWo8Vn7Vx808taZQfLIDaKX4QYLBqgtp0BonpazjQHfQRB6+8x0V88jFQE7ui@lists.linux.dev
X-Gm-Message-State: AOJu0Yw4Rt5sqjppibp/Y+gasaAqvDxFPt+uDUbglaj994grA3+iWC32
	DWxpfSK0XuQ4MpEpSax/szxnkvGUkna68eSByyllU6wMJ/QIhcK5eb+9c55OKsYHVbxPC3nMX7R
	hrKVqpKtLt5lvQQQAqUGh9rpbhojWjZ+dibdLxJ4k
X-Gm-Gg: ASbGnctK67KX/1JvpcHNxIMq9dfKHOLt97njHI/IcR5i7TUGpx4PXZpPfFVCAYK/JN5
	DQhjE44krEtvfnpRD07BQKHMU1q9Km9V9AVcY+Cjh+Pv3wllE0Tvm2qnq6UTnkC//jV7TZboIIr
	Aax4I0PgdAx965hyrNaeYU9k/urKm3J09W4knZsOGMG3jcH9I2bW6ytzB3C668RRwkbpkeZDHTu
	YEnJA==
X-Google-Smtp-Source: AGHT+IGI+xF2OSgRbI6+fabXiqu9Xwuf5bxWYwnja/rNGOUuSmNzhH42MNUAKuR34Ox7ov8nmiujA9clDhMS84oRbmU=
X-Received: by 2002:ac2:4e09:0:b0:576:d217:3f2f with SMTP id
 2adb3069b0e04-57796b5e819mr1028160e87.3.1758132043747; Wed, 17 Sep 2025
 11:00:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250912223937.3735076-1-safinaskar@zohomail.com> <0342fbda-9901-4293-afa7-ba6085eb1688@landley.net>
In-Reply-To: <0342fbda-9901-4293-afa7-ba6085eb1688@landley.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 17 Sep 2025 11:00:32 -0700
X-Gm-Features: AS18NWAGwakGZ9zjxjq7MnfN8O7ZgOJb6fmKIJ0JIML7P3j0NnlDZ27eNb5S7Es
Message-ID: <CALCETrXHxOkHoS+0zhvc4cfpZqJ0wpfQUDnXW-A-qyQkqur-DQ@mail.gmail.com>
Subject: Re: [PATCH 00/62] initrd: remove classic initrd support
To: Rob Landley <rob@landley.net>
Cc: Askar Safin <safinaskar@zohomail.com>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, 
	Jens Axboe <axboe@kernel.dk>, Andy Shevchenko <andy.shevchenko@gmail.com>, 
	Aleksa Sarai <cyphar@cyphar.com>, =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
	Julian Stecklina <julian.stecklina@cyberus-technology.de>, 
	Gao Xiang <hsiangkao@linux.alibaba.com>, Art Nikpal <email2tema@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Eric Curtin <ecurtin@redhat.com>, 
	Alexander Graf <graf@amazon.com>, Lennart Poettering <mzxreary@0pointer.de>, linux-arch@vger.kernel.org, 
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

On Mon, Sep 15, 2025 at 10:09=E2=80=AFAM Rob Landley <rob@landley.net> wrot=
e:

> While you're at it, could you fix static/builtin initramfs so PID 1 has
> a valid stdin/stdout/stderr?
>
> A static initramfs won't create /dev/console if the embedded initramfs
> image doesn't contain it, which a non-root build can't mknod, so the
> kernel plumbing won't see it dev in the directory we point it at unless
> we build with root access.

I have no current insight as to whether there's a kernel issue here,
but why are you trying to put actual device nodes in an actual
filesystem as part of a build process?  It's extremely straightforward
to emit devices nodes in cpio format, and IMO it's far *more*
straightforward to do that than to make a whole directory, try to get
all the modes right, and cpio it up.

I wrote an absolutely trivial tool for this several years ago:

https://github.com/amluto/virtme/blob/master/virtme/cpiowriter.py

it would be barely more complicated to strip the trailer off an cpio
file from some other source, add some device nodes, and stick the
trailer back on.  But it's also really, really, really easy to emit an
entire, functioning cpio-formatted initramfs from plain user code with
no filesystem manipulation at all.  This also makes that portion of
the build reproducible, which is worth quite a bit IMO.

--Andy
