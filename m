Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8AD16A949
	for <patches@lists.linux.dev>; Tue, 30 Jul 2024 17:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722362116; cv=none; b=kdGGVuOatIA2LsIEBNMzQyEz6PSRmow9VDhAftmPBB0kPWFzcT/GM9DguTBOjShZLFlhpZDZscfEmVd9AtO+uMGcO70Xj8Rv/VhcM7frIZ5xm4JfU5CTA8gl3HRDXkx0F92NbATYZkhF2hfzkJ53WoRTVVu4wzlxSykCFaHQHyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722362116; c=relaxed/simple;
	bh=JH2Cd2lN6IoitPNPrBTESvV7VWxwDFLNLbMvOE9YGkQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hXZ0IRAGlm+sS/k6tEPhmPUWbYz/6IOQKEromWDrc/RwAEuMkJMBQ3mSDdyj1Cizj3uo0kQHxl9GUCQp2GKXjNRlyAfSY9qd+Lq3SrXBF2OCAXZjibQodtJ4Fg6w8tLXMM/7i/zPy0YLoLJE7T58Nxq9ryAWtq6poPWr4SvhU38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KsgeJqZc; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KsgeJqZc"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3687fb526b9so2253696f8f.0
        for <patches@lists.linux.dev>; Tue, 30 Jul 2024 10:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722362113; x=1722966913; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hZVb9b6idPdGqOLlS0LbFKJPOJQMfcfymuIDhlC2e8U=;
        b=KsgeJqZcdBSOnmly9besvrCrBWYfHBHC5JmB+j2GvGkaH7R/EEVDxFliWQrmgvfCY/
         xVQI1WG5qu6LlHK7bVGpp7Uo/VlmjdkuCxLLxuO2DFMgiXMNFiiUinSwGGMD6xoHZo/N
         FkmJ6PVouHF6RJL/3IEO5F49b6AZtVFIo5qcvuvCbEIANkNllq7T5i30TcP+gVJ04rNa
         T+AO6C2Ry7EcTRYkjmztTK4BeNioxV2zRt/NrLlraZQvng8aTAUtbZmdAJ0BvfDQeqeF
         9fmBEg/Y/QFCUAsQiWfXi3wSQIP0mSEaJp/3macjQP5U/L4l2Q1FCKQhDsGwf7EAUS6W
         RSIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722362113; x=1722966913;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hZVb9b6idPdGqOLlS0LbFKJPOJQMfcfymuIDhlC2e8U=;
        b=dZPDrHy7x0tg29B3M2QWv7jxae0ydobMhAZsFs/qkBm47enRoSa6Mv7dG9KF7sj3dJ
         wkmjF8OhRq0QaXG8kD/nt+rU4fmuRuFPB9lP/A1KdwO8bI5H/jSRg/J664TahG6rRLKm
         edogNzL29xBtjQozNPiWpgB6nqwMho30KvTYJMZ1yuccVptxV/Y4AHTkkX84W5psBfDC
         D/xdMYDiHsSliMZYwUA+e5XoPi+KDjXjpPRLwvShZSDnVPCmyiLz6GXPuLccmo8KLVOC
         JUmE53OYgRfVoN69itjUZUAdXFmrywdvl0k11N7R50OyejZf0p4vNsElkjJAzrijoj+G
         U7Xg==
X-Forwarded-Encrypted: i=1; AJvYcCW8polLnGH4hzz0fNgK7EpK1slcsOV2AAnEYpiDpCq1d07HFhMZKPTvesN1OGqVUr+9X9OaiAoir56F4BbHyqFf2n15jKTLfQ==
X-Gm-Message-State: AOJu0YxOFlKLGtLBsNUilI6LrcxG90BKaWCg/4rAj+JCinvSiYo3amKJ
	1S5Sz6v7uDXc3Yx3gK/pJAmak+sgsxZf6p5YVaRl11eJkjWjadLXH+HSZ9NrJ5qBCyhNKL2Ijlk
	DUBzangvpZc6nTlXZKiWynIZQnfZrEM7Fq2cy
X-Google-Smtp-Source: AGHT+IGmM1tNNed7IrynwbRJCkV3w6w+USTXC/B0W7HVIfMnsxonH0cqX1VcweXyc+Pt8fczaIJn3PMNd+t6XksY8VY=
X-Received: by 2002:a05:6000:1e47:b0:367:f0f2:66c1 with SMTP id
 ffacd0b85a97d-36b5cee9ddcmr6956783f8f.12.1722362112425; Tue, 30 Jul 2024
 10:55:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240730155702.1110144-1-ojeda@kernel.org>
In-Reply-To: <20240730155702.1110144-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 30 Jul 2024 19:55:00 +0200
Message-ID: <CAH5fLgj-0EsVjh8xdV1mXZBXPxKGnwUa8-R+Bg1eyjh0Gh_BWg@mail.gmail.com>
Subject: Re: [PATCH] rust: error: allow `useless_conversion` for 32-bit builds
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Russell King <linux@armlinux.org.uk>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Christian Schrefl <chrisi.schrefl@gmail.com>, Jamie Cunliffe <Jamie.Cunliffe@arm.com>, 
	Sven Van Asbroeck <thesven73@gmail.com>, linux-arm-kernel@lists.infradead.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 30, 2024 at 5:57=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> For the new Rust support for 32-bit arm [1], Clippy warns:
>
>     error: useless conversion to the same type: `i32`
>        --> rust/kernel/error.rs:139:36
>         |
>     139 |         unsafe { bindings::ERR_PTR(self.0.into()) as *mut _ }
>         |                                    ^^^^^^^^^^^^^ help: consider=
 removing `.into()`: `self.0`
>         |
>         =3D help: for further information visit https://rust-lang.github.=
io/rust-clippy/master/index.html#useless_conversion
>         =3D note: `-D clippy::useless-conversion` implied by `-D warnings=
`
>         =3D help: to override `-D warnings` add `#[allow(clippy::useless_=
conversion)]`
>
> The `self.0.into()` converts an `c_int` into `ERR_PTR`'s parameter
> which is a `c_long`. Thus, both types are `i32` in 32-bit. Therefore,
> allow it for those architectures.
>
> Link: https://lore.kernel.org/rust-for-linux/2dbd1491-149d-443c-9802-7578=
6a6a3b73@gmail.com/ [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  rust/kernel/error.rs | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
> index 145f5c397009..6f1587a2524e 100644
> --- a/rust/kernel/error.rs
> +++ b/rust/kernel/error.rs
> @@ -135,8 +135,11 @@ pub(crate) fn to_blk_status(self) -> bindings::blk_s=
tatus_t {
>      /// Returns the error encoded as a pointer.
>      #[allow(dead_code)]
>      pub(crate) fn to_ptr<T>(self) -> *mut T {
> +        #[cfg_attr(target_pointer_width =3D "32", allow(clippy::useless_=
conversion))]
>          // SAFETY: `self.0` is a valid error due to its invariant.
> -        unsafe { bindings::ERR_PTR(self.0.into()) as *mut _ }
> +        unsafe {
> +            bindings::ERR_PTR(self.0.into()) as *mut _
> +        }
>      }

The formatting here is a bit weird. Perhaps we should swap the cfg and
the comment?

Either way, it looks good to me.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
