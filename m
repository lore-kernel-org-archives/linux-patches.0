Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A702218F2EF
	for <patches@lists.linux.dev>; Mon, 25 Nov 2024 09:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732525753; cv=none; b=TZAk54PeDWtWBh2byi0WgDjRnDNKoEBbPyk0NTl4MHxEOi+fS/Uzoxk/tGsHzrCauuI5Pgqb1iOHrRJpIfiUJ1mZJKhU4EUe2/JhLhwbb7031Y/EjX1yorc6+KAOpvgHy0ESlPpO/lLOoYQ3EqEJn21p4PpQ3NoBePDT/cP9u7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732525753; c=relaxed/simple;
	bh=PZjr1Yu0Ay9y016nTeQBXSJo1HOEMk7mulrM8bVslrk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tmhb1vCvQH4ipsvsTMgUPQD/Bt4l3+Oar7RZSPF3MCk/hc4gIkOyX3TZdaApAPW/A7XZ0sHvmrVMinFcqV9IL4z5uObKi9sYFHGTrgbwiDfUJJFUHPL2LAhPfsBJKGmBlo900NuoBDKu+fjFqoDwyjDkPSkPC5IJArB3x2Wkkpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0YpO2GbZ; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0YpO2GbZ"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-432d86a3085so38647885e9.2
        for <patches@lists.linux.dev>; Mon, 25 Nov 2024 01:09:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732525750; x=1733130550; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PZjr1Yu0Ay9y016nTeQBXSJo1HOEMk7mulrM8bVslrk=;
        b=0YpO2GbZWSWNLl7zurOWum/WiLDWJ3RWM4ZrN56v9wcMNm+HIhY9rpBsmRMLryEDRv
         sfK3zSyEHzsOpaxFjzpkIES2h2EeL7OVuwYX/XZf11Ze8x6PTq6RjcVqS9jq3FD6qpjD
         hsZkgNzZqjYotYfTozcoAb/2VDD04jflbnvVqUhKm3aXSyl2aj6NQVxTfgoh7NumKr1y
         IUH1xnKSKOjFJxz6b/4CQDBfuuB68/Mao4DB4fIajDhLRV4KQnp4VMGy7fggz39kxRzj
         i1JDXVpKZpwultZj1ZRT6pw8iL+EXXQP4oIPr+e1/2GCwWfo1efQHXOqEnjagvMvSq5T
         if/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732525750; x=1733130550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PZjr1Yu0Ay9y016nTeQBXSJo1HOEMk7mulrM8bVslrk=;
        b=Ak2mYZkl2x4bfXJBr8PrEFjxpiL6/0yGOrMt37VleJW6RZvQc7hetZKlZOdrPphytZ
         +ZtSsmEyTdLhelURrHue6LUXl+Dgu3zvINEmz2NkDQZf1rYz4qyaYgqyAlbMOgl+Mf6f
         AWFoYOsMc1bxRtpOudgD07igFg/hzOMIBYuMZiL5bkWdCDhFIZj0ySh5r86+qjWFz7ND
         tqv+BXnylHIjUXg1yhbmSRZIOqOdSORGKMZs+eyZrWc6caAA1L8CwwqcRn9u/TvKEalg
         vo6fMtk4PmLEDMszLpFksLRHP+kPsJZep2oQi5LksKmvdkp6ntUUH5jNSB3bcezCIo3U
         glNA==
X-Forwarded-Encrypted: i=1; AJvYcCWzdhXd+2Zix5FXBqsDBPGqCuShMjMzsZIQDSMzKcCwRVoSdujpC5a1bcdp83X1TbgUfO82hpJy@lists.linux.dev
X-Gm-Message-State: AOJu0YxMh1Qm3eB91/hRhmbaf012RbK0eLTHcJo+YQ4Cdj/Eolk1Znyz
	E66yfAXtm3j7l/ItlVGZWVPAq5YvNhJlVjeUWV5jCKlUD/+3FExTf6hTjy3H5Vx8WEoy2y9oTBP
	nkbY9NHhOtYT+29OXkPF6C9Ktc//Ncv1ATSl1
X-Gm-Gg: ASbGnctRlO0Gl2s/3ClIZDhVQWXA23p1WyN3VTfYQ0IMGp2eLe8TyG7pogPouWNgV5B
	HVKmFhbHhYD4xvmBB70g2XqQW0YB+i2gPAt7i+LBP9pW/hCaC8AMAdZyJPyticg==
X-Google-Smtp-Source: AGHT+IE7Fba0mueXQruBT2O1+P0k/ZOupdomBzRzh1mSpCPpLePxV1BgowFf14yqcxgVhzpT4h9Z8LLvXCth5luslj0=
X-Received: by 2002:a05:600c:3aca:b0:431:52f5:f497 with SMTP id
 5b1f17b1804b1-433ce4253d2mr111486625e9.9.1732525750068; Mon, 25 Nov 2024
 01:09:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241123180639.260191-1-ojeda@kernel.org>
In-Reply-To: <20241123180639.260191-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 25 Nov 2024 10:08:58 +0100
Message-ID: <CAH5fLgjdbyFADFZQqjFP0o2eohKjtrbVq_-_d341-TU7aPtw2w@mail.gmail.com>
Subject: Re: [PATCH] rust: kbuild: run Clippy for `rusttest` code
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 23, 2024 at 7:07=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Running Clippy for `rusttest` code is useful to catch issues there too,
> even if the code is not as critical. In the future, this code may also
> run in kernelspace and could be copy-pasted. Thus it is useful to keep
> it under the same standards. For instance, it will now make us add
> `// SAFETY` comments.
>
> It also makes everything more consistent.
>
> Thus clean the few issues spotted by Clippy and start running it.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
