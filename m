Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BFD22309
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 04:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727583539; cv=none; b=L9dozxawhGpBjOn/dHmOsVNO4pti/lhbWvxJpvzUg6rI799VjE7A8ricWLg0bQFVDDL1d2JH19R40ViGXnQPILDz7aFNnKplHTIdJXDx7UmKrTmkMSCJkRi6VafcUz8VjNCVhMYRxjqrSUVTMA3BwUwz8biX6EUEjszLKEaGyM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727583539; c=relaxed/simple;
	bh=f3AYE4EAY7+DIMSg6zZBDw1KLgq1Bt3GxtTiTGtRrOY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qDcGXDPFkFVnn8bkXqkMjZGKOtQunoxrGCg+yqyMh5YqD1ioRM7H5LNjWEATLtIEjbWMtMyakp/uypFY1A8VdyhFrzLNux64Um47i/DzQU9S/7FdCnqBU6LMzOVg8gqTSIxuOXfntN6F0NPn3+0SqJMrNxEneEjwjT2A99MBVEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=V6QUQQ21; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="V6QUQQ21"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-6e2346f164cso24844317b3.3
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 21:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1727583534; x=1728188334; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f3AYE4EAY7+DIMSg6zZBDw1KLgq1Bt3GxtTiTGtRrOY=;
        b=V6QUQQ21zZ2L97G7VfvAd4tfDJQqoACZ8U1VmaMwrD4mctjM3+BnaEavfyTlF5/jRh
         QtNKH8dR93YRXisOh7WH8X2BJFQukiw83717M/IGL/RrO8ELbivns8swJgOZAfoHX81k
         S9watYpM1ETFp31Q9q82H0kQBCGQMTOHGQ+dC8iZwLQXo+3O+C2Z4ugisDbnN37549BL
         nAkI1DIQVJIIxWYUNNBfJ0i7TEB5kLVgd7nZ6RZKzpeNaWOqoLpl608R685pTsBSYa6T
         6nxUoZaakjhT55yITNZjlF+8uk07guu8eaBp6b01e/aUuFtEviO2hto3neieZqlaJP5k
         UIUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727583534; x=1728188334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f3AYE4EAY7+DIMSg6zZBDw1KLgq1Bt3GxtTiTGtRrOY=;
        b=ucTwVPhq2jusSqdtUUC3Ml4MWSaJnuAE2y+USnEzIC3SyyfgiJ1GmTtLhdBTidoNTT
         hJ+TaR6pWrO4Wd50WPS1tpi7A4YYCHXKSIF7j8l9jVOENarP6JboQ23ijwBa29IRN2zJ
         M1GGp+VRTbOndcWdbcvazY9pNaOm1o/eYTojXsNiJc0BoBQrH59v+CcuD0H0ZiIlXdXG
         Mtfnr2FTTajtY2g8G0//C7KHPN0u9bDkkw/vWnF1kjvWr8I6FPQZHeKvBMoPIJl5GrdQ
         Kii+1xKMZ7V+4ouJsC0phnPTqef6w33OZKHdZISX5EuBLhSf2IO9e8Qm+unFedNJRdoQ
         JCLg==
X-Forwarded-Encrypted: i=1; AJvYcCXMdw99tM8FDowDYLoIg8EZtNgViN4fvmr8saPKG1PlDc+kYyEy6QbNcFAgfEzpRTmTJoKomuhd@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3CR4QH/A+gsPvJ3/84G+m6HgMcLRLVpyKLLFWli5bkkFoYVos
	iEKuGU0FKrWCVU79f2ZMSsotP1+d0+xinGOk3Zlgr+SkS+RNEqNG7tvLrqjQk/ZSuyxSaTX0I59
	8UygTzTvo9tVWZRMFVJ17y1ecS0Pw+AHBEd/N7g==
X-Google-Smtp-Source: AGHT+IH+HCA/i8rZh8JidjsUomu0azwpuBChRZ5m/iwQKitnQIu0YDMzjdhAOLhRYeUuP7vLilNtecFjiWVpiz02oWo=
X-Received: by 2002:a05:690c:448f:b0:6db:da26:e8c6 with SMTP id
 00721157ae682-6e247610a6fmr48073547b3.44.1727583533702; Sat, 28 Sep 2024
 21:18:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-3-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-3-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Sun, 29 Sep 2024 00:18:42 -0400
Message-ID: <CALNs47uftdC2wY=Se9dx_cavd3yB6rJ09NSf2CHDtS31OZMjKw@mail.gmail.com>
Subject: Re: [PATCH 02/19] rust: sort global Rust flags
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 4:44=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> Sort the global Rust flags so that it is easier to follow along when we
> have more, like this patch series does.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Trevor Gross <tmgross@umich.edu>
