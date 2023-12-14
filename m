Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4873C473
	for <patches@lists.linux.dev>; Thu, 14 Dec 2023 11:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D8NhHHgf"
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-462e70f1c20so2442539137.0
        for <patches@lists.linux.dev>; Thu, 14 Dec 2023 03:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702553645; x=1703158445; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OVpZi9LWxDndkG/jKZcYbbE5b7b5vMwfJTUTNSHguf8=;
        b=D8NhHHgflDIyNSjwDJ9Z/eJdEn1V4aQIhD3W7ww4FefHGVILZnkO58Suy1npEfVj7F
         Ni/uqcjVl2k+w7++rW8UzHYczZ/SMTR48heEA0CXiflSNDaCEEy0pM5pg2WpbLfOKSmL
         hXEOtxFpv9dyyZt83m93+78ymEM5FP8plI+vNKppdvbxCMexFqxWcfz6Ah6rqLPvwt61
         hPDoFPkSc33QMNhjQYCACu5aFN/pEHsXK+9uTd3VmxO5saRcHiamXZj5Fyy/daB6v39H
         5cNNIjfuvDuSu0Eo7bXP/4rj3ou+NdbLviRpnVsaUYpEfLzG76nXzkY1+bBnLQ0uWDJs
         4d7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702553645; x=1703158445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OVpZi9LWxDndkG/jKZcYbbE5b7b5vMwfJTUTNSHguf8=;
        b=sQxKTZf8AndQAkjVn8UnNJ/bdf+N5UY4YuL/QxMuThTpPcTqrUnWobngVgPQ31MZXK
         khchw8Gf8pOtbRugzRWJjOBSx1NSiq552dcLrCu6gjQS3jiFgYT/JAvAR9JPSy517nSx
         397CO8piW6gnIsKWzagFRXgc5616yWDwLFjM7tUxTpliai9uK7tmF1CYV1xXgGJcV1gb
         sRK+nmiVhJdqBnlwUke6Hr8054DK/Ro0F2iqn6ISitVtdLrannCB7s+GCJXBl5yyQ9wt
         atjuwchJxK5ZKD6fX6R2OgIfKqC+S/+zmYbm2bXoAMGEb5ZOHyKJ11JTM9RDpQP3N914
         yiog==
X-Gm-Message-State: AOJu0YxgBkyaIebHwZTf6dLnQQrgIIJBz7mQ9BC31IxATlDrzYjibFrO
	puEbcQQ0nULNltYwTBfWRmS4K7irb+1nkFCJ0KjnAw==
X-Google-Smtp-Source: AGHT+IGeIFMmkXzAkE9CquW7ofTFH0Rne6ZQ1/XSFA5z4R3Le9J9sRiwED3yszhOxfCM+mmsLl4seJ5a8HkLRjI4a9c=
X-Received: by 2002:a05:6102:3d90:b0:466:6074:122 with SMTP id
 h16-20020a0561023d9000b0046660740122mr544557vsv.18.1702553645344; Thu, 14 Dec
 2023 03:34:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231214092958.377061-1-ojeda@kernel.org>
In-Reply-To: <20231214092958.377061-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 14 Dec 2023 12:33:54 +0100
Message-ID: <CAH5fLggnkWAVBmmeSk-DAbkLQU9QTApE_CqsMxiVm1z=h+uhYQ@mail.gmail.com>
Subject: Re: [PATCH] rust: upgrade to Rust 1.74.1
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 14, 2023 at 10:30=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> This is the next upgrade to the Rust toolchain, from 1.73.0 to 1.74.1
> (i.e. the latest) [1].
>
> See the upgrade policy [2] and the comments on the first upgrade in
> commit 3ed03f4da06e ("rust: upgrade to Rust 1.68.2").
>
> [...]
>
> Link: https://github.com/rust-lang/rust/blob/stable/RELEASES.md#version-1=
741-2023-12-07 [1]
> Link: https://rust-for-linux.com/rust-version-policy [2]
> Link: https://github.com/Rust-for-Linux/linux/issues/2 [3]
> Link: https://github.com/rust-lang/rust/pull/114201 [4]
> Link: https://github.com/rust-lang/rust-clippy/issues/11219 [5]
> Link: https://github.com/rust-lang/rust-clippy/issues/11431 [6]
> Link: https://github.com/rust-lang/rust/issues/117976#issuecomment-182222=
5691 [7]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
