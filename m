Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDB739865
	for <patches@lists.linux.dev>; Wed, 18 Oct 2023 22:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FFWTF1hN"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-5a7a80a96dbso1866507b3.0
        for <patches@lists.linux.dev>; Wed, 18 Oct 2023 15:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697669848; x=1698274648; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AE1SaR/BHQxenJ33mN0ItySiN6Ep+fGPSaWs9qSQa2Q=;
        b=FFWTF1hNMMuuQ0opAdMgqW/VthtVt3an9rbNl8FuTlYpcp4NaBe6lKW6kBAT5QVuB1
         76xb1homBLA7Zk2F9Avd0pqIZFq5acrBGSzUq8K8ubUZCL3L96BTDEbH8GXJonRKUSnX
         Vb1AwxFDe1UAxxWW/x9HOTjP2ZGeidWYgDwAtd7BBltwr00QbpW8zO9YiFmq0gyWmUhL
         azWVbe3eUCjh92qM321u/Q8Xr1peBFmABINIaInyWkNdzHiBdsm8xmtGyfruauPpFFbd
         2oFV+Ea0NMH2KC3m1ijnWgg0XjQVOggnT7R2ObGv8G7B7l5nwUnPuu6AFcSwgNxhJ6ZP
         RsCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697669848; x=1698274648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AE1SaR/BHQxenJ33mN0ItySiN6Ep+fGPSaWs9qSQa2Q=;
        b=ny7WrYOFwZ5049jm0kdiybFc1dWdQGE8Iimh4vlig1ugRVqPPVIgm+fb4NYelqo3D4
         tI0QzQzV13mvsV79Z8KraJqsqHKKkl/RnAhZTkoyxqGntOi+RLu95XsbbjQOQ42TSHEP
         uC1M1qnPoI64CnPig9YOiZD8dqX0wgCoaCh2ZsTMhrt1nxuKHjPLmdOewrlQLRw2Nnle
         e3fpBwErv3XNI7gUOqfnLv1wH00019mcilV8RZL+kC1Ghy4izpTIWvZLMYafvWx25Mkc
         4DoahAeyL3pyD8ijhUNov+7M4HtP3q4TQo8r4lzXDGfWSZ9Znz/i4UhX5d/pCJOdQYwN
         KdOA==
X-Gm-Message-State: AOJu0YwH/lS64jGuqeILL9jkjhZy4tv9Aek5TRDJKbEwLi5IF4Dy07lk
	y/S/e4D0xq55V+/Db7rPKCPrRu+Mx0R0EAgF/nk=
X-Google-Smtp-Source: AGHT+IEhExAjJ/kqU13bH/iu+1hTB73pJsYiyEBFRfajbn0eLIbp0DQbJge+BtAiBbYc9eQEJDm8R0y65x2ghEM15FE=
X-Received: by 2002:a0d:eb4b:0:b0:5a7:c887:43bd with SMTP id
 u72-20020a0deb4b000000b005a7c88743bdmr182981ywe.15.1697669847838; Wed, 18 Oct
 2023 15:57:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231018160145.1017340-1-ojeda@kernel.org>
In-Reply-To: <20231018160145.1017340-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 19 Oct 2023 00:57:16 +0200
Message-ID: <CANiq72=_jGC1YR+9jHxYn9w68iZoC9sHoXdXqGu6qGxzriEkwA@mail.gmail.com>
Subject: Re: [PATCH 1/2] docs: rust: update Rust docs output path
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Carlos Bilbao <carlos.bilbao@amd.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kbuild@vger.kernel.org, 
	linux-doc@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Akira Yokosawa <akiyks@gmail.com>, Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 18, 2023 at 6:02=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> The Rust code documentation output path moved from `rust/doc` to
> `Documentation/output/rust/rustdoc`, thus update the old reference.
>
> Fixes: 48fadf440075 ("docs: Move rustdoc output, cross-reference it")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-fixes` early to start getting some time in
`linux-next` -- please feel free to send more reviews, thanks!

Cheers,
Miguel
