Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770E017D1
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 08:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aNZ3o8DT"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2bffa8578feso50984181fa.2
        for <patches@lists.linux.dev>; Mon, 09 Oct 2023 01:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696841301; x=1697446101; darn=lists.linux.dev;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mfyyjdb+T/gk0d+IVQlbaZvTKr0SSxvaZIsplnuemL0=;
        b=aNZ3o8DT5isrnbHUtIAEC/fYxe8z9Rq8FH8RGUAA2j4aq/dJGIwxhUO0D5oHepIGpR
         uyh/bflgGdZc/uPIzoJcLf75dRXEpj41DN9Hy6sxTny3I1Sm/Baf4jHNwRNl63wO//ZC
         8m4W22B8suVp7oPtZya3m1v1AAxWoexzUWBzZtljzgLsGeTcswU7EeOynncQqcQh3tHf
         NA0rELJffSK6f2wazQKrkhHEVFxxOG0GAYygUa5Kp6WglymCt9LT9ZqBnT5EGWjK7AVD
         1AkqN06kvr3jpT+JFqHEKTuEQ9XnpurMDYMzpBzIXN4Y0N0GcKP4BIWrOobEH91oVpSb
         16Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696841301; x=1697446101;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Mfyyjdb+T/gk0d+IVQlbaZvTKr0SSxvaZIsplnuemL0=;
        b=FVPOOAZBtQcIpicoAkZk8wfIqgBDK0qY5BoTcHy7mosMBc0pAguwnuI9zX+r/aVLGh
         OdJdtGHUPVK2RImlAkkajTAhOAfmfpBtzdQfpEus6x6fosbDd0cufWwcgfohe6U9QsG6
         i96lvvepmx48mDPbZWhLeVm2lDeZajC7MeqiHgCu36xOnZEnXc15hR2iKGIgx3/KGtmR
         Spt7HybkaTRugY4DtWLYyqfbIKS7HRRD17ZyXHfw+9KKDuW+5redJoqMHigw6jig7dbL
         F6BAwh9sC4Xn8hMCWvK0qi7pMyBzOH1jhMxkJPVCqsxnLrRV9/c1i/80zZHXGv8R+1FI
         XjGw==
X-Gm-Message-State: AOJu0Yz0gFkEkJL/BqVbiKtP208J4LS+cJO3fgEcHkokBgoNPXceRFj8
	ZtVyreefpEWj1xb3iJkY3OM=
X-Google-Smtp-Source: AGHT+IFiIewVzzvOrGx/jJGjRrf8IDuw/w9wHlqS8H1L3mU/KJICkmE371s7owG2drRYRK4Gcy6jcg==
X-Received: by 2002:a19:644a:0:b0:502:9a2c:f766 with SMTP id b10-20020a19644a000000b005029a2cf766mr11734198lfj.30.1696841301095;
        Mon, 09 Oct 2023 01:48:21 -0700 (PDT)
Received: from localhost ([146.70.182.19])
        by smtp.gmail.com with ESMTPSA id v24-20020ac25618000000b004fe36bae2d6sm1374671lfd.81.2023.10.09.01.48.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Oct 2023 01:48:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 09 Oct 2023 10:48:19 +0200
Message-Id: <CW3S1FL7JQ9K.3R5QL6NYCVBJ8@gmail.com>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Wedson Almeida Filho"
 <wedsonaf@gmail.com>, "Alex Gaynor" <alex.gaynor@gmail.com>
Cc: "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <benno.lossin@proton.me>, "Andreas Hindborg" <a.hindborg@samsung.com>,
 "Alice Ryhl" <aliceryhl@google.com>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 1/3] rust: task: remove redundant explicit link
From: "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
X-Mailer: aerc 0.15.2-211-g37d5fc691aff
References: <20231005210556.466856-1-ojeda@kernel.org>
 <20231005210556.466856-2-ojeda@kernel.org>
In-Reply-To: <20231005210556.466856-2-ojeda@kernel.org>

> Starting with Rust 1.73.0, `rustdoc` detects redundant explicit
> links with its new lint `redundant_explicit_links` [1]:
>
>     error: redundant explicit link target
>       --> rust/kernel/task.rs:85:21
>        |
>     85 |     /// [`current`](crate::current) macro because it is safe.
>        |          ---------  ^^^^^^^^^^^^^^ explicit target is redundant
>        |          |
>        |          because label contains path that resolves to same desti=
nation
>        |
>        =3D note: when a link's destination is not specified,
>                the label is used to resolve intra-doc links
>        =3D note: `-D rustdoc::redundant-explicit-links` implied by `-D wa=
rnings`
>     help: remove explicit link target
>        |
>     85 |     /// [`current`] macro because it is safe.
>
> In order to avoid the warning in the compiler upgrade commit,
> make it an intra-doc link as the tool suggests.
>
> Link: https://github.com/rust-lang/rust/pull/113167 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
