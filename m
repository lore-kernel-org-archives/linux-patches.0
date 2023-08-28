Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B20F125CF
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 13:17:20 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-d7830c5b20aso4053291276.0
        for <patches@lists.linux.dev>; Mon, 28 Aug 2023 06:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693228640; x=1693833440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MGYTgGJyz9hK6P1W5cYWJ37ojkoun6scwiaYLpf40GM=;
        b=PDCzEuB4+vOFbmlh9WJaVjW8tsiEFTj81FSUQotQQVuJyuddJBEM6FCZABer6pd7gz
         qZP9Jjhj7qU+ei9c6IIh1aVkpKKiXLZxr1qnGL9qczFSYStHkCYvpRv8JTnM7UF/705j
         gOpAC2ZDoVUm2R4RV/xkBw/VcwedpwWOiBS6k37BLE3C9ihOwrn0uCEGaiGE2ug+0LKa
         uO5mhSGt4DE13AGsazbGDfCsya1jdMG5KrKt+5b5Am4HsMtGpn5A+/YztZfQo+gBQzJE
         lVP0EqmMGzwE9nyUKvlROzTt1GMY0rNpAs8fTnre9C8bq5H19nk0OZBW1ZfKwSK74dkO
         g8BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693228640; x=1693833440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MGYTgGJyz9hK6P1W5cYWJ37ojkoun6scwiaYLpf40GM=;
        b=EZ1PEzo6PGv2rqo2E+w1wI9++9WVNyCcx0Ym90J/YkpuZ8hkOXjngr979nGZIRkhIy
         mptG2X9apbtEd74KcIr5R5aUFoK3Sw63mflvKkIgZXzvcRdpxvMyH/GiB58uhLjuhbjq
         Y4AeG36eh7DdJ1H5j2bRRaJLe7ve2I6+3ljtSD9b9m+Ipbr9yvFbK/1rWNpmCtfOjWg7
         34VHnAgp9fv1H+VBwbC4AyAC9Qv1pduL8b02tP9FlSOE/oRCQVW3HLDJyWrWqq9NgfIJ
         wqzeI6aeeUCOpWxjbaw9hGh2auwefmSyM/zUcKk+9LPIZIIPeZDphzgw+0FGQzG1KFT1
         2M7g==
X-Gm-Message-State: AOJu0Yz3br5W4PLtNckQQ56n/oqMDf8LR4B0RMs+Zu+62/nH2QFO114t
	eJL4b5oZUOoCIMjFli+Bbryht3oA0dvgWyHHKP6UNQ==
X-Google-Smtp-Source: AGHT+IF472zwt+zJU5bvh6KBEPeZ/osWrL9kS5Td1S0IJH6vipNayQJ/MzpTXVzXkB4GiGqUispoj9X4m11CdMwjvSY=
X-Received: by 2002:a25:27c5:0:b0:d66:9fcb:1fc1 with SMTP id
 n188-20020a2527c5000000b00d669fcb1fc1mr22835256ybn.24.1693228639796; Mon, 28
 Aug 2023 06:17:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230823160244.188033-1-ojeda@kernel.org> <20230823160244.188033-3-ojeda@kernel.org>
In-Reply-To: <20230823160244.188033-3-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 28 Aug 2023 15:17:08 +0200
Message-ID: <CAH5fLgjDf9VP4BWp9zX1iv9KiUhA6y+p2Cp2L6-3mR=KS_ExDQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] rust: upgrade to Rust 1.72.0
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Jonathan Corbet <corbet@lwn.net>, workflows@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 23, 2023 at 6:03=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
> This is the second upgrade to the Rust toolchain, from 1.71.1 to 1.72.0
> (i.e. the latest) [1].
>
> See the upgrade policy [2] and the comments on the first upgrade in
> commit 3ed03f4da06e ("rust: upgrade to Rust 1.68.2").
>
> [...]
>
> Link: https://github.com/rust-lang/rust/blob/stable/RELEASES.md#version-1=
720-2023-08-24 [1]
> Link: https://rust-for-linux.com/rust-version-policy [2]
> Link: https://github.com/Rust-for-Linux/linux/issues/2 [3]
> Closes: https://github.com/Rust-for-Linux/linux/issues/1012 [4]
> Link: https://github.com/rust-lang/rust/pull/112403 [5]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
