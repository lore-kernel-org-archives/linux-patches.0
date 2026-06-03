Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7315A3E4C88
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 03:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780458679; cv=pass; b=Tae4CKAwQu634lrsquU/picgQDnZkMfOv16EQFOstgwkmCFHhpMCcVVVSvUnWR6gevJIFCsii/4C2c7VefUKssPQBPGx3IYBMA9jPHiDv5G7Ps8yXCvARp8EwY2ufxtyKB7KOfzERYLqP1UCHECK5+nISrr0kBypOyYPSmXxe/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780458679; c=relaxed/simple;
	bh=anjN+nTOXqNBWHTS9fQMFqGEaXiDXaRnabq18gPz6kk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sZTXaK2azs4j1SM+c5wOQY1zXW19Kkoa8Q+y5isx/Yjuc2yqiAYn7sBNi3JyYS3B9ekmpdWs/Vrky/qRzVRh9uO7xojpAXsSVL1vbuDxmLBxsRWN5EzwpqO8TygDhdTizVQr3MfAj9RZVB0pRQyCtVi+7tQEve2S7jtg0vVpRqg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=ERoJG6xP; arc=pass smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="ERoJG6xP"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5aa2c25c632so13311918e87.1
        for <patches@lists.linux.dev>; Tue, 02 Jun 2026 20:51:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780458677; cv=none;
        d=google.com; s=arc-20240605;
        b=e5jhXudHpVWtea7rPnGhKN3vmHDiYtc1rY5YcuZSLNxUVFeB5tBNihx007Yrsdcpon
         HPiM4QpU+BvXuguv71MNmHtijNp6aGX7WTV6dx1SYx0gMoi/N6s2kA4Nf3nsf0uTKJMw
         1+WcV7uaPNPNFhPJ1eKz+zgukAhEbhKar2ZSGGXH+f5yTuRthZGFPQz4Pf3+nP5N9llJ
         8eVJGscs1+5E3UCVlZnWqm6lcaj7YcZxtgauQFM6PYSau5hxy1ozQ0JnH8qcf9AqOKkm
         g7nqLbVTke919LqwCIqW0BI9sc6P31HxGf0lPq6UP2MHZfHxUeJVH7f8wxmpCBsXZa4O
         baLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hLctvnpeHHKwaBCwCGUFctRGdwexf3XsJleZhrQYpkE=;
        fh=4SPaypGmwTwBJUsBNbX/hCq+nTnMIyZeHbZ0nn4ot5Y=;
        b=CRITEVBlLBHkpmUIXgiDDqKJoOxL5qLItzv5/ROUufQ/krEhnyscJwD047Dr8VyHx1
         p3n9PeIOFc1oLrvqV+v3rzGtv6saEpis9eSayvRwJnGNR1SMGEepShzOTm21myAuyGN5
         aTOvXliSINQz/V9L6MVr3GkiaXFzJZfSWjvrydOmrbTnylm2ClVcF2oAHIqI8TXNY/8o
         zxFpwUfiVI/EmH86/L260MOshWUB6J6wm3Mj7/Ffs4IJTouI84wwJT+u3QL6HRiu8RM9
         kliC1Osu77r1j8QumtJ9+4aCvv4y8lw9gjW6lLDdFTNfKGoNAuJ2sLfbtA+IllmIDiRX
         Apiw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1780458677; x=1781063477; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hLctvnpeHHKwaBCwCGUFctRGdwexf3XsJleZhrQYpkE=;
        b=ERoJG6xPEfcL61kkxkvTlgAPseDiMgZek0NW+dSE/7BDX2L6YcmNcq+yYl83iCOpnZ
         7tiOeAr+HCbWdAtHFOr6MWdwrRhQxlDr3udQjUKNuASI/8TZcwFLwiyyKANGI/kCD5/A
         kBXbVrLHpW/O1c0YW/dKH5Zl2CP8cKKhVmBNNMV4Npo7Bj1N1CVKe9ZpmnE+W6ARNxQ+
         7SlsBAHKCB92SSoyw/e9aT2GAzMPi9btOvZ9uwL/DEDkBrjazPJvp1cgPdOxSY6bIb0f
         ja+bFi4FmPjxQBYP7ySQULz/D1OQl75TYllxZ0rOQ7v/lhv7RfOJXKp5omOHzWUa7352
         Z7xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780458677; x=1781063477;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hLctvnpeHHKwaBCwCGUFctRGdwexf3XsJleZhrQYpkE=;
        b=BuhVsk4A5Nfx4Zi3gER+sBWFRhs/zb/JxIP5RoMXgLgoAsaezL5ahfYo8G0NmwWy2f
         zRa7/vALvOgnueKpJs6TvK6dfakV2/e0K1t+qS1SzLV7Os9AUVUFCNvKwVBUpn6Avv/m
         kdLDtkaLGhBMMrsCIaVHNc0NoSgw3//5BK3UP82Q+qhNCj6NmFcPubYOSHxt+jLZszAq
         xONQwH8Iwi8+qxYF8qCoOms19+CveVLJhS/oiEJAdUA0u1QVpYe6dxNZZHHZP7IIhAWW
         Cowu5Kv7FC8UF3FkXkVSOtvFu0Fw7l7NUJgV/MPZPaCTKwxDbCK3NdsXcSsupuIllCSE
         O5JA==
X-Forwarded-Encrypted: i=1; AFNElJ8UbfgZB1c9ZS6lE+pvhXPmnW+JCV221wkDF/8vXtGJRD9Z0b2XaShgPy55FKuQ7Q+WGsFqxP10@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6lXvFfpeMG+G3qWkXKmc8q/9kXJfCUpG8m67odJnZ1jeAzw+8
	hy4XtBEHGtXCuj+ASPAwZBFVqwSDRJyZ5SIo8ccgwJ590Et02JnWPKdyqYiqC7Taei/WD14bE7h
	1UJiCLb7kK+alEM/GJe0LX6HBjEOFjyEZAQTpwI9h
X-Gm-Gg: Acq92OHUEV4tD2Cf1GN9JVMlLSXHNa+QCotb3GTpkN4Ys5NQHI9a3kVwWQVSUVrplmh
	GP5y5sBdbBjrD34dB7H7E1f/UDW9bQc0529gYLZDmi75/X/Jzvq3T3LIp/HxUEAjSuOeDyQKyJ+
	vlpTCBKj3Kp8aOXiR/z1TranHU0kpIth829fgOxyfP8RYvI/8QVoSxPEDZzJkrcD92dAjNjw/bB
	MLnBYUtvrRteINzwf+w/Q5sucRDyQKYMxSYVapAa0zEzD4nCL7XJIWkIoVBSlYVkX0fKw/7STg3
	NXXo4C0yPhD+bDk=
X-Received: by 2002:a05:6512:1587:b0:5aa:6d0f:1dc7 with SMTP id
 2adb3069b0e04-5aa7c0bf470mr459675e87.19.1780458676548; Tue, 02 Jun 2026
 20:51:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
In-Reply-To: <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 2 Jun 2026 20:51:03 -0700
X-Gm-Features: AVHnY4I4B2wg7ilf1zQmemgKARTlVUvTJ9JxDnVBlHgiDg-UsafiWLR7jiVDKio
Message-ID: <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 2, 2026 at 5:12=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, 2 Jun 2026 at 15:54, Askar Safin <safinaskar@gmail.com> wrote:
> >
> > Pedro is talking here not about this vmsplice patch, but about
> > my future hypothetical patch, which will remove splice-pagecache-to-pip=
e.
>
> That absolutely would be my suggested next step.
>
> Something like the attached - get rid of filemap_splice_read()
> entirely, and just replace it with copy_splice_read().

Am I understanding correctly that this will completely break zerocopy
sendfile?  sendfile is, internally, splice-to-a-secret-per-task-pipe
and then splice to the socket.  How much to people care?  These days,
a lot of high-bandwidth network senders are sending encrypted data,
which is not zerocopy frompagecache.  But there are surely some users
that care, for example the person who went to the effort to implement
IORING_OP_SPLICE:

commit 7d67af2c013402537385dae343a2d0f6a4cb3bfd
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Mon Feb 24 11:32:45 2020 +0300

    io_uring: add splice(2) support

Now maybe someone cares about a different path?  Splice from socket to
pipe to file?  Splice from socket to pipe to other socket?  Does
anyone do any of this?  One can, of course, recv() directly to an
mmapped file, but then you pay for page faults, so that probably a bad
idea in most cases.  At least all of these cases don't have spliced
buffers that refer to a potentially read-only file.


But I'm a little concerned that zerocopy sends from files to network
are actually important.

--Andy
