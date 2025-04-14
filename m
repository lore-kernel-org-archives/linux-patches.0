Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F5D23D297
	for <patches@lists.linux.dev>; Mon, 14 Apr 2025 13:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744636981; cv=none; b=foKi9svnq5VE+7eYk5DtB1/cBaOrprSBROhMIo1/tQszlG/CRtrQFT2Z7BWliMNaK0lMOCTrbRjjKdaBv2E+DMKUHM6zvYBdGqOWNmOSNWLHgGreQLozrDQVjeq/vsarwDY9yIJ6rnGLmYNl49viRpPWVN85aGRbTJuEXKdTKBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744636981; c=relaxed/simple;
	bh=YqZznskXltnYKmBVLbbwElNix3jQOvyAnCNlCgTo76Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ii1moUu7p7pjvVgIE4KanJE+rUwVSPNTOm1n57cXphJ0ySNZPzA/Q7RlpilVEMKxrgbzIqCeG+EIykoGJylWv5ece2rh6eQqzX/lpQn4QajxXDN4i1AgtpxE3TvneJ2Xn++qcE7eTyR2i1jD2SJyhV/9HBR8qjxDbFGlgKz5vsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cuOG59N1; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cuOG59N1"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b07698318ebso92337a12.2
        for <patches@lists.linux.dev>; Mon, 14 Apr 2025 06:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744636979; x=1745241779; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Df4ZlcRCkKHa57BJ2xndOrkK/FrGdY+gTPtYXvqZp/Y=;
        b=cuOG59N1t2euKsKiJgLoGW3+SDEmOrEzqeNKL+jcnDcrPRf1+GEe5G1TAvJuqJpkUO
         I6HvISUeTPLVWzbDmKkah7U5UA8IB4s8YM70DsVXjNEPBzRfWwMfIWwJmj9mK+ipT94G
         MjwD1TFwAxC82bnkxHn7IffWsR1PnxngBJAABVYHD1kUCRlDB9oq0AuX3fm6f/sGLTvu
         1lp/DVOCWrKLG8xr3XxnMxiolXhhoBDAprn/kZLEPM3Oasb/qYu5W0Xia4J7uyFEvuyA
         ZtImi+iH5ALKUfkhJV3pe1rfhyC4xN0MWVLWUTOPYJPy6CKYY493lK0wZH2s3wwWp9LZ
         NRGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744636979; x=1745241779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Df4ZlcRCkKHa57BJ2xndOrkK/FrGdY+gTPtYXvqZp/Y=;
        b=DuHAoUclghIyjIdpGShVTxOqSekG46V+NppSCOFiHWW0zRrM4B/o5AHHjppKcJ93Ib
         7/XM6i9Rx97fhkiy9sav0jXVEb4OvlpHvr+3Gp4+4xBBerojO0wit2cpsj+8pxPmL1iv
         YKeo4SmxniXOUSrAbZ/aUF+xjetRYBp63XTxsPHcuNBleg2JDxNTAj84rS4BZKfClYPY
         YaYCiBPlt5HaCUB1j6iY1oN3m8r2Mi8zmimLw6wiL7SdJC/oJqoOw/Ub5xMSmy42HtiJ
         tpGjuzlrYyHm51JGGjzKI1oi1mE0cJdtpiVb/ryiKEksH2N66PtXwfHeORChoaj4raal
         6tDA==
X-Forwarded-Encrypted: i=1; AJvYcCXfAsVBH+Do5Cl4aPOXprQo8gTRUYfb2k6v/b4h3g11l5OyxXbYhIw60Tp7xrepp1oqrgVOyfA0@lists.linux.dev
X-Gm-Message-State: AOJu0YyMZzZut08bDkaB3IYDXs4lJ5QnljtvqIGRanBXfbiFjXRQbYXk
	BTXDmlkeFLOiQmn8QR4gbXekZE9nWtHfgn0dFmr3gZZeoQpBdspN2PjpGDFhXE24f9zzA9gYqz1
	NnYYTnxJVDVgGGVs4HnqMQtjvi1k=
X-Gm-Gg: ASbGncve4joZvBZFlXW1cDLRtNpp9mP2MNjvOEDMvVWYPp2qgotdfktPeqIbOalMPbx
	yodJu+aWm31gdtjQLeypuZzwFLRv8kp0LFwD4GgCuuY8KcOEcG3iUtTEP8RkWIca7g8rNPl+9Gf
	ims3SqZ2RzGFYwmlHFIULEgg==
X-Google-Smtp-Source: AGHT+IH3zMwiQZZF0MrooAxLxss2WjlELR7XDWfoKS8xT5Swj4kCI9USG4kreGACDD6msII1YqtOpACzPgTOIcNg6iQ=
X-Received: by 2002:a17:90b:1b0a:b0:306:e6ec:dc82 with SMTP id
 98e67ed59e1d1-308273f3c3amr5931863a91.6.1744636979074; Mon, 14 Apr 2025
 06:22:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250413005650.1745894-1-ojeda@kernel.org> <CAH5fLgiF0kZdOYaQi18_LTNx6Onq-5PBomA=bwS0m0z+C0wtvg@mail.gmail.com>
In-Reply-To: <CAH5fLgiF0kZdOYaQi18_LTNx6Onq-5PBomA=bwS0m0z+C0wtvg@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 14 Apr 2025 15:22:44 +0200
X-Gm-Features: ATxdqUGEpSrfVFnwvmwXXDxiUjWRT_U8CHO5cnUITp-hEVmYDeKZxvObhfYQwF0
Message-ID: <CANiq72ngfTJ5PTYaJOOQ2NedERrLYzA62hL8Fgw5C4QkuZ2R-Q@mail.gmail.com>
Subject: Re: [PATCH] rust: add C FFI types to the prelude
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 14, 2025 at 10:47=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> =
wrote:
>
> I wonder if it would make more sense to rephrase this section to first
> say that rfl has type aliases for the C integer types called c_int and
> so on, then mention that they are available in the prelude, and then
> at the end of the section have a note that we don't use the type
> aliases from core::ffi. I think focusing on how to use C integer
> types, rather than technical details about how they are defined, is
> more relevant for a reader who is just looking for coding guidelines.

Hmm... I see what you mean. In other places in the document, we start
comparing with userspace Rust in order to establish a bit of context.
But, more importantly, in this particular guideline I think it is
quite important to say "do not use the usual ones", because they are
actually different types, i.e. it is not just a style thing.

I have thought a couple times about perhaps changing the overall style
of the document to have a 1-liner short summary on each guideline --
some books do something like that consistently. And perhaps an
example, before a longer description. So something like the following,
which is closer to what you are suggesting:

    To refer to C types, use the FFI types (aliases) available from
the `kernel` prelude, e.g. ``c_int``.

    For instance:

        ...

    Refer to them with a single segment path: e.g. ``c_char`` instead
of ``ffi::c_char`` or ``kernel::ffi::c_char``.

    Do not use the `core::ffi::*` types -- they are different and some
do not map to the correct C type.

But even with this style, I think it is important putting the last
sentence in the "1-liner summary". Otherwise, someone may skip the
guideline thinking "oh, OK, it is just a style thing about using just
small paths, I will fix it later", without realizing they are actually
different sets of types unless they read the entire section, no?

Thanks!

Cheers,
Miguel
