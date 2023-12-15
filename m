Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5425F2555C
	for <patches@lists.linux.dev>; Fri, 15 Dec 2023 10:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="saWlSHk+"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-4b2eccce4dcso183996e0c.2
        for <patches@lists.linux.dev>; Fri, 15 Dec 2023 02:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702636439; x=1703241239; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QUVhEwhGG5R6yJfLzMvql4u7DQlTyWt51m5KiZQOx4k=;
        b=saWlSHk+sWsQs8BEIAlWSTxjnYP4ahTZop9vtbLXgMY+mbfYBZUxU2K6eiOZhaJdOm
         CA2xRadSMhpQ3FSQ6InxXMVQI0TjNRFFpdp2/uRpPQ3Hs9++7tlog3t4ULWqVydh6Etk
         oSmtRoYRM5OYpExm3phzro6r4pEXm8nY9/p57ukME6g/O0Jh9I83LwTek0DkrVrO63tc
         UyYq+uDyQUsDu0yhJhK6mlAObNBZCKAKd2i/XjgycVWGbNegTvdkimCcSeZcmuggcfid
         BUQFGnHZ7L/h5zSeQz8biL1S7aL7jhF3J+nA/qXuEH0piDDLmNGG7Lx/AKbMmdvrrpmT
         qYdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702636439; x=1703241239;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QUVhEwhGG5R6yJfLzMvql4u7DQlTyWt51m5KiZQOx4k=;
        b=AEMi6ojsNd5BAdrs6lYrODqBDaNuTqfUnHOiEvENE1VaY/2sBtp0gweGn6p7wAEWYu
         brGB0SOA7ppqVN8vrk0+hWQEDxgTyGCLBLotDHRoVtbLeKZYIpmjhbSER1PMC5MnZNsq
         HCIXCfxWn+7De3oUKcrBwpkUuDrxRa6IXWWhX5iO/Vs3q4+EF9T/5UUNlSdY/KmFZeMi
         U/cZMIJZO+d+8StJG1zopfT2qL1v74/EHsJTBR2P3HJaBE90N4cqW2ECDSTmGmgKcVks
         TQ9buBCXdI+U95gQ3kIDGYOuJQvHE8NLuWzuPv8403K682SWW4rZ6X43izdp1CrpM0X3
         29Hw==
X-Gm-Message-State: AOJu0YzmZQavmUd6+n0Qm3dStvzIwrjyNMdxZwmCzdJ5nI416NGUQw3F
	0czSnu2pkRHd89dKo1Ojh8BDe4VXBHPDviiObTR48Q==
X-Google-Smtp-Source: AGHT+IE5lEPjohScF8M2+o9L0ZurkGWcYGEHMF7ggwPClq4fWZTrD4KlogJkKTQ78bQH/IAIKHZqCt2tU/dbAqnvSDQ=
X-Received: by 2002:ac5:c38f:0:b0:4b2:956e:f651 with SMTP id
 s15-20020ac5c38f000000b004b2956ef651mr6658491vkk.0.1702636439100; Fri, 15 Dec
 2023 02:33:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231214222253.116734-1-ojeda@kernel.org>
In-Reply-To: <20231214222253.116734-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Fri, 15 Dec 2023 11:33:48 +0100
Message-ID: <CAH5fLgjPznV1pjaxoXovnfwSBOv6sKZc3G_MwfELbmwH0-Xf8Q@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust: add `rustupoverride` target
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Nicolas Schier <nicolas@fjasle.eu>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	linux-kbuild@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 14, 2023 at 11:23=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> When setting up the Rust support via `rustup`, one may use an override
> in order to select the right version of the Rust toolchain.
>
> The current instructions at Documentation/rust/quick-start.rst assume
> one is using an in-tree kernel build (i.e. no `O=3D`) [1]. We would like
> to provide also the way to do so for `O=3D` builds, but ideally in a way
> that keeps the one-liner copy-pastable and without duplication [2].
>
> Thus provide a new Make target, `rustupoverride`, that sets it up for
> the user given their build options/variables.
>
> Link: https://lore.kernel.org/rust-for-linux/20231207084846.faset66xzuoyv=
dlg@vireshk-i7/ [1]
> Link: https://lore.kernel.org/rust-for-linux/CANiq72=3Dmvca8PXoxwzSao+QFb=
AHDCecSKCDtV+ffd+YgZNFaww@mail.gmail.com/ [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
