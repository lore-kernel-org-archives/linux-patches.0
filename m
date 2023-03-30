Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9EB1854
	for <patches@lists.linux.dev>; Thu, 30 Mar 2023 04:13:43 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id e65so21952393ybh.10
        for <patches@lists.linux.dev>; Wed, 29 Mar 2023 21:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680149622;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KJJx5iancqfU2xP6aCcU6aFC/gwsLXj0cw8Dg1r4APw=;
        b=qD2R+eHRuovgMaImQFjOnZhrTXDoFRtXFpQ4Bs/vlHCbI0U5sYPKI9KCxSHdB12zUb
         ddj+zmouaWz/vCth+2gz8b1HR1p1GJa/omGuk9rNUv4t0P1VIew7udHJjzo9FGCtGhHg
         kGfW/CfHYMPjCeSHtfrfKgUFFtqdyHgWsvFq+B2N5IVHEd2d5RWScb8KGeNLXbH+5abv
         VyAl8VvHWj+PHHadPWqaGzuWnyyQwO0wMdr1FhDkP8TRNC+2MFnXZ6YCTUWL+5Ad+Ada
         mc7tXp+sRbs10uFt7fYrQIYLmVSR27/Jb1ie1e1Szw+QLNvZWkztv2yzmnUkHb5SfZJs
         ln0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680149622;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KJJx5iancqfU2xP6aCcU6aFC/gwsLXj0cw8Dg1r4APw=;
        b=cn94RRNFGkjnjbyBTMw5ty+wxnAnZYgseml8ThK6sjg8tlfWEJ4CUHI1qv8Z0xU7Ca
         NZ0Qy0ztoDy2sbJFMs5u6TVXeHhxOQ2cPAMq8G97VdkCFnvvQHW+Zn3HV4d/CjdIS+IW
         As4sN5WWI3iE91lGBgCF9rJAj85DNx0E6UCPZP7wlyuRrElsi6jWJgI9lp44xOLa7fVI
         tE6f5MffTz3yH44mnNQDk5AA9hol+RhnlFSzYpVQurZb6Cs0YOsMJxQzQ1IlOQ628sTA
         SbPnPF1daeKONGgDsiUg+Ce3+73xP2CB/4T1+fDLw70Z73EggkgA76R9hI2WoBkJzxpG
         YcTw==
X-Gm-Message-State: AAQBX9f4lGP34vSyKm8kgug53O1k8XkvZJya4PfGbE1cDWxKnxbrFVTT
	g/+KPNiSTjDAt9MlLZi1kpHQsbEYb0V0MCtDXTk=
X-Google-Smtp-Source: AKy350YVT/flqSFBvFxTZR2FoNaRxvExziTKKNo8YLQm0TU2WQWj4bq5x2eOF38rCggnH11dWohhHNjx5L9VarDX89k=
X-Received: by 2002:a25:2d7:0:b0:997:c919:4484 with SMTP id
 206-20020a2502d7000000b00997c9194484mr11425853ybc.6.1680149622452; Wed, 29
 Mar 2023 21:13:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230329223239.138757-1-y86-dev@protonmail.com> <20230329223239.138757-3-y86-dev@protonmail.com>
In-Reply-To: <20230329223239.138757-3-y86-dev@protonmail.com>
From: Wedson Almeida Filho <wedsonaf@gmail.com>
Date: Thu, 30 Mar 2023 01:13:31 -0300
Message-ID: <CANeycqprth29MGQsAYHkQKAoCBr_C0J010VTvs1YK-Yg+pY+0Q@mail.gmail.com>
Subject: Re: [PATCH v3 02/13] rust: sync: add `assume_init` to `UniqueArc`
To: y86-dev@protonmail.com
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Alice Ryhl <alice@ryhl.io>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, 29 Mar 2023 at 19:33, <y86-dev@protonmail.com> wrote:
>
> From: Benno Lossin <y86-dev@protonmail.com>
>
> Adds the `assume_init` function to `UniqueArc<MaybeUninit<T>>` that
> unsafely assumes the value to be initialized and yields a value of type
> `UniqueArc<T>`. This function is used when manually initializing the
> pointee of an `UniqueArc`.
>
> Signed-off-by: Benno Lossin <y86-dev@protonmail.com>

Reviewed-by: Wedson Almeida Filho <walmeida@microsoft.com>
