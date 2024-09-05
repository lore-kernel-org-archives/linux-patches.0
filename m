Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CD61946CC
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 08:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725524084; cv=none; b=YESPHRLt8pU/rCxHOREEZIF2M9cdkqXhY5f2jgoQec80iwadWeDrDQP4xRv5/YRME9p7N4dmgdybe+NQn7nrK8A7ZKLdYz5a/cy7Ec09Z//cd53+fC0afeKHsrDx9y4sccvfqd+ZdpnxMkTFBfxekhRyKJNGBgPy/AAjGjN41XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725524084; c=relaxed/simple;
	bh=4Z7ZM2Zqsf7stqQxw1qBOI8mLWWVIXA0qh6UQvkxfis=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cjwRwD19/Ng2EHPvXiDxmvjH8xoVdINtJVWTC2SSXkP6ZtXGoPoSiuSGgIhw08ElvQzQoP0mZA3unPvnei/XpE28Yg2x+6Psi4817ueZo8IaOUGscf0UeaBLZVCuT/c0S7T3oyF9ysGbTknH6p7TAMJ+PTG4DDCwVLB8qi5FSQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hO2s+ulk; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hO2s+ulk"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-428e0d184b4so3190335e9.2
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 01:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725524081; x=1726128881; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Z7ZM2Zqsf7stqQxw1qBOI8mLWWVIXA0qh6UQvkxfis=;
        b=hO2s+ulkTiWTMxkwTo580QlPLMpJwkQqa4+z9T1YkedhlMFWRWV7YX/fQkH+W7mJm0
         MgrxaDY7Xx/dGlbaAf4VrAjJ9heI/fCNUSgWLmPjGXk/X1g8eKirBSD++JFm+ZMIS4hX
         tKTWyoq6ipJ51UpMA6OYd+a8rzXK7UT80PiktqQALWbrUc3MZLnrq260QuPLb2vY9xD/
         4CP2vxKELwiHRQtWnK9sh7UJ/IPjjQCBKQ+9HEnYPteMNtyZl5S5XSB/v5NXymDAIAhM
         Ns4zDv1or+AQqhbmg6hyC6bFZfcobRX5MISHONcs7px2LTnMYe2w7AHHPd1BczlNkRh0
         pTEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725524081; x=1726128881;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Z7ZM2Zqsf7stqQxw1qBOI8mLWWVIXA0qh6UQvkxfis=;
        b=k78TMtHktGLsktvrl0XxQ92oRLtHAqEh1FtllGPfVOpPHDluyueVz8RrccEyz1L2ny
         PyZuIbwgpIYtvyZhkBcf8MRbUdnno5yWYpBBogb64b4CyGq5iWRnXpU5TF+f/fHJ7Dm7
         MAyOYXbMylIDBHNBCWBUyaUnvUSC48kWM0ULeg/uXIU4vaCeDgJce8wYXR3wiwrFu+kU
         zIopYXKDLmRMqBV21mFgXtwzl5v7BwNscZqozcS6yVVXmgk/kbENQC78QYlbQL5/GRAD
         m7/E2xLS+/6tazB+2/4rYLb6QGxFLtXczhiUQb0mHLIIQUkk6HuoWaPuM8/mz0/khq2q
         f2zg==
X-Forwarded-Encrypted: i=1; AJvYcCWNtNwrRzPysQxuUkzkK+BEDBCn6GYmBjUMAybMaKYhXrPgSIGM18hwfkdcQXvSgeSOBCLWl3Aw@lists.linux.dev
X-Gm-Message-State: AOJu0YxeUPOZ2Ip/3V3Yv64ypuXVWNhIFOhJrajI4rBNziiBgMMcnK9v
	k/rBGh8KuAejgySH4ITS/JuBhukzzXgrZz8rLxEL5mh+X42Wavho5RnoUhdSFasiepPP9tvx9zM
	yroTQAG0+5P8XT8TMV6WGtusGIg/x07THDrT4
X-Google-Smtp-Source: AGHT+IFoFMEFG++KUV5iQ/Tyfkl/lsDMQem/o0J6AzcE+fLX1huKPxyQpwstvU5CcpYtGKJwWga2u5zlwmR9qabq4Js=
X-Received: by 2002:a05:600c:1c09:b0:423:791:f446 with SMTP id
 5b1f17b1804b1-42c7b59e335mr112875365e9.7.1725524080520; Thu, 05 Sep 2024
 01:14:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-16-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-16-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 5 Sep 2024 10:14:28 +0200
Message-ID: <CAH5fLgjnX1hF6OSJco5xce1Gmd0brSLKDbmotCPUmOXa4UChEQ@mail.gmail.com>
Subject: Re: [PATCH 15/19] rust: enable Clippy's `check-private-items`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 10:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> In Rust 1.76.0, Clippy added the `check-private-items` lint configuration
> option. When turned on (the default is off), it makes several lints
> check private items as well.
>
> In our case, it affects two lints we have enabled [1]:
> `missing_safety_doc` and `unnecessary_safety_doc`.
>
> It also seems to affect the new `too_long_first_doc_paragraph` lint [2],
> even though the documentation does not mention it.
>
> Thus allow the few instances remaining we currently hit and enable
> the lint.
>
> Link: https://doc.rust-lang.org/nightly/clippy/lint_configuration.html#ch=
eck-private-items [1]
> Link: https://rust-lang.github.io/rust-clippy/master/index.html#/too_long=
_first_doc_paragraph [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
