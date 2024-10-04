Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F111DAC81
	for <patches@lists.linux.dev>; Fri,  4 Oct 2024 17:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728064758; cv=none; b=fZnzzDMR5oxibKEiFZy5qtR6lkKaOh2Lut34ypQ2ijsh0qA7IhsN8KezTG/VrcQ0sjVlUt62+QgIUueb9rbzcf/Ou1iJql+lQ5B8S5KqYZN+udx/CWl0EXg09XeRHB/aiy0TIHGhuD6zhCHgCHvqqvlSAESwFiVYXLMZzYjUdp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728064758; c=relaxed/simple;
	bh=DRwOS9bMoOzqePm1SDrUAn8rG0Un516NdS4FyBLqf2U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oBPwForAYBHTyGjveGqZwHURzPwUfsstnuVHp4cxHUpRuM6kPHxi6SRn1tvF+5yWABc48x7X7YlN3KfW6fKAQDyHFHNiXsiMBZ1njL9Womt6ypUXkzOdyBLBVYLxUj49VPZJHGsDNkozQaDbVHWvklna9fo96bG8zP0UiTqK7T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RusTXHGR; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RusTXHGR"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-6dbc5db8a31so19462687b3.1
        for <patches@lists.linux.dev>; Fri, 04 Oct 2024 10:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728064756; x=1728669556; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DRwOS9bMoOzqePm1SDrUAn8rG0Un516NdS4FyBLqf2U=;
        b=RusTXHGR0A4e/DB46q4vx9dR9YI8Gb+B7dENpF/VZXvEt9Euc3NfKUlOxpDY8jV8Bo
         yTVTjOq0AQL/e4if77/a83x4Sz8ROvgXAxOUhY07zovrMOyZoSBwVL9tzZmxPOp3b33Q
         fp6xhEltqsoWn1HjC9Tf3x1tT9rsHagmVnkL74/6ofbsMeF2eNAOTxjNmJUMfSW5GEga
         E6if/WiPj1QbzHunoBXmo1QXfXp1v6IfwA/6eLZTFQ4KxvI3XoTJxKN92x4uklWX6k0Q
         PaE6j3qz2oDuCktkkDfvZEw20868C8gquBnKr0UenBAx72t8Z7mrQqCXonJuOU4DZpMN
         CNhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728064756; x=1728669556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DRwOS9bMoOzqePm1SDrUAn8rG0Un516NdS4FyBLqf2U=;
        b=SSAkUrO5b+PW1Vmqv9OyeLb/jfSTeLTZwE/IN/OsC7Sy9/HUnkB6dV+waginhpLkdk
         raKB5H8387MXjOeNqvul7pGAhQ9DqbeJ4BsZ/AI+5+r5XQn3/kzs11yMbGjpDtDTe2eL
         ICfa+Vaqs1Mob6TW9Vxq0ETZ+h+bOXoLeZ0oCTbdtjrnUEe/liZVVo53l64rhENfJwvM
         o5t1hshBJu97NOnZAHsQV23uhfK67PZpA3LArjCrae+vyfxr/NxA+gS4+pIQoUYDxbfd
         6YHqWYEcYAtoJwiBTFcgXnqMmLXdknxqrJUV93OsVVL6+2ggOJ9bCwzJ3+TMGhqdLT2e
         089w==
X-Forwarded-Encrypted: i=1; AJvYcCUSgxn7yNZNM7sdz8u7d1iRi5H1DCgJDplDiQZaN5DvTtnSLfBkOXp+Wij1DakZJBkJ31Rxiy0m@lists.linux.dev
X-Gm-Message-State: AOJu0YxC63uf0u6cG2/pWWCOqY2VnGfGJCusoze2R/Z3bJ67C7mFz7O5
	B6yQgYaPwbYq00WDBgTesA0JF9P5yhvm/ChBMzvBjmiRbHJcAU9MORrYUEKSFJs3sXLt/gippmd
	1tZ/YMjjwzISBIKmZ8xI3RiQzXfQ=
X-Google-Smtp-Source: AGHT+IFIOBo8QxrlSc3g6B70PgpHtfKVajoreTZbg9Pk/0PJQDfMjjagFzFHQKaJiS/RgZ+55j35mDaSxCD+x2fkZts=
X-Received: by 2002:a05:690c:610d:b0:6e2:a250:a1bc with SMTP id
 00721157ae682-6e2b540695amr57442297b3.22.1728064755895; Fri, 04 Oct 2024
 10:59:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241002125822.467776898@linuxfoundation.org> <20241002125838.303136061@linuxfoundation.org>
 <CADpNCvbW+ntip0fWis6zYvQ0btiP6RqQBLFZeKrAwdS8U2N=rw@mail.gmail.com>
 <2024100330-drew-clothing-79c1@gregkh> <A8D6C21F-ACAD-4083-900F-528EB3EB5410@oracle.com>
 <CADpNCvbKGAVcD9=m_YxA6qOF6e0kohOfVsKOqJeVmrYaq0Sd8w@mail.gmail.com>
 <2024100420-aflutter-setback-2482@gregkh> <CADpNCvYn9ACkumaMmq7xAj6EQuF6eYs174J+z81wv5WqzdWynA@mail.gmail.com>
 <2024100430-finalist-brutishly-a192@gregkh> <2024100416-dodgy-theme-ae43@gregkh>
 <8AC0ACC8-6A77-487E-B610-6A0777AFC08E@oracle.com>
In-Reply-To: <8AC0ACC8-6A77-487E-B610-6A0777AFC08E@oracle.com>
From: Youzhong Yang <youzhong@gmail.com>
Date: Fri, 4 Oct 2024 13:59:05 -0400
Message-ID: <CADpNCvZXyw25A3+DvMpECFoffWmcrFQ0Do5hhwbqftxTVr-+Mw@mail.gmail.com>
Subject: Re: [PATCH 6.11 397/695] nfsd: fix refcount leak when file is
 unhashed after being found
To: Chuck Lever III <chuck.lever@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-stable <stable@vger.kernel.org>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Jeff Layton <jlayton@kernel.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The explanation of how it can happen is in the commit message. Using
list_head 'nf_lru' for two purposes (the LRU list and dispose list) is
problematic. I also mentioned my reproducer in one of the e-mail
threads, here it is if it still matters:

https://github.com/youzhongyang/nfsd-file-leaks

Thank you.

On Fri, Oct 4, 2024 at 1:23=E2=80=AFPM Chuck Lever III <chuck.lever@oracle.=
com> wrote:
>
>
>
> > On Oct 4, 2024, at 10:35=E2=80=AFAM, Greg Kroah-Hartman <gregkh@linuxfo=
undation.org> wrote:
> >
> > On Fri, Oct 04, 2024 at 04:26:39PM +0200, Greg Kroah-Hartman wrote:
> >> On Fri, Oct 04, 2024 at 10:17:34AM -0400, Youzhong Yang wrote:
> >>> Here is 1/4 in the context of Chuck's e-mail reply:
> >>>
> >>> nfsd: add list_head nf_gc to struct nfsd_file
> >>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co=
mmit/?id=3D8e6e2ffa6569a205f1805cbaeca143b556581da6
> >>
> >> Sorry, again, I don't know what to do here :(
>
> When we tested 1/4 on upstream, it was neither sufficient
> nor necessary to address the leak, IIRC. And I don't recall
> ever seeing a clear explanation about why that change is
> necessary. That's why we consider it a defensive change,
> not a bug fix.
>
> But it shouldn't be harmful to backport it to LTS kernels.
> I don't object to a backport. To me, though, it seems to
> be lacking a complete rationale.
>
>
> > Ok, in digging through the thread, do you feel this one should also be
> > backported to the 6.11.y tree?
>
> It's not clear that it is needed in v6.11 without testing.
> Neither Jeff nor I have a reproducer for that leak, though.
>
> 4/4 seems like an ABI change, and again, testing is needed
> to see whether its backport is truly needed. So far we know
> only that when all 4 are backported, the leak goes away.
> That is not proof that 4/4 by itself is required.
>
>
> > If so, how far back?
>
> LTS kernels all the way back to v5.10.y are likely to have
> this leak, since they have all the NFSD filecache backports
> already. 5.4.y is generally too old to be reparable.
>
> I would prefer more testing of this backport on the stable
> kernels, but I understand if that isn't practical.
>
>
> --
> Chuck Lever
>
>
