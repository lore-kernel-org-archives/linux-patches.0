Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0C51A4E66
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 20:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725308090; cv=none; b=k2/FQ1qU3UbELO09WIdD8HKVIYzf/8ujKnZIQeeIO53bCenFcEdN7pJt/l5MqKk+pKYt2uGz+WY3IgALd7a+UUR61wA7NnK80usyjbIYt5u/12eEqiyJ9RIZjJC4gnwYg6oJBRswI3gSiJ1gJS8dtgrgCRKZOWFKh4ojcOnwHHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725308090; c=relaxed/simple;
	bh=VUBUrgI8fZ9UdZTf7JBIxZO5g8A0/zi0bMsBWCmBpmI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CynxRYHb+BE13I1i1+9m9CQF4iVjWXcUhuyBeWiacmVcOkjcEqJqcNwQZjsN0KF25ipA1gKsXSqGRPTE8pn9FpAYLjxXNus0luz9qULHagtrovaQyfgxDLjsaJyA53bFNGTI7siBRhMqNled7jpPr1Le0/yFF+ByamXtlx0FBTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=cj8V7H+i; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="cj8V7H+i"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-6c91f9fb0acso38820047b3.2
        for <patches@lists.linux.dev>; Mon, 02 Sep 2024 13:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1725308087; x=1725912887; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VUBUrgI8fZ9UdZTf7JBIxZO5g8A0/zi0bMsBWCmBpmI=;
        b=cj8V7H+ioXdu7zLuBchHqmirehh2tkw8C86tdevoKFflX2U4/QU9901aCDMVuXDQCe
         6bPNXBXzJUhCzSNkVlXxr2rY7H3gOH6CEdr64VzSNHfIPMlvhQxh87c4Hxv4SbRGa2Fw
         fCxCp5wK8ipwYZBwISfeyV+V7nVDLrY9clUH2motHUnFBw8DI4KHN2qrHxfp+E047pWo
         CTsNDU1xtQI297gKcfRdukgrog3FaTuaQAHvon6E83CkeFyAiZ2FZkI75ApgCk4t+usz
         ubykaARsIa6YOew5ElEfemFE5cY4bi72wedSE6wnTU4txoR4gMDYtOriXku/s6irhZKB
         WDtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725308087; x=1725912887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VUBUrgI8fZ9UdZTf7JBIxZO5g8A0/zi0bMsBWCmBpmI=;
        b=vbQACBmcWtDAKPkMF4FlF89TyaPDmqF81tF8MlYs1tguFqh3ayN3rvGvu9cXKJ8Omg
         TFih/e6YJaze2W/pIarHHqb6Gc9tG0rJTeOSsPSACBksaQQMYzUZEHMFGTjltVb1ytsI
         niMsZktAj6Jt/M8JGZ+6Jmfhv9vY7Fy/IzcaB4SurOLm1DifJJeL+A3rfRrXXWSfLZ+8
         ApgCnIzwWdLT6BcvOfNY4csokUcHTrEQahoS/Ouq6t0MG4dcGAzBebY/vowqJ3fY8Lkl
         BhtEspf21ZVFCAHfgNpdCQ5OdhL+vs8VoRgp5VxY6fjqXBQgfQ05Awm0wrfjXisE1z2T
         42Mg==
X-Forwarded-Encrypted: i=1; AJvYcCUygSHYkjvOaEsAgzr14tpl9KUcZGccyKN14CTdKcYo0SgwfblEuTHJQSUjNrGRcMHR8PJq+GjY@lists.linux.dev
X-Gm-Message-State: AOJu0YwUpd4iLDrLNrmHldWB2sEb7+Y+P6/+YUeS7vnJnOzTctVD5fsH
	Ud9weU+SwKDCDRxYCrPT0uv10cS11P4IoMdyOcomfjAKd8rj25Qtj10ZhikENZ2AMrXPYW4jSFg
	LffWCZzyVk7uKoiM4dIt1eWKUxJ4+B9WTHLEOhw==
X-Google-Smtp-Source: AGHT+IGsXiR+Wz+6S4QOoyChhXUKek0EL7dfcorJfeKc88gOTnhJF8XcgdnaFG0Y0Q9vn6kCbLybTQ+QQtTSSBDJQwA=
X-Received: by 2002:a05:690c:418f:b0:6d3:f400:81e1 with SMTP id
 00721157ae682-6d40e17f6a2mr89660447b3.14.1725308087698; Mon, 02 Sep 2024
 13:14:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240902173255.1105340-1-ojeda@kernel.org>
In-Reply-To: <20240902173255.1105340-1-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Mon, 2 Sep 2024 16:14:36 -0400
Message-ID: <CALNs47s_DT4Vt3WuAAcP54GA7so_aNg=LY4CCB01xn2nGiUjDA@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add Trevor Gross as Rust reviewer
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 2, 2024 at 1:33=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> Trevor has been involved with the Rust for Linux project for more than
> a year now. He has been active reviewing Rust code in the mailing list,
> and he already is a formal reviewer of the Rust PHY library and the two
> PHY drivers.
>
> In addition, he is also part of several upstream Rust teams:
> libs-contributors (contributors to the Rust standard library on a regular
> basis), crate-maintainers (maintainers of official Rust crates), the
> binary size working group and the Rust for Linux ping group.
>
> His expertise with the language will be very useful to have around in
> the future if Rust keeps growing within the kernel, thus add him to the
> `RUST` entry as a reviewer.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Thank you Miguel!

Acked-by: Trevor Gross <tmgross@umich.edu>
