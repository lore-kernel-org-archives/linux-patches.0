Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB252FE56A
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 09:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760349601; cv=none; b=Cql5FVpR0yYK4GA5xm9JPX+oRkvRTVBEdnYlSgikwClNPG0Umn18g12dfPWi7XHPuplA1kWL/QMhrZFig/3fUGeQzyFXoNyQZxDW2G9AtnmoLMpwhbDP1coG1AEWLGVjY0/pt9o8bOdxptnDAGHHgqByiGB5kBGLbF0d9uNpOq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760349601; c=relaxed/simple;
	bh=+zOuCBbttI2pym4Pdpz046IX8ZPwrX2sj4yc80Raf0c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jnNWvvWOjsBO7WcdZZkbhIiPrRyC/2CIDMCMnA7sUIvCqiioxTeM+uY3ZHD+PEWkr8Y4XAUt89VS7OWFvotz/tr2WBEFB1qxVJolxvx3Wtqgz0aGnU3rTN1yvgIiMMGvQf5krllxVHgSE/roJ+RgrJGdqiPJVZalBBOmqio4pwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d/Vex3Sq; arc=none smtp.client-ip=74.125.224.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d/Vex3Sq"
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-638d01a8719so4103574d50.2
        for <patches@lists.linux.dev>; Mon, 13 Oct 2025 02:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760349599; x=1760954399; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hZsaCMPk0e7xOahYxc9B2HTwzlp/3SZdj7OzfRUl7Tc=;
        b=d/Vex3Sq/FPpkpatAqksknDnBxE1Xxu7W7NSv7BAf9lZNOIbPtQJI+CDNAkxhr22c+
         cGfl73C8VUQh/ItCTAHjcr1B+ixxa/RU+NLHgp5fhhCt8yDtG9XRF3sIMAcXeNIu08UP
         SHlU5xsDSoz2pygbWLTlq6+3t63YAFdYE66rIERNuq0bDnwpTgacFnRXUvVUv2FuN2WF
         xTput0J7VB6FM2DOqDopRCIplMs/GV1b9Clw50mhG6OSKIIZQsnYDI10amNME6B830yw
         WWX7d8VTWoKo/YldDOFbL4Uq8D/EZCehkMVM8nJuZ+/gf4qeavV6lpeswjScknamQHd6
         huCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760349599; x=1760954399;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hZsaCMPk0e7xOahYxc9B2HTwzlp/3SZdj7OzfRUl7Tc=;
        b=X5e4LxAKnMtU2Dv/hMhwyYZZUH/qSFwfvM1J5R6Mnj3C7t9qGZggTomzgUoDUMrkaK
         75v74k8So5N3EZIdjGYb0azQ4kkwuXJzYg2NDTVi9f2/AUFADdU2jpjaRP2Ua2YbMrwB
         xDzAG5ImLP9IkRVxoJ40yFnMe+ME9A1Dp4J8a/0XBDoAVlF/Eb0YHU60v5gg1u6moPsZ
         VSKLs8NIadQ2AMuaV+CmeWVwNVlU+nc4HodLHSwQ3mXNnlyAbMPEx6X716G6tWSLUJFY
         lGkpNSkGqrd0m8n9QO0PctvJu+Ru/w8TSp4w32XBdblnodCnRP+HdR/kFOLhDv+K4iDl
         v9LA==
X-Forwarded-Encrypted: i=1; AJvYcCXUgCOdKtyEh2NUKkvPaFWVMk0d8uflcgpU2WpchMREsdBIa6/ckF4nQGdsey0tYHMCFfv1xKll@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3oNw+VpXQ2sCfQijbu/q5b5fr4OB/Nw9mrCt+Wbkx1BRDjf2r
	PzWUOqrj1oACkii2kVn6X7/PBwBoxn0yA0zwya75qkRFdu71NTZh0TqwQhKtkFUXDspYqiFvErA
	3BhB6zQQ7zldbq7nznYKKp9BXG8r9hsI=
X-Gm-Gg: ASbGncvTz2SanR/yvmgdHR89TtSXHb50JWqrmuRLWJAPGjTKEOHvgG4eVtr4xXpzopg
	ywotm4I8/IbEfxZE59dTwAxj5QM87aEHnwBPtI0AASg/o88zRW0BDwRXyvSrD+aCwJ+b/dBOsou
	FvLVUTjV+yeHpGEL1uM3C9Foglb4BbHuDXUYEm0jVYXLjkcDOWN1qWWcJSoF25HTbUMs4BRzVi3
	McII3/ZEM8jSz25CdoGnSLxHukcBExpmU9m
X-Google-Smtp-Source: AGHT+IEjiQMnhpQ/Kb5hfGFGrybCEQQLnH8Bm2H6/rcdu7ghvXP+Te8kpl6LHQn/PIgvNHwUMvVrGJdsfOorS0mdutU=
X-Received: by 2002:a53:ee07:0:b0:63c:daf9:bf21 with SMTP id
 956f58d0204a3-63cdaf9fa65mr11783686d50.24.1760349598638; Mon, 13 Oct 2025
 02:59:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251010094047.3111495-1-safinaskar@gmail.com>
 <20251010094047.3111495-3-safinaskar@gmail.com> <CAHp75VezkZ7A1VOP8cBH8h0DKVumP66jjUbepMCP87wGOrh+MQ@mail.gmail.com>
In-Reply-To: <CAHp75VezkZ7A1VOP8cBH8h0DKVumP66jjUbepMCP87wGOrh+MQ@mail.gmail.com>
From: Askar Safin <safinaskar@gmail.com>
Date: Mon, 13 Oct 2025 12:59:21 +0300
X-Gm-Features: AS18NWA-897xF_-UIFWa7pg6NN4-821ID7y01MXNqW6009NHHhcR0gsdnks-4OY
Message-ID: <CAPnZJGBAc-kqZ-MAKRGrk1big=N_GZupxKgM_+TodqgteffLvw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] initrd: remove deprecated code path (linuxrc)
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, 
	Jens Axboe <axboe@kernel.dk>, Aleksa Sarai <cyphar@cyphar.com>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
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

On Fri, Oct 10, 2025 at 6:05=E2=80=AFPM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> > -       noinitrd        [RAM] Tells the kernel not to load any configur=
ed
> > +       noinitrd        [Deprecated,RAM] Tells the kernel not to load a=
ny configured
> >                         initial RAM disk.
>
> How one is supposed to run this when just having a kernel is enough?
> At least (ex)colleague of mine was a heavy user of this option for
> testing kernel builds on the real HW.

This option applies to initrd only, not to initramfs.
Except for EFI mode, when it applies to both.

I will remove this option when I remove initrd.

In EFI mode it is easy just not to pass initramfs, so all is okay.

Also I will clarify docs in v3.

Also, please, answer here:
https://lore.kernel.org/regressions/20250918183336.5633-1-safinaskar@gmail.=
com/

--=20
Askar Safin
