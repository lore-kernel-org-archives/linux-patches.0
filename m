Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A73822D4DD
	for <patches@lists.linux.dev>; Wed, 19 Nov 2025 18:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763578383; cv=none; b=trUf16PD1rhVHu6ZUHtACNMNHGy94bv7rTradTVippBBbU2Gx6gVu4zp1UaDmoij1ugkC23lG47lNSjDRfYyP1K2ZLNJn9aKa5s+5A8ZOW7xuCmiYxd5aktiLPuRCvNmj2cuelLKUONh3B6I80JHwuaEiQF+CgM0t5Xa2X0s0JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763578383; c=relaxed/simple;
	bh=E9uXQ0JY819H33SH9I6LfIYFKn1vAPEt83QJBC4E+Ec=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xv5j2+ZfCpDpeBBp5WrZS6HbNDEbppmLSkGeBwLXMAujKUFlrlz7UeHqQvZyuFWpaDLVeDObFRGpeusAQyuK6EqlfFY7G8JHFmt1RTpvDF3HyIEHzte5atj3yKS69NIVuZU1ipL+wFLdTiitueJtYHmxtfTWHdhAZADEo3s8z1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F8zW2zOD; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F8zW2zOD"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4779cb0a33fso1090025e9.0
        for <patches@lists.linux.dev>; Wed, 19 Nov 2025 10:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763578375; x=1764183175; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t5iwDg8BxWRb95mMBf2Hf9zvj5pFB121qLoC8B/rNF4=;
        b=F8zW2zODq405iz2uytMdmEyfX4DAAN6wnkUfaka1Du41Jnz/UzYN/NDYR1xuhvfyqg
         iuhptlDUvSYYGH0RTpafAr/0qaXEV1bprTYEEhwvpKtc/01OtEzIiqL+0IFXMNJ1IqOa
         qrAgtiv9rDMmVxToA83CdoUCjY8P7Zkshr13vvq2cvHk4m18fgh+n5ukwdfTYMoA/jIB
         /PVcb4dwv/eK681S4n05TFx6mH/GEdk3muzYcXRSkOxMBgb8cY6hjQLvdFcEY9a+M8xr
         V9LJfzdAEPkbygl9djKRafFCZy8S/yXcoZENk8KY1WALxWLJcUFteiJrrEb/UC897X8o
         e6Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763578375; x=1764183175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t5iwDg8BxWRb95mMBf2Hf9zvj5pFB121qLoC8B/rNF4=;
        b=WIjdyI73UF1Yx3DcEa7cIfTOu8Zwz7zDmMrMYPAQ0bPiR76cr6V/53eUtEth7JbE5B
         cd4avub5PvSvo9O/2M4VfwBtR1ZBDqS3QKptxshZpO/C3k9MPucGwxa0anr6CIx23n7H
         pZdmbINch0b/XPyXwpvveEb4eN5wmukEAv7ua6Ouac5GhKyCuDMY/HSnuLnCS1HV89OQ
         96kJb2SgyrzLikazA4LuJ9dWAZV7H5mCKEqkoakacPWYeeEXMmlDJQaxTXit5ebmFIun
         uxOU3roYxWDrsAFNS7nKVYa0iFsHDjK85qORcRtoRqaaCZpo++ccGyRD5OR0vG2kNRPj
         z3Sw==
X-Forwarded-Encrypted: i=1; AJvYcCVZD+3hmy5/jwwBdnJG5eHQcCoj03ndOlB7GmmpB1bt/fQ0sRA+pIagwZDUcr7TlcjGUgw23sK4@lists.linux.dev
X-Gm-Message-State: AOJu0Yxe4+KUIHK8asFtmEGNnqMb7LvbyekWd5mqkxAad0x1Qx8uPafL
	YsNWdckt3wIJem+EtdURUuiP4s33ign3HkZhC8CfCA/stEawStDQyjE5KdnV2iRmoSe4HOdNp7g
	gfLtRiW+UAsCEph11OuQmZq/hnolNE5MZGRkwx5ar
X-Gm-Gg: ASbGncuL/q+3gEbJXG1U56unApyZS3bfP+Ad/e327xAzfsnfkGNwsDkrhUPq0LqMvus
	H+Stz96qf8xgeM4/xIYTgiXh9aOPSNBr0E/yDLoeGtt+fX74xm9ioQ8qiylDNKzdRrdh1zjmObV
	lD+WxDV81nVCsCrbUpJhYa/Xvm/m2Ar9u/9wvSVznMmbPdPdWMy+m/rOojjDzm2eH0UZ/V713hG
	Ot+8ZuLYIj50Ig7+vukPy6UqiOR37pWv6Pf2Ywg4EwCsrLQ6yLVMvj32k9Txi1WyyhWBJXA
X-Google-Smtp-Source: AGHT+IGUNWPDbFQdc/ELVI+iQclDYjmS6WRirf5qm5wL5IsXaluZQRoAAg/BbUachfaqe2TairnalVTD0GVTqhqTnmA=
X-Received: by 2002:a05:600c:314e:b0:477:755b:5587 with SMTP id
 5b1f17b1804b1-477b8953b21mr2763095e9.8.1763578375141; Wed, 19 Nov 2025
 10:52:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251119185125.1411151-1-ojeda@kernel.org>
In-Reply-To: <20251119185125.1411151-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Wed, 19 Nov 2025 19:52:41 +0100
X-Gm-Features: AWmQ_bnL48xO72RE85Z9tspjJcOF3bjKk-8nMyZ8avtpWCtpTyo0amoZN1QcsSA
Message-ID: <CAH5fLgjYhX1jnnSbNX-euXBcdwj4+TN6fiBkr7GbM04GTaq--A@mail.gmail.com>
Subject: Re: [PATCH] rust: slice: fix broken intra-doc links
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Danilo Krummrich <dakr@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2025 at 7:51=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> In older versions of Rust, the compiler doesn't know about the newer
> `as_flattened*` methods, thus `rustdoc` complains about the intra-doc
> links, e.g.
>
>      error: unresolved link to `slice::as_flattened`
>       --> rust/kernel/slice.rs:19:23
>        |
>     19 | /// [`as_flattened`]: slice::as_flattened
>        |                       ^^^^^^^^^^^^^^^^^^^ the primitive type `sl=
ice` has no associated item named `as_flattened`
>        |
>        =3D note: `-D rustdoc::broken-intra-doc-links` implied by `-D warn=
ings`
>        =3D help: to override `-D warnings` add `#[allow(rustdoc::broken_i=
ntra_doc_links)]`
>
> Thus fix them by using an URL instead.
>
> Fixes: 88622323dde3 ("rust: enable slice_flatten feature and provide it t=
hrough an extension trait")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
