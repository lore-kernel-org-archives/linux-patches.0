Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC2F28F5
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 03:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760066302; cv=none; b=XQeGt0waPZikE5O5wN3udXhTTjiwQXXe5yWmQrrvW3ICaMS1zvuX+aDP2yyAYoauDMW6D8VeZYderopIot8SEmNGBeVlUsTsoNCYWepT7r3bSg+qRTSQJ3v0KkYnlRO/7hwONd30HNPrSkIX8mqQxY95nWhGTSwTvND9PQtAx30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760066302; c=relaxed/simple;
	bh=Pa2OhCNI6n3Mf2P8BAMZLHp7akXwtALOTxVawJZtfK8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ESf+osgse2D/MPKdYACw/cm65ISOUVZ6va0Kn81/2hA/QQRC2YK6n22P9g1iAVl4PKlrs1W5U/K8CxBq62j7Z9wb75ORKbidznFeHAfC9sUu3KTEep8tVP0nStIK1dd8XOcuhgM14Q6817mZ0Bth6H/iBVvrQn2a+sVtRKk68HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VuPFJRAr; arc=none smtp.client-ip=74.125.224.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VuPFJRAr"
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-6352c8b683eso1884895d50.2
        for <patches@lists.linux.dev>; Thu, 09 Oct 2025 20:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760066297; x=1760671097; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pa2OhCNI6n3Mf2P8BAMZLHp7akXwtALOTxVawJZtfK8=;
        b=VuPFJRArITzhj+MrMPl1Kq2LVdWE0gfm0PncJ6jX5tq5wC/aRfBAmzies+25IgY71o
         2Z5xwFnyHGpgKx9MjP1YqKxScm/oMTnccNKgo6cP7zcVS4qsjNet/92fIoGpQ6TzfU1+
         ukey5FF+zNCyF+SID+r1n5md80tyw74CdAxBgaigE5Qm7Xcn1t3KomiEeKeryI/UJuW1
         pDlBpxmSw2O47cdorUvGl2uMn+xxJQ3A74nFswaW+IRHLl/lYPJBtJ6YW3VJzq3iSwnk
         EVntPzJ/vkLuIfivGD2JU38wYRVgWATBckj/DppEAI0vJIiYv7tkN8dbiK2vh50iu5dq
         lXmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760066297; x=1760671097;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pa2OhCNI6n3Mf2P8BAMZLHp7akXwtALOTxVawJZtfK8=;
        b=SaE3YX6SNP06GT0aBuktZ31k/YqOWtEaSFZWepbSzro3lEPO9IHyG/V3FEvxkgd8ud
         uUVFktpGECPehmSww61Er40ARhD4ABGKNULL8UXzwa/VIBwVx+rA7h2CKl8OYbheOwF+
         uxHYjbgJaTSX8ab7+vYqtmhShCoSti/fM8M6QuLtnVWvRThmh5EFetWWakOi+IKDq/Pw
         BmaKEV8OHJNHttbo5pnqhsn059n23hxWt/fDiUzWEJZmzJ9gjbWRhHKXPXXcnd/AXMED
         7c8u5sYuhntd1ddPfsbOQ7IJS/u8xINd/8I3cf162HrqMnjDShyJIk8MzZmB1RcmM2TX
         7nHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpzr/S8hXOM3F8mDC9lVP/05fb8Pml9VxS9tobW6slg/oScI/ZsWNPMc4W8Q6kl2SNVsYl9XF2@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6OavO9E7vCqq9cK16Sf1vmBgduv9fxUWrnGGxhpU2bhoujfn7
	iCBZav3KECC9/H0pxitNPr6f7kwiPF1hycdgKJSKWM/RLnwrcpu7wlldQrS4qH051j8Ha8E8EOe
	Om9n01HqMg4kgfkju+Ij4ARO8CTpjnrc=
X-Gm-Gg: ASbGncv6WXJ+tdXJSAsgZafcMVl7eFh7V0++PLYoemCBo7oATkEBcbTgOF3CmhYALdB
	JFIevchbHEp9E5rquQb3m/O74hiOGAgbswFzkxYm++AORFT24spzKBBRur8nc6rF8j01xUvrPAX
	E4nH/klcILvPikbrjBlkJetuBv2efMY3T5BPsSwBP11YR7LB7TPLb8OEm3iWMH35mTWVn1QUGHk
	RKbXyI8bfN5R7r3HvL00H9OlA==
X-Google-Smtp-Source: AGHT+IFTQdXvlZxDoBIwCyChBgf2ijvKjPOXu3xyloDy3VewP6H31eXx2tdJ5Y2sZs04pWqa6kN09Zh4TAMeP3pYKTk=
X-Received: by 2002:a05:690e:1587:10b0:63c:e90c:a6d8 with SMTP id
 956f58d0204a3-63ce90cac96mr2654086d50.44.1760066297220; Thu, 09 Oct 2025
 20:18:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250913003842.41944-1-safinaskar@gmail.com> <20250913003842.41944-3-safinaskar@gmail.com>
 <053f39a9-06dc-4fbd-ad1b-325f9d3f3f66@csgroup.eu>
In-Reply-To: <053f39a9-06dc-4fbd-ad1b-325f9d3f3f66@csgroup.eu>
From: Askar Safin <safinaskar@gmail.com>
Date: Fri, 10 Oct 2025 06:17:41 +0300
X-Gm-Features: AS18NWCm5nh3vfq5EIpD-J_OKHQvi_8uVbgLjcXTz6TnQl9pdn9vqNDRLNkppRk
Message-ID: <CAPnZJGC9avy1s=xFS5Tg6obS+RB3zw4yWsUBw9g=Vt09S6j88w@mail.gmail.com>
Subject: Re: [PATCH RESEND 02/62] init: remove deprecated "prompt_ramdisk"
 command line parameter, which does nothing
To: Christophe Leroy <christophe.leroy@csgroup.eu>
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

On Mon, Sep 15, 2025 at 2:16=E2=80=AFPM Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
> Squash patch 1 and patch 2 together and say this is cleanup of two
> options deprecated by commit c8376994c86c ("initrd: remove support for
> multiple floppies") with the documentation by commit 6b99e6e6aa62
> ("Documentation/admin-guide: blockdev/ramdisk: remove use of "rdev"")

Will do in v2.

--=20
Askar Safin
