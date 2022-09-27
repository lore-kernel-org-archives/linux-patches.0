Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289B033FE
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 15:53:24 +0000 (UTC)
Received: by mail-io1-f47.google.com with SMTP id g8so8128180iob.0
        for <patches@lists.linux.dev>; Tue, 27 Sep 2022 08:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=tUHp2nHddiilENT+8Cae200wA2dTxcOTzzNtjUo2Ijw=;
        b=H8CRnUPOCIjgovWiquSsLuWyIJJ1m1yYV9n8LRjmBPqtPS/gT5N4I0Tu7+l69T2+T6
         QvMDeRjcyhE+C4PKcvAzR4+4oGBKRL/oqmflDu7gg9an4wL0irf+XVtuBNLSVEuLuy4t
         bdG6O8KOHICb2BbZgBEyBQ0bWhAAQxMbNk+yoF0tMuXd8+MKnTinQC0etp5KC8Zy9RfS
         YaMGSFmDwKS8GhaWYVELLJIw6efkA+zveMYo01833yWz7LdtwwiPRE/ScVzOJoCc+UOG
         rjKtaWWP3PylQhdeDEsvywUf6xFzcUP0BgLvY9x0ZQKrzcsCabYXpIPcEdvGz+3SwUE4
         Iw5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=tUHp2nHddiilENT+8Cae200wA2dTxcOTzzNtjUo2Ijw=;
        b=QReD5fD4fZ1TgJFmfS9b59/ELAhcLHUhze9joq+uusafQpf2eJTQ2Fxryu1FEzod5/
         RsvD6L9bpzBs5d0Nq6PqplqEWoit02y8k/vWYStrYV2lROHjyohDBBxTqUBabqml+O4k
         Wt26mNz7u/AjPfDTsLh5q7VjaPjjSm9buUma4gGgCilPyoEWhYjqUWtAUVQ7IS8jhVjq
         9EDn1i8luilTJWtKDfjxZULz82kFIC0IAs5PYPQX2bamUihoK2Ze+rJiy/NOD4cXAikm
         YRHilHYPRJXOuvXznq/WDAr/4iy+I6OIYcj+c5pYHv7Hwf8NfTqJwdZ3dDkUWxEHOfD2
         mbrA==
X-Gm-Message-State: ACrzQf15feF+L7MDxwLUD+fzBXlN9+hU++VosNmWd5zv15eKLjHFWwGF
	LepJ9w9e2jFyD16gc2gUAa6B6EGZIsMsbNDASH8=
X-Google-Smtp-Source: AMsMyM4zX7hRygDuErXpVsOgtg9pYghLaYPrwHXI3wKDVg0monRfyJcd0mKU8ygB3ifILSCT/B4YZcMPfqK5UKckPk4=
X-Received: by 2002:a05:6602:134f:b0:6a4:cd04:7842 with SMTP id
 i15-20020a056602134f00b006a4cd047842mr3620542iov.172.1664294003136; Tue, 27
 Sep 2022 08:53:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220927131518.30000-1-ojeda@kernel.org> <20220927131518.30000-28-ojeda@kernel.org>
 <20220927141137.iovhhjufqdqcs6qn@gpm.stappers.nl> <202209270818.5BA5AA62@keescook>
 <YzMX91Kq6FzOL9g/@kroah.com>
In-Reply-To: <YzMX91Kq6FzOL9g/@kroah.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 27 Sep 2022 17:53:12 +0200
Message-ID: <CANiq72kyW-8Gzeex4UCMqQPCrYyPQni=8ZrRO1dQsUwDmAPedw@mail.gmail.com>
Subject: Re: [PATCH v10 27/27] MAINTAINERS: Rust
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Geert Stappers <stappers@stappers.nl>, 
	Linus Torvalds <torvalds@linux-foundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Maciej Falkowski <maciej.falkowski9@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Sep 27, 2022 at 5:34 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> How about just fixing up the emails in these patches, which will keep us
> from having bouncing ones for those of us who do not use the .mailmap
> file.

Sorry about that...

One question: if somebody wants to keep the Signed-off-bys and/or Git
authorship information using the old email for the patches (except the
`MAINTAINERS` entry), is that OK? (e.g. maybe because they did most of
the work in their previous company).

Cc'ing Maciej since I got a bounce too: is it OK using your personal address?

Thanks!

Cheers,
Miguel
