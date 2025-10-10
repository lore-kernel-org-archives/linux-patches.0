Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F472F7ADD
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 15:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760108713; cv=none; b=DLC9SJ8HFAwrZWqyTuX71wQ7c4tAlXlU/bBiPJX3eVsGX+mCdxs65RCMNl3koepTa//3NYBy66iHjVs2eScwUhqwStkQO1bTAriZrm6YL7EPSnFgmJaYj70Jf1oje2dGUQ4dQGQXBWKfI6f687ZFVjAbiWMutcPO7pZIvb+Gkro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760108713; c=relaxed/simple;
	bh=auvR4vzTTatOuCuru52VOtm4KI7SmeTOVUgJyw2/46g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g6oNf6pmHUY/TjfnF340aA/pHjylEfgnc3IBpeVZeoBEnLqEC2oD/amNOMdf3jALKAPlq6b8YhlbC6PNer1w27va+gk/TPCTzB4AtT41Bz5o4IOD8WTh+9ztNEgC/yRfGMPxlMO0UhzvZFWBf3rBbUzOD+K2Y/d+UHZRKigEij4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VfHgN5FQ; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VfHgN5FQ"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b3da3b34950so358792066b.3
        for <patches@lists.linux.dev>; Fri, 10 Oct 2025 08:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760108709; x=1760713509; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NIWxPopIPg40sXCXJnzxg4lhVvntApAACn3HESqIPcY=;
        b=VfHgN5FQEPOflHGeEBVRI9W/80RK3eRHBqVEM7DjaJcOAObJaOugt5m1ohPQV3Of3P
         Fz6N6c4gmP72ZCI00DYmWTlpERll3BStZKxAg6qodPsQ/jP7ZnQ66d/dc0eFh8oBQWRb
         C0Frh+23QYAlvnCquyuYEWx3+V2gumeKTcIOwUiHMUDiNGe3K4DTFUbmg/A2docyW8OD
         Q/ULatVZFM8eF0gp7Sxhe9vps+1ErnDWrMnDgOdi3FkScCyuKSAFHN5qec97R80LSh9+
         hUhLy5eG3Tc1WXaSJJFR4Hqa+bAipb6Zaa8WotJaTw936YLAS7FzLwREXIJCw4gXldPY
         zuWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760108709; x=1760713509;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NIWxPopIPg40sXCXJnzxg4lhVvntApAACn3HESqIPcY=;
        b=XYnAmvajvrNFJqc/0sLEZQh5ztMtrAIxModob1QENvmUPPgrc/AZSBTkbfDBm4oPJP
         NHHFKbSAffcxI9xPKP8QzXjI9m/ZAQPHeJPT6HpeXp7+vF1odnmZIdK49/sauBHAgX+Y
         ptjehnjd/tcE1XvUXUUizRdIKe9eoBS3+XQOykEQXpvk5HiHI2H5fsdNEnQb6Gbv55S0
         RcLY6uicfPVDTy9feOtfC++jHFFVJDAdFJkBhVmZ/C9mqoiV8YFfyxwzak2l7qoIUoC7
         b8VWzc9UnjCGsd02ljUafLpO5dRXBdQOr7H9ko4zl+GMiWvQ3yFPVj++4n3T/wVjFDlq
         Jy4g==
X-Forwarded-Encrypted: i=1; AJvYcCUalPmPXDOb9uCacGnKtZFiiKHUwwNTZxQczc1ZczEE/SmKnhtxsOCSPDgbhEC7bCCLdPkAClFP@lists.linux.dev
X-Gm-Message-State: AOJu0Yz2x2b6RweFvTwt4SbPIkkq3f8x/hbg8X2Z15fQD9yEz/EgdNeB
	MPMCrwYHanOufYF9gbT/N0D5oAz1rYjexHJBr3wYhE9+UpaOFgmOl5yTpiB9oIQ3Bbq/YVyOS9b
	mI+H0c7LgQkJeln8vgaDuUpLnS4IszOc=
X-Gm-Gg: ASbGncvhUCWL5aFhEtG461Ryt6gL6yQyYjtxbf1y5f52tdMhfCG2GrMZxRnojsVP3hh
	uLnONBQAUqvysWS91Bz/WC8Y1bU5nkH38bYJ+BWbXYhJfCKX9ln+ynkc9+kshOI7U4b0+szp9/K
	cg0dfBehiuPXfIZibpVk322SuQMsF3ZU/vT31787SyzhCGBDayBxiSLlweZdeN8KwZcAyKh+ZN1
	4B7G7W8FUoOvMRxQW+CMWIBO9vk1QW/X/whYVps7YlTKXA=
X-Google-Smtp-Source: AGHT+IF09dfhTcQpiRWLSf2A1k/s4FQSc760VKHf84ZQbfzXVjJJrp2yCq5wGIDsYhhFT8HuSa1w5HwjyUCOwQmF8So=
X-Received: by 2002:a17:907:2da3:b0:b3e:e244:1d8 with SMTP id
 a640c23a62f3a-b50abaa44c8mr1245748966b.34.1760108709145; Fri, 10 Oct 2025
 08:05:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251010094047.3111495-1-safinaskar@gmail.com> <20251010094047.3111495-3-safinaskar@gmail.com>
In-Reply-To: <20251010094047.3111495-3-safinaskar@gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Fri, 10 Oct 2025 18:04:33 +0300
X-Gm-Features: AS18NWCvLx5PLZaUkorsbem-B-yR3hlKjw6yF-hbdTFMFmR4Zuzb6EIcT1htWkA
Message-ID: <CAHp75VezkZ7A1VOP8cBH8h0DKVumP66jjUbepMCP87wGOrh+MQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] initrd: remove deprecated code path (linuxrc)
To: Askar Safin <safinaskar@gmail.com>
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

On Fri, Oct 10, 2025 at 12:42=E2=80=AFPM Askar Safin <safinaskar@gmail.com>=
 wrote:
>
> Remove linuxrc initrd code path, which was deprecated in 2020.
>
> Initramfs and (non-initial) RAM disks (i. e. brd) still work.
>
> Both built-in and bootloader-supplied initramfs still work.
>
> Non-linuxrc initrd code path (i. e. using /dev/ram as final root
> filesystem) still works, but I put deprecation message into it

...

> -       noinitrd        [RAM] Tells the kernel not to load any configured
> +       noinitrd        [Deprecated,RAM] Tells the kernel not to load any=
 configured
>                         initial RAM disk.

How one is supposed to run this when just having a kernel is enough?
At least (ex)colleague of mine was a heavy user of this option for
testing kernel builds on the real HW.

--=20
With Best Regards,
Andy Shevchenko
