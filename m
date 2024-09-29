Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF423C30
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 04:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727584527; cv=none; b=jRM1UvuO4iwoP0Ozdy73VO2UerYagWzQPM+z/3/Ms6mG9M6RwucEz7/SK9Z70Mf7d6dmnnT+PHNu9oR/8kar7dBq0g04plN1hObGkmKpQ8vBBhsA61OSoYufcHUzxDBqGHHmSh/PtpVAOTkpfheiRHshh3bv/X0SyP/VgkM66lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727584527; c=relaxed/simple;
	bh=iq8nYlJnTvsBXaVdMJD5ZEW9MPx3F7bxAs2/3KJBB/o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uGEjlB1ZO8LW9mVoJ0uBXOpZxNT865qX4jiAVs2cpDL+T637noyKFkIDjz9km7C5j0HnZKBakskG2H0at4fvLSjJR+dQXabsw/PSdPf2pshLzZcIpiPyZcX5Bz4zYhA8RLKOl+TaQ6g2FA04vZCEKKFAubUF48rkWmCsGlEk0Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=LFRDccMl; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="LFRDccMl"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-6e22cb0b19aso28621277b3.1
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 21:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1727584525; x=1728189325; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iq8nYlJnTvsBXaVdMJD5ZEW9MPx3F7bxAs2/3KJBB/o=;
        b=LFRDccMlaXZmMO/8E7CsT+i8ZsKdAjRxyie9K493FKHDfd2dhI1mGBZ5VA0cLQctb2
         kKyOD+3nJwEpK/Lm6X4ltCxdpeMpsytH3Sgg2sGlSYJkxirGf6mPPycS3ygCTlbDmWPj
         lWWhySBdwAmQxzdBkdYWX8nGPoul8lMyWC/uZC/PYOxJrV9aWrU/L6G/3kK+JcteAw3W
         rtqS606dumL4mcOIZLduUBEY3Fkceku8F3OEtwpGaiT/ZWH9qnZVPs2NB3n4epNhyaf5
         j7XresYwp641tTZaREuJZCZsO4lRyjEiN2xEHctaJBqGA4wMvks7kmgJoMNWlnnmWzHk
         kCBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727584525; x=1728189325;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iq8nYlJnTvsBXaVdMJD5ZEW9MPx3F7bxAs2/3KJBB/o=;
        b=VtoPpZZQmSPzLfoq4dO9ujTypXllODOXOS8trLAOLhgWOuypBVMetzaex+e2XsiTId
         XYlzVXOG6B5vx/ZiFAcjYi36JmcQbnNR3srHDx5OlPjrt40O43cyJaoMU4lX/RladmrV
         UUCW5YYT/PwZ1QevBxPfbuYTJQJJMmhj7jJK/MtLe8NUI4i3LbNddDPuXoeqq4VzDRF+
         39TiWaHDSs3oiRJBgxsOHmPtClBC6nChNiCrThe/s7NPhC3Z+SmSPuVaDSV92cMYzENB
         qnpSu7IQibJ1iwMSsGL5j2CvL7daspMYVguw1fqCMw8whxzRxg+0+MR3xO6CbqdY39HO
         XPGw==
X-Forwarded-Encrypted: i=1; AJvYcCWLTl2K31vfnHRwoLH+/TgbWaNrebTyHDUQdKDmrBKAvI858Su1OuOuK5GuHY0QY7+MM2WVNjal@lists.linux.dev
X-Gm-Message-State: AOJu0YyCY11zmUg61qnwiC13qQb7TudpltYbigwidI6LhxD9nKj5ZJYx
	5QQ5RMoxIdt2UHbtVAJFofAW+f3Nq+n9yuNLpYI+U/8fATgk0bhS36PVUTfusjEMWAz5ASlvGp/
	IqTDL/joY9qbv4NRDBhwn/aj5SWMARj1aw82yDA==
X-Google-Smtp-Source: AGHT+IFTy978tTVEtvPzHwUu9f9ON7IF/qpS/26+6FLmZ3cp8HWcWTa+ibDUFZepM7iaF+ljOiiv7aClfsJOk7PuJM4=
X-Received: by 2002:a05:690c:4285:b0:6ac:ce34:9726 with SMTP id
 00721157ae682-6e247584d12mr50393967b3.18.1727584524823; Sat, 28 Sep 2024
 21:35:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-6-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-6-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Sun, 29 Sep 2024 00:35:14 -0400
Message-ID: <CALNs47s9t=bFbcLOuwkMZ8XV1S_hF1igdfLKG4RLCwAsivG+ag@mail.gmail.com>
Subject: Re: [PATCH 05/19] rust: enable `clippy::unnecessary_safety_comment` lint
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
> In Rust 1.67.0, Clippy added the `unnecessary_safety_comment` lint [1],
> which is the "inverse" of `undocumented_unsafe_blocks`: it finds places
> where safe code has a `// SAFETY` comment attached.
>
> The lint currently finds 3 places where we had such mistakes, thus it
> seems already quite useful.
>
> Thus clean those and enable it.
>
> Link: https://rust-lang.github.io/rust-clippy/master/index.html#/unnecess=
ary_safety_comment [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Trevor Gross <tmgross@umich.edu>
