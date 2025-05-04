Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6ED24677C
	for <patches@lists.linux.dev>; Sun,  4 May 2025 18:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746381604; cv=none; b=RcPwbCochc5u/iE940l2WgdziuhblX11tCT4lB0yIVWxQpB7MDbKScXrJNuEtzLdnJv3zSwb5LQHxpq43oSasQoBFutwMmgCRPdd347z7s1hX1124PyqUATrj8ZpLk61SKCnfse9b0nNgTTyV0OEewVeBY1HKVWi7mqxLgPYhK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746381604; c=relaxed/simple;
	bh=gMmz0xrFGblYrts2MVNPbSYkOBP0t20o7T0mZB/6a+I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FwvLozYtjpxHgGEtxr5jue5tzlEgObxDpFTDRMvzX42wjnzYlFD4IeJFo12+q2BhRUFiyt8emicBWAfEnFbYLW0YCou9u1wmUQvd2a+8OQBdDnd2hgZE/TkY6GDHJrsYpwG+r3vs+lkkJ+r5ExmGrWUV69pWvExN2ByLGu/Y+aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DkNFPFzX; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DkNFPFzX"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2240b4de10eso8601785ad.1
        for <patches@lists.linux.dev>; Sun, 04 May 2025 11:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746381602; x=1746986402; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gMmz0xrFGblYrts2MVNPbSYkOBP0t20o7T0mZB/6a+I=;
        b=DkNFPFzXEDu6/WJfWR+iMlWENyHtRsT5VQZB8Q29tHcpIecLqsNMToACb5852ZkR4Y
         8fab+cR5zSNWsxhbAHp6UOxH08PjZRqj7R2ioyqIO2c/KrxdjyVJInY1o/f/X+Zq+NdN
         R8sLj8tEtjBPq3dP9o8KI1RArgdZa0FiJXG99b7mPlt908iNlbgoT0f7B7G1mFJalbAl
         /HzXoqc1eYD5GgkjPr0exsnEQR9XfMFb2zgLdfunYAwxjqS7/QhhCvfgLe+sM8C7lwzn
         R9j1hPQ9d8QhFiYNrfMN0wo2PE92ABP4h/dylOqewdikbZpmvKSHPHtpuEqQyvTqH0tB
         2MlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746381602; x=1746986402;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gMmz0xrFGblYrts2MVNPbSYkOBP0t20o7T0mZB/6a+I=;
        b=eVoMG2pFGfLB3Jo5urP+pNnzLAbrXrbFvvzfQanmhYYI2SdtGEAh/xfxvldDqPjAuB
         is3q4VsZkPaZOmGFtCiLwCTLi9iqC9LkHqyMjDuchYA8ppxn3HNp7EELh3CRHsStlTPD
         QgO7JpmnoVnDe2Ik9uv0fpz9Wbc0Qx7W7WZmWRw+nkaOfz/u+CrakvswCzdxzuFOdiBd
         vbcIO7Oq9qZrUXabY3iq7Qh4z79JNg0MFPDB1j/qLBf4brEZwDWJnpjS/sEJJ2WMln6a
         DqoBOWG8/x6cjnuptDXJv+OhV1fz3PV5ysWqpdNVl7vnanqrw4hWoabh9DkXypI7mBZz
         d5fg==
X-Forwarded-Encrypted: i=1; AJvYcCWOilkG03NKEYCjRpySKIsZhZYsqgz4i6Z29J9WpdNpwmDD/AM1BPFIU0+sLtbF83W+cbUWjtoX@lists.linux.dev
X-Gm-Message-State: AOJu0YyfJuTLnTHSO/6eGSzhu65hQ6FD+pwvJl6hKo3SOE5nMUrhqFfu
	pYFL4W3eU9EgJDk815gSNBh5j5ypy6qNczR98TnefDnpEJXn2cHwFaEupbeKnGkxTwakGX9NKU6
	u+SYHRQr2R1skj7Z7RUDdTKsdaBQ=
X-Gm-Gg: ASbGncseMSSsJdWrhb7cd1oPGyvHg676pmr6mFTfc9VCp5af0XtVBSMp+nhwZzuCDio
	Nn3G3MWupB+J5/KnD83xRt3ttB1FFF8tWgtnj7F1L0salX3JFyH2/njn04Lh6Ng0bm3LN5rjWPw
	kLE/gI25fEgqH+0ZNw5OkXmAYA5xJCDEJU
X-Google-Smtp-Source: AGHT+IG10nTmSSofjOBje28dUf2+IMvpiGM28AIkNlFwzc+b2QjcTA+FDkybqQ1kasUk4HKenUIhjeB9Q2WKIKme63Y=
X-Received: by 2002:a17:902:c947:b0:221:751f:dab9 with SMTP id
 d9443c01a7336-22e103958e7mr62623825ad.14.1746381602442; Sun, 04 May 2025
 11:00:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502215133.1923676-1-ojeda@kernel.org> <20250502215133.1923676-3-ojeda@kernel.org>
 <CAJ-ks9=v8E_bV+oJ-bdm3KZW2dfrFdiCmeVLs+bgK8oVu6BCUA@mail.gmail.com>
In-Reply-To: <CAJ-ks9=v8E_bV+oJ-bdm3KZW2dfrFdiCmeVLs+bgK8oVu6BCUA@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 4 May 2025 19:59:50 +0200
X-Gm-Features: ATxdqUFd9uspIO8JG7LjKJl3xaEnjAQIhi12ZtAgUBxbovS5zZvywxn5xVHJpf0
Message-ID: <CANiq72=C1+2B221ecxM5Dy1rF8nEtR4ikgAA2nEh3M1=EkkXyg@mail.gmail.com>
Subject: Re: [PATCH 2/7] rust: kunit: support checked `-> Result`s in KUnit `#[test]`s
To: Tamir Duberstein <tamird@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Brendan Higgins <brendan.higgins@linux.dev>, 
	David Gow <davidgow@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, Rae Moar <rmoar@google.com>, 
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 4, 2025 at 7:34=E2=80=AFPM Tamir Duberstein <tamird@gmail.com> =
wrote:
>
> Why not restrict this to Result<(), E>?

I guess it is an option -- not sure if there may be a use case.

> Is it possible to include the error in the output?

I thought about giving some more context somehow and perhaps printing
it "manually" in the log, possibly in a KUnit `# ...`. David can
probably suggest the "proper" way.

Thanks!

Cheers,
Miguel
