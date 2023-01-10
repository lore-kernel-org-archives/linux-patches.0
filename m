Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4E86FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 12:28:37 +0000 (UTC)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-4d13cb4bbffso31403327b3.3
        for <patches@lists.linux.dev>; Tue, 10 Jan 2023 04:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2vRpvlz/nTbkuUWpiT0ilG/Sg8qqMAAl8bfBXBzFCxg=;
        b=iZLPUyiqSibhLkBnGrBg3hGw/AMODHqYyvgvfr2R0O/W7SxuuDn6gFWytT2k++2EAy
         HczFFtSB/qhgr2f28uXRl0+zWfU/7MyOBwKXvKOfQ2+5YLVIGPKOYHchXMbzGL8eGxYO
         99ff0hquQQ0oC98c+Dt/gHwxYsviqX5NbsfKsNa0QySsneUCNurnCeEqGczdy0lnkKRY
         hIuExqvBgRRtwS6luRBMKaVVm3E7ta64yQY+oxG/EzVm0RmPurL+LXtxBx/Cx9URVulo
         i6EaKBELkj+AHHg1ejZyDFOvdWAK9HsIT6fLlgt8ytGSty0HtfM25Wq5SQb+7svTpzLQ
         MaEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2vRpvlz/nTbkuUWpiT0ilG/Sg8qqMAAl8bfBXBzFCxg=;
        b=qg7TiuyC2A0yrVn6HCLh2vuZnGbwJ+OWxS9g2Oq2qu29/xcgTRVfYbNSxArqXkemwA
         yuMPzzCb0OSABJi+1pl+x2+Tf/kpUHOP1LQ5fh225KT3c/AYKbZWjFaCI44sT4wFQFnK
         Cp3dr7YATi4WSGtXVDB4V+FJFkqIx1ETX8jxq7sHS8ebBdMoi3V4JgMC8c7PeOCD3hi2
         BWK5MgHa+p2RCP7eV3nOVVCCfUSWHTJnbfi9zFqi+E8QILNGh2xE28XkP0U75mk7zvfi
         0Lcq5yYiERvxmIlDKzysq2JclzjQcXOZ216vcpv1QP4vbSFUrB4bFnfrXOSTTmt4S25m
         4tdg==
X-Gm-Message-State: AFqh2kr7Qvs5A6fEx1TRAT5H7YdoaG3AcnYAOlHL5Nat8Mzb4pWCNh3E
	OahIMGcPXa647pfRHtaEpx3/qcj4S6ieAZXfcdY=
X-Google-Smtp-Source: AMrXdXvBz8/Dl4bwHgsKcFKZ43+bE2HeLAUWlYQrqbBvPXwRkdFlRzK/6PXnpStRCc6iPNFNVUp06TSwBjekEL1JMWE=
X-Received: by 2002:a81:b60b:0:b0:45c:d900:f30c with SMTP id
 u11-20020a81b60b000000b0045cd900f30cmr1581382ywh.256.1673353716487; Tue, 10
 Jan 2023 04:28:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109204520.539080-1-ojeda@kernel.org> <20230109204520.539080-2-ojeda@kernel.org>
 <1E542F5E-220F-4061-BC71-F37C76616F34@nyantec.com>
In-Reply-To: <1E542F5E-220F-4061-BC71-F37C76616F34@nyantec.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 10 Jan 2023 13:28:25 +0100
Message-ID: <CANiq72mYHzHVk9s6Tf+vbG5ToChzCTBh0vX67s87P5sxbD-PVQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] kbuild: rust_is_available: print docs reference
To: Finn Behrens <fin@nyantec.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, linux-kbuild@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nicolas Schier <nicolas@fjasle.eu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 10, 2023 at 11:16 AM Finn Behrens <fin@nyantec.com> wrote:
>
> As I always use my systems rustc/bindgen, I always get the warning, which already clutters the build output a bit. But I see why it is helpful, so not a fan, but this patch is reasonable.

Indeed, if one uses a different version, it may end up becoming too
annoying when running it during build -- it is something I worried
about when adding it back then in commit 11c0cf1e8c06 ("rust: run
rust-is-available on build") in our repository.

I think, for a while, until more people is accustomed to dealing with
Rust, it may be worth the pain for some of us in order to help to
catch bad setups, since otherwise users may not attempt to check with
the `rustavailable` target themselves.

In any case, of course, the "too new" warnings will go away when we
reach a stable version situation since they will not be needed anymore
(but we can also do it sooner than that, for the build step
especially).

Thanks for the review!

Cheers,
Miguel
