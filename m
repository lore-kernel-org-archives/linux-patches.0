Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBECB3DD85D
	for <patches@lists.linux.dev>; Wed, 24 Jun 2026 17:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782323546; cv=pass; b=D8m0pEcfttT898qJ0V3moxhPAhdb42kawKfrC6pO+UXAObFCRpmS+/DuDVOBOML2Z+oClKDt6E6ub/VIj/BEs1cqkY2ie4y5A1KEdvGgdbkiO18T01KAw7pOsGIHWUdXQ6qmAvYNH2ix/5W2+hT3Gq4loMRMm5i69zDsP0WPTyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782323546; c=relaxed/simple;
	bh=BUqTLbaqUYoKdg3iiW+mLowzEHeWjN5LiDlT2QPIVfI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GTKbjlyynhz/tA1sRpZD0yd0Q7WoVETyaUGmRy2pN+5+NyIirhiVinqawvCQjhSf+i/+mItRuyD2s7xQzy+J6I0H0AdTVU/ytvtXlHLUbazFx6WlXR5juBdOVuHTNdevzHdy1q49ewmTuMAjAMRFioF1CKwFfMbXQKBd/J4vMA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IEQtORcu; arc=pass smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IEQtORcu"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-6a1009f6adeso995532eaf.3
        for <patches@lists.linux.dev>; Wed, 24 Jun 2026 10:52:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782323543; cv=none;
        d=google.com; s=arc-20240605;
        b=GSTRwE8vn7ywSyOozlf/jRzoXqZRDHBWADyn1Fmw60k7IWzEy//Z1x1f9RfkrW2ln9
         FnUR7BcoHUCJP9GOoZZi1T/7Ko2q7HqfKS4b8wCFJXg9/qi4zleTcHqMDicdRlgtvkr0
         J0n1LZsohYsLS2mGBjEzLJ1f424akUmLZbiOBoVR5dtdw67lRSxSRX9KBJigpUvI9IqJ
         VHAGCacD8B2f+9p8GUXxVhFQs9naeb3oQyewjfXYvQfsVVP3OZb22FDVlB0S2I+smYrv
         3GpioSaW5QEN9PfCDRvrPToXvvWF3V2xgKjNWLlY/CXFH2TtPWQ+/AQi4N6c1qm8okva
         lhJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3yIQCK+bzs9AyvsQ75CttiaMe1DqI5YJnh3974Pl4HA=;
        fh=cQ92MZh1pFLer459CsVwokU/70y/92/sVhrgjuDdwrs=;
        b=LRy3CjBS3nZLNX8s5Lq9evYWXl9u7MEnowIQgYiodRr/vxqTVu/PAZstfiVJaZHeo+
         KyZ7OEjgiCSuVYIqB8aOji1akXZERjMXK75OmLSiCxXJwM/N6WKtHOt0Em8LnV2CRgCo
         E03Cc6GDkbN3Tc0v5lt+Rm+CBvOS/IzA/fcFrz/j49r4Bv/zxq9e4IncR5u6MZlmVePy
         jFSCFw8K9pLCW8F5BOnt2o1B3srHJqR0+votuiIl3Wq28NPXDRi2DCS63eYIUgtGLq3Q
         Bj2VmOiY9FgfnnkZZmPKI8TEeiTpFuN0zu7wTc+K28YQwsn+46no8KzmSlEueMHnVOEk
         /FyA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782323543; x=1782928343; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3yIQCK+bzs9AyvsQ75CttiaMe1DqI5YJnh3974Pl4HA=;
        b=IEQtORcu9FfZNKG9zCWq9uT4agMtf7fhH+5Rhd10G+KmSTa5CQL+TF16SB5GU6f4uI
         DyE38MN6D6XnfrJXWuaoQ21BphtZwWbtQvM+zN4mKTEWR2NdZKvtTB8D2mIiHoAOsdw5
         sAVlD0HHnFrtpCnON3zAaLLQV/rzh7kCV3Z32+zRSUpb0aCzYnXc/+cgwecMp9Ocu2XX
         LyPIvYw3I8o444MEL+VpKULIuDEnmODL8WvmTsNxfJlgn5CSl90XW+jLIj7mtOh1/A6a
         edM5yiFSM0Byg9Ckl31QhmJUEztYcTxraAcnyFrukwmuAPV5OKATDrRf/ANnDvzCIbs3
         /7Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782323543; x=1782928343;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3yIQCK+bzs9AyvsQ75CttiaMe1DqI5YJnh3974Pl4HA=;
        b=PRgmLx37h29Ldx9muz1Hc5cQQIjz8nCWy9W4fq0loDGfKz3YRF1PBk4sKpTk6mJxQJ
         6Aq36lQS7Y0ezVaOewgVegowFpKQzididH6P2T9CAKunQYRs0EnG320PHank38PS8YNm
         scWQUEEd7qu0Q9rZJxm7jbcb3sctApe8izDRYJagZTkywxTTJm6PiT+q5Px1k47KiTDo
         AhP3UjiIvR7aSJ29dOWTmggeqAzf2VEx6H6P5kaFgQksM0Zjijkk+QjMLB85jIrtNv4o
         IT8ZPLQRaaJXjXXhDTAUo9e5N9XqKJ38PoU09j/wPN4usys2NwTLBvID9BIIlzQ7mpEi
         hGrQ==
X-Forwarded-Encrypted: i=1; AFNElJ+wHrnyla5QXPsgu+aB08RdB2oetfUMVuPPKIrfhhkcWsVEoIkBj0eBxXCu3wAKUEzSxLstbpd7@lists.linux.dev
X-Gm-Message-State: AOJu0Yx74KstjmMsjPMD9FK1/+umAQZQUx+ZHXk2r87tXjCrPR2jVxWj
	OVzsMSiL/yXc6AOdaPK4UGKcugGp6f3YC27Y44MyJvA4hYTmaKuuO4qVRGykDpohFpF27iymbm9
	dOJHUhbVWno15fTXCpuwxMUF2uZ1+zEw=
X-Gm-Gg: AfdE7ck9wKFUIALRuA22GF3Uv7qA3susUOTJhEr5iPZOVFp+t8+sBY5aq/ERpcCU8Te
	uOyWXIbXw9cr5o+E1zSy8daS/OgRDfGvOhZRubbEj8gtxQUs52lyR3YGIMMq++QQ+9+16P4NB81
	Q6cO2gq6x0DZay7R5SWitRlrL7RWk0OU3PpjqihwU0p7jTFDOMppijo9UaMuJ6W3voB0YNynYYS
	jtAjBAAdQMM7eWw2Nx4/T/AEy1O/Grz7FOpSPkzb/i9b27FHQ9b7jZkTkev916VxhsgYNA=
X-Received: by 2002:a05:6820:4d03:b0:6a1:10da:ab9d with SMTP id
 006d021491bc7-6a123056b05mr2754013eaf.15.1782323542879; Wed, 24 Jun 2026
 10:52:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CANaxB-zK5q=Xw6UZTmeFtXsDZjUsPkFk=p485m-wtNTBnf4hgg@mail.gmail.com>
 <20260624071226.2272209-1-safinaskar@gmail.com>
In-Reply-To: <20260624071226.2272209-1-safinaskar@gmail.com>
From: Andrei Vagin <avagin@gmail.com>
Date: Wed, 24 Jun 2026 10:52:10 -0700
X-Gm-Features: AVVi8CfO4ShP8XHn8pnL2N4gaP9BD3pzKdndivNRe-NdNvS8dpf9qzg05LfmNXE
Message-ID: <CANaxB-xUrLQYGiRJZc4Boi+KX=0TJSWymErNovANVko20fMDVA@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Askar Safin <safinaskar@gmail.com>
Cc: akpm@linux-foundation.org, alexander@mihalicyn.com, axboe@kernel.dk, 
	bernd@bsbernd.com, brauner@kernel.org, criu@lists.linux.dev, david@kernel.org, 
	dhowells@redhat.com, fuse-devel@lists.linux.dev, hch@infradead.org, 
	jack@suse.cz, joannelkoong@gmail.com, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org, 
	patches@lists.linux.dev, pfalcato@suse.de, rostedt@goodmis.org, 
	torvalds@linux-foundation.org, val@packett.cool, viro@zeniv.linux.org.uk, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 24, 2026 at 12:12=E2=80=AFAM Askar Safin <safinaskar@gmail.com>=
 wrote:
>
> Andrei Vagin <avagin@gmail.com>:
> > The CRIU fifo test fails with this change. The problem is that vmsplice
> > with SPLICE_F_NONBLOCK to a fifo file descriptor fails with -EOPNOTSUPP=
.
> >
> > It seems we need a fix like this one:
> >
> > diff --git a/fs/pipe.c b/fs/pipe.c
> > index 429b0714ec57..6fc49e933727 100644
> > --- a/fs/pipe.c
> > +++ b/fs/pipe.c
> > @@ -1253,6 +1253,7 @@ static int fifo_open(struct inode *inode, struct
> > file *filp)
> >
> >         /* We can only do regular read/write on fifos */
> >         stream_open(inode, filp);
> > +       filp->f_mode |=3D FMODE_NOWAIT;
> >
> >         switch (filp->f_mode & (FMODE_READ | FMODE_WRITE)) {
> >         case FMODE_READ:
>
> Does CRIU actually rely on ability to do SPLICE_F_NONBLOCK vmsplice into
> named fifos? Or this is merely a test?

Yes, it does.

>
> If this is just a test, I think we need not to preserve this behavior.
>
> I did debian code search with regex "vmsplice.*SPLICE_F_NONBLOCK" and I
> found very few packages. And it seems all them use pipes, not named fifos=
.

In short, this isn't how such cases are handled in the kernel. The fix is
simple and should be applied to avoid breaking random software.

>
> (On speed: I still think that my vmsplice patches are good thing,
> despite performance regressions in CRIU.)

I already explained that this isn't just a perfomance degradation, it
actually breaks the pre-dump mechanism in CRIU. vmsplice is invoked from
our parasite code within the context of a user process, where execution
speed is critical. A heavy performance penalty completely invalidates
the pre-dump logic, making the feature useless.

Under normal circumstances, patches that cause this kind of breakage
would never be merged. However, since there are exceptions to every
rule, we should let the maintainers decide how to proceed here. In CRIU,
we have a backup plan to utilize process_vm_readv to dump process
memory. We already support this mode, but it isn't the default due to
performance concerns. If these patches are merged, it will be the
only option left for CRIU to implement pre-dumping.

However, we need to look at this case in a broader context. This is yet
another example where the change introduces a workflow breakage, meaning
there might be other workloads out there that could be broken by this
change.

At a minimum, we may need to consider a deprecation plan where vmsplice
with SPLICE_F_GIFT triggers a warning for a few releases before these
changes are applied. Alternatively, we could introduce the proposed
behavior alongside a sysctl to fall back to the old behavior and explicitly
state that this fallback path will be completely deprecated in a future ker=
nel
version.

Thanks,
Andrei
