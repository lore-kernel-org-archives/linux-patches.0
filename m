Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44882FF168
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 10:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760351386; cv=none; b=B0r5AaXsIXEjUJHk3x4HNWljA+8C/cQIgJ+BtmvQL3XZaCGB0HDx/j+L7EjfVbATg484ortg54wqdLXgWtYT0BCy/FHHLe3lhwUdvPYczHWQK7A1CJRgc2sh4qvT2WJ3PWsjbWJajRbjYwXPJ22vuwSo2635WBddHs9jHQQfcCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760351386; c=relaxed/simple;
	bh=SVPUlK6sYHZahK5O3+GOTdw6Bx0G0qiDlm5PKLNZXQA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oMPEr+Ybd5Sb6a3aZjQyD04bXhejibpwnY1WtChMDasoNtKaLJUSvo255r0ehdACMz16x5r04hoZYnYwLH5nh0IEbv/7/T2y8M5IME1FPxrrSOLpen0a2GRa7YGv7SHB/ySKympkBz6zcrN1rnYguF/+A/KraN+ArHn0zHBUNKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zrpsd5DU; arc=none smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zrpsd5DU"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-635355713d9so3872473d50.3
        for <patches@lists.linux.dev>; Mon, 13 Oct 2025 03:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760351384; x=1760956184; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SVPUlK6sYHZahK5O3+GOTdw6Bx0G0qiDlm5PKLNZXQA=;
        b=Zrpsd5DUUmyaQ+hVxflihEbyNENLqhTQsSrIKUGG+0UByiXl5J82ZqqKTLkmfHrHyX
         aNyDEqWVH74LXMr8URme7UXwhYoehcp/TvXK1BYDmLvNOleauijFn7d10UfHaH2xyHzb
         lfy5YxpFiN4k2cHGoj/Y+Mtl0fU6tJrvkJ8WjoXwsWkS+uPS+LhuTjgId/aiOJLFxhz4
         xRBDfoswxtD1fWqDnKBdkxWHORKr5y3AQ7Ljo0dvYthWllrfnM9dQpNmKRx4Lc1LXNuF
         nU2ciHoEV7AFcgg6WHeyo1yM7mJiNuO/fC/QOrOOsQK8lveiGeWdQVj1hjS8LHDG0zwO
         i8KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760351384; x=1760956184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SVPUlK6sYHZahK5O3+GOTdw6Bx0G0qiDlm5PKLNZXQA=;
        b=aUfFdjRMqR2wH9Br7PvnfuaSNf8BD4BgaxgHUHIqsaTKj6AKXgSvaUsVv5X7V3OM7g
         PgDXZnWgNCDnxccbaliE0EBKLsuy2X9dN+rDMABMmHbJ87bYbBHiHjYPW+H62Z205qCL
         Xic0sVsuZs9XIhSRXNvdQ5jd8vAE1uvNuNfX8Jhz9vWGBoV4dZjQDB2t3pLi18YWS7V7
         K0Obtq11iCpTzHWDlgCHbxL+N8nWZuqyAkHagC14l8sJmzuf7eS0X9eMK17ztZMwMMTi
         DCKkrWh+adWyFj92bkBRKtaEairLmpwn+yU7gVJWHyan2sWxzQkV2Xt/ha1vpxZOtdJV
         OrGA==
X-Forwarded-Encrypted: i=1; AJvYcCUfYI12YjWyIVSsyg1A7g3PFQXcn7G3CLVWjOTWnkBNbGDn+/kqOqw5z24jjkko8Sz9YuWtDqK2@lists.linux.dev
X-Gm-Message-State: AOJu0YzaGdLnQZ4V6CLkqlwbVG0g92gt+9RbBopUDj32XCAP8VbI0ltH
	jbmAv6OVMorh/0A3vVm0vIZho7GACUubPjVXU+lZxj8moBTiWD3Vb/18q0lvgiEghiPD41dInoE
	Q8A+oXRtDMAK9P9PpxqZK7jLcM7qC56FLFHyo
X-Gm-Gg: ASbGncvFOHOg0sysA3QmDmpjbGq6avAr2oWaGLKPjhyjXxIJpJf1ubbENU7/IOLfJCv
	XiiDEbf3rvYETm/69teZbMmNYQM0NW5ojVxlgfoD1IZH9z1JWL3CmX3WxCDzA6aS037qHrYxyJV
	a/jFI6o6re93boV12q13J96VGcMHHauK0Tp23JEGVBGpdCnchusGYL60vcniM0memkX6Zymb0pd
	uKe145l61L472WrJ/7MsYRlGCudSsrZ0fO0
X-Google-Smtp-Source: AGHT+IF7gB/uIYJ4y7t+OLiZ00mCO9lllMt+QoIyqpZ385m2NgZqSy+lqlMIQpqL29tGtjodZ9h+RUr8WRjGSui6l/0=
X-Received: by 2002:a05:690e:4186:b0:63c:f5a6:f2f0 with SMTP id
 956f58d0204a3-63cf5a7080fmr6997775d50.66.1760351383745; Mon, 13 Oct 2025
 03:29:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251010094047.3111495-1-safinaskar@gmail.com>
 <20251010094047.3111495-3-safinaskar@gmail.com> <07ae142e-4266-44a3-9aa1-4b2acbd72c1b@infradead.org>
In-Reply-To: <07ae142e-4266-44a3-9aa1-4b2acbd72c1b@infradead.org>
From: Askar Safin <safinaskar@gmail.com>
Date: Mon, 13 Oct 2025 13:29:07 +0300
X-Gm-Features: AS18NWAYGkNu7BjeCT0jHGno_eA5ARoSWF2j7yYdLIuVOnrJP74yF3CsWnjM_B4
Message-ID: <CAPnZJGDe+sDCsCngHyF6+=3=A9pYwQ1+N87jpq-ZdsSvVbQuNw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] initrd: remove deprecated code path (linuxrc)
To: Randy Dunlap <rdunlap@infradead.org>
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
	linux-block@vger.kernel.org, initramfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-doc@vger.kernel.org, 
	Michal Simek <monstr@monstr.eu>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <kees@kernel.org>, 
	Thorsten Blum <thorsten.blum@linux.dev>, Heiko Carstens <hca@linux.ibm.com>, 
	Arnd Bergmann <arnd@arndb.de>, Dave Young <dyoung@redhat.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Krzysztof Kozlowski <krzk@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, Jessica Clarke <jrtc27@jrtc27.com>, 
	Nicolas Schichan <nschichan@freebox.fr>, David Disseldorp <ddiss@suse.de>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 10, 2025 at 10:31=E2=80=AFPM Randy Dunlap <rdunlap@infradead.or=
g> wrote:
> There are more places in Documentation/ that refer to "linuxrc".
> Should those also be removed or fixed?
>
> accounting/delay-accounting.rst
> admin-guide/initrd.rst
> driver-api/early-userspace/early_userspace_support.rst
> power/swsusp-dmcrypt.rst
> translations/zh_CN/accounting/delay-accounting.rst

Yes, they should be removed.
I made this patchset minimal to be sure it is easy to revert.
I will remove these linuxrc mentions in cleanup patchset.

--=20
Askar Safin
