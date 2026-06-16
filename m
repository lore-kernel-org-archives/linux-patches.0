Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400173EDADF
	for <patches@lists.linux.dev>; Tue, 16 Jun 2026 06:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781591900; cv=pass; b=aOA1cye8FtXQ8TYupYrHG0ZGp9YV8RZQRQ7g1YZ8L4sxtyaL1w73+XN0seZG8hq9IfQg5hiAG+D/NwDsVNeKl0joCXKwjZXr4H9t9dYOAED4LjAIQXLmoqVbep27O7yBr9mfzKL0JuiyHpPxq9nEfX6Tdrhs0wJcGzv14x4fOIA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781591900; c=relaxed/simple;
	bh=VAHE27Z0i1OSVl2fxjSynlkhr+r+LPgK1uJ+hP7Zbj8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZxnU4RpjGCusD7mxZsNW+acGYoCPshNt2bSWtUTkxXIpYRMiWzLM3KUnpQb2pgqADVLKcf8CLCXbIHEZTCMYehAoDbQbLtH3o06nvcdCH0kfuyKzwG27PcyoPrIQFFhsiKChgiV6zEV/TmUpzMp4zihZcYRsYeVWV05+C0fF7w0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YDmKGw2u; arc=pass smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YDmKGw2u"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4600cbb06deso2305016f8f.1
        for <patches@lists.linux.dev>; Mon, 15 Jun 2026 23:38:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781591898; cv=none;
        d=google.com; s=arc-20240605;
        b=jiOaYBUjl3OlJiHKRexevawMbp5nwq8/fxbKdL0E+X3Eg914JvBGSli8Jd0n+Iwc74
         wxaQSrrJ81t83cimsTjynwynQAdJZ6ljGDtMppwaWKOAZ5fvm1FnVJOgSrCRvhfMfMfx
         OXMKcegdQ9IietRv2Ms1bqF3SSHXqIq0xCb0sj5i9/6Wyx32ni/RF2eUe6SjEc7arZ47
         PCYKe5a+WtMNOEvYcZLe8TGtdKo6fRTPvIxO8JOqZftqEEdfe6Ze5MBROhVZZdDYVPw/
         BX93sRPkbucIbyqdr2kgq7MPFZU0JlJMu08xiB6+qdqbDE0FtteMMvqDG+d3xJLa2s2h
         E0ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VAHE27Z0i1OSVl2fxjSynlkhr+r+LPgK1uJ+hP7Zbj8=;
        fh=4MrnyhPA+MVor3xdy/0Y1tAxo8gd8iwwMOj3RJjWpUs=;
        b=EJT4UGyKStj3BbPuVRhZ35H3+/O+0pU0nXM+UUqWRAw58uHY47+bchEZGDH5LBDq0S
         9kOFhhdyngHF92bXtIbmoLNRF+ZXMH2AwrEdw8yIzeRLecq/T6xDkw82KhScdRcryFlk
         NV6+0Eij8IMKkyR3N5RFrNEEj0G6IsacCPcwuyv8vC0nozXvXz4xJH+QIoPwEkZeBVxr
         EId0CSeWpOyGDoHEyFfjrs1eV/Tr3MPEhaVlRl0n9V51phINCFTB4ZAIkJLInHWdcxou
         fskft1Jb5RBY4DsFkhzEUxy1hW/JRGDqILX+UsnrgWCETA+lxfoyD9AT+9c/kLXPNrKQ
         Y18A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781591898; x=1782196698; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VAHE27Z0i1OSVl2fxjSynlkhr+r+LPgK1uJ+hP7Zbj8=;
        b=YDmKGw2uk2eFSFsBrilMdBC6ZazV1LxjbrjCGZtazWy7hbLjk1cYC3V1HhWPWgoZcC
         S0tsMpqZW8nrnSK+Ez2X6uf3X4OIdr3ijAyDGSBlyuL+eXg7pp21VxuL/ginln0aycrK
         /hMU7aBd4nEbVVQTHMNgN6I24TBsJXtewhxAbleBJcNwkt2J+VaeWCG+qHZarToEYgKA
         M9FhAAcmqqqNHnm9Or9hsmCfzYgEtxS5QG3OlkTn2X33UMHoyOcOQwEcQuv68Dux2IA1
         DKqWJLqAzt4W+TJR0doRnVWbR0AfZxTbP9lKIFy8O1uIQ+oRUu/yqcZiP/CtRr64EnYU
         cXhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781591898; x=1782196698;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VAHE27Z0i1OSVl2fxjSynlkhr+r+LPgK1uJ+hP7Zbj8=;
        b=oGcvYCKPunVih921jBEL6KEvJruS57cQ2PTPwV5Y67Te1R2vva8ZX+iXrPSy1YD3/a
         4/o2yHIC9ATkL1L6D5+fIVCg68fg/qA9apLGYSsw5q8coSh7j6tL4RpnqnNDQjp2PPUT
         jvZG7IsLnBD16UsjeGTiEel6EnERm1drD/jRTftosGkpM1pNWAKi0WAx/kgcn2uo714T
         +ZZuVlG3C/ZPwlTcF8SjRTf90gl9G1zvhq9r9sDyMNyCcXox76nNSEekUd2n6BWGWD61
         iLAvUQUpe5aTqeFOgOLHnqDzUqzxhOgvPuBMnQTDZIjuKRoVtGvvkAMRYlJwxlvkTKbv
         tiNQ==
X-Forwarded-Encrypted: i=1; AFNElJ8/AIhDhYNQre/z0qcaElF0rX/QNK+vvqRG2gZ/tN/AIv3ECkRq4agWJ1MQZgm20XSD9n5jzVPQ@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7ZL5bzmamBpkX3foaLxUwhBdsrb3WNiF7NWIoWDTw4RiDU2Br
	XovbEXovozLzuuKioOoZxv5xqwNVC1el8obRm4LCHLS9GgNYYUvoXD0DFdBUBVydDc6cmaCoY1/
	vdaM4X6pecF3HiT3Ljw43nN6WV/Eevwk=
X-Gm-Gg: Acq92OHfsREhruNp7ntNFDCjidKOn4QZBvpXsEMeDYiW48cvNbVwhX9qTs93e9FDMxL
	Foj7HGBIKdMjZFuT48abzqdJH8yPKhSMmxsu+W7tUcrgBoM8dtZHQiO10kHnJjncaGEApIId2Qf
	HhL4OGXB2llghGQBWDj+P+5YzQPVug22fM5vOPz8K51JU3ij/fk3gwgGGc+ZwUTypdzfnGJoHge
	VeEWoUhXABHEjD8duGg8n/LZrvFd9B+rzMGk4JXKKvHtIRDU9+r2JbZAhGOeATKIK5t1GC2s9x5
	lSS8J4CmWcQlny5D5NLiFnpmikK8jbybvbWiqKO56jxudZwZoNlY6jZMmTwTxs6zFkcQqRQsst3
	liw==
X-Received: by 2002:a5d:5d11:0:b0:461:a19d:3547 with SMTP id
 ffacd0b85a97d-461a19d361emr1794950f8f.19.1781591897693; Mon, 15 Jun 2026
 23:38:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAJnrk1Y9egYizkx1H9K0cqxSYuB+7vLvQbV7Tf4C5eHFqnnC-A@mail.gmail.com>
 <20260616011516.4039110-1-safinaskar@gmail.com>
In-Reply-To: <20260616011516.4039110-1-safinaskar@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 16 Jun 2026 02:38:05 -0400
X-Gm-Features: AVVi8Cc6TBHBfR45WJ_2epcrLUaiFCORhANibC721wRIalY3QlqXFyIm-p-MJJQ
Message-ID: <CAJnrk1Z_V8TShvWV6zwTMQqXra3J4J5CL5ofFMm9DGoLj9whEw@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Askar Safin <safinaskar@gmail.com>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, bernd@bsbernd.com, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, 
	fuse-devel@lists.linux.dev, hch@infradead.org, jack@suse.cz, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	rostedt@goodmis.org, torvalds@linux-foundation.org, val@packett.cool, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2026 at 9:15=E2=80=AFPM Askar Safin <safinaskar@gmail.com> =
wrote:
>
> Joanne Koong <joannelkoong@gmail.com>:
> > > speaking of fuse_dev_splice=E2=80=A6=E2=80=A6_write actually, this se=
ries has broken
> > > xdg-document-portal!
> > >
> > > https://github.com/flatpak/xdg-desktop-portal/issues/2026
> > >
> > > Specifically what happens is that the EINVAL is returned due to oh.le=
n
> > > !=3D nbytes:
> > >
> > > fuse_dev_do_write: oh.len 16400 !=3D nbytes 15526
> > >
> > > (where 16400 =3D=3D 16384 (read len) + 16, 15526 =3D=3D 15510 (file l=
en) + 16)
> > >
> > > After reverting the series, there is no error because oh.len
> > > becomes 15526 too.
> >
> > I think this is because of how libfuse handles eof / short reads. When
> > it detects a short read, it fixes up the header length after the
> > header was already vmspliced to the pipe because it assumes vmsplice
> > mapped the header's page into the pipe by reference. It assumes that
> > modifying the header length in place gets then reflected in what the
> > pipe later splices out.
> >
> > The logic for this happens in fuse_send_data_iov() [1]:
> > a) sets out->len =3D headerlen (16) + len (16384) =3D 16400 in the
> > stack-allocated fuse_out_header
> > b) vmsplices the header to the pipe
> > c) splices the backing file to the pipe. if this hits EOF, it'll get
> > back 15510 instead of 16384
> > d) detects the short read [2], fixes up the stack out->len =3D 16 + 155=
10 =3D 15526
> > e) splices the pipe to /dev/fuse
> >
> > After this patch, step b) is a straight copy which means step d)'s
> > fixup doesn't modify what's in the pipe. This could be fixed up in
> > libfuse to not depend on modify-after-vmsplice, but I don't think this
> > helps for applications using already-released libfuse versions. I
> > think this patch needs to be reverted.
> >
> > Thanks,
> > Joanne
> >
> > [1] https://github.com/libfuse/libfuse/blob/master/lib/fuse_lowlevel.c#=
L846
> > [2] https://github.com/libfuse/libfuse/blob/master/lib/fuse_lowlevel.c#=
L956
>
> Uh, this is very unfortunate. But I still want to remove vmsplice.
> Maybe we can somehow save my patchsets? For example, let's return EINVAL
> for this particular combination (writable pipe + SPLICE_F_NONBLOCK).

writable pipe + SPLICE_F_NONBLOCK is a valid vmsplice call today, so I
think returning -EINVAL would still cause regressions. It happens to
be a workaround for libfuse only because libfuse falls back to
writev() when vmsplice fails, but I don't think we can assume other
callers have the same fallback.

Thanks,
Joanne

>
> --
> Askar Safin
