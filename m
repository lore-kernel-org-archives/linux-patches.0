Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2AA146013
	for <patches@lists.linux.dev>; Tue, 18 Jun 2024 17:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718733334; cv=none; b=uZ/8FA1fzeTFfBsK1SQrgIA8hPE2IMgvu26hkePL/rYt5g3bAR0MW4qx7vl/8uZi7jAKeYB17zHSD5Ou6dfrL4/QAYoizc3PpAHDmYY+Czppt5qwVFrV8fDDELKzPui3AEOoeZVJ6juEfGEiT3mAYCQ1vgo88X7lXdzkcZtBDhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718733334; c=relaxed/simple;
	bh=DTLUZ676QRfLifqNmaQ9PMFqLKool7WG4v5zx1rImQY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WZX8+rDg0qXAbSxIoEj6bouF8Robjz9pgDQ3WcV1As+xCj6pjVsr+zQuZYyELAbIBhKWvLDnhpvW39hHFpSRC363gR4Aig2zgYHaeIQLSUemXr+A+IfUawp4sV4tH+Bj0SUdt+1p6SytFS2ADJqkeCMljH4kA5RDvW5RxwQRvig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b=p/PhqN8T; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b="p/PhqN8T"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a6f958a3a45so142193766b.3
        for <patches@lists.linux.dev>; Tue, 18 Jun 2024 10:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20230601.gappssmtp.com; s=20230601; t=1718733331; x=1719338131; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zTmVnnzmQsdyJIvy7P5jLUWUPiZqPVgC2Gi3EXBWni0=;
        b=p/PhqN8TNQ53sLbjBUvCLaUXYbE/QuMVIla6boeNFm4U4R7rW32zNoKPo95nnlrHn8
         hQdqzOpDn2cue+IBV/oYe+gsA40IFGPHCRQy8jvhfe754OiDupCCLKneOh6ifQZ+NwZ8
         F5EGmCl7e/kxHch2pEbvFwtdDIR/2shHbD79CdpbYMkh41U1oc78VhDFs2eVO5XkAUAM
         o4tBhAaAc+qVH0uA7G7iKg3y6FqOJtyRqzcK64g6UZVUSoDMzcmgZZqWkScLclWzJo3C
         Tt1b6UXha01ryYiIb5MxGH8C9uEgS3vWiFj8xE6TAaOM/vA8p+dIVfrlLNzp36tk0Wyc
         vd1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718733331; x=1719338131;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zTmVnnzmQsdyJIvy7P5jLUWUPiZqPVgC2Gi3EXBWni0=;
        b=aI6vkhojXpVQcmFcr5lU3pW908t2HyXGstO0BIk6hCjA+rs8+mu+y9RSWL7o8Gikek
         5GRphugBm9opS/RVmYvgeQW3VfRTHNPIR45UOXnNp2H3Z7/zA9Po4iykPLkMTb4JyJ6+
         3Lyf1upjGs5+ZNqn6jJsC2vOjDsn893dkQk33FDDy6AG54KRDrACKpWcX61n3dyywcO9
         48DaPVC7LiI7fUKHB2EmqeaTSW8eH8m7LEfZ8/EhXFv+Ht2/E8NS+ozbzH4TIiMHEs8Q
         ccWsZ0UmNeIEGPdpKEiOJCRemcKDUE0K4Ogigek9jeCTSGmfS7xkRmP9nATXdBf9oLQw
         bsnA==
X-Forwarded-Encrypted: i=1; AJvYcCVmm8bqc+rq9Z+IQNmYTBwgZSBK/z//+DipWb+HF+riHTwvKRD7mWjyJ7R+szv/K0/Y2EX80XfTdOk0yCGlHJ6ln9KazHkQuQ==
X-Gm-Message-State: AOJu0Ywoo057BtlwDRbnJ+xGQvcpurdUYIPnBX49dc1JykZi93VCFyP/
	XB1NbYuByhpks+Ou2WA5DVc3AK25GzEvTw7vKROBS+azNvyf8ZDOgnJoLiFBJI+8/wRpSKNCfwn
	RxlkmA/NbfqT32pHgKqlf+/0P8SzDHoM80U2I
X-Google-Smtp-Source: AGHT+IGDO9MunPaTLk2H5XQt/NMq7+U7oPvCv8jQC1cNGWo0/s+agXuJNN4zhVSHAUJqe1AspkjtzsT7TrN2MZj0MyE=
X-Received: by 2002:a17:906:c10d:b0:a6f:cce:4457 with SMTP id
 a640c23a62f3a-a6fab7dc751mr15171166b.71.1718733331107; Tue, 18 Jun 2024
 10:55:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240614190646.2081057-1-Jason@zx2c4.com> <20240614190646.2081057-5-Jason@zx2c4.com>
 <CALCETrVQtQO87U3SEgQyHfkNKsrcS8PjeZrsy2MPAU7gQY70XA@mail.gmail.com> <ZnDQ-HQH8NlmCcIr@zx2c4.com>
In-Reply-To: <ZnDQ-HQH8NlmCcIr@zx2c4.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 18 Jun 2024 10:55:17 -0700
Message-ID: <CALCETrWzXQMXjvL+nGq-+aLVUeiABJ46DACtLnrLXxmwh9s_dg@mail.gmail.com>
Subject: Re: [PATCH v17 4/5] random: introduce generic vDSO getrandom() implementation
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, tglx@linutronix.de, 
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 17, 2024 at 5:12=E2=80=AFPM Jason A. Donenfeld <Jason@zx2c4.com=
> wrote:
>
> Hi Andy,
>
> On Mon, Jun 17, 2024 at 05:06:22PM -0700, Andy Lutomirski wrote:
> > On Fri, Jun 14, 2024 at 12:08=E2=80=AFPM Jason A. Donenfeld <Jason@zx2c=
4.com> wrote:
> > >
> > > Provide a generic C vDSO getrandom() implementation, which operates o=
n
> > > an opaque state returned by vgetrandom_alloc() and produces random by=
tes
> > > the same way as getrandom(). This has a the API signature:
> > >
> > >   ssize_t vgetrandom(void *buffer, size_t len, unsigned int flags, vo=
id *opaque_state);
> >
> > Last time around, I mentioned some potential issues with this function
> > signature, and I didn't see any answer.  My specific objection was to
> > the fact that the caller passes in a pointer but not a length, and
> > this potentially makes reasoning about memory safety awkward,
> > especially if anything like CRIU is involved.
>
> Oh, I understood this backwards last time - I thought you were
> criticizing the size_t len argument, which didn't make any sense.
>
> Re-reading now, what you're suggesting is that I add an additional
> argument called `size_t opaque_len`, and then the implementation does
> something like:
>
>     if (opaque_len !=3D sizeof(struct vgetrandom_state))
>         goto fallback_syscall;
>
> With the reasoning that falling back to syscall is better than returning
> -EINVAL, because that could happen in a natural way due to CRIU. In
> contrast, your objection to opaque_state not being aligned falling back
> to the syscall was that it should never happen ever, so -EFAULT is more
> fitting.
>
> Is that correct?

Yes, exactly.

My alternative suggestion, which is far less well formed, would be to
make the opaque argument be somehow not pointer-like and be more of an
opaque handle.  So it would be uintptr_t instead of void *, and the
user API would be built around the user getting a list of handles
instead of a block of memory.

The benefit would be a tiny bit less overhead (potentially), but the
API would need substantially more rework.  I'm not convinced that this
would be worthwhile.

--Andy
