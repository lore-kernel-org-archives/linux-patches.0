Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE2D472776
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 22:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780525414; cv=pass; b=mA2CisAMeurJRgOs780qte83+EvY7D1Jd8XwXXUnHjvRV4jNkLv+naCsLOPvvjOXBQ4NMPIHQYkLnP03SOYhRlPmsZSg7LBFtOeAGYXvpiJlOD329B4Xwqo1x4omw+8Db+Xrb3n9j57WXZkz+HhCYKR904Vn3GCOpGjAb25Kc6U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780525414; c=relaxed/simple;
	bh=qdFVVpm9+qBWydzXpCd5rc442R2RuxPVFhAYWPCKrjk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HxccStyCPwexmKpVJeweKZFMwWA/5N49A5zmBHoNL2OlfvatoJla1//wyBRqajwk2Gi13J5ay5s9cLta/AP1XMH+qthjwu4Z0p1JTIyD8fonTbFHttqTF8dhbgzaSsJ9J/1jH3f+bpUpxQpJx9Sfk9zLzYTTOvukHupdswpyNfY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=Ez+9yFV7; arc=pass smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="Ez+9yFV7"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5aa5edf347eso4012360e87.3
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 15:23:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780525412; cv=none;
        d=google.com; s=arc-20240605;
        b=RjYVDlJvc26HpttbO/5s1AhIFwZ3XYKVRP+GXPC4FnZKcV4cbTvI+0NysO6v5F6clL
         Gfh2ePFyWr3zkDCbxE/NfNvlyNNX6UYVyXoeNppMwgryflz8YfY+UEbkVAiCh5lzwz6t
         kLw7auMkPzL64HA1yhfEk/S/PmrRjKqe/o5MQP2QWd5RPWjQDUMANEUmDZ41Xvdt+nv4
         GTNQcDDZgYvhBeRnBG5OZpEceGghyi0UP2o7T/Ic2dmy9UdtXTaqdU6BErNtl3AKmX2T
         UL7K5LYewXWuovWfXo2duBRvDHDxYs+lQhKY2DaFXOgXVD+yOQ2Ms/VdewfrkB0cb40C
         bM2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s3SPKunMho6E/CBsMnfM4oP5YS4R7re3HwYPdqVA40w=;
        fh=y9xaNaP7M75QC3/apTLJQY1oe+8GCgk40u5uHpfbxyM=;
        b=Dy8rjX5TJheKl0ao/jF8/E0JtQTiBAlqHwVlWprlmd2u6mRol4N4CG4DDidglfbfmb
         1Z20J/EQAFoDgS02nya38XffqogWNggtbgXvbPuryE8nNUgARnpOzCoRIudUFo2xOr8j
         0zVhpWpjf7tdm9YlsvtnC8CPlfcUKy930i+o94bxP4qDM6pxYByMmwLZW5kicQnclnHf
         lG2e2R3xkJb36opli7f0cCgne3cG9aCUegdT0GVoymz3aoVzMmHe7OdR9F1WUWip3AHi
         D7vXVGxU13eT2CupbTKEMA/29sivVUmjJfcmhACLgaT0iPWo4Nclp2PugavrCReh127s
         zg4g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1780525412; x=1781130212; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s3SPKunMho6E/CBsMnfM4oP5YS4R7re3HwYPdqVA40w=;
        b=Ez+9yFV7jDxak6dwO95GP1WzFoXRoTrbQP0drNHSj3ynQgpfRI2o/OEcKydQu7QXWH
         uBBf8RcqX2tju5JG38OteyXqub5IA0zBOji+pDeXNC9xpi9Jb6YUjMt2dBPb11IS/4zN
         /kfDK/D6JMCrtYVYQ3VJmmKuIwuq5vkPkd76lLa6Oq3uj/9TOCcC4tAdrkBGJ7I00QLi
         nS80cDJ8dgZ6yiU0vUUeZXQjy/Gyxj/LakTMQfuZ3ZOtynRdnGNSay12GmRKvNXpub75
         6Dhg7y9LsIMZabDmqXq+YV5jxih9Z0UDnvT322ty9iQsrTqjiREuwzMUsgL3k3rfbn9T
         c5aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780525412; x=1781130212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s3SPKunMho6E/CBsMnfM4oP5YS4R7re3HwYPdqVA40w=;
        b=CoOqrNkr6S9nFNsgqpWyGE1aY0LFZzuAAJBtDsPq04ZcrPLiVZ6LVVr/+VUU2LdE8V
         3VtyIiUNslYp8hh3S4qePBCCloCoKQqzb0wuy/kVvCqyscRKAfTKTiL2GR+dY7IGnDxy
         2mf93j7NDA/Zj1I5pcxTKSNjkerrWEEPImsZ9Zziq2SUzlyTdK5wCKqTgUBTTPcpgU7W
         rDXtZ0AXYDQ4z+f22IO1ukEXWxfpb00YVrCoL2yWWh6HRP5bYY72tkcEx9GkO8FJKCC4
         lgYHxQtcJ5fqd6ab9w9hEc3A/otlYFlLM3Y7Im0UaBTUkEtR5otDnN0YGItd3Uc0Jg9/
         oQ4w==
X-Forwarded-Encrypted: i=1; AFNElJ++WM+I5fGz7Z2Eyd1W2CcWan0SvBCDw7hyG/QHBT0nS/LMbhCbkW3y+RIF/rZR5b69MSHfOef/@lists.linux.dev
X-Gm-Message-State: AOJu0Ywbx97qyDCIMalPcij0uEGbkb8aIF1XC8lmrDL7LcBR2J59R9DZ
	zy/wlylPmNI8xBtUl6lqANa6U5QMf8NsvoXNaYYLsYwYCZCIduJnAgJcR9i11W8LrRzFFlZlGl/
	LxCiypJ8xdo2CUG/6oFBMQusuTwvHwiJl3Km+93rp
X-Gm-Gg: Acq92OG9o/TEhCE/2Jomp5rDsO8QsOpXS13V79PuKBaCAwtr6QaLsYvW/uVq/rF2vzs
	OSUQtv1GdOjXi78nGyQlo7eUwr8qS1vJsHeoiJOYg/rNoMaDiTw4H4T0giD2ZFwltVO7WUzG5xa
	QvNTP8uzokXOQBFvsSdnzca6eIBYJxvcXz0Tv9c70vlA8uH5Uuc5+N5YMT9WpoDFD9iTV12mYtt
	YGdJRqrcYl4FbtH4Avh4f/+2EO8+cvVm3p4fbYFDo9RVCkEVs8P0e86FTMNRXnHs5M5z8L21TOC
	IM/1LexjR58CGwS084A=
X-Received: by 2002:a05:6512:3d14:b0:5aa:7126:c645 with SMTP id
 2adb3069b0e04-5aa7c088c90mr1762489e87.2.1780525411782; Wed, 03 Jun 2026
 15:23:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
 <CALCETrXzxubt4eWue3+wv7Fq9C2m7uu6bWPstqFh6Mo57bPwQQ@mail.gmail.com>
 <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com>
 <CALCETrW3XcNLuB1Y6PSkxQDSK2o+=EB2AAd25SjWQqcJemwnbw@mail.gmail.com> <CAHk-=wgn3QTLj+F+XccE10dXY-UGWN8+fNLEvhsLw+tik9rOmg@mail.gmail.com>
In-Reply-To: <CAHk-=wgn3QTLj+F+XccE10dXY-UGWN8+fNLEvhsLw+tik9rOmg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 3 Jun 2026 15:23:19 -0700
X-Gm-Features: AVHnY4Ikay6WVUle1y1S25sIv6i_k8jcErZspj4ec4V3SJVcTGqkjlXJTjro2bQ
Message-ID: <CALCETrXpqPMS487Bm8f8mHe8hv9DzCqoaW4UdoHetzYBUAhYLw@mail.gmail.com>
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

On Wed, Jun 3, 2026 at 2:39=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, 3 Jun 2026 at 14:31, Andy Lutomirski <luto@amacapital.net> wrote:
> >
> > I think I buried the lede too much and you're arguing against what I
> > was trying not to say.
> >
> > Maybe we should keep an API that does an optimized copy, from one fd
> > to another, that can send from a file to the network with at most ONE
> > cpu-side copy.  Not aiming for zero like sendfile / splice.  Aiming
> > for one.
>
> Oh, absolutely - that's what my completely untested test patch  basically=
 did.
>
> The user space interface was still there.
>
> And the networking side still continued to use the ->splice_write()
> thing for writing to the socket.

So I'm suspicious that you've possibly make bugs much (MUCH) harder to
exploit, but the underlying awful code and opportunity for bugs is
still there.  MSG_SPLICE_PAGES is still around, and there is still
(AFAICS) no actual coherent description of what it means.  There is
code that checks for it and apparently needs to do something special.
Foir example, some random kernel version I have checked out has this
delight in af_alg.c:

                /* use the existing memory in an allocated page */
                if (ctx->merge && !(msg->msg_flags & MSG_SPLICE_PAGES)) {

Grepping for MSG_SPLICE_PAGES come up with all kinds of terrors.
Check out the lovely comment in drivers/block/drbd/drbd_main.c, for
example...

And even with your patch, I think checking for MSG_SPLICE_PAGES still
matters: if I write to a pipe (using copy_splice_read or even just
plain write) and then I tee() that data, then I splice one of those
teed copies into a socket, then we hit ->sendmsg with MSG_SPLICE_PAGES
set, and we're hoping that the code does the right thing.  And maybe
all the bugs are fixed by now or maybe they're not.  Most of what your
patch accomplishes is breaking the connection between the buffers and
pagecache, so you can't poison /sbin/su.

It also seems kind of unfortunate that we can have skbs that contain
data that isn't actually owned by the socket in question, and, with
your patch applied, I'm wondering if the only case where this can
really happen is tee() and a handful of random drivers that send to
sockets.  (The ones in drivers/nvme/host/tcp.c and iSCSI seem like the
ones that people are likely to care about the most.)

I *think* that what I'm sort of suggesting is to drop this ability
from the kernel as well, or at least to consider it.  skbs would
always own their contents.  And something would get wired up so that
at least the cases of sendfile, nvme and iscsi to TCP or UDP sockets
would still works with only one copy, from the source page cache into
the socket buffer.


I suppose the counterargument is that, even if more bugs exist, it's a
bit hard to imagine a real attack involving tee, and one needs
privileges to set up nvme or iscsi aimed at an unusual socket type.

--=20
Andy Lutomirski
AMA Capital Management, LLC
