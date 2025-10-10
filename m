Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B0523BCED
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 04:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760072282; cv=none; b=rkoYnsQ8RSoW4IXOMeeBP7YUA31gHehtOFoIRxrCH0KT8mN3F7vddwwaFxMf56ZgkB+wZbTnhyxP7WeFsOKVWIF6wv4xhHJTNnmRez9rPGcNFkubTxo3lh+TVDM5pkCp4k+T6Yr2bxkAveB+jVVuKXXZ28QeLE6aH1c7z6Utt10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760072282; c=relaxed/simple;
	bh=20zVq/I1A85ImSdUuzZ7bh9Qs7dqD4eEIEsQzzw5Ci4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hqX4TBrHJxPLRLmQaGHu29WCXsOVJppzidDal/wGIUAs9f+tr5LBK7Bgx3hemMVzNYRvsTyyA8T+fPrgGUhQVcqDP/WJGrJCNs1v15XEPvWVmiYU8kAiulSy9Mh/ivpEV7ErlbHJOfp4FGB7Rpban8OnJ5TXMWSjHtc8SP0KCKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PkuVLr7O; arc=none smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PkuVLr7O"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-63bc1aeb427so1693680d50.3
        for <patches@lists.linux.dev>; Thu, 09 Oct 2025 21:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760072278; x=1760677078; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j7qS0AM3lX7OGhXSFEYS6mkC3EKNzPxshbg7hLZcah0=;
        b=PkuVLr7OxOOEj0Ap1gkG0zox5iub9qlLZS0phcMIP6hSDj3GPr6QVtf+P+BYSZYC1s
         Go3oUhLxeK2zJc/hoOS74p6C7qfdTXvGxb2w0rHe+VUn8KNLPAvoMfTuJEfgycC7rYvw
         mKu1egsiiYFN2hcgEvJBHEx8v91kc/XKAsTzZENYXKwdThWfV1896r5RKkXsp34/hDQO
         8zebSOwIsAa0AfiQ4+/Z/9rWWiuyR0q1CoOL8Vol6ZgpphNvOx5Ru8XGY5c3E6CwK7Ta
         K1uDBY77p3SFTdLvoFQoSDPedmr/3knpac6v8Al1xgi1TJ6bqSDzLfwWZtXchCYBm2yV
         H9fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760072278; x=1760677078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j7qS0AM3lX7OGhXSFEYS6mkC3EKNzPxshbg7hLZcah0=;
        b=AI+PP/ELmnk24g7y7Y21ScRPSutelrfWD6T+xg4TDI7wVmzrxBzO/vjwhAAJWZSMDj
         wfBBQfliM9Osid/vDqvpjrW/OHlY6xi+WOTXusapz56xtpgOZcO1nFNdCzBVWPAdJrDV
         jF4zDwBkDurCuGcaFgzatG1v8Ga1VObJcCL9bMvejvf1SYpqrtaQzFH1vu9nLxApUs+b
         fpMWdFU5ItQTfyvZBKtLfhpTH6Rg6fOhOufWlPp90qvx8pkf67NBE6BTw033EynBYEnA
         fGXdTRXjkFHQNENWSkEc+viy3kySCdaJx8hha0TP2A4yOdiU4ytOrc4oKSZ1d6nOFhPo
         E51A==
X-Forwarded-Encrypted: i=1; AJvYcCXb8AIZv8dUdfy61GLBJPXoKIcDfmwZ8rAHM358xpNaf981L5QrRIQUrBNww1wn4y9JQjfmE1bh@lists.linux.dev
X-Gm-Message-State: AOJu0YwEka+bNvQ+LtEr7vIhMNyJpTZ+AtTVkhemuYlEP8JczudXLUF+
	pPZLULuuf9FDp+/g9QXTa6Uj+cpPBk3irKbQ9Owk1WUFHMiqrMq3eBzRzQlEHApfKTDBQyfsymm
	5RVSIxftTyOUPgbDut3ePUAzeyYQlikE=
X-Gm-Gg: ASbGncuMULn/e5CeJ9/xdVz/lkM461xb3L0VrHmSCbC14ARlX5bv6WAZ44xw942Ck+o
	ymg4lXRSlr833kXbM29ucs33nGcZa1hOepx1Z1nJOyLW+ICl97uXD9fgHQvVJNm6b5tFcE6sET0
	uloHCg6t/PSbdwOGFgOjFvI8iHPXYGdNz36qGB3Mmp3oj9Z5/JYfBF3KX2RBadFEJZa3/XSxVCa
	4v2DrxooDCPTCJqYgs3/WcYWw==
X-Google-Smtp-Source: AGHT+IHqDciv7GAPYfMGdKr9Fwuo5GT168N8GcrpsJ5KozP5HqYqg/LDALxuogvzJXgNCm6zrA+DoCqu7lr8uhQrVc0=
X-Received: by 2002:a53:5009:0:b0:636:2420:d3ce with SMTP id
 956f58d0204a3-63ccb93456dmr7466309d50.51.1760072277565; Thu, 09 Oct 2025
 21:57:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHNNwZC7gC7zaZGiSBhobSAb4m2O1BuoZ4r=SQBF-tCQyuAPvw@mail.gmail.com>
 <20250925131055.3933381-1-nschichan@freebox.fr>
In-Reply-To: <20250925131055.3933381-1-nschichan@freebox.fr>
From: Askar Safin <safinaskar@gmail.com>
Date: Fri, 10 Oct 2025 07:57:21 +0300
X-Gm-Features: AS18NWAQwCKadWHXCZjVUBNaD3TaKIilJiJAQzSbvGFaYuFuE8UDpW1_H3riB-k
Message-ID: <CAPnZJGBPyONjJoM6cskxysDnN4pxWuWJCK5A6TgikR2xHsrN5Q@mail.gmail.com>
Subject: Re: [PATCH-RFC] init: simplify initrd code (was Re: [PATCH RESEND
 00/62] initrd: remove classic initrd support).
To: nschichan@freebox.fr
Cc: akpm@linux-foundation.org, andy.shevchenko@gmail.com, axboe@kernel.dk, 
	brauner@kernel.org, cyphar@cyphar.com, devicetree@vger.kernel.org, 
	ecurtin@redhat.com, email2tema@gmail.com, graf@amazon.com, 
	gregkh@linuxfoundation.org, hca@linux.ibm.com, hch@lst.de, 
	hsiangkao@linux.alibaba.com, initramfs@vger.kernel.org, jack@suse.cz, 
	julian.stecklina@cyberus-technology.de, kees@kernel.org, 
	linux-acpi@vger.kernel.org, linux-alpha@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, 
	linux-csky@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-efi@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
	linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-um@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, mcgrof@kernel.org, 
	mingo@redhat.com, monstr@monstr.eu, mzxreary@0pointer.de, 
	patches@lists.linux.dev, rob@landley.net, sparclinux@vger.kernel.org, 
	thomas.weissschuh@linutronix.de, thorsten.blum@linux.dev, 
	torvalds@linux-foundation.org, tytso@mit.edu, viro@zeniv.linux.org.uk, 
	x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 25, 2025 at 4:12=E2=80=AFPM <nschichan@freebox.fr> wrote:
> - drop prompt_ramdisk and ramdisk_start kernel parameters
> - drop compression support
> - drop image autodetection, the whole /initrd.image content is now
>   copied into /dev/ram0
> - remove rd_load_disk() which doesn't seem to be used anywhere.

I welcome any initrd simplification!

> Hopefully my email config is now better and reaches gmail users
> correctly.

Yes, I got this email.

--
Askar Safin
