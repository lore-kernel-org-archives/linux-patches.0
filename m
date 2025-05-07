Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A189B15E5BB
	for <patches@lists.linux.dev>; Wed,  7 May 2025 03:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746586821; cv=none; b=pbcUlhCOeOPNlpoYCjwPBWwbnh/7A5uTokLg9rnsyn6gwR+hKWq0g3cq0gGZJLb6c/CZ/L2vTBhV8/v5dFoLwGawZpcaffaRhxSd06ud2JiLZZXUXXe4deG9xOQtD9T2PRCOfKIFWkmqgKcz7WJV1DHRBV0avu8083tR96n231I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746586821; c=relaxed/simple;
	bh=5JDagOBJhi69/Z0miRzYPNWtGi/LGnLQuCjRfdTjCTY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y550+sy3CgbhDzi1R5O7CwuWdaQ2hBSxWpGNyyF3stzv5TzhEb4WYVxb4qj96NV10stGYOX3K+ifvH8SDrexEHmSAMQIZ0lB34/NtLI+2yS/0ivBPmDOmNdDcM+XF+wFushex7lfKBGlOLYoWDAZnkGHSSfFwMEY1tGJMkdRb2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starlabs.sg; spf=pass smtp.mailfrom=starlabs.sg; dkim=pass (2048-bit key) header.d=starlabs-sg.20230601.gappssmtp.com header.i=@starlabs-sg.20230601.gappssmtp.com header.b=V/l9r21U; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starlabs.sg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starlabs.sg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=starlabs-sg.20230601.gappssmtp.com header.i=@starlabs-sg.20230601.gappssmtp.com header.b="V/l9r21U"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-30bfca745c7so57296761fa.0
        for <patches@lists.linux.dev>; Tue, 06 May 2025 20:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=starlabs-sg.20230601.gappssmtp.com; s=20230601; t=1746586817; x=1747191617; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5JDagOBJhi69/Z0miRzYPNWtGi/LGnLQuCjRfdTjCTY=;
        b=V/l9r21UGtB7ueKlIK9yUg4DO5gKMHHdWrYf2sPqXMsb45u7aKvDKBBQa2CPVBvXru
         gV5OfwVLb0YWu4pUpZILSGVvKEUGdc2YGHHCCohQbZ5tNiu1K00RcXQYFgHVFVaiEC8g
         mrPyA2f9niOUxdHd3lUV2XNKmx9LEqf7c2yQGyacPJZkyS/ZHA77K63UzjyhiaAQYqHp
         xY/68wpMol9MOjmrRNIzMYXpnDk3SP42Y9WsID0V38sZk95Gtwbv+sVyaCu7pD6lv/Gx
         p6AzOnkzz40fr5ni4NgALXkr/1OaOvXpcpMsA7n2ZQnlEEi5KwKcr3bG4DiwPzUf1gQs
         0f4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746586817; x=1747191617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5JDagOBJhi69/Z0miRzYPNWtGi/LGnLQuCjRfdTjCTY=;
        b=YD6T+Td8YnwywHeBDHwcJAHSFS3utnLgMbL8sQ0e0eI+QCZQHSOS5Q4yyTKi3NNwvX
         dRZxpKBN8Fh5O3LfNQ4kSHCGkx27IBXHRk65WX6UFsHcEPizfMgh1UyWzqpPhnjtPTzg
         MXTCoWRRENnAYmeKCJTT07NfzKdZtJINaGpo3xjyhtUina5ZQOze5SjH8t9atPI5O+Q9
         5B6QiDa8x67lOCBUQYpWFsZWHCzOXEN3cJNGgJVeKvpEgoEwdG8zMtmVJuxjeddhN7Ii
         coQOL1qboboEAYXg8b0neZa8hy6HoQjJGDykCNZzhh5wvrE1S7oKdPVERfEo2+4CpNQM
         lepA==
X-Forwarded-Encrypted: i=1; AJvYcCXsZ06WOrQPiLLT/k2oJJCmvLR7N+6+rKIJvh7REkpMzNx3C8nNlwosgxOo6EwQotDM4U0ckJVY@lists.linux.dev
X-Gm-Message-State: AOJu0YxWXOWX79eG9sCJESFYztBcaR0H1H/mhV6TJrJAxVPLzU72zB7R
	v4r0vbjBCxc++2232b9OwRIukCKxA22+a7rCxT1qTEfNh0ZlJ0Cj+ALpyTxr7L6aU70m8d6p5YS
	Mk1Q9a504r/a8e9dUvNeIv6IOSZFZ/MDT1qQmU451hVgCXQDMx5s=
X-Gm-Gg: ASbGncsi+ZQfh9VozOCsb90IeUi42DneI0rs08eVL4PmRt6catYe1j76X0jpBw4x3kJ
	NsN06EsRTCtMyA+b/EJYwB+qXBf5SAKxCY7moXOg1de8+/ov0DJAFQ4EZFysPDcNLc54LIobFtv
	MagRdWRO5WGKBDaq+uieSUmZmd
X-Google-Smtp-Source: AGHT+IH+GRV7N1UIr5FtQt5I+kjU/jZEEl/lAOfID68gVGxwYmTKC5QxaGQMqFIA/UkDgI9HyoPcAoraNJBmboK+hyo=
X-Received: by 2002:a17:907:1b05:b0:abf:7453:1f1a with SMTP id
 a640c23a62f3a-ad1e8c524a6mr173897366b.36.1746586805626; Tue, 06 May 2025
 20:00:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHcdcOkW1D_zKh-HPsfjX-oGYhv-OwojPXVwcA=NYoO0hcCbZQ@mail.gmail.com>
 <2025050519-stem-fidelity-25b1@gregkh>
In-Reply-To: <2025050519-stem-fidelity-25b1@gregkh>
From: "Tai, Gerrard" <gerrard.tai@starlabs.sg>
Date: Wed, 7 May 2025 10:59:53 +0800
X-Gm-Features: ATxdqUHqYIbPstDEIaQN0aaQiKYxtgLr1_9QylxIxA0iyVxaPBUw62bO1vjlDEc
Message-ID: <CAHcdcOkMt_Mpcm1AjxbU8MurGO5e--LPPJOrSTA+utDOzVHE3g@mail.gmail.com>
Subject: Re: net/sched: codel: Inclusion of patchset
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Cong Wang <xiyou.wangcong@gmail.com>, Simon Horman <horms@kernel.org>, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Paolo Abeni <pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 5, 2025 at 5:28=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, May 02, 2025 at 12:49:48PM +0800, Tai, Gerrard wrote:
> > Upstream commits:
> > 01: 5ba8b837b522d7051ef81bacf3d95383ff8edce5 ("sch_htb: make
> > htb_qlen_notify() idempotent")
> > 02: df008598b3a00be02a8051fde89ca0fbc416bd55 ("sch_drr: make
> > drr_qlen_notify() idempotent")
> > 03: 51eb3b65544c9efd6a1026889ee5fb5aa62da3bb ("sch_hfsc: make
> > hfsc_qlen_notify() idempotent")
> > 04: 55f9eca4bfe30a15d8656f915922e8c98b7f0728 ("sch_qfq: make
> > qfq_qlen_notify() idempotent")
> > 05: a7a15f39c682ac4268624da2abdb9114bdde96d5 ("sch_ets: make
> > est_qlen_notify() idempotent")
> > 06: 342debc12183b51773b3345ba267e9263bdfaaef ("codel: remove
> > sch->q.qlen check before qdisc_tree_reduce_backlog()")
> >
> > These patches are patch 01-06 of the original patchset ([1]) authored b=
y
> > Cong Wang. I have omitted patches 07-11 which are selftests. This patch=
set
> > addresses a UAF vulnerability.
> >
> > Originally, only the last commit (06) was picked to merge into the late=
st
> > round of stable queues 5.15,5.10,5.4. For 6.x stable branches, that sol=
e
> > commit has already been merged in a previous cycle.
> >
> > >From my understanding, this patch depends on the previous patches to w=
ork.
> > Without patches 01-05 which make various classful qdiscs' qlen_notify()
> > idempotent, if an fq_codel's dequeue() routine empties the fq_codel qdi=
sc,
> > it will be doubly deactivated - first in the parent qlen_notify and the=
n
> > again in the parent dequeue. For instance, in the case of parent drr,
> > the double deactivation will either cause a fault on an invalid address=
,
> > or trigger a splat if list checks are compiled into the kernel. This is
> > also why the original unpatched code included the qlen check in the fir=
st
> > place.
> >
> > After discussion with Greg, he has helped to temporarily drop the patch
> > from the 5.x queues ([2]). My suggestion is to include patches 01-06 of=
 the
> > patchset, as listed above, for the 5.x queues. For the 6.x queues that =
have
> > already merged patch 06, the earlier patches 01-05 should be merged too=
.
> >
> > I'm not too familiar with the stable patch process, so I may be complet=
ely
> > mistaken here.
>
> I'll be glad to take what is needed, but please list what commits need
> to go to what branches and in what exact order please.

Here's the list of commits. The order should be the sequence as listed
below.

6.14, 6.13, 6.12, 6.6, 6.1: (all 6.* branches)
5ba8b837b522d7051ef81bacf3d95383ff8edce5 ("sch_htb: make
htb_qlen_notify() idempotent")
df008598b3a00be02a8051fde89ca0fbc416bd55 ("sch_drr: make
drr_qlen_notify() idempotent")
51eb3b65544c9efd6a1026889ee5fb5aa62da3bb ("sch_hfsc: make
hfsc_qlen_notify() idempotent")
55f9eca4bfe30a15d8656f915922e8c98b7f0728 ("sch_qfq: make
qfq_qlen_notify() idempotent")
a7a15f39c682ac4268624da2abdb9114bdde96d5 ("sch_ets: make
est_qlen_notify() idempotent")

5.15, 5.10, 5.4: (all 5.* branches)
5ba8b837b522d7051ef81bacf3d95383ff8edce5 ("sch_htb: make
htb_qlen_notify() idempotent")
df008598b3a00be02a8051fde89ca0fbc416bd55 ("sch_drr: make
drr_qlen_notify() idempotent")
51eb3b65544c9efd6a1026889ee5fb5aa62da3bb ("sch_hfsc: make
hfsc_qlen_notify() idempotent")
55f9eca4bfe30a15d8656f915922e8c98b7f0728 ("sch_qfq: make
qfq_qlen_notify() idempotent")
a7a15f39c682ac4268624da2abdb9114bdde96d5 ("sch_ets: make
est_qlen_notify() idempotent")
342debc12183b51773b3345ba267e9263bdfaaef ("codel: remove
sch->q.qlen check before qdisc_tree_reduce_backlog()")

Cheers,
Gerrard
