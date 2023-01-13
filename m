Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6EE627
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 23:13:06 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id c124so24129110ybb.13
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 15:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jcttPvIOqjLZM9F4gnEg1fZ9duaMxSmsJ9dAT4eVMto=;
        b=fsQRQYaY5XCcHXaWXRuTKkkyaOlhbgd5f9J9NehHJt1yDL6jWOLYtP00oTRQM8X+EV
         PzZ6b4gUaeBWZxDXhZMhuoJ3vCgOeOE6bDFdzqZR3KtOec9HxcSj0PNS0HwqXuitKp8c
         4kKB4jD6svKgKQTIfr6q0I8SLgfQUWYjy0kovaXnuIulrJ2r5AQNed402wSVDtZjqCCY
         sxtDD+P5whbyeTs7N5+4xrykU1o9ZVG8tNmjvtebpKted2crhPWLNXxKC4nzt8epMRDP
         bGraUhX3drBGhmKqjmhnUtLH53UboTzKhyjma5AAYJjiOBwEO/bgrzl24YM0vy+Ck0vT
         hppg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jcttPvIOqjLZM9F4gnEg1fZ9duaMxSmsJ9dAT4eVMto=;
        b=c7HbEWUHi3FfVegqJ/998VKUeMd0ZhEtpRrrwrHouzo09U4kUGs5rviv8vjEUKXHSK
         nfNugv/1BmsuDN9HxD6mnfaD/CYg2wocfoMcUfGic7OfvjHHlrmULo5q6KH68gm/o8S1
         8/Vp6kNXZbJr+P+oOxpnYgjYvfd8vArnebbJ70e0JLJEQMcBw8f7zKTVbYatfwcm04Jy
         o/nA+upB47e0CBdKJ4rnduMt9AZ5QY1avQxRRXQB5ycpE9gdPDRi9sEeAVgALjgX+eF3
         8hpz8bWDPPYl3rFeCCUQZ0wmcgXrDZtdSaGREtcG1kdMfx0gQM5Y5IywC6dI9lxoGkw8
         chfQ==
X-Gm-Message-State: AFqh2krBhuLydBGittIEdnvnEkEshDvKc2e9SICyplQQnzVALFRFXqPN
	XiDocwEla7RWh1SqtZP2GBaKJL6Au95zSQMUO7s=
X-Google-Smtp-Source: AMrXdXvcg7dpfZwB3s0fAR3OY5o+zrWc7k7fTH4cyRXkF3jJzahtcGpoV1NtYkEOEmH6NAnM5wRTgZkTcEqdootpCXw=
X-Received: by 2002:a25:e6c7:0:b0:7cb:dfbe:3996 with SMTP id
 d190-20020a25e6c7000000b007cbdfbe3996mr615970ybh.489.1673651585333; Fri, 13
 Jan 2023 15:13:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109204520.539080-1-ojeda@kernel.org> <20230109204520.539080-5-ojeda@kernel.org>
 <CAK7LNAQj_WykFWcrj=L3wJYxDhOCGs+JHPB4E2vzWcx8y_at0w@mail.gmail.com>
In-Reply-To: <CAK7LNAQj_WykFWcrj=L3wJYxDhOCGs+JHPB4E2vzWcx8y_at0w@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 14 Jan 2023 00:12:54 +0100
Message-ID: <CANiq72=MsV8EXV9cib+GJd0AXbpF8YSGdDd723m7=ON4jhjXxQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] kbuild: rust_is_available: fix confusion when a
 version appears in the path
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nicolas Schier <nicolas@fjasle.eu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 12, 2023 at 6:32 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> +set -- ${bindgen_libclang_output#**clang version}
> +bindgen_libclang_cversion=$(get_canonical_version $1)
>  bindgen_libclang_min_version=$($min_tool_version llvm)
> -bindgen_libclang_cversion=$(get_canonical_version $bindgen_libclang_version)

Nice trick :) To be honest, I am not really fond of `set`, and in this
case it means the command is not symmetric (we remove the prefix using
parameter expansion, and the suffix via positional argument
selection), but if you prefer it that way, I think it would be fine.

However, why the double asterisk? One already matches any string,
including spaces, no?

Cheers,
Miguel
