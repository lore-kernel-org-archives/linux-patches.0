Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9173398B
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 04:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727584836; cv=none; b=NTw9SIP3N8ksR+jWIMIkr6eIwQa+pDaaZES9p+223yS19cjTH9cfUAzwKAkQsDL5nh/OJG1MiUo9BmG3vSKPqHyOhgFeIn0iV8n2AwSpA7h7F6pCEit83zYfUnNrWr3hPY7D2Zkl/gS1qmCv/36WFKkIR+eQPc7VO0NqCkCgO3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727584836; c=relaxed/simple;
	bh=gEGnP0STUu3Lpzltu3JSxCW2N1DRULTC36U1Qhm75Lg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=czos33x7fWp62+OrDySclarzqDODwAnz8Hjbx3+OHGb2a6enHrUe8ewRVEeVqtdNYvYquAxdzxXBce4Sgv8rZPMFQM8KdQfUQt2FwYmksv1FAF4ZhOXbEwAyTt3BaxozhtLau8gxEHjJrJPhViVw7vyYOIgxiaO140GWpS4UcTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=W8DaIfpI; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="W8DaIfpI"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e24985919c8so3348428276.1
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 21:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1727584833; x=1728189633; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VV2YxyLVgm/A21lFnrbUS0xzE5yvl49iPMLTKyEnGNo=;
        b=W8DaIfpIBsHjf+7B8aVzXTlpkOZT1dxGt+CHXV+f43/MbuIdsVo67e08d/naIAT74y
         O4+uZEgXyqYkz7RUOXAxH2AD9tyeod5YbyhTutNr34Jc/KW0CnHkRxqgFvZnOjphseE5
         A/0bU/+H4QiGZT5jUZNM5SsZAwOF4pUfVP2quc7MZyTGsFGcgaOzD8jMZL5UOOQE85cw
         c3LQsYDSksPVv1ODISrfQkrHiEZ5+y4dCD4eQeEU4vrBalm4SsHQ8OrKIB2uwgrRmQgB
         HoggbcLPQnhL86TDlwbHaIkrHca5B81rNY8y3OUy10in+duqi2bcFz0Mbrb4yM1Zsydj
         u68g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727584833; x=1728189633;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VV2YxyLVgm/A21lFnrbUS0xzE5yvl49iPMLTKyEnGNo=;
        b=Rdqy3G+4E13DF54UTHvEVcGkoq2X00D68PGgg+vWPyL9b9391LbHWgIg6TdHtA5Mza
         q7zTGF1EZT/Eqf2h3+igR/wNeRWNkzVMrdl3fQ2qxOoThjijutkVXPGAPedRxnzUeA3D
         IHgPtRUWhpbkTOsg7MC1hpJ6A/H7xHK2Q2uy0uOQCR/qw0qY+gRIsMvzpz8nM3fLgPgc
         Xi26gA8O8e7y9m4FXEcTYRap36mbLEgkJ9LasdPVaOmKQtqyTdJ0nMCedzGMYpkrOk0G
         /DengAZ6/BOr/xukHwJy/vSmITpO9CEKdlCQCdt2wbJbzTsyKZd34Y3D4bA5Jdo3rpVv
         ce7A==
X-Forwarded-Encrypted: i=1; AJvYcCVVdIN1NhTKrr+lDPnMwCw8H0xv8i9alWd+qSU1giJUBX8J5v55IFo5Fi4BdwVGybd1QdRNBy6U@lists.linux.dev
X-Gm-Message-State: AOJu0Yzu1VaDzwiJVAZjztMtKtGKLbVLDtOu2AibyIW+U5378gkvUXEu
	3gnkJzsXvn9DlSOB0bbjxrYxMb2IDN+ZClUlXnoyfE2geOW2NB25h2vtd04f1VAHfbaSgoINr5h
	n23Kx2ihxxYW3GLxXzZ8zvmfRSxORqBt5v1FHfQ==
X-Google-Smtp-Source: AGHT+IE4B4r6X5b8t4Dk7RmIMj8MQORtpJ9++eFIxvMdYYJl/soJ9aCmoTuPzU+LqekFU43oyGbJtCB5UAMgPSvpC74=
X-Received: by 2002:a05:6902:2493:b0:e25:d0c9:b0c6 with SMTP id
 3f1490d57ef6-e2604b5f2bemr5869513276.11.1727584833057; Sat, 28 Sep 2024
 21:40:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-9-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-9-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Sun, 29 Sep 2024 00:40:22 -0400
Message-ID: <CALNs47uC43vixDMt935BB-fuDJEKFE-SPFmSQp4Nt3v+O9wfbQ@mail.gmail.com>
Subject: Re: [PATCH 08/19] rust: enable `rustdoc::unescaped_backticks` lint
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 4:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> In Rust 1.71.0, `rustdoc` added the `unescaped_backticks` lint, which
> detects what are typically typos in Markdown formatting regarding inline
> code [1], e.g. from the Rust standard library:
>
>     /// ... to `deref`/`deref_mut`` must ...
>
>     /// ... use [`from_mut`]`. Specifically, ...
>
> It does not seem to have almost any false positives, from the experience
> of enabling it in the Rust standard library [2], which will be checked
> starting with Rust 1.82.0. The maintainers also confirmed it is ready
> to be used.
>
> Thus enable it.
>
> Link: https://doc.rust-lang.org/rustdoc/lints.html#unescaped_backticks [1=
]
> Link: https://github.com/rust-lang/rust/pull/128307 [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Trevor Gross <tmgross@umich.edu>

> +# Starting with Rust 1.82.0, skipping `-Wrustdoc::unescaped_backticks` s=
hould
> +# not be needed -- see https://github.com/rust-lang/rust/pull/128307.
> +rustdoc-core: private skip_flags =3D -Wrustdoc::unescaped_backticks

Maybe we should use something like FIXME(msrv) so things like this are
easy to find?
