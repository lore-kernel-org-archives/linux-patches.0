Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4516C3F0AA9
	for <patches@lists.linux.dev>; Mon, 15 Jun 2026 13:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529125; cv=pass; b=CQtxkzPA8zzF7//dJRI9eONmYk1mMwTOWAtMaWh0jy+fEdcSo4op3c5BvFxwQadngEBUb8AYBZUtjChB9MxOdeX/PNs+okqkhsczi10kxW2cewJXadT9CSnUa8K28FxRDvjj5q+6KIXj/17cQy2L66w34TAkHh//hZWL8J23434=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529125; c=relaxed/simple;
	bh=kKNBiJvc+rzdgShKrG5gbJxYUuppXn+sgk4q2LkXCxM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tr63AfuOtkGZ+c4vejZk2PPgCDkYxSYFKcPJGtrSNK1xnnhiwJBmX7wFDlH8I/+fEOdFbAdp7LLUXbs0maKwm6WNG2snXuiErfH2p6nL5rzQaxIHivS47NogJaPAOG/c78ZxSJNMNzhz84faCnFnzottXTifRMavBIwrWRGnYXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BdHG/JGL; arc=pass smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BdHG/JGL"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-45ef1629ff4so2072695f8f.0
        for <patches@lists.linux.dev>; Mon, 15 Jun 2026 06:12:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781529123; cv=none;
        d=google.com; s=arc-20240605;
        b=O4C0nn2VHp/8/EF7+6sMAHUwTmu+uQMoC4CXy6h7J6oUz+KybRbT9msIIJOhV9JzJi
         JEi/vt3enifV6Hyt5F0b6ba3xHoiimxr0o3k7YY4I1e4yn8r5acGHinJx0tdDfGV7EoM
         ROoykeRh2N/9eZQaSsR6mJboawsOFtTECbM/ESLxkty/M1zme1ZEhYZMsNYqj7tVgeWC
         eLtBMpypV3P2oNTfemrFoGiWRr21daEp0C3kpwQUvyX0FcZv6LhaQ/KPVDSuFpv4CMOt
         9lXHgGVkLTtGgGk7XIWFzHhqzbXzM36GylsKSeU01734Un62wS9+IZCYI6onZYMle9GI
         5EfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kKNBiJvc+rzdgShKrG5gbJxYUuppXn+sgk4q2LkXCxM=;
        fh=GnaV9AoXsDmkleW2l5t1kp8zPh1BWNa9f2qK5H+WVVg=;
        b=lVOTDEsHwWq4JgmmcT+tTVPo5Gx7xck5aB+2srijDHOR1L6+ieYXONFqMQkolACYYO
         NNYCqJpz57bUCarEUb6OM+mrYSSdvtMMtmYhPUqQSfQf5ljnlFBi5+0e2NDsDsz1svkT
         GfDk4vUK/DE/xn0Edyx+jtAItaxdp2YICwFfyLo0JzirUmMi2VYCgVuVeS8K8FBr85WV
         a9hILCtvR+g8QU0rj20VLmj7pa+VdrdoWoLUlm1askAm425SGZEIbpQs0Ozw8+mushtq
         TQmHy68/kexqF49Pwo4yXcxSkGOgQBJmF0/5M0MuMGCdVpy7qTOz0k/wjXlek+exWZp1
         sgeA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781529123; x=1782133923; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kKNBiJvc+rzdgShKrG5gbJxYUuppXn+sgk4q2LkXCxM=;
        b=BdHG/JGLXi1yCHP4CwPyt4YH9FkwWFSBrtTHLayDNomTD+e6sZL3OcDf1erNDL+zuF
         ZXDf74zW5dZrFytR2TjAhdtKFrBoGeeN0Hvwy0wo1onHdLiH1xyR+kkB+dGv9vOYwIX+
         rP8nJ9mAxeYRQx2j+ieTQtsm3C/fmWkK9jCK5CaQ6J9I2gvTJ+7LIv/Tn9asRrXQs2ms
         lkCRyrLntQuzQJNx4BNXmSiq1smscHbk00mY9+zZ7XK3P7CAW6xB2R7vo06hpfEqrsVB
         A15x1dDACOzE7p2WxhTd0+2XD9SWBUtVyNLgP0YPaiT4m8AKwDuixfTfEUKLkCViqsvg
         4QNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781529123; x=1782133923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kKNBiJvc+rzdgShKrG5gbJxYUuppXn+sgk4q2LkXCxM=;
        b=qI5NGXi6CU76RheMIS6Qp+HpHwCRDcRSaAb3FztC90+wpcFTQYvjptqa1ngpFDWScm
         4L+Cu8AbRYlCZhzGWQsKCJF2FawxnRBl4fFaepdWUaxI3tFFz2O7yTrRYprHlSiVN0Ba
         KAAi7uMz86maPyszNJ054Fd73Kmt5MPEe0CuFjoEbrrh1IWN2i389xKhDQfzu8pZ4UyP
         TLD2nz/YXAskAPgTYBzntQo/RE/ItbOKbQZ1xt2m8UsbBG9EI4TcXvK3Qj6cFyrjpegQ
         iKkILn382bX5UhZ0jQPezdivy8gGndXuYwdjIHTjXDl+A1+V5i/FPw+KHpVJSP0RXzgd
         yRig==
X-Forwarded-Encrypted: i=1; AFNElJ9vR+FeHesnTuxhiNxHSZzG0k/rWgD+9MAKMws94/GXia0EARYVbMbSXz92bETHzVf/vK+rB1bg@lists.linux.dev
X-Gm-Message-State: AOJu0YxVxaJ6rTfJs6T+YClzIgiMbW3JpbWYLQqC9nCBSEbYlXfeSsot
	ZVoJb0EPGwDYTTYJJn86IOuVyivyIAZLxtLRRSXNxI9eP91/p8P9SIa0jpLJaUKhmgH2xGhdDjy
	vwe/CkSWCqst7KUoney2gxFfqyOP32Kg=
X-Gm-Gg: Acq92OFrz/Mze8gB4qAf7RgIMzB7V8nN/kkTByBlLIp6a/xhDz9ezz0Pbr6alOq/06z
	Z5LFX22ccgpIRKE/pqqBeDIW6gco/iqMe0ZKEka057EaPCfTXg0p8enmumPnb3beEfR6xouxhbG
	74GD/hPkiE/+3MStUShKesiYe/mpgCcB0SFJ8Zo7vME/8cAdtcSvWdPB3tbJ5//z3lkYugGaO9Q
	Nz48Ujrl9D7joMwLPlxX6cDaPUVGsHwTSQZP/jLPrnntGAqzxIRTYwU5UY7nuW5FK8NOFhFr4xP
	Y9XB5KpfsS5iIvOcIttsVfQ8sbbPb+9jdMZvwxhCGs4VG+6tWruiETLdGNjlxviHknA=
X-Received: by 2002:a05:6000:1842:b0:45e:eec6:500c with SMTP id
 ffacd0b85a97d-46074b8a1a8mr14546144f8f.39.1781529122279; Mon, 15 Jun 2026
 06:12:02 -0700 (PDT)
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
In-Reply-To: <83f05c55-efba-4bf5-abfe-d2ab0819e904@packett.cool>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 15 Jun 2026 09:11:49 -0400
X-Gm-Features: AVVi8CeKgoUdgzfGyE3gGhvo39veJuptxa85IFXCJ5UZu0W-8unFPPqkk0CT60c
Message-ID: <CAJnrk1Y9egYizkx1H9K0cqxSYuB+7vLvQbV7Tf4C5eHFqnnC-A@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Val Packett <val@packett.cool>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Christian Brauner <brauner@kernel.org>, Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Steven Rostedt <rostedt@goodmis.org>, fuse-devel <fuse-devel@lists.linux.dev>, 
	Bernd Schubert <bernd@bsbernd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2026 at 2:25=E2=80=AFAM Val Packett <val@packett.cool> wrot=
e:
>
> Hi,
>
> On 6/1/26 2:33 PM, Al Viro wrote:
> > On Mon, Jun 01, 2026 at 10:17:23AM -0700, Linus Torvalds wrote:
> >
> >> TLDR: maybe we could ghet rid of "f_op->splice_read". *That* would be
> >> a big simplification.
> > FUSE might be interesting - fuse_dev_splice_read() and its ilk.
> > Communications between the kernel and fuse server at least used to
> > seriously want that, so that would be one place to look for unhappy
> > userland...
>
> speaking of fuse_dev_splice=E2=80=A6=E2=80=A6_write actually, this series=
 has broken
> xdg-document-portal!
>
> https://github.com/flatpak/xdg-desktop-portal/issues/2026
>
> Specifically what happens is that the EINVAL is returned due to oh.len
> !=3D nbytes:
>
> fuse_dev_do_write: oh.len 16400 !=3D nbytes 15526
>
> (where 16400 =3D=3D 16384 (read len) + 16, 15526 =3D=3D 15510 (file len) =
+ 16)
>
> After reverting the series, there is no error because oh.len
> becomes 15526 too.

I think this is because of how libfuse handles eof / short reads. When
it detects a short read, it fixes up the header length after the
header was already vmspliced to the pipe because it assumes vmsplice
mapped the header's page into the pipe by reference. It assumes that
modifying the header length in place gets then reflected in what the
pipe later splices out.

The logic for this happens in fuse_send_data_iov() [1]:
a) sets out->len =3D headerlen (16) + len (16384) =3D 16400 in the
stack-allocated fuse_out_header
b) vmsplices the header to the pipe
c) splices the backing file to the pipe. if this hits EOF, it'll get
back 15510 instead of 16384
d) detects the short read [2], fixes up the stack out->len =3D 16 + 15510 =
=3D 15526
e) splices the pipe to /dev/fuse

After this patch, step b) is a straight copy which means step d)'s
fixup doesn't modify what's in the pipe. This could be fixed up in
libfuse to not depend on modify-after-vmsplice, but I don't think this
helps for applications using already-released libfuse versions. I
think this patch needs to be reverted.

Thanks,
Joanne

[1] https://github.com/libfuse/libfuse/blob/master/lib/fuse_lowlevel.c#L846
[2] https://github.com/libfuse/libfuse/blob/master/lib/fuse_lowlevel.c#L956

>
>
> Thanks,
> ~val
>
