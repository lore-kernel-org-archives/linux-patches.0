Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460A51EBFEB
	for <patches@lists.linux.dev>; Thu, 22 May 2025 20:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747944355; cv=none; b=cxGOxOr/vMyT4nvJwZltD1IfZKnruB5rEzODt+IwadNpBCrH9lPcS33+xwyrvxE8SWYNBGejuxCOf61VUJDDLmut6ULfdvgz9fkxFgh3ZOU3HBn79DbIkM5xq/PpWNqXiMo1/Q/dvHhP2l0eCIQGHd/jZWhJ4sjpZBL/2Icn9zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747944355; c=relaxed/simple;
	bh=PwXql5ZCCKKA4XkDZsjmxfvBZJ2akfXd0xfKzICmRAI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R88BAMKMhQgqo2eHJ6Rl+3KQv9+8CgDgK8MFu4mY3GvqHBwUNjHCp/2EbasHWtUKliYqR3gTJ+NwJJUk/U9LLn3IlB8nYAIeOvGqzhyvF6Znsp0G6nk2asjKG0DdSiBCP6hxD8gMZq5H9H873/J+gQC6PCD9219d0Gl1Al+g8Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O6RvMGSP; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O6RvMGSP"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-23228a8acb0so5904565ad.0
        for <patches@lists.linux.dev>; Thu, 22 May 2025 13:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747944350; x=1748549150; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PEAP9pb/0X/MHqDazxQDkHXQgCofrGr3ghVoB2vRtOE=;
        b=O6RvMGSPiJA0MyC+KGFdJLOup+Tw4bzcSKHeR+Cg1Jfqqi45DCbkDOoPgjikHPNjv5
         HEZL2TifUI+Dw7JxYllHx4Zp/DWWj7H40aNSA876qccm/QsIEzkzJ/uVFrQBbouT3dC4
         Jidq48m0MCN+B/hYyz7bU7vVJdICDjTWzMRuPnZx28UH6r4w0uXeSNvfAFwF5rKNrrJy
         Y+mrxHSYUZa6qYtB/M+fjKqEZxbdSwhGEVU2uSc24UJM1Lo9WDfuxft+KmT6HIHg4D8G
         hc3oMOi7901mxPfCv/LsDjPC0mCuAmVf/QowSeV4CDuKpvnNPY5SssdUW0eosR+Ivh9m
         PueA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747944350; x=1748549150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PEAP9pb/0X/MHqDazxQDkHXQgCofrGr3ghVoB2vRtOE=;
        b=bQlt39auZ5IFVBVOn9sIwaFXtD5dXUDeg6ChcjhRUaxwSG6FzfOlQl+Dbp2U1BbHHp
         gQOE/NOcbH0vKO4fbCs/6VtXO4Jpt8+LEGVz7owmQ4qTTYvz8vPXKviPrCYFTqBJugn2
         B9+EhYvj9NNdtUfBhLlEB49/OZoyoj7Y75hfoAECbpsCLu0iSR34DHHpa0GtMiTl69cK
         hDwnxkXxhMmSyzvWNPSNllbMKT6ODhdfn6IlFPwvmsdPmbIirzjZLgfYGh+CgltoofyK
         YOAGC/G/UMHFRhN3fpQKMR61JgRmX2vU6s2EiAH4/xtN1z3zzcm6AvoHPHwkLBQUQl6f
         eHtg==
X-Forwarded-Encrypted: i=1; AJvYcCVe6gcVKJkib8pre1WkiKgfydMDCV/yMUvqdWr8DXBGX5z+/DCrsI6doSPrATmcIuJX+0b/+6yR@lists.linux.dev
X-Gm-Message-State: AOJu0YxohhqV6HVbYC9LyEGhC7QdhbpWjc/sUgeKhnWAJRjwndH5HAW2
	FJ+DDYixNYKjosMfIoQ+g1oSV2bDR65pgj0t22qq4yHhU9lZ0wgY9ng6IdPF3gWtzcmw2DwxouH
	KN1QbQHn/YlJ7bYdqM5F9pRJZsKp8Hrw=
X-Gm-Gg: ASbGncvyQdmabbp+6pgiSDIQMyP+pKW0ahk1ECoO5JvKH0UrFGYmOMYybGxZrPrXoqa
	Ls6gtTrvlXC9gamssfjpUu/S8W66B2H2/vuiCZdGP8lLCJv+AHVwrSQ2gWD3qyPzLfT8q3Klfwf
	4JCzB0wBzj5O4aPOfeMMUaSPb78lA2C5yj
X-Google-Smtp-Source: AGHT+IGPM4c++XAu2BeE0v0Qn2lebj+uX6J1h637R5QAppETAHsqqSaI+d/qnmhdsieSt+fAB2/XC93MamPMrxQDWBg=
X-Received: by 2002:a17:902:ea0a:b0:224:c46:d164 with SMTP id
 d9443c01a7336-231d43891f9mr125907535ad.2.1747944350417; Thu, 22 May 2025
 13:05:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250413005650.1745894-1-ojeda@kernel.org> <CAH5fLgiF0kZdOYaQi18_LTNx6Onq-5PBomA=bwS0m0z+C0wtvg@mail.gmail.com>
 <CANiq72ngfTJ5PTYaJOOQ2NedERrLYzA62hL8Fgw5C4QkuZ2R-Q@mail.gmail.com> <Z_0X8Z9M2H0mmcK8@google.com>
In-Reply-To: <Z_0X8Z9M2H0mmcK8@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 22 May 2025 22:05:37 +0200
X-Gm-Features: AX0GCFsd3MjqVKVYRSlSmd3gv8L2oHNQPn44WQ8nmzQaz13xEZl3bEswwymnTDg
Message-ID: <CANiq72=ttuQYrGNDqNZDmBN5G4TUpna+ex8eD85HvOP723frDw@mail.gmail.com>
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

On Mon, Apr 14, 2025 at 4:13=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> Hmm. Maybe, but I think having it at the end is okay. Could we catch
> core::ffi with checkpath instead of clippy? Just search for core::ffi?

Sure, we can add it as a good first issue (Clippy would still be ideal
-- it allows to check all the current code).

I came up with this, which puts the right way first:

    Rust kernel code refers to C types, such as ``int``, using type
    aliases such as ``c_int``, which are readily available from
    the ``kernel`` prelude. Please do not use the aliases from
    ``core::ffi`` -- they may not map to the correct types.

If neither of you are against that, I will put that in a few days,
including Danilo's tag.

Thanks!

Cheers,
Miguel
