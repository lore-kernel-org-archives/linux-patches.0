Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EB921083
	for <patches@lists.linux.dev>; Tue, 30 May 2023 14:14:00 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-bacfa9fa329so3639578276.0
        for <patches@lists.linux.dev>; Tue, 30 May 2023 07:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685456039; x=1688048039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PTwLalb60PTMu/jAkQpXrnGqb2wva++F9Sq3eW5kYQw=;
        b=qPUeDTcfr7OxXHtWHpcNb077XYd+nlwgobee3voPFCtgiNZZCdBM2G3Mhwr2tv/LRJ
         jHmRt9KmlO/RUNoiqFwZSzGXMZaBSGflQGfKo+G6DDH+ielIX7hxTdc3rHYBPgRLOYX7
         h8GQHgoSGNJ+0lf1kj6aZ8S8zbAByKRnQBhxbFrgOcciMBi3CGF9Ey9JXPNtqraKpXgc
         Moy08rwTmdHh4+hZOS6DMcn5aohfMr+L/rSQcCnG2cCVx9nQ0hNv4qQNbCUcy0gB7FOi
         VMfhyusYx46sN3ZYS3Y2vxo5SkU+Kgx4hTm41bvGnkgAgk4P/fKBHtiMCJWWNcLAvwjN
         AIVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685456039; x=1688048039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PTwLalb60PTMu/jAkQpXrnGqb2wva++F9Sq3eW5kYQw=;
        b=XT4aChKXJ8hh3iei34z7H9ZpPfHfpMnFDqpCNz9KHgbdONHlhf1BpY9pYR2ZWMmM7J
         2eO6kBhpAvsJpYy2a0o+/zJCF/RFKNPcHXYL/NDbI9ORQd7jKgYQD1n4YKW7y8ZO+U26
         mpdG177SzTWYz+AU2uGA83M7d9WT1j6wzOwERkQEb6t8rjsO/Ev2LLhSplgpgKoyK/wH
         gsgN9BJgZx8SbhyKNrrcs3DLEQWOPRS0IXhtHSdRBK2u5+sgAE6ImU2+RM32OAjqsWMV
         JofhhGhVfeTKNCjoaQu7gPDPqjp0kiHp4mllObwDz9Vte4FzzIHSaIPd/CC1n/hIJX5m
         NNyg==
X-Gm-Message-State: AC+VfDyMNvrGUhzIavfxQb51ZgGcntTY7nTVr7ZhW6+GFETDVzSpFPvL
	WX9dKxtCss+jTAfgk7TvHaZkvLAAX6la8KOeH6A=
X-Google-Smtp-Source: ACHHUZ6RCEc1+fd5Perd8QLWxHmkFspNj2sVjBhJt3SR1lXVmV9tboAd8bJTp6zA0EHcE71YBH9ngmMm6Ax3uTvHiJo=
X-Received: by 2002:a81:a0d2:0:b0:565:6acc:2e56 with SMTP id
 x201-20020a81a0d2000000b005656acc2e56mr2589958ywg.15.1685456039055; Tue, 30
 May 2023 07:13:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <b54801cd-1afb-2190-3b8a-4a095d04fdff@gmail.com> <20230523110709.4077557-1-aliceryhl@google.com>
In-Reply-To: <20230523110709.4077557-1-aliceryhl@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 30 May 2023 16:13:47 +0200
Message-ID: <CANiq72kw-3usvn6JfD9Lp5KVrYyCVgOEehM7qXdpTvoDrX5TCw@mail.gmail.com>
Subject: Re: [PATCH v1 6/7] rust: workqueue: add safe API to workqueue
To: Alice Ryhl <aliceryhl@google.com>
Cc: yakoyoku@gmail.com, alex.gaynor@gmail.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, gary@garyguo.net, 
	jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, ojeda@kernel.org, 
	patches@lists.linux.dev, rust-for-linux@vger.kernel.org, tj@kernel.org, 
	wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 23, 2023 at 1:07=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> I think this is a question of style. For a comparison:
>
> match (queue_work_on)(work_ptr) {
>     true =3D> Ok(()),
>     // SAFETY: The work queue has not taken ownership of the pointer.
>     false =3D> Err(unsafe { Arc::from_raw(ptr) }),
> }
>
> vs
>
> if (queue_work_on)(work_ptr) {
>     Ok(())
> } else {
>     // SAFETY: The work queue has not taken ownership of the pointer.
>     Err(unsafe { Arc::from_raw(ptr) }),
> }

There is also the possibility of using the early return style:

    if ... {
        return Err(...);
    }

    Ok(())

This one makes it consistent with other early exits (i.e. whether at
the end of the function or not) and closer to the C side.

It is particularly nice when we are talking about errors, instead of
two "equal", non-error outcomes.

Cheers,
Miguel
