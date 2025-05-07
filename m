Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677341D5146
	for <patches@lists.linux.dev>; Wed,  7 May 2025 04:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746591109; cv=none; b=TC7YdfUn1pWBOLfZAHukCnlHFQkFt/wLuNiwxltvnK5/WdPdyG23K2T9cHkLGAbB+abxmXA4FLgxkQLmLBkjjwRpEtNX9+o5DEvRTmxs2CD5E0/PFBvyth7gx0OFq5fQ3Atfbcl3n8XVAwq0UaWD42diA3mOwTcMvHhGDQOryCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746591109; c=relaxed/simple;
	bh=8PID+wi9yLs6Itz1N7GVcdzH699Be+tpw+C+FjNWjf0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uc9sdxLeChvSRU/ZlfcFvDDc3Qks3fGjKFr7MYmGeX/R2J71YmMpKGDDk78iwIUyln9AB5j8QT9hkjcQeN0afv/m9fCV3B0m4mF7SFl2ohHrlSHe7edHkXkYLUyx4etar9tGnkeMNV1ZW4aA2kV3bFF6T+ZnZWiNKrP4TvHZoHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VmQSSiZr; arc=none smtp.client-ip=209.85.217.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VmQSSiZr"
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-4c315dd9252so320953137.1
        for <patches@lists.linux.dev>; Tue, 06 May 2025 21:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746591107; x=1747195907; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8PID+wi9yLs6Itz1N7GVcdzH699Be+tpw+C+FjNWjf0=;
        b=VmQSSiZrpvYk47YvGRGamU5mYzY/g2NLsokTtY4eyCdtBBH7kbRLTX8gxrIh0mHd7L
         vuANcAOoHFdcd4af2yo6zvYqyeliSC5PPmvvYwoggFdspeE64w97V87XDsvDTdZirEiq
         zfhdv29ijpRx2l3bNSwXlXZA+fI0a/h06STNdgd3XqfJln+7Hjjnc0zk95QfS4Om2VMs
         tlYNToyWBkHFcG2Vb0r3z7kz2fmTeHqSDxzR7tF/bC/OKh8EyDTeHCb61Eogg/KmaJYB
         El8qDpUZxnAHsEJzZPF8anvX4dYkzZk92FOwZjGLl5jVL/OrmCR40AyMNcU2s2ROWEwC
         5QAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746591107; x=1747195907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8PID+wi9yLs6Itz1N7GVcdzH699Be+tpw+C+FjNWjf0=;
        b=LFVAepdJkEEVi0cF5eIzVOBTFj67Zt3m/SbiJbhisRMZwTwuXPN/DBzBZCrlTyDosw
         6H5ZniC0b8372hwn4UiUTtpQbcV+NQwO6cILUrGOKncgj/yNpbKdS2T43CKcNoAtwD5H
         rLA2AiEOvFZn8jwWeVy/aWQoDPyHcH3Qw/g4xXTdrY7Q0C2KJHVIABG+wmdiZbR9RWL8
         L/I4Q5TJfwanKDzk9NJVE7NBJ3Negyznn1KS0D3/MwEZhBJC80oPb+0K/DWrGEBnvgpd
         ysMm5RhyrYjRkH9dzh3c6ZeqQHcfK+LyEwplNbN8v2lrZxYDmeTv9cEA+igWjoX/Fm1I
         e+FA==
X-Forwarded-Encrypted: i=1; AJvYcCWnkMrae6jtPQtHtVcPwahSQOP/CLB2mVntwjnMTkPh5Cq+3HgFygUs973R/tcsGlOP19XBGY9N@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8h3NrcrHhOjWyNe0AZkd7Kg7oeKawX2i8vhXSC52s1v2Xk/4D
	14sZXVq1776hmTyY0bopE9gp3zGeNU9ayeQKYdXTMPSPr2XdLMtRHYLdi88UehMvYXGsp7ooLGU
	oaXt3sZpa3i6OtKxdRITJvHMW4qU=
X-Gm-Gg: ASbGncvs1r9kK5vmSQOD3EJointM/1gZ+JGxXfJPAjlhY6lYgMgGFhqzq5Qf2uu+pbd
	cVRDIrbeewLzHIvBGZroTFy50YCMY1X3wsGG0lObh77T/GsnEqcnagiVQVg8ER7Vi8ECL8qCmFA
	yJAE53oTfSlPnRa0X4wbt31CyR2DCJim1Wj7+BX2e4qUDhj+HEck1Ejfc=
X-Google-Smtp-Source: AGHT+IHoK/t0qRHJ5yM/hOBVyZvoaX1A0W9udJoXG+cRgaLh3QCyU3sjlJYfXKdomUH9Boz59AguWE9GpYEdpAi/0AE=
X-Received: by 2002:a67:f64e:0:b0:4c3:243:331a with SMTP id
 ada2fe7eead31-4dc71f555famr1971628137.6.1746591106989; Tue, 06 May 2025
 21:11:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHcdcOkW1D_zKh-HPsfjX-oGYhv-OwojPXVwcA=NYoO0hcCbZQ@mail.gmail.com>
 <2025050519-stem-fidelity-25b1@gregkh> <CAHcdcOkMt_Mpcm1AjxbU8MurGO5e--LPPJOrSTA+utDOzVHE3g@mail.gmail.com>
In-Reply-To: <CAHcdcOkMt_Mpcm1AjxbU8MurGO5e--LPPJOrSTA+utDOzVHE3g@mail.gmail.com>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Tue, 6 May 2025 21:11:34 -0700
X-Gm-Features: ATxdqUG9dkblt4V27qOpHvU3W8xLOFXG2ZqD-fIWGWgiz-WZgF_XlHMyWmIiywI
Message-ID: <CAM_iQpVHg+6WJB7On-+1uoeRHR=HRH6pOZvi++CRktU818DLyg@mail.gmail.com>
Subject: Re: net/sched: codel: Inclusion of patchset
To: "Tai, Gerrard" <gerrard.tai@starlabs.sg>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Simon Horman <horms@kernel.org>, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Paolo Abeni <pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 6, 2025 at 8:00=E2=80=AFPM Tai, Gerrard <gerrard.tai@starlabs.s=
g> wrote:
> Here's the list of commits. The order should be the sequence as listed
> below.
>
> 6.14, 6.13, 6.12, 6.6, 6.1: (all 6.* branches)
> 5ba8b837b522d7051ef81bacf3d95383ff8edce5 ("sch_htb: make
> htb_qlen_notify() idempotent")
> df008598b3a00be02a8051fde89ca0fbc416bd55 ("sch_drr: make
> drr_qlen_notify() idempotent")
> 51eb3b65544c9efd6a1026889ee5fb5aa62da3bb ("sch_hfsc: make
> hfsc_qlen_notify() idempotent")
> 55f9eca4bfe30a15d8656f915922e8c98b7f0728 ("sch_qfq: make
> qfq_qlen_notify() idempotent")
> a7a15f39c682ac4268624da2abdb9114bdde96d5 ("sch_ets: make
> est_qlen_notify() idempotent")

Plus:
376947861013 ("sch_htb: make htb_deactivate() idempotent")

>
> 5.15, 5.10, 5.4: (all 5.* branches)
> 5ba8b837b522d7051ef81bacf3d95383ff8edce5 ("sch_htb: make
> htb_qlen_notify() idempotent")
> df008598b3a00be02a8051fde89ca0fbc416bd55 ("sch_drr: make
> drr_qlen_notify() idempotent")
> 51eb3b65544c9efd6a1026889ee5fb5aa62da3bb ("sch_hfsc: make
> hfsc_qlen_notify() idempotent")
> 55f9eca4bfe30a15d8656f915922e8c98b7f0728 ("sch_qfq: make
> qfq_qlen_notify() idempotent")
> a7a15f39c682ac4268624da2abdb9114bdde96d5 ("sch_ets: make
> est_qlen_notify() idempotent")
> 342debc12183b51773b3345ba267e9263bdfaaef ("codel: remove
> sch->q.qlen check before qdisc_tree_reduce_backlog()")

Ditto.

Thanks!
