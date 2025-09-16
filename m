Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BDF212560
	for <patches@lists.linux.dev>; Tue, 16 Sep 2025 01:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757987337; cv=none; b=YdDMF2Xu+imPZiGkQxqTZ0xhuYcIPFQqxZPPxLRt5XR3iHnz8qlR9tHIGDzd2AlAiAcxgCMHTV64ITx48vFWe8pwWhBy9xQ2JE53iWlAVqJnNrwV0VJ9cX1rIK+wAkV6DYHhOhP+WlJofflWReZuENelwQXnqbvkek7NolbiWTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757987337; c=relaxed/simple;
	bh=ixp1vRoqVO/aQuZyYy6zFP7jfZFHYTqyHd5Z6tSU/S0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KdWDJiuy4aNUf7QGzrOxRcSOhvftyVTMvnbc1MSaJ24FXE6ir+9n34TwgMO95xJbAtK8gVSoldVtSQFpZIpDTr7N7glpFSlw+qvDQFLz8ZsWRmeFd1JTnLGQf9HXmYGGzZ84Psx0aDJH9fIgJeaG+zLyJWQWTmqi3BfXkr16lJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JGzWjT6J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JGzWjT6J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757987333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UM/63QbNRNL2CWSzKhJPtVEvJogEqqs3VcsifJT7nZg=;
	b=JGzWjT6JFY44F9HuG73zfC+XVXSpyEZnpQCAqiavnVJaex4OmR07wPNEUXLEBK3aPPNASb
	DTaTB1gZFE+DJer/o51vsb0HNic3DYvivGyJhMpU+pMvEA5BzK1/RIXnL5VmsY2pUK7A4X
	JJbm37DGkbr6iy5wEYEwqu+Km41BUrY=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-147-riWB5Pn5PXyAhdpub0v1FA-1; Mon, 15 Sep 2025 21:48:51 -0400
X-MC-Unique: riWB5Pn5PXyAhdpub0v1FA-1
X-Mimecast-MFC-AGG-ID: riWB5Pn5PXyAhdpub0v1FA_1757987330
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-571c4a20e8aso1867394e87.3
        for <patches@lists.linux.dev>; Mon, 15 Sep 2025 18:48:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757987330; x=1758592130;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UM/63QbNRNL2CWSzKhJPtVEvJogEqqs3VcsifJT7nZg=;
        b=sjwkNIfCKnjyF4ZOA0WHMVkGAteeSi2oXgPahgafMEklxqO8wBmQ+GnyziBHfYTiRX
         J3KTsT4DaZnML4CHF7oAeaI965aNwXqd/O7EB/iTqDn0jNZBQBJyUYqEO0wWah7Kj5oT
         rmOMp1Gbp7lpOlL2XzM7mBXxGSuaX7ZeQz1n7h/1jpLVvnEUqySG1jGPfnSpZW5qPIoG
         7rozSNBBv4phDXjgznWag5RcW5kNuSYChcB9shzu/QKPYRBM1veuWLJvU9eYF9TtyJkr
         ePA8nuw6C9JAv58Cb7njkKlZ9iJl7Oaq0zug+AIQAS6QqU08mz/hpF9F9XAdec09b6AM
         Im7w==
X-Forwarded-Encrypted: i=1; AJvYcCVhdjm4Sgdq0LExPu4CmOvDjZR4+Ar1L8FxL78taT6XQYHZTyQXFvm53JsCpY9+BBT2dGb5XGJb@lists.linux.dev
X-Gm-Message-State: AOJu0YxfdIAKe0mA1dKlVeuFJw8RWnTLrlZDoWHNgkPVGfNKJGEDEZ2V
	u8CXl0sdRdZfMOJ0pm+vXDcFeqCO3tRNy9nJrJdZn6PTgg5hICrFLCZpTOArkO/fv5omHnjNN/P
	vrhdX5MomUW8cuTQO7om+34LycaXMV7iGPynxviYdFhALfRlGkEeQGXHAgiWi1n3gCz1CY8gYxP
	23SQiUZDx94PUBO276yi+9GPIwRn1TGOgQkA==
X-Gm-Gg: ASbGncv3uRJmwOw7/JnwRd3UlgodD8TkfHXxIvUW/YT2ZuGG6ZlJNPoe7ljaCobXzAK
	ybUNQmHcQsPqUyck8fCmYb6XoZoRKXnSb6oLk1MhKu0/ZzRvIkVzWLAVu8viCwGloYYLF2omgkd
	YnqxYeE3AD+suTOPDFNzdpVg==
X-Received: by 2002:a05:6512:3f21:b0:563:d896:2d14 with SMTP id 2adb3069b0e04-5704f7a3535mr4252932e87.36.1757987330033;
        Mon, 15 Sep 2025 18:48:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGi0qyrJSXhatUAjAN5GaSbgChEfkulnz/zBRoEI09ayrVbCpTRhDlFRFU2ScIQdlOHU/dANXpgiKsiuT/Fm5k=
X-Received: by 2002:a05:6512:3f21:b0:563:d896:2d14 with SMTP id
 2adb3069b0e04-5704f7a3535mr4252904e87.36.1757987329545; Mon, 15 Sep 2025
 18:48:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250912223937.3735076-1-safinaskar@zohomail.com>
In-Reply-To: <20250912223937.3735076-1-safinaskar@zohomail.com>
From: Dave Young <dyoung@redhat.com>
Date: Tue, 16 Sep 2025 09:48:40 +0800
X-Gm-Features: AS18NWBkCHbtMZDfiuZiXnfW8KzozFHrUJlGejiASEzNumvZVB8NmHoE7UrrQwg
Message-ID: <CALu+AoRt5wEgx-=S263CReDf8FmLWwjs8dF9cX4_jFcMUkuujQ@mail.gmail.com>
Subject: Re: [PATCH 00/62] initrd: remove classic initrd support
To: Askar Safin <safinaskar@zohomail.com>
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
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2aFD3CJdjsrTvB5QOHvJoRCnD-Iavz6mmWttKFH0VGY_1757987330
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

Hi,

On Sat, 13 Sept 2025 at 06:42, Askar Safin <safinaskar@zohomail.com> wrote:
>
> Intro
> ====
> This patchset removes classic initrd (initial RAM disk) support,
> which was deprecated in 2020.
> Initramfs still stays, and RAM disk itself (brd) still stays, too.

There is one initrd use case in my mind, it can be extended to co-work
with overlayfs as a kernel built-in solution for initrd(compressed fs
image)+overlayfs.   Currently we can use compressed fs images
(squashfs or erofs) within initramfs,  and kernel loop mount together
with overlayfs, this works fine but extra pre-mount phase is needed.

Thanks
Dave

