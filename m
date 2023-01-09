Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD7923A3
	for <patches@lists.linux.dev>; Mon,  9 Jan 2023 23:27:12 +0000 (UTC)
Received: by mail-yb1-f177.google.com with SMTP id 203so10104535yby.10
        for <patches@lists.linux.dev>; Mon, 09 Jan 2023 15:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UY+1Fpt0FK7lLfeSUW68NLIUA8SVjtGE9huFocWEeKs=;
        b=RsPeIV8aR7aKfgIzo27xLUiVGHbaKd/HgO/xGdeCY4Z0KxryxI15LpnavV/6d0HkhV
         1cKBycFNaX2/yd8D6T4WqDnRfD8maa7cOcBxaCQcuuADA9aHi2YzyJELnsqub6TGp2wf
         TLdcpBx0OUvtWE1eg4dBoCmAq8geiYAFNLdlFnMZtTMP507iy8hRLh/oc1b1DZYFY7zG
         3PMnSMKODrz2VQ7e08Hddf+pM4njPz0TzM62IeX22sczwbtilNPm9m5402co2okNV6pO
         ncrcgvDkMhibTOzPPDsCz34FFZr1bUXGhPG99LWJ98CDztQ+QSI3cir8Erx0QRl60ZRi
         qWsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UY+1Fpt0FK7lLfeSUW68NLIUA8SVjtGE9huFocWEeKs=;
        b=YTCzYoRTJUdgDl9p6JGXPuS3MNdqabNYeRYtxlI3RkXJyjLGqGmWnL0XDn8VSSo8E1
         iEwFqdeRgFHUmgFaAzX8surZPK9qtLdyy1wrfphiRk+iXEGXhkDhZQfLUMSohxgShisW
         EMk1T4/pTvJBwKdzz/LBOW3kqd1qLFqS/4SyajxRz3vMVeNSNsqgfl10/1jfF7is3ppT
         yLI2fz3chAq+KZIDh5m2/kmK+q/TH2HRnqwqeKAl34WmFGLxXYw6GxLaK9Z9whsQJFZh
         lt5J1ui3lDbx0Mj1p8Sn81CuCR0Ra2kGgCAf7GppXCc2pmC4b2vgygESgPx3JKsTfPzC
         jaUQ==
X-Gm-Message-State: AFqh2ko6Fa0HmXdXCfmhnTXBe5dxzZfyi50kbJtNwfZBVBryWF9Y4K3b
	r9n9PRB1ilk0cmXSJBgXmiEwOm6YPV2QVxdYRF0=
X-Google-Smtp-Source: AMrXdXvrlbd5h1RWMBpkgFbj03OSP8b8iebn8qrpIDcVK3qInC9NLlZPapSxLJBCkgA0jhZXCtuRUWOP8uBZd2h4Q1M=
X-Received: by 2002:a25:7702:0:b0:7b4:bdd7:e631 with SMTP id
 s2-20020a257702000000b007b4bdd7e631mr2014500ybc.507.1673306831157; Mon, 09
 Jan 2023 15:27:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109204520.539080-1-ojeda@kernel.org> <20230109204520.539080-3-ojeda@kernel.org>
 <Y7yZTBIF58+1Fj5m@boqun-archlinux>
In-Reply-To: <Y7yZTBIF58+1Fj5m@boqun-archlinux>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 10 Jan 2023 00:27:00 +0100
Message-ID: <CANiq72=bqp_tPL9qq6OYBv1uyByL65_e4Bp4r8pfdBFf-2gBwA@mail.gmail.com>
Subject: Re: [PATCH 3/6] kbuild: rust_is_available: add check for `bindgen` invocation
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, linux-kbuild@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nicolas Schier <nicolas@fjasle.eu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Alexandru Radovici <msg4alex@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 9, 2023 at 11:47 PM Boqun Feng <boqun.feng@gmail.com> wrote:
>
> Per Documentation/process/maintainer-tip.rst, the "Reported-by" tag does
> require "Name <mailaddress>" format. Given we already have the GitHub
> issue link, I wonder whether it's better we ask for the reporter's
> email address (and real name) for the "Reported-by" field, and if they
> prefer to not providing one, we just don't use the "Reported-by" tag
> since we still have the GitHub issue link for their contribution.
>
> Thoughts?

As far as I understand, that is for the tip tree (though
`checkpatch.pl` complained too), and I am not sure in that guide they
intend it to mean it is the only form accepted.

In this case, I ended up deciding to add it since it was not a
Signed-off-by/Reviewed-by/Acked-by (so not as critical, i.e. no
DCO/RSO/...) and there are quite a few other instances, including
different CIs and tools, raw emails, security teams, etc.

So it doesn't look like it is required to be a "real name" like some
of the other tags, and sometimes we may need to do otherwise anyway
(for those cases), and I guess we don't want to discourage reports too
much. Perhaps we can, at least, ask for an email address -- that is
way more common in the log, and gives us a potential way to contact
people and send the patches to.

In any case, I agree we should prefer the "real name" way as much as
possible. I had sent a message to each GitHub issue/PR linking back to
the patches, but I will send another to offer them to use their real
name if they prefer.

Thanks for taking a look! :)

Cheers,
Miguel
