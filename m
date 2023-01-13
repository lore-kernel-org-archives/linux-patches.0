Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E0A627
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 23:10:22 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id 20so5090074ybl.0
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 15:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=12LpQywJJjBUt3FCMjBNpWZt4HLsrmq3D+lfWqk6LQM=;
        b=fRrF6T6XabAL4uomg1EBZjf0pG8RRsV9KFwYLgx0AgGZ5PzhyNocQe6FI8oroqiu5q
         eOfUU4c2+Ed1v+y9Z1doeIlckw+oOgbTct1ziWgWR6MX3BaWmALJcE/pMOtF1OK+BACi
         bULY/xzsuDVDHcvRw8Gw+Ml4y46953meYP8XqKxShlh2WaVgRkgYF5lo5q6m8G8K00kK
         cB1zYo2puvKiPeyUjvCOjNSWXVr/D+lb9iFTh07ISTck420D6q7SF4Bg5Nu4Q+NvxfmK
         4E1BucCijZaAtoAZJurv49EQz5dCPv5iIIydwMdAwgy0DjT1rvib24QS/PWyDbWZcqSa
         RTAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=12LpQywJJjBUt3FCMjBNpWZt4HLsrmq3D+lfWqk6LQM=;
        b=lvfGdL/DVwBOrCHx9x5VBaWRDvV1oQIqK8DEtKpnlXtMAGcr4oRMJb8jg3hDHc2hlm
         8wJsmRgCjx6XkqnV3PjeCLhgZz3621oatrnjQqhwYfOUVYFQxInfUR9QwhTo3yujrINq
         akDROKo3/lVnywGOSFXKIVTOJWRV3qlC4MZirW/zf+0wEnQKOwR+qKR/DVgs7vYeMzcV
         NBd3mAtJ0kyCvl98/j3evrWVtB113fZEEwlclQzJeSdjLScSEa6e9UjXpWSPbXhjAw/D
         EeophVYCFrJpL2HthklYCttcpuxb0IphGSVg97gyB4Se8hQ9J+izkmO7r+kPBBlKSGEh
         7sKg==
X-Gm-Message-State: AFqh2ko8AWsDXS7J6x3WvCf+bfMwTBQwc6LVvjs46F9UbAoeMhGucQSP
	6nWSIee7V0fWNrms9wGiUlsK5ovhNoa9bO0LnaM=
X-Google-Smtp-Source: AMrXdXs0dEMNst1mDvKhLbzcUm5c3putoAqwcOSEik/6eKrko8ZBfOxL/z4F7QwYPbUY7iJt64JnMnFORkPuNWfECts=
X-Received: by 2002:a25:bc43:0:b0:7b2:343d:6b11 with SMTP id
 d3-20020a25bc43000000b007b2343d6b11mr4500515ybk.75.1673651421281; Fri, 13 Jan
 2023 15:10:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109204520.539080-1-ojeda@kernel.org> <20230109204520.539080-3-ojeda@kernel.org>
 <CAK7LNATVJ5e=DnbJ++03iEMk0bN3-UvODBLkEKcYdSnJZa_tmA@mail.gmail.com> <CAK7LNASDu+i4G88TYYa6feg-bha-_cLv1si_ujuSMbWuyUve0Q@mail.gmail.com>
In-Reply-To: <CAK7LNASDu+i4G88TYYa6feg-bha-_cLv1si_ujuSMbWuyUve0Q@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 14 Jan 2023 00:10:10 +0100
Message-ID: <CANiq72k6jCf_LP5vmBHKEpZ5njmH+u1HpJUjs_GyFi1a4B94ew@mail.gmail.com>
Subject: Re: [PATCH 3/6] kbuild: rust_is_available: add check for `bindgen` invocation
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nicolas Schier <nicolas@fjasle.eu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Alexandru Radovici <msg4alex@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 12, 2023 at 5:35 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> I meant this:
>
> if ! bindgen_libclang_output=$(LC_ALL=C "$BINDGEN" $(dirname
> $0)/rust_is_available_bindgen_libclang.h 2>&1 >/dev/null); then
>        [snip]
> fi
>
> (">/dev/null" was lost in the previous email)

I used the error code in the message below. I am happy either way.

Cheers,
Miguel
