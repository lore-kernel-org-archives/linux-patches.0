Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E84E16418
	for <patches@lists.linux.dev>; Wed, 18 Oct 2023 22:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="knL4Mr3Y"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-5a7afd45199so93077257b3.0
        for <patches@lists.linux.dev>; Wed, 18 Oct 2023 15:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697669875; x=1698274675; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RKkVdOuDWF4XkQSOFeT9iebziRU+xr3n1OlUXKxR8yQ=;
        b=knL4Mr3YgnbAVevCQ3KH2KHYwpBYf4dWd0zLHeohMI0ORUmFz3SMOLgu9zGHtinoNS
         i/wX8wcDVywcWlDlQOrrTsJ4hEqvC06EMMwGNWk6LDt3I2TCz5KRtxpg3hzTaggylTVD
         aNDWIxfTpuUcDjZnU0nj6s4zTo8+7sxCuZnRVBeKGlAOYtp+ek2ztpfQ4L1giKwzHM7a
         hg7jHum1Gnoy+d1U/3UmFJt7lkKp6UQgKGZ7X6ZqeYs/q1RCHyqRWqbipzrPH+7oTlJK
         WCPs0b6oatPLQueFOSDmuAUPmqnfX/eqKJD92cvSmc49+/CIiKII6rFGVNDDBoRCblQ2
         YHbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697669875; x=1698274675;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RKkVdOuDWF4XkQSOFeT9iebziRU+xr3n1OlUXKxR8yQ=;
        b=QWiPXkJ58q26Jf3VZOysOnCnDly1mUnK4T/04GBV0JYErdjn4pujbu6Di4hCrviOyG
         HBKKwMliCIAf2FpdIHEQdCaqrGla11S6wJa9RiZplnBgf32AkANWBaFK0P1P61nGMAbe
         mw9YGm6CUcv9QwOwryxooWF0l+dzGbdDMck3ZhA4Rp3C0t+dj2F0alTRlUGyHxovOHCx
         xIjY+JoJu/YZVLowAtsdwUnEzfP4VoCpTLY5idU2+CGlG0eUBWHoHsDUlCXIDa/BWwFW
         ksdIU4mK10c/t3kD0y/sdP6lDSWkikyQ0WjwPRSEk78+bhdM2JNSSH/60zlCavf51St8
         C5/w==
X-Gm-Message-State: AOJu0YwzdMN8+pBPUvsU5vdASVTtY8/crQkqsIPTOZHhk5ysiRY664ee
	8VEtZyieY28GJswqQBc4rRTFk9AaFTy/03pmcRQ=
X-Google-Smtp-Source: AGHT+IFrRe19551V3133QusmY93KFsTv/XMURZAAbpLgmpHhSRq0ztkPRgjFSMeQaWFwYIX6VJzYxBi/XO3cFeKFXQ4=
X-Received: by 2002:a05:690c:dd1:b0:5a7:dbf4:6a1a with SMTP id
 db17-20020a05690c0dd100b005a7dbf46a1amr792663ywb.7.1697669875320; Wed, 18 Oct
 2023 15:57:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231018155527.1015059-1-ojeda@kernel.org>
In-Reply-To: <20231018155527.1015059-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 19 Oct 2023 00:57:44 +0200
Message-ID: <CANiq72mx+gHfP+PE1fuHcO8zhv038qXJ9Zz+rKgRN5tt7eokvw@mail.gmail.com>
Subject: Re: [PATCH] rust: docs: fix logo replacement
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 18, 2023 at 5:55=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> The static files placement by `rustdoc` changed in Rust 1.67.0 [1],
> but the custom code we have to replace the logo in the generated
> HTML files did not get updated.
>
> Thus update it to have the Linux logo again in the output.
>
> Hopefully `rustdoc` will eventually support a custom logo from
> a local file [2], so that we do not need to maintain this hack
> on our side.
>
> Link: https://github.com/rust-lang/rust/pull/101702 [1]
> Link: https://github.com/rust-lang/rfcs/pull/3226 [2]
> Fixes: 3ed03f4da06e ("rust: upgrade to Rust 1.68.2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-fixes` early to start getting some time in
`linux-next` -- please feel free to send more reviews, thanks!

Cheers,
Miguel
