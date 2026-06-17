Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C53C3B0AFA
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 19:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781726254; cv=pass; b=MNRB2/Wocr7ppyhZSiCvzsOaBhdIyj+kd8zmoi6AHZ7Pwl8Jq5B0D1hetHwekRyvhYTeFekbGFgLkBT5l1NPaUZOEqnKwGhASk/JYGj0Bi/pCMRDEDahEMFeAcql+7GTr/WpqHjLcRqyHlpzpgpfZSdlL5vREGdUcRSpy6yFKkI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781726254; c=relaxed/simple;
	bh=zJ0IUeGHsdJdPluNaERbeBaxMQit3LG3hz6ZGuJa0tY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KGyAvaRLpP5bfTekMkdFJZiGEQTcTae89LINpoujAIfmB2hBxBeGblpie531YcMLz2bp6SvbLrP+Yf1cUH8iK0EdP2G2SXhYlWHutbBjqFjEPjY883v3Nd2GLO/rWiWIThVSn5UuTuJqHvmhhMC8/XWRQHJ4Srq+wZMjKBKS5p0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CaiTZoYL; arc=pass smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CaiTZoYL"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-6a0b1edbe32so188492eaf.1
        for <patches@lists.linux.dev>; Wed, 17 Jun 2026 12:57:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781726246; cv=none;
        d=google.com; s=arc-20240605;
        b=QVv+6HVq3mnNfIJ9SC5NAmMNWxM3BnqAr1MbeCvedDnyphLhS6R/8aiig1t6Qfa76d
         YLMFQLa58+hnAUsrcgUivB7c5w3/MCruqwJGDTWUcFn9pJ8oS5jqMQxO2BZfipPgqB0w
         8hrk4DGJZ4BBijH+T5lOqu2/IRPhCRzkQ2/NaYtaq8Yw5NIgBL6en844MzjIpsPedjcw
         1AnXBpdzvxwJAXwS1iQG7gtp9ee80jm6UDuLA91xNs8Fdz5+Ggh2Lo2yVo/xzmA02Fai
         KRojJXBSorZ7pD/X60KGr2pSwWc791cYOZLkKFXACrMRybMXXeA7ypvRm3W03FHAkqz3
         65PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i6aC/adY0+BnTZkQLrAHVNjq6XIIvBAX4bGpMQTnTwE=;
        fh=dnizlUUPidpX8d8K770krYfan7dHg9SxNBxVkDmA4Lo=;
        b=iNBIEL+1vNiegsJTfwT/Ww4Zowb2AZQKPnkaHTx+VUaU163vCcs1QK6qBX4yA2MjPb
         AguV5TvwpRRaoKpxBh6LxPfozRKkspZaVutT40t5O8Mt9Umf1igGVC5OHGsLui/X1l1z
         vvXIjbNfDfOJUl0Tannggx0BMr7esYuGuYDbUhT2BU7Dp56eSc5tgGCMvPyP5mz4020y
         SNCdbRQSDj2EOlmywuS8KSUq300KC07+d/Zw/FSHfk1UIVfkFc6PHodlHf+HrARGm9aS
         oPvKkYoOzcO2u7vdxO4HYrSSep9bWO7NY8F3VMYwzSZ6nITQZtwMZtWPXyYh8mPZtDn/
         LhTA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781726246; x=1782331046; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i6aC/adY0+BnTZkQLrAHVNjq6XIIvBAX4bGpMQTnTwE=;
        b=CaiTZoYLO0HoZl/P0oTtm9M5wWyU041uYxv0NCPXj0pRR25VxhCnU5NIHY8Aq1EJSo
         U3sn8Up9OBSHDscNvXbrccy/2m8+m1hJnP/SrWYzs9TW5GSCo6+E8m7detawrN3zH6It
         +3NnO9w6JK95NY3TZYUkko4QuajrOJIqBzPMgzOHqwT8ajOeiZ+QiFX1BeeZjZxtAfVK
         0jovjSvTc+v4OlAe7q2eIJxDaoSmxtIVObAB7M9h4Yaqw8TsNcVYmXhR7MHzy4mA3vJD
         WxlSTDkGazDvTTjMZX/HnATHh3WXujEMzrmC4iszFzZU72dvSjowwpDF4g++yBOrDC1I
         Mv/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781726246; x=1782331046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i6aC/adY0+BnTZkQLrAHVNjq6XIIvBAX4bGpMQTnTwE=;
        b=jY0HFBFoIw9y4EUoqjU7oR2Owk08kVBfst7WZX69Jv+4OJFOvjYrauyPno8azsoOou
         cqqQZN0wZ9B8ib8Zj0Z+zQ897AFb5iq+D+ni13jBWsuk3njhH06+GYJM9+xthejv1JLu
         tOle3Lg9m3M0QxWE6XPX5bFIRJZiBwoUJ5MWyazNoVMdFmV8QuqTfRjcuKTJHGxqDGW8
         a8xBM5o7QUif4wy/RWaXbgJplZtKEPDLj3v+20Wdgvo+8BStaMZxcFAeDyZ3yYq/8EXF
         +1QF1Edt6P2CHAEh+GqRSOwKcNb7jdR82cyIyVIf87hicD1YEONXr1whef/yTffBRcjr
         awBQ==
X-Forwarded-Encrypted: i=1; AFNElJ914QOkLhNltfsqd56otyuedoz6sW91OtHMP77eSeOEi7Div21xQzaVAnkaHzXjWBJ7LV5NKmxQ@lists.linux.dev
X-Gm-Message-State: AOJu0YwvrDJ/OPbPze5MEei0P4qB8KjrDeXyl7kljom6TedOO8zQtjMd
	u6edGxaU0PWTgSEtA+lPMZ4+n5fvmoflaTObupy8tE9Hl3UK3bZfP6Vv43Z0YNmYqV6uaK7IxCj
	tyYf6xjxDF2guHs8IABVkN2m+JOJFFfQ=
X-Gm-Gg: Acq92OHi1Fejl/zClGu8u+evLcr8C5P6hHat836KLC0Tmacb2qdLLlP6AMLUOWZ7QCH
	5AAtLWm3r1kz+r1Sfqvn6T0sFdDJA6hS2JxSe0k8cQP0OZOXy5tk7oe76DrN+N4udKjbfZiteQc
	cO/pg5TGF57cq84Y3RQQM7VJFEL/Ic44BjOaFevvuHokhkbYvi/vzex4M/5MCh+ga33mnsE59Gw
	o6hgpGkODTPav34yJgEpP2/xNkScv9roPAdxFmqtajAqBijpLOkQR32tBjpEAzSo+KFw0g=
X-Received: by 2002:a05:6820:1c90:b0:68a:f494:e8fc with SMTP id
 006d021491bc7-6a0b60c0b36mr3762306eaf.33.1781726245995; Wed, 17 Jun 2026
 12:57:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV> <83f05c55-efba-4bf5-abfe-d2ab0819e904@packett.cool>
 <CAJnrk1Y9egYizkx1H9K0cqxSYuB+7vLvQbV7Tf4C5eHFqnnC-A@mail.gmail.com> <20260617-attest-gewechselt-tragik-7ed473860051@brauner>
In-Reply-To: <20260617-attest-gewechselt-tragik-7ed473860051@brauner>
From: Andrei Vagin <avagin@gmail.com>
Date: Wed, 17 Jun 2026 12:57:14 -0700
X-Gm-Features: AVVi8CcHFrVPI3Twv4VAYTkdhufN4WGXszz_j2JUYmYPkPtYdrsmDFCM1RURvTg
Message-ID: <CANaxB-zK5q=Xw6UZTmeFtXsDZjUsPkFk=p485m-wtNTBnf4hgg@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Christian Brauner <brauner@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, Val Packett <val@packett.cool>, 
	Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Steven Rostedt <rostedt@goodmis.org>, fuse-devel <fuse-devel@lists.linux.dev>, 
	Bernd Schubert <bernd@bsbernd.com>, Aleksandr Mikhalitsyn <alexander@mihalicyn.com>, 
	"criu@lists.linux.dev" <criu@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 17, 2026 at 4:08=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> > After this patch, step b) is a straight copy which means step d)'s
> > fixup doesn't modify what's in the pipe. This could be fixed up in
> > libfuse to not depend on modify-after-vmsplice, but I don't think this
> > helps for applications using already-released libfuse versions. I
> > think this patch needs to be reverted.
>
> Note, nothing was merged. I deliberately kept in -next though for a long
> time to see how quickly we'd see regressions.

The bait worked. CRIU wins a prize in this lottery.

The CRIU fifo test fails with this change. The problem is that vmsplice
with SPLICE_F_NONBLOCK to a fifo file descriptor fails with -EOPNOTSUPP.

It seems we need a fix like this one:

diff --git a/fs/pipe.c b/fs/pipe.c
index 429b0714ec57..6fc49e933727 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1253,6 +1253,7 @@ static int fifo_open(struct inode *inode, struct
file *filp)

        /* We can only do regular read/write on fifos */
        stream_open(inode, filp);
+       filp->f_mode |=3D FMODE_NOWAIT;

        switch (filp->f_mode & (FMODE_READ | FMODE_WRITE)) {
        case FMODE_READ:
