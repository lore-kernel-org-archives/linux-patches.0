Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119117B
	for <patches@lists.linux.dev>; Wed, 28 Sep 2022 11:57:33 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id 9so12287346pfz.12
        for <patches@lists.linux.dev>; Wed, 28 Sep 2022 04:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=kTt78o8sw7DrI9PLxyN0n+3tUBa/gb1NqpPxWUB4KCg=;
        b=KLxgcyg2qJUDAGD1546ocHb8zD2jWooEsH9eajCy1V5enFhJ0vDZDVHNomuFEj6HWh
         IKIa43x1gFDU4UnbGndt1qlNHG5Om3aGTlAlbUtBWWMSukv2G3FCwzU+3uiX1S4Iv1Zi
         cGyPGpGG7E/Uwvsua9q2jNYlymXI1NC7Rt66i+sODKVtVwiRBpYAIpALaUvGPClPvtqz
         8bGNEV+YKROfTMty3Mpm4kZjr65dq4/Ufhu55wKYYBbM1y7sJKTEqAnYW8xkJcG/Kv4e
         34O+WOA1GovKCD2U2VCu9l5eeH53JHhtp2xEnrvhD/S/5LQHOBgnpugNVMaCiZJ6uN0A
         4DGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=kTt78o8sw7DrI9PLxyN0n+3tUBa/gb1NqpPxWUB4KCg=;
        b=piMvx+AJk6x2cIuk3SnDM7brYboGxGf1LKKkplMvRAN2Z0TnOCuFX8j1hDSoeHYqAB
         pBm3HvoZBHgOjcwLJdKjvdPPohPXfn3TJEutgZrv5SIqpBroHRPI98NoqSnDVmI5M1oq
         9nvCkTqF2S3jYDLU5ErvIzvP8tBJqLOo1sU8WQD/HB/noATlHAV7FCBbzRSfb35OxSsf
         cEdA6ecl4FOkl8XyNULXZd3yuGL9ofRcvSwX9IMRp8zAyTRVv6uI3ZHA+MvqYxssKHTe
         D+m5MR2wQYqRWBGvfKiiTrtsr7Os0GJXzXn2MRsGZVQ1UCiZdD/g3uaagNbqrAFMBELl
         CVmQ==
X-Gm-Message-State: ACrzQf2ojFtQYYlOphRl3AKBDaTI3mVobr6zQkIxddEdkqbR2qeSs5qI
	tuBrf7Q+Zw+YTiyhVxbmiAuF6O3rGl+hR8sL3D06lVjJ+roMtg==
X-Google-Smtp-Source: AMsMyM4vgLDLNPomf1ilGGAQV/z0snFyjMbp1+L4a1xwnRIAKJuyvJL77nq2QWriD0JZ3CnNSzaD7wRe+e8Jm5At4tc=
X-Received: by 2002:a05:6a00:3492:b0:540:b30d:8396 with SMTP id
 cp18-20020a056a00349200b00540b30d8396mr34458408pfb.81.1664366252575; Wed, 28
 Sep 2022 04:57:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220927131518.30000-1-ojeda@kernel.org> <20220927131518.30000-28-ojeda@kernel.org>
 <20220927141137.iovhhjufqdqcs6qn@gpm.stappers.nl> <202209270818.5BA5AA62@keescook>
 <YzMX91Kq6FzOL9g/@kroah.com> <CANiq72kyW-8Gzeex4UCMqQPCrYyPQni=8ZrRO1dQsUwDmAPedw@mail.gmail.com>
 <202209271710.6DD4B44C@keescook>
In-Reply-To: <202209271710.6DD4B44C@keescook>
From: Wedson Almeida Filho <wedsonaf@gmail.com>
Date: Wed, 28 Sep 2022 12:57:21 +0100
Message-ID: <CANeycqo3O3yh2ms6vpHkzBLtT7QuCYWeweLq_z9SVygsot43YA@mail.gmail.com>
Subject: Re: [PATCH v10 27/27] MAINTAINERS: Rust
To: Kees Cook <keescook@chromium.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Geert Stappers <stappers@stappers.nl>, Linus Torvalds <torvalds@linux-foundation.org>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev, 
	Jarkko Sakkinen <jarkko@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Maciej Falkowski <maciej.falkowski9@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Sept 2022 at 01:11, Kees Cook <keescook@chromium.org> wrote:
>
> On Tue, Sep 27, 2022 at 05:53:12PM +0200, Miguel Ojeda wrote:
> > On Tue, Sep 27, 2022 at 5:34 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > How about just fixing up the emails in these patches, which will keep=
 us
> > > from having bouncing ones for those of us who do not use the .mailmap
> > > file.
> >
> > Sorry about that...
> >
> > One question: if somebody wants to keep the Signed-off-bys and/or Git
> > authorship information using the old email for the patches (except the
> > `MAINTAINERS` entry), is that OK? (e.g. maybe because they did most of
> > the work in their previous company).
>
> IMO, the S-o-b's should stand since they're historical, but fixing
> MAINTAINERS to be up-to-date makes sense.

Our intent wasn't to have a known-invalid email in MAINTAINERS, it was
just my mistake: after leaving Google I updated my email in a lot of
places but missed this one. Apologies for that.

The patch below fixes this:

diff --git a/MAINTAINERS b/MAINTAINERS
index f4e31512bab8..e082270dd285 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17913,7 +17913,7 @@ F:      tools/verification/
 RUST
 M:     Miguel Ojeda <ojeda@kernel.org>
 M:     Alex Gaynor <alex.gaynor@gmail.com>
-M:     Wedson Almeida Filho <wedsonaf@google.com>
+M:     Wedson Almeida Filho <wedsonaf@gmail.com>
 R:     Boqun Feng <boqun.feng@gmail.com>
 R:     Gary Guo <gary@garyguo.net>
 R:     Bj=C3=B6rn Roy Baron <bjorn3_gh@protonmail.com>

Thanks,
-Wedson
