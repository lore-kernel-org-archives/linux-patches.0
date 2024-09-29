Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6D5184D
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 04:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727585530; cv=none; b=YPh/Mdx2LN46JT0tQN2o655GLj+tk/3EUYbCHesUPmvAV5TTlxRm0gLXMTOGicmifDyfRgnhswAb3uTTKkXrTP8UimBzdwb23+5oohKQ9ntF+pDVCKSsecg+gXIHsPlzDXqFqUM6IftiqscuDd3n3BFaAWxs0MumCftY39kg7po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727585530; c=relaxed/simple;
	bh=jS0EBvC7XMwFo9M+zQPcxKM1gJbWMDlWI+8/9TQt4Hg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T8a7mEy+YWZrq4pPYFQNUKQZ4wHhEzTOjfBRap0jAcCOwQEDNNhy152jYvwyH/6fGVFCrO5K+VozEie02qLi6icnCeBHCJ7DpSVaD5hpZzOvBBLT8vMHOLVHYbmG3aTffOfufaGiflQP9xDeUQ0Zh9TBxoPDQSljzzYWORi2g2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=j7he+2pc; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="j7he+2pc"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-6e2598a0070so7357397b3.1
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 21:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1727585528; x=1728190328; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jS0EBvC7XMwFo9M+zQPcxKM1gJbWMDlWI+8/9TQt4Hg=;
        b=j7he+2pcCxLkQkYFeQ1VWmjrtbwt69dRE7wwJ+CHc6nVvVooqHKayiZzfDYdqk3ZPd
         598GvS3pbN6wBjEteMHaUq6cJMW0ncZwmx/OVUvGgpzitW/B7QYBjSm5MLhibIJqmH2m
         gfRNI3xpI8lDMH02IqlyyvKgbYz1tsyPuiSMR5DZzeDbk7fExocz6e56dNgBti2PeWdn
         BvMtHlo7lhyLkNc5Z/EfgL8Ghk85kFzMAX8rz1EOyVpgc+p/Ob4PdUoXOpc+5uU9V5Ma
         gWfHaIJrkNY1Xwn+3XtMOnJgwLXf7nTT15nMH1zDkvzKgf1rLr2m/Fyet1r4Ggklcou2
         lQFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727585528; x=1728190328;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jS0EBvC7XMwFo9M+zQPcxKM1gJbWMDlWI+8/9TQt4Hg=;
        b=dfnGlp2g4wcQTgTXAXOV4gI30yG66/GjqpxAxvOYDfpdkfnJO2bhBcxttNteGYDv8k
         oQXB+dNbtwk0vWOt53Exy/8E6dR0DnG+Ku89G0oFszzysD+iYF71Yp0QFFgPOSMKfWIN
         /ry6eE72NGvXxjLtDwzfY5rchQ9SppSmCIBc1WpxF8PytlaoahHY4wRz41lscRWgVhkh
         LMfTLnjUG0gNRu99WaAD2moARpBZ8/ff8stwtRr7UGw7KAVcqMBvv6rTTEGiF+FqQcCK
         HnVd7YNPQwJLp3vHyI5Q2hMIV6jGatUlnnFPosYT1tkIA0jGwqUNPUvbYxUUCJ4DnyDz
         3sbQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwG2uoUN1Cv0Tb6phjUntPAQRYXS3YnPZnXqm1nUCUHt4ZUc0SU8L0ktgCSMTzHw8XXhbdiOP6@lists.linux.dev
X-Gm-Message-State: AOJu0Ywu3Mc9ABiU8l6QTMlE6DGZMo9SGYjLlsci3cI8R2gWn7tnYmlx
	GXU3bUmb1kUkIdzh+p2xTitqdfLKjpraktC6FEH+JZgvVbsBuW4hU8J7eAlIvOtrRnRFSiS0YAB
	9snHCovtrQzcynBO7eeU7I46nYv8Eim8WV4h3XQ==
X-Google-Smtp-Source: AGHT+IHMo7X9/akLsAQal83FgKc+F7pvFVjQlHUFGrQQNk51EFPSY353VuXd0b6yO+OVBgyvQdIsjKfkuOP6FlzPnEo=
X-Received: by 2002:a05:690c:4787:b0:6d4:b774:e503 with SMTP id
 00721157ae682-6e247603ea2mr46816127b3.41.1727585527889; Sat, 28 Sep 2024
 21:52:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-14-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-14-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Sun, 29 Sep 2024 00:51:57 -0400
Message-ID: <CALNs47uHcW3fSfE1nvfy_m=J5H51S_B5CvWK1HsK0FDKW=bdww@mail.gmail.com>
Subject: Re: [PATCH 13/19] rust: rbtree: fix `SAFETY` comments that should be
 `# Safety` sections
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
> The tag `SAFETY` is used for safety comments, i.e. `// SAFETY`, while a
> `Safety` section is used for safety preconditions in code documentation,
> i.e. `/// # Safety`.
>
> Fix the three instances recently added in `rbtree` that Clippy would
> have normally caught in a public item, so that we can enable checking
> of private items in the next commit.
>
> Fixes: 98c14e40e07a ("rust: rbtree: add cursor")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Trevor Gross <tmgross@umich.edu>
