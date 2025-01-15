Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6848570801
	for <patches@lists.linux.dev>; Wed, 15 Jan 2025 15:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736954765; cv=none; b=fXDkL8cEBthJtzO2flT2L9Uu51yRqMk9+yoJrRFRQR1RUUli73n95fxkTWyBJajGw4XTx5OqXIMXXZw3bNMAd9bIpTVHOtw0yZLQsVMjflXWkSChDa/6hBSfI0FE6OufS6VTbwpc1VpkW6JVXdb0HeH/veFGpkARbjwArQQx55c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736954765; c=relaxed/simple;
	bh=oS5Bu0PKeMi1oxl+u86jkjs1sd8YAhS/wSqvsUauqe0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bEgXtiZtwOhK1AwkZC14iSNgn7fj6H8w1YoJXe5o7Gk65Rwqx2XM07RuUmSCJzaRgLlXX5nlZDCFrAJo+rTBqFcyxtYFhiikY1+HRBxmoYU11NwCUMW3lYsJZ+k2ln2NDbs3GajsPMeUq+sOcXnp6EsRps1YATsxcwYa86jNU8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WrktSgCk; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WrktSgCk"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2ef6ee55225so1393043a91.0
        for <patches@lists.linux.dev>; Wed, 15 Jan 2025 07:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736954764; x=1737559564; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oS5Bu0PKeMi1oxl+u86jkjs1sd8YAhS/wSqvsUauqe0=;
        b=WrktSgCkHAXrMBYvlwmZGtawqY4hK25zLB4VQEg3aXvg+DXaw69k3QCAFZe3N5NSG0
         nzmAkUYBwrEyJqr5dF+Uowlg5btzJoREYQCbcBFa7qQuF4rr+2gdnln/XoS6FnhYOmxt
         +Vsq1vpp+MqF/PiO4MM6cQitZ4vcFF5XKgrLt9Acc4VORe4+FzLrDOvQBmc9/RBEZryu
         iuI9R6VCXqs2MzCDE1Kk+xC3UhgcP4H1c+SrKWCXe7FHCchEPsD7S/kScwQSxUeTYvuU
         zr3xso6Gxokhe+c8F70kGK7TkSx7VEgR4rwQus4Ds32OhHpFM9Ow0R+jA4ZcoMeFq9sM
         GXLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736954764; x=1737559564;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oS5Bu0PKeMi1oxl+u86jkjs1sd8YAhS/wSqvsUauqe0=;
        b=ThhyMBpauDsOIpV8mvuf2PMeJcM/CRnpL6DjDfYU2WEk2KOEmB4zdkTbIUIyfmzeQy
         cxzmNgSICgTF2m/Zj2qAPQv00e2GHTmD5JNp9u3ntGuMFIxC+UPqrEmARwoW7WqQHT+v
         P8pyQ4WqGn7PW2cZMhzJ1cwP/yQRw+NWoRM/8DG8CTiK19iM5H+CaIIfjnHA2HsVnqvc
         Vgwb8Ax2e97fABn0B44gaRYqiC4FxhLASDS4NlTiHvrR5rfuUk45HOhaIw+WbYiz5Zxc
         cS0VQ+Hl9TkGToni7YtgORZlZjfkHOvQMYEu+810VW2foZcrLfu9Wymc5hNBBaHc4aNA
         +T5g==
X-Forwarded-Encrypted: i=1; AJvYcCUmmnYuTWyC3oSA7ZXvsD8wReu85g6e3fKnmsgiH/lxBsEtDCWwVeoA9bvWtPN0wsWoP1+bbv+a@lists.linux.dev
X-Gm-Message-State: AOJu0YyH/kvwSqk9C1QoSoHjBdIGfj/G513lxtVuWaRNRRVn/2/l8flF
	LxkazuqXlKMPOpCoU/fd8fXySmbZN5/uKGmz5fbu0LCJ9gw6HNwy65CiQ5edMg9eBCcb+FpDdrR
	hUFN26tnyKLYdSYw/hIxHm0utChI=
X-Gm-Gg: ASbGncvNhT80kPxMFB8Bv2F0n8VGD5TME2otOP3RLbSDUBORUSJP2C/HxyRegrDj2A2
	Rnqv+Ql3UTNpDeUrOrE5EfEKJNabFpTZ5i/mS6Q==
X-Google-Smtp-Source: AGHT+IEuvaHjinrYdSDGGIHqYQ1y21shSye1Mm1xAH9Bg2IFjYO6qBwnOAGewySKKnoaj5WrOGhqbHAClvlRG3RF3c8=
X-Received: by 2002:a17:90a:d88c:b0:2ea:c2d3:a079 with SMTP id
 98e67ed59e1d1-2f548f3fc41mr16367753a91.3.1736954763662; Wed, 15 Jan 2025
 07:26:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241112184455.855133-1-ojeda@kernel.org> <CANiq72=BvnriScFay8SpLNe9mNhjvGsBJ9W9UtdzU_6v_i+woA@mail.gmail.com>
 <CAABy=s12gOZadhYC+=6=TbbyN9j5L0B19ZLSGR_VFEdt1jhwEA@mail.gmail.com> <CANiq72kQKGG7j61bpsORnE0vzNo_dzwMZMLx=Z0xOnY0wefv6g@mail.gmail.com>
In-Reply-To: <CANiq72kQKGG7j61bpsORnE0vzNo_dzwMZMLx=Z0xOnY0wefv6g@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 15 Jan 2025 16:25:51 +0100
X-Gm-Features: AbW1kvZUpcYldFjbwOBXy94o_6lTFAyj-QS9S6GkQe2OruPN52aGDmHoW0Pxiqk
Message-ID: <CANiq72k3YfiEGT6JV5semYJWn5St8GMF3nhDW0Bt6rX1z+oDng@mail.gmail.com>
Subject: Re: [PATCH v3] kbuild: rust: add PROCMACROLDFLAGS
To: "Hong, Yifan" <elsk@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
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

On Tue, Jan 14, 2025 at 11:46=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On second thought, #731 probably only applies to `rustc` native flags
> only, rather than those that are passed to the linker (e.g. if I pass
> a dummy flag, it is passed as-is, so I doubt they will start checking,
> and probably they shouldn't), so it may not help here after all.

For completeness: `-Clink-args=3D` appends (and is allowed to be passed
several times), rather than override. Moreover, the docs say so
explicitly. So it is unlikely that one would change or that #731
applies to it (i.e. as a whole vs. individual options inside it).

Cheers,
Miguel
