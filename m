Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749C73FE4
	for <patches@lists.linux.dev>; Sun, 20 Jul 2025 15:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753023749; cv=none; b=Ls7WItSMEvTaZ0X9XbEu0ZwUT0QTSGtvFs/xH7qf2YHpGNegjWE7nfYDykogVStbD6PVidi8h0LdlyZ3zfzY/yMPz7ObXemZ1+wI5G9bsLgdEm6qE/UC2yjtnoxe4c4JT3RkShLK4PrnGID164QnrhLwNnhbcZ1GiRsiroBpW6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753023749; c=relaxed/simple;
	bh=+NU0f4p4nwF4AjyVPqBrzsnpMY/oszbnf1fJk84DbU0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ar6kjo2pKVNh5f4pCz9PO6ORLdfv4ZxnxSDI+0L2nN+1vwbIGvyo7OdiQPxrY3dZz1MsAlppuyHtIJFTeueCvnG2ExntTnZ7uhg0Lr4MrGlUc9Pk01LY8SXx4w/N8B8lJJYwWCh5QBLKFG3wKP0f+e6WOmc+bjMV3GE8EMg/Mr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YkWPb1hs; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YkWPb1hs"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ad56cbc7b07so572714966b.0
        for <patches@lists.linux.dev>; Sun, 20 Jul 2025 08:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753023746; x=1753628546; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yBq4s7IgvgeI8LlVi+Zh51XwjN6MneGpapQDOgcp+VY=;
        b=YkWPb1hs06zlZ6P3bW8PZbyk+WeCWdFQ1KSx6I07F+1t/sDfr/T8pieRxMygYevnxZ
         wK21MccMf43RSsHxA+3kPQvM61fW7kZmece8bK4o2TmBo0e5CO2poFD0NTRuq/89jkdC
         ZjD3rrDuwkqYZVVj3vT6NIukqQNWdVCleEvzLEm4zK2mHKeod951dFfZw1xBh52S5Gw0
         kn3k5RkQ90bKr9qUReaXWjhZolHcuyVWdXjyao7fj7sZzeVlbRzQlczvQIliI8uwBYhg
         /s3UANz2fJEUpXlJ57Fes/niSx4GZZ6OsfPxQ2IHpsqpOgkmOItLmzLRXNjU23Q54OgN
         +uPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753023746; x=1753628546;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yBq4s7IgvgeI8LlVi+Zh51XwjN6MneGpapQDOgcp+VY=;
        b=wTMc71cLLvyCqxeJP1+ppWYQHAVH0sgEIKAvkYm50L6oD5meIJQ3j5KYL5gjjZ7Trf
         cPK+Vntcz/IKqr36NMP2OaN2o/d30oK8frL5uqkWIJteCb2W8TYHm7Ia1HwP+h5ByLgG
         6ZJrDbxqbXs8S7oMMnZkvkfvf7DpyhQTxlh8BvuyhKYJkEGrl2Awf47Yq6WKMPYyzyFy
         JFxKi+dJ6cGQI455dGbVtOv7W4TTKIAu+B64V2cPpLnN7M7qPgJ1F3EsCseYSXwJ4SIS
         xN1CNAur2zUwXzjRzOlr2Yp2OU3O/yEk0mT0TBdUrk/DvBYoFOK8GkIghjNvQqsnNeQN
         Xhjg==
X-Forwarded-Encrypted: i=1; AJvYcCWEIKTR3AcNWuDNchDqSH/3YaI8jXQlt/cucZ2ylleTmg4PGc93py4ccBRM9WjI49WpXAIx5Hc3@lists.linux.dev
X-Gm-Message-State: AOJu0YyshPDRZ0u/OIm7UnT6H8Y1dBRka20QfW1EZDWuRwONOXMXTqxe
	Ehp7imAfBxj6W6H5tC3Lc4CecMRI3B29qVRpd/AdTnLHOnKq9q3AdmIss56sNafW8VZRSD42YMa
	2pblGgZZi90CDjDZjkcdwpfM8u/WiHq8=
X-Gm-Gg: ASbGncug+4SR2YFP47WVyBa3q6DF+dHQh+sESvmoiarPWsQbvQ5zpVtClsFyz4R+cni
	LSZnoSyc9Ts8dn/xNe3t5ocUaWGOL8VaUEIpBiMRsVIFB4JhyOTTLjcR8fQQ5CEvkZ+Nk+Rb+11
	YO8tJbB0v9mU3oB+j+85A/4b2WlTZaXFNIKu+14TA5gMClEgBh7MbVUIJsr58ugPqXsaxmW7gVS
	QGVAcPAkfPj7pfg41bSzQBIetB//uS6nssEchepZw==
X-Google-Smtp-Source: AGHT+IG0lJPkWuVauq9Kk7wmPfK+95V5H7PAaLnR7rtecUWMdjLuVrjjOvS9g7KVdGyT92YjJl9LNkfMT+/MgwTDuo8=
X-Received: by 2002:a17:907:1c17:b0:ad8:ae51:d16 with SMTP id
 a640c23a62f3a-ae9ce198bf6mr1743464466b.55.1753023745422; Sun, 20 Jul 2025
 08:02:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250719232500.822313-1-ojeda@kernel.org>
In-Reply-To: <20250719232500.822313-1-ojeda@kernel.org>
From: Tamir Duberstein <tamird@gmail.com>
Date: Sun, 20 Jul 2025 11:01:48 -0400
X-Gm-Features: Ac12FXzqgH4mx0bfYQ1wCS2u-3aY2us21hvNcois8QEn62EbIRZeMeCNHcEFquk
Message-ID: <CAJ-ks9nq0wC2xpAr_AiSFa_hD+ss1DSvy-Uw4NG66E_1FaYCag@mail.gmail.com>
Subject: Re: [PATCH] rust: list: remove nonexistent generic parameter in link
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 19, 2025 at 7:25=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> `ListLinks` does not take a `T` generic parameter, unlike
> `ListLinksSelfPtr`.
>
> Thus fix it, which makes it also consistent with the rest of the links
> in the file.
>
> Fixes: 40c53294596b ("rust: list: add macro for implementing ListItem")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Tamir Duberstein <tamird@gmail.com>

> ---
>  rust/kernel/list/impl_list_item_mod.rs | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/rust/kernel/list/impl_list_item_mod.rs b/rust/kernel/list/im=
pl_list_item_mod.rs
> index f4c91832a875..202bc6f97c13 100644
> --- a/rust/kernel/list/impl_list_item_mod.rs
> +++ b/rust/kernel/list/impl_list_item_mod.rs
> @@ -17,13 +17,13 @@
>  /// [`ListLinks<ID>`]: crate::list::ListLinks
>  /// [`ListItem`]: crate::list::ListItem
>  pub unsafe trait HasListLinks<const ID: u64 =3D 0> {
> -    /// Returns a pointer to the [`ListLinks<T, ID>`] field.
> +    /// Returns a pointer to the [`ListLinks<ID>`] field.
>      ///
>      /// # Safety
>      ///
>      /// The provided pointer must point at a valid struct of type `Self`=
.
>      ///
> -    /// [`ListLinks<T, ID>`]: crate::list::ListLinks
> +    /// [`ListLinks<ID>`]: crate::list::ListLinks
>      unsafe fn raw_get_list_links(ptr: *mut Self) -> *mut crate::list::Li=
stLinks<ID>;
>  }
>
>
> base-commit: cc84ef3b88f407e8bd5a5f7b6906d1e69851c856
> --
> 2.50.1
>
>
