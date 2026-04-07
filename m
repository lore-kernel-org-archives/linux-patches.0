Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43830175A63
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 12:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775565997; cv=none; b=Bn8XQe0gif12aPKY39ZecAVZNq/EGnMJ8tlFRKrwbacWv3FuO166g7/gt/CZOiOagdLF2fZEanyBCnkwAjlfHFJ1oBmETNvOZTd7xfLME51OT6UQPQ2T5VjvUrUtNA3ehkNXmwsnfBkAJAdAkYyXKmWgobhNMFIbgwzTDTUXOnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775565997; c=relaxed/simple;
	bh=PlWLD5qNONSjz5uDAptenV1FUyAly/9GdpSuevkw+Cc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rRdax+OImGyZnXoXRVbyiOlnyC9pazbI9x7Yx2hE0H20MChOB7zGQ7K6LdVAq/h5JiLHgHifZDPRQXmSphnkvNiKTXP0gm73bk5cqQTMIVCvdLhEubQ2K2BPA1U7GAedWkUWZxyhnXyy4C78GkChlntmSgn9EiPeVcUmSuarvpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YfeF99jU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YfeF99jU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28782C2BCB5
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 12:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775565997;
	bh=PlWLD5qNONSjz5uDAptenV1FUyAly/9GdpSuevkw+Cc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YfeF99jUKM5TBG4FLKjTfH9VO6JWho2Srhg2x0FtLZwn5yIZrZRKZo/3dgJNOBUzA
	 6xoYJ/00O+uQ3NetjsYFKWiPD2/60O2tjoYBUuxaNakpt1C0XzPjrnbu5p4LqFrECG
	 HMlW38KEChoQZFjf05DGtSJqkCfQ5JpTh14GjJA5SBa/5abknKxncQox0d5IitvNsi
	 HggBZN9tIDEAUvRXbCtW0ZoXORsatiSAXXDs5yNHrdZiqmQwXxwcy3kKMR0r33Ugx4
	 7POsVWb8cnkaLubYn15pBDmqOwem99xpukNFACaPY1eyJveCHO0wRXL9xuzTyFL+/n
	 uswYjP82Q3vdg==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b9841aecf72so716047466b.2
        for <patches@lists.linux.dev>; Tue, 07 Apr 2026 05:46:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW3AoNjmsOnBKkxPJM+zhoFfDd99LDRxzRDi2voTfh/qMiITMarH0OkR2jzUXJNnHnizbWcK5Sj@lists.linux.dev
X-Gm-Message-State: AOJu0YxTbnoaTH/Ih9B8B0ONa+tzkoefo7vPvFj5S8RjIkP9gv9OMe6c
	Zz21al2y8scJLvd2eooC1gssIZyuyxbKBlGqEkNPCRTuRUQ8E6gLJ2P8XIp1dndgO4Ci0GKA2ag
	y0it6mIeaHIP0mHd7xkvDEJC8yvzNYYM=
X-Received: by 2002:a17:907:c310:b0:b9b:fa57:d5bb with SMTP id
 a640c23a62f3a-b9c67b497demr869862366b.46.1775565995561; Tue, 07 Apr 2026
 05:46:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260312201018.128816016@linuxfoundation.org> <20260312201022.504112831@linuxfoundation.org>
 <28a3e1fc-b6e7-4d92-b949-7218a74b7231@oracle.com>
In-Reply-To: <28a3e1fc-b6e7-4d92-b949-7218a74b7231@oracle.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 7 Apr 2026 20:46:40 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6Jihemh01mXx1wWU4QBw2-x5XwV=a7rUD5ZoJiQ56FDw@mail.gmail.com>
X-Gm-Features: AQROBzAP6hJ8KuGViv2hx3W2KUVZdWbArqdBMdfBoMgxA0YiwPyuVoOaYFasGdo
Message-ID: <CAAhV-H6Jihemh01mXx1wWU4QBw2-x5XwV=a7rUD5ZoJiQ56FDw@mail.gmail.com>
Subject: Re: [PATCH 6.12 118/265] LoongArch/orc: Use RCU in all users of __module_address().
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev, 
	WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Vegard Nossum <vegard.nossum@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 6, 2026 at 8:28=E2=80=AFPM Harshit Mogalapalli
<harshit.m.mogalapalli@oracle.com> wrote:
>
> Hi all,
>
> On 13/03/26 01:38, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me =
know.
> >
> > ------------------
> >
> > From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> >
> > [ Upstream commit f99d27d9feb755aee9350fc89f57814d7e1b4880 ]
> >
> > __module_address() can be invoked within a RCU section, there is no
> > requirement to have preemption disabled.
> >
> > Replace the preempt_disable() section around __module_address() with
> > RCU.
> >
> > Cc: Huacai Chen <chenhuacai@kernel.org>
> > Cc: WANG Xuerui <kernel@xen0n.name>
> > Cc: loongarch@lists.linux.dev
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Link: https://lore.kernel.org/r/20250108090457.512198-19-bigeasy@linutr=
onix.de
> > Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
> > Stable-dep-of: 055c7e75190e ("LoongArch: Handle percpu handler address =
for ORC unwinder")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   arch/loongarch/kernel/unwind_orc.c | 4 +---
> >   1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/arch/loongarch/kernel/unwind_orc.c b/arch/loongarch/kernel=
/unwind_orc.c
> > index 471652c0c8653..59809c3406c03 100644
> > --- a/arch/loongarch/kernel/unwind_orc.c
> > +++ b/arch/loongarch/kernel/unwind_orc.c
> > @@ -399,7 +399,7 @@ bool unwind_next_frame(struct unwind_state *state)
> >               return false;
> >
> >       /* Don't let modules unload while we're reading their ORC data. *=
/
> > -     preempt_disable();
> > +     guard(rcu)();
> >
> >       if (is_entry_func(state->pc))
> >               goto end;
> > @@ -514,14 +514,12 @@ bool unwind_next_frame(struct unwind_state *state=
)
> >       if (!__kernel_text_address(state->pc))
> >               goto err;
> >
> > -     preempt_enable();
> >       return true;
> >
>
>
> Looks like this is dependent on commit: 7d9dda6f628f ("module: Allow
> __module_address() to be called from RCU section."), so I feel pulling
> in this patch without the mentioned missing prerequisite is wrong. Can
> you please help review this ?
>
> This is also part of a feature series in
> https://lore.kernel.org/all/20250108090457.512198-13-bigeasy@linutronix.d=
e/
Yes, I have also asked about this:
https://lore.kernel.org/stable/CAAhV-H7GxtWRZyAT=3DkedLEMu=3DC5wH--NUzRjwi3=
DKXzUq+QZjA@mail.gmail.com/

However, no answer and no action for this. I don't know what happened
to Greg and Sasha. Recently, similar accidents happen again and again.

Huacai

>
> Thanks,
> Harshit
>
> >   err:
> >       state->error =3D true;
> >
> >   end:
> > -     preempt_enable();
> >       state->stack_info.type =3D STACK_TYPE_UNKNOWN;
> >       return false;
> >   }
>
