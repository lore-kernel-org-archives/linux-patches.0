Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8A57C
	for <patches@lists.linux.dev>; Sat,  6 Aug 2022 11:23:05 +0000 (UTC)
Received: by mail-il1-f175.google.com with SMTP id j20so2478172ila.6
        for <patches@lists.linux.dev>; Sat, 06 Aug 2022 04:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Um1v1FrSCBFvVj7vNPvt2QZzZCYl4QtDmBW6UESDgwA=;
        b=QUa+QsnYh9cvzUYscq18TKSV3NJAdEQI9JP5mrkTCnTyNNiLCNWs4wUNegk2+bavFF
         sramTVQ/jBd9lIjNZ/K0LctPG+/50shDCsbEUDQFjVuxBI6zbiGxH0Bg5jQQjKOeGCHt
         vQ7QB0ZAngzih8tY3Sv9JIIS3K+gSEdgwjnPtrWMuPZYpc3Qy0HGzrSP6gcRG5P6tlFk
         Gbocjr9mZaYsVuSVrK77WgNt+jyrIb1k85dBHQMvu7A7ZUSIrvm0yorv0/2Hx8h9sHfl
         MNGFsq9UtdOK7lByFvZidEJVdx3OscdAypKgKIwYO42ynokMUusVLPzhkV6BwyMoR/4f
         AbGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Um1v1FrSCBFvVj7vNPvt2QZzZCYl4QtDmBW6UESDgwA=;
        b=yZfYzcwsu40k8JdZ7L7NKeh4AX8Aub5D9gJ64WJj4ZDhA2gnNK+3YsUurRFotwFJwU
         JP4XFiDX6DL6MjhjgOaFyN+w/C2lGcTa/N3pyW2fW8x66f1n5Rah6F+15/XTLoUysLDp
         ZNcX7p77exdvZdLH0h7BMhgdN0c3hEH68XR9wgIAaEjR3A096CV+SG7+S0Ougt8Vs3HF
         DNVb8+DZZZTbHRaOONPpkeqzra89E4CF1X4rZ0kD4iQERCZBXIuIM5tSP1zvE8Tg1NK4
         5Efgux/F43eYU94lUVAS2Zpb8WDA4ENbB24MkOrasd8aaAWlKIokH3iu+tJoFJ+ahNkB
         AHIg==
X-Gm-Message-State: ACgBeo1jcLcjK46FBsPXZPjq9vdh8+PCS1y0joF7RNHYc1DB6dMMqE63
	PnCPgNF/OJ5wO3fYhL/XMGOU1a/aoRBCSXUkkWk=
X-Google-Smtp-Source: AA6agR7qEC8iU/WaGU3JQe5au0X+zcl2gDqnJ72SDHmcqd6eC86RlGuRDU4TMA1Juf98d4Nn/szP9GBxXNRIAhTu/Yg=
X-Received: by 2002:a05:6e02:1c23:b0:2dc:e497:8b12 with SMTP id
 m3-20020a056e021c2300b002dce4978b12mr4884021ilh.151.1659784984174; Sat, 06
 Aug 2022 04:23:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220805154231.31257-13-ojeda@kernel.org> <Yu5Bex9zU6KJpcEm@yadro.com>
In-Reply-To: <Yu5Bex9zU6KJpcEm@yadro.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 6 Aug 2022 13:22:52 +0200
Message-ID: <CANiq72=3j2NM2kS8iw14G6MnGirb0=O6XQyCsY9vVgsZ1DfLaQ@mail.gmail.com>
Subject: Re: [PATCH v9 12/27] rust: add `kernel` crate
To: Konstantin Shelekhin <k.shelekhin@yadro.com>
Cc: ojeda@kernel.org, alex.gaynor@gmail.com, ark.email@gmail.com, 
	bjorn3_gh@protonmail.com, bobo1239@web.de, bonifaido@gmail.com, 
	boqun.feng@gmail.com, davidgow@google.com, dev@niklasmohrin.de, 
	dsosnowski@dsosnowski.pl, foxhlchen@gmail.com, gary@garyguo.net, 
	geofft@ldpreload.com, gregkh@linuxfoundation.org, jarkko@kernel.org, 
	john.m.baublitz@gmail.com, leseulartichaut@gmail.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	m.falkowski@samsung.com, me@kloenk.de, milan@mdaverde.com, 
	mjmouse9999@gmail.com, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, thesven73@gmail.com, 
	torvalds@linux-foundation.org, viktor@v-gar.de, wedsonaf@google.com, 
	Andreas Hindborg <andreas.hindborg@wdc.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, Aug 6, 2022 at 12:25 PM Konstantin Shelekhin
<k.shelekhin@yadro.com> wrote:
>
> I sense possible problems here. It's common for a kernel code to pass
> flags during memory allocations.

Yes, of course. We will support this, but how exactly it will look
like, to what extent upstream Rust's `alloc` could support our use
cases, etc. has been on discussion for a long time.

For instance, see https://github.com/Rust-for-Linux/linux/pull/815 for
a potential extension trait approach with no allocator carried on the
type that Andreas wrote after a discussion in the last informal call:

    let a = Box::try_new_atomic(101)?;

Cheers,
Miguel
