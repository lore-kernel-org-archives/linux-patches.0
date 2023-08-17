Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060FD18043
	for <patches@lists.linux.dev>; Thu, 17 Aug 2023 19:13:55 +0000 (UTC)
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-58c55d408daso1616287b3.2
        for <patches@lists.linux.dev>; Thu, 17 Aug 2023 12:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692299635; x=1692904435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uIEs+zY5mVb/g93Ss2uTmENSwbzNg8Kom89qgvF5FRA=;
        b=W4Cr0mvis2OIKZsFy+6rdHNEUPvSbKjJynj7HSrWf3aZFurLDZHIQ9Sc5adepU7X2g
         yuA5at36fBxZ744aDN/SnOjlOab7w3PtJkx5oasb1Vr2zRH9GNzEISvKuiaOJVjc3a4p
         fi5NjNaJzdwlTolP5tcLYURgorPSDxfXL5y3y7pFJuFIzanAUckId3vdJQ8RiPPaPa5e
         pktTa6ctIs2F+R0oFxGJF7hpEttO3KQhesWLCbtd2KQP807I0K61zxtkFEc6BEbPrr4g
         WxyDPuCkBUfgihuqexYxR0P0LCnXiFw5A5nI1Z13wInFcGXiiNTVEVlWMiHl2Avy4Z/V
         TzFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692299635; x=1692904435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uIEs+zY5mVb/g93Ss2uTmENSwbzNg8Kom89qgvF5FRA=;
        b=C/YDFdiZYTL70QBI8tuqF8M2Dm5JgQQtPMGQBHtiSbbHwfxo8rND2p506r5Omg14dZ
         mqUeTRNHJyyAK7tFNWxmiFrkfzONsh9gMDkqa1cp2PbDlFE9MEnYuJeeOV3mcoSHn2Qg
         jJwJvDRwVnu/PYhL/SURWj3cf3pTf8wrmCe0W/38CkYFMv/1WO4LGTJ9fx6Hf6u3BE1C
         yXsbeCc4dynlKFsoBFTK0RsMJqLf7i95tAmqUXDJoJsz9HviQ4fE0mYny6nhcuJgkJ13
         aCKuCsQxaOzhGCgqjfEYxPTWaXMgAKvwXIOJAKB4KQyBdbvSBeVhmnfaFvNqgF/KqV5D
         VyIA==
X-Gm-Message-State: AOJu0YzV3/ot8kqrXT5p0zKssxeIYHgr7m3ISHBrx60ip/5LTY7+yfrL
	2G7/IbZzmdAZmo5i/mTMb0vDXvg++oje8nub3GM=
X-Google-Smtp-Source: AGHT+IF/w8EXRcnrNyaP+WAiDPrkMT8e5wTpJpESG14m1yR+ncLrSovatqvFBm4RL7ksjyteyKLfjDq2FURcSGdSb/o=
X-Received: by 2002:a81:4e85:0:b0:57a:897e:abce with SMTP id
 c127-20020a814e85000000b0057a897eabcemr401799ywb.7.1692299634794; Thu, 17 Aug
 2023 12:13:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230814092302.1903203-1-dallerivemichele@gmail.com>
 <2023081411-apache-tubeless-7bb3@gregkh> <0e91e3be-abbb-4bf7-be05-ba75c7522736@lunn.ch>
 <CACETy0=V9B8UOCi+BKfyrX06ca=WvC0Gvo_ouR=DjX=_-jhAwg@mail.gmail.com>
 <e3b4164a-5392-4209-99e5-560bf96df1df@lunn.ch> <CACETy0n0217=JOnHUWvxM_npDrdg4U=nzGYKqYbGFsvspjP6gg@mail.gmail.com>
 <CANiq72=3z+FcyYGV0upsezGAkh2J4EmzbJ=5s374gf=10AYnUQ@mail.gmail.com> <20230817113853.4b47e636@hermes.local>
In-Reply-To: <20230817113853.4b47e636@hermes.local>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 17 Aug 2023 21:13:43 +0200
Message-ID: <CANiq72k0FxqE+_4jUM58pKinArARC75jYORe3CWX+OkosDqABQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] Rust Socket abstractions
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Michele Dalle Rive <dallerivemichele@gmail.com>, Andrew Lunn <andrew@lunn.ch>, 
	Greg KH <gregkh@linuxfoundation.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Davide Rovelli <davide.rovelli@usi.ch>, rust-for-linux@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 17, 2023 at 8:38=E2=80=AFPM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> I thought Rust symbols were all export symbol GPL.
> And therefore any Rust module using these must also be GPL.

They may be not distributing it just yet, e.g. it may be in
development as part of an academic paper, but they may be able to
publish later.

Cheers,
Miguel
