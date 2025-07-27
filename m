Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379EB2E370B
	for <patches@lists.linux.dev>; Sun, 27 Jul 2025 10:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753611408; cv=none; b=anI8BVfnjrE85aVzUNpcX19DNJspbBOHhCRqyI0CtPi2TQEYqL0wGYcwuEGoqKtACg+HQte9At4xz4Rs5guwhK2AV3+In2IjUFdAlBaa96allDACAxza8s2LDiCt9MPg7e3T4/Sn6xSNpz/ftDepcn5NqbcxhpOpbcmLVBBQM44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753611408; c=relaxed/simple;
	bh=7gXF/JGd7cdYSztftJD+wHyryWPRVHXOyQ2/0gQV568=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lH0dErPOtGxHvLwQhoOolaxLcwJSWxyaeaPPqw2SDA1EH+MVSqJBMdCCOV1imHopCPZ10MypRpJLYCv4nxyAyyqZnsirHEqmJ35JHay5CzPfCTW26BbIBjFGyydS5y3wiJ+C7Qg8GdG5m6YqZ/RmvHypOSST0nX8QFHGV4YbjhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4RKq0rKu; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4RKq0rKu"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4561ca74829so37195495e9.0
        for <patches@lists.linux.dev>; Sun, 27 Jul 2025 03:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753611404; x=1754216204; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7gXF/JGd7cdYSztftJD+wHyryWPRVHXOyQ2/0gQV568=;
        b=4RKq0rKuOwyJ8dw7/8h5Y9SVBhlaQF8l2wwgYq0QAYZuDLl04SKaqNACLoXKGOeRAI
         A6JXNQ8ebbO7pCoCAnb946ahL4CkFIgD93spd7OTmRBl/O41N8XefhX8hmpLZKNT+4gp
         L8WER+dGjQL1rEo+VARocJqoCdT9mt0LgeTbndIQvpKdeSAa+qoy02Jtx2EPakDngkrO
         UV7QnhSipS4booTqm5vFb1gDhl6zbbq6pZDMym1+GOrJe0s431lC11QTFxOSB/thpd4V
         7kYVDnl3kaiZ63jIdMrHBXxKl9h+W5j9eWPcwCHHdjw7DHxfyuB8oty8r2QQyYYGZXGZ
         SJRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753611404; x=1754216204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7gXF/JGd7cdYSztftJD+wHyryWPRVHXOyQ2/0gQV568=;
        b=qPBMrHRg/qmpa24nWJHn7Tdht/ogvD+/XzmPh5nvbChA2vnMLktTbkRFql7wWcXtO3
         cu2GQsp8LjNJPOk5C2kMNjKHTdbuPtcbTVL2Ubgz3pLqh/ffoJC+3HGH0+IssFRKc3p6
         XMxVtZ3Q6Cd1ZWDfdxl80RS4QK35XEPzQMOmBFqK9fFRSmDoLVqJv8YuQbB9tV+WZg9X
         s3DY8kCn9clcX5uZ0/Rc2LKwfXtpQ2ubeubNYIwt3cKmvgJPPqaL+K+bnooLzTmRoBD4
         ZXD2cIFk4lscw+KuiEnGZ+DZNxBLkPH3URXpGqtVWthMCZ2qgggX8PbMSYp1JNymETxf
         3Yyg==
X-Forwarded-Encrypted: i=1; AJvYcCWJI6t4XFvZPVZvimEJ/BtMr9W5kIQHy0XKYgIs5NX4B4k5AlgDeKL8n1uo+Y7vplQlsgpUWNfk@lists.linux.dev
X-Gm-Message-State: AOJu0Ywp/BMw1IGpsPGjFTjJdzSU2SEyZwsJq9PRO08y3pexwu8bbypY
	j8VMxt0wVvmpHKoEJb7cqL/n6k6lGezrcP0h4hXA6DAL6vTVkt4LLW4CsD9HVLNEdFdUVzgt6yO
	xhTP4vRXcxl37r5TvEV+7b3UDNeNnHi8yVc3Xud8X
X-Gm-Gg: ASbGncsf4Ihesr94Wuqm4Nen5PGDu1tpn6TAf8cZTda1cbeYTjbubSIO5vzqW54D8XI
	cn8TA4+vZD1A3SJQrbndk1UpOn0xC1h1tgCgNLrdmFdMLPdyQ/q9au/tTb2I8K8iBGaCr4jV1DS
	+oFDbbOrNlcUotB/QoSobnKYOnSQMGRfyTXuVM2hp8tVYcshHY6+VBfbobtFZf3NgM2R7Fb2DNE
	4LGkvh5
X-Google-Smtp-Source: AGHT+IFyrg1ejKvUxd9ZtQSI9909R3ixl5LPHcy5aVZC0U4Sj9RIX4I7zArgs9AtLDU/QcoqDxdQPatS2VjlhudegxI=
X-Received: by 2002:a05:6000:22ca:b0:3b7:791b:649b with SMTP id
 ffacd0b85a97d-3b7791b67d5mr4008222f8f.11.1753611404412; Sun, 27 Jul 2025
 03:16:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250727092317.2930617-1-ojeda@kernel.org> <CANiq72=Y3i-WeygLix6j-sPZwE2QTOkaZDQOrED1aCiMoH3Cqw@mail.gmail.com>
In-Reply-To: <CANiq72=Y3i-WeygLix6j-sPZwE2QTOkaZDQOrED1aCiMoH3Cqw@mail.gmail.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Sun, 27 Jul 2025 12:16:32 +0200
X-Gm-Features: Ac12FXzQd6Ubqwcqmg__eYKdobRTIYZ7Qw-ApZU0mG8XcaNSXbzlilcOMmffJUM
Message-ID: <CAH5fLggeVq83ZPWPE5Thv8LUNrp6pX6sifGBFFbe20W1neWJ=w@mail.gmail.com>
Subject: Re: [PATCH] rust: workaround `rustdoc` target modifiers bug
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 27, 2025 at 11:31=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Sun, Jul 27, 2025 at 11:23=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> =
wrote:
> >
> > Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> > Closes: https://lore.kernel.org/rust-for-linux/36cdc798-524f-4910-8b77-=
d7b9fac08d77@oss.qualcomm.com/
> > Link: https://github.com/rust-lang/rust/issues/144521 [1]
> > Link: https://github.com/rust-lang/rust/pull/144523 [2]
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

> And most likely:
>
> Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is
> pinned in older LTSs).

We also do not even set -Zfixed-x18 prior to v6.12, so there are other
reasons to not backport it further.

Alice
