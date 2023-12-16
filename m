Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0B04A28
	for <patches@lists.linux.dev>; Sat, 16 Dec 2023 00:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T9c3HEQZ"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-da7ea62e76cso1114508276.3
        for <patches@lists.linux.dev>; Fri, 15 Dec 2023 16:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702684956; x=1703289756; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HUP3bpCvVKirlUHMbPP+Vvn/KkPpGHwcdqXev2j/lBA=;
        b=T9c3HEQZOQ9U9vHMbweNzGPsQHKbRmyNrJtWYvOHH1dZkI75JtRLS76KCT+CwfFP0H
         o+ktW5BmEYgtFqAh390CQNCVqR6r1KhtI/dBxOOb5/7qI2/R5YWXxYdQsKkmjrF7FiW6
         d/Cq1y60sEKH1JbGg1v3o5k1pEj8/ugiwXz8Ls1RFekl2YhcyC35wowyFxJdwfkts4c0
         cTiSVR352LfdaGbZe50S4uDn9fpO0mgFq5guPPriOFsygc+rFxrLR99Uk2ZSfSypWFTh
         clX2/asHTy++UI1gbCDfs1xCTB627nJr7jrB3TH+T+X9n9eKVbALB2SErF9R0zYOf0Im
         +X2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702684956; x=1703289756;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HUP3bpCvVKirlUHMbPP+Vvn/KkPpGHwcdqXev2j/lBA=;
        b=NLv9ohAMwOgx2I73lCTzrnSydMEvIJTAq1rrDSflA4ZYpejUIrzUo/NWcHYTj/Dk+9
         adb0+jRGu9bLlZIuTCA/pjKqPTdjq62Dk6fIgcG+6cnIX9Wa1JrmOZ+Ry/a+FMdBdVUY
         2pB0xQIVZ0g6EUdQZSl6M0kM/o2fwOCUYH7Z7pdZ4od8c5mYTmW2vtNUK8Q6de+0sjts
         CzpIvA8fP/9f+nvN9H1cn7ybEuNZLEJeJ5WWcD12XGZkpPEUQM2OYyEzWVc7rRUodBC9
         f8QyLtgHnLZ5rpuvcMnIeZn/Pu5FIbuk0R8DSvH3uOUY31jZ0YmsYufAOax2O7BPIci+
         ogBg==
X-Gm-Message-State: AOJu0YyeWkX+0igsPXAFevHbrlUrhVou9pPbsKMjEeAHN+HH8EgdrupS
	plgMBFL8/KYgIf7pPBdLFaDgp8KkVO6LBJdGzlY=
X-Google-Smtp-Source: AGHT+IGvPfH0mpoBG1iug8UwmNxFRI3F59+AybxidcQnROd3JXcSiY/aigPxSIwnvGkPkOjXOxZBO+SEVyrpS16B2bw=
X-Received: by 2002:a25:dcd1:0:b0:dbc:e53f:8705 with SMTP id
 y200-20020a25dcd1000000b00dbce53f8705mr2535065ybe.81.1702684955826; Fri, 15
 Dec 2023 16:02:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231215235428.243211-1-ojeda@kernel.org>
In-Reply-To: <20231215235428.243211-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 16 Dec 2023 01:02:24 +0100
Message-ID: <CANiq72mvspvQ_0Mr6TAw55sa_GUM6FRSYb_1JU67hwT+PzLZkg@mail.gmail.com>
Subject: Re: [PATCH] rust: support `srctree`-relative links
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 16, 2023 at 12:54=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Instead, provide support for `srctree`-relative links, e.g.:

If we decide to go this way, then I plan to send this to stable later on.

Cheers,
Miguel
