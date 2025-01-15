Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C1E232441
	for <patches@lists.linux.dev>; Wed, 15 Jan 2025 02:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736909766; cv=none; b=Xuh+U2KTkfdCsV1aSPMWzcfPno9WIETrF+F2vKQyeWPm2n9TujM/BwoQrlBFEUL5hiQmTdJUFb+W8gbi7BCEzcAtzXnyC3A7/e/qIjBbEwBl+yn6JdeW0LXCGg9dQztIsmudjQno5+Bf+TpFU5oIk3cZpYRyjCT2eRDESUaT3UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736909766; c=relaxed/simple;
	bh=b1D/84dPUMBe220vbJMcnbOIxZdg5O2ChLT4aFfY+yc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=emnXeEH0bG0P53lBezkC7cajDcu5qAMRAiWbppIJQJPbD2A0gkzZVBwJxbybWDnkesonWq5B3yUsQ+9S8e3f2XkaRPeJ+5bXZ9DLYjKDGGHJEvfQyLJwOlvmNYKGOi0IZxIfxWMFnh66N3YMSNBZ+6zguaXRbzWBOswM0Yf2LXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OBIcCM6+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OBIcCM6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5535EC4CEDF
	for <patches@lists.linux.dev>; Wed, 15 Jan 2025 02:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736909766;
	bh=b1D/84dPUMBe220vbJMcnbOIxZdg5O2ChLT4aFfY+yc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=OBIcCM6+oaj9KLFplmpEVD4/80cRA4OiBp60v5IR1D2yZdu6vRQDYKHyiMzsgHC4k
	 YTgZK+NA4FbtOPvII3WPpCyzavbKX/JzEQrNWPACH3R9zbwi80g07Id8LzXSqZI0qA
	 XeDCakto21NyxW8mc/Ah4kPWbN44ex8yuduxX0x/LfxndTlse8h0iZpnRAkc4dxkdD
	 M7zlLdmNJyjXqoDN6up1g19XFCURZKaTDTxLEZnGFEwkH2jVfMBjKIUVYW6d80oZvv
	 n61q0Jsk7359sqdPxgIsACW4h/VdvsQxALh1gUCIPjnTm00vDBBeh6j9fvinhdXP/2
	 SrmkfrlI5Pa1g==
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-304d757a9c1so4323891fa.0
        for <patches@lists.linux.dev>; Tue, 14 Jan 2025 18:56:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXhd/0A2lBnS4SqbN8/op0Qc1AnGJafOsYhsUui0zXzFpsJ0W1aKq4kFQ3wu166td74T1IdpjNu@lists.linux.dev
X-Gm-Message-State: AOJu0YxLWkpUi3xhflbsOcvM+rj+/NIEhqO+5Au0R6DWeZ8wtb4n2EFP
	UqWpBBI9H4Ebr339DPv88Sep3hgP5sCMEu3cVnPDy5u3lTBdvvNyaxxht9ManbjHK3Os3endn9+
	nG699uoys1uHkYupFHAu8yWblq54=
X-Google-Smtp-Source: AGHT+IEbKF7/p4jXX2Y6c4kqW+fI5K4N8QYbyrqp8XXUV/YZnWVH3r/4hFyXitJa+p0igPBJC9MwYK7VAnxehvdzjSw=
X-Received: by 2002:a2e:a544:0:b0:302:4a8f:428b with SMTP id
 38308e7fff4ca-3063068737cmr2821231fa.15.1736909765029; Tue, 14 Jan 2025
 18:56:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241112184455.855133-1-ojeda@kernel.org> <CANiq72m+k07miKu=vHfp1-A+nu092R+khau5b95Ugq8M8sksFQ@mail.gmail.com>
In-Reply-To: <CANiq72m+k07miKu=vHfp1-A+nu092R+khau5b95Ugq8M8sksFQ@mail.gmail.com>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Wed, 15 Jan 2025 11:55:28 +0900
X-Gmail-Original-Message-ID: <CAK7LNASXLdya8d2Cjo9H2j5J2d8ukj27aDNStqWEVbDQFgsP2w@mail.gmail.com>
X-Gm-Features: AbW1kvZlCoUAFxXw5sPs1DKJmHRvk0hzaEaGSs6dBB0CiAx9p8qI6YLajE6H3Tc
Message-ID: <CAK7LNASXLdya8d2Cjo9H2j5J2d8ukj27aDNStqWEVbDQFgsP2w@mail.gmail.com>
Subject: Re: [PATCH v3] kbuild: rust: add PROCMACROLDFLAGS
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, HONG Yifan <elsk@google.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 15, 2025 at 8:05=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Tue, Nov 12, 2024 at 7:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> w=
rote:
> >
> > To distinguish between the two, introduce this new variable to stand
> > out from KBUILD_HOSTLDFLAGS used to link other host progs.
>
> Applied to `rust-next` -- thanks everyone!
>
> Masahiro: if you wanted to pick this up through Kbuild or to give an
> Acked-by, please let me know!

Acked-by: Masahiro Yamada <masahiroy@kernel.org>

--=20
Best Regards
Masahiro Yamada
