Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4F917839C
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 11:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721991971; cv=none; b=C/ab/Ri/TIYiVA1Z41SZoVZ+Wxp7uJligVDUmlAwPQ8JfS/jQru6nsbXfvX1J7oOfYT603lha0FIcoXH50YE9nrytwimBjD/pmKmd1xib8eyA49pc1qLkNkqJd3cVwJemly1dReBx7HEpaQQkXUQdkwmVSm/QLH2TIdwWWGmgZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721991971; c=relaxed/simple;
	bh=/sVicTNfY3cet1chvNxxWo/ZPwMTD06+KwNxAx+VxkI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K5YRy/3mumHBalXdwDz6MTfTTl2e1LoHziHPUgMqyE6r2sHs/Fpc/hRxP/BPyhb171goVeeNuJ6hvCXCFgE490+XAg9xhnk+ek1CUHWau9gxy8twm/dsw0aQAROY25MzR4SVEH5IhVlYCBSCa+NFvUUNxwlZXae8wqAi3aBW2VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=VpPxe77f; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="VpPxe77f"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-39a1e26ca96so6767735ab.3
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 04:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1721991969; x=1722596769; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7hckkNbMLOcuR+z008FLIKbuIPv1ZZE1XmBUhRiJCWk=;
        b=VpPxe77fJ52HSZXvXKZMIAybU2kPxNxYYzID+Flsj8nLRkUlLzou3qMNa0Ta5Fpl8T
         cvgcXVddKlVWdbSGONN6mbw14nztV7XekhtkUQMbGtGprzzeK1UgCnFF0n6shZE6TEgA
         vusvRCXXWQGfdgK980edbmvNMtjyZYLw5btB45Wx5tW7KaEQH4I+TAmXH/6Bjkpf/x+V
         w80vZEmLW6uoaC84iM8nOiUczjiWatKjZjIuHf4hu1XDc29+qZ+mpKP6HcBc4BA+rT0J
         +HYrL1lGCNlmz9qfgZ61iZYEfGV2AME7sNI4dtn52b+lQBL0IunSqIPPR0kP2o7M4wUv
         p71g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721991969; x=1722596769;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7hckkNbMLOcuR+z008FLIKbuIPv1ZZE1XmBUhRiJCWk=;
        b=QXDQQblsERiABtHe4gi5E0cM8X8K5fHPgqxJOlVPCl7vRfibGQ5H4ZMwBfwPH49vjc
         2ss9DWP2ES4ZJqoHvGF6K1SAwxiOBjEohkm7nxdaXmm3avTmXA2ryIY0HuDnqZ6Nb6Ws
         g6lR6nl1joTvJOISLPSENbe3HYzO7+Bviq3YDEuhvuCXZ83qaH8WM5MGfQD6vSr/P0oM
         ppPVaKumOZZHdlRED86jnT5zct+cki3JozPWQyhc/m0Ne3HM5iuqcKFq42ZanZHKWhTi
         2zSuia8BpFhyMVTCmq4rqfWICRgS9Uuy418zFPnxCWly0kdDTyoaUq7Q48yqCuQbMzPa
         fpGA==
X-Forwarded-Encrypted: i=1; AJvYcCXDtT55tJMqSc1HIPWbsqlPUnTe9zUKqMdjNZM6WSc8/xebgWhjlvf/sw6JfRaxr9QgSP7s2se8BNtx669FuVSwVdLvzlcoYA==
X-Gm-Message-State: AOJu0YxSU8j7G3JVo+9xP+InkDhT6BOlYOhQANHByrNAWwly2RJtCumD
	PBrVDBHmM+OgSASTuX7YLLlz4U4ktiLfluyRwL8znrn7OkfjwsqzH+Tj5YVRX3b/DqltQ9Fe6o6
	4ySJi27wwWwCGl7cIBS7y3g6M0HeUVjpgDTNdGIpjD7605BnJZjM=
X-Google-Smtp-Source: AGHT+IH9Is6Tym8XF86g8B+5uO9SsdZqfsnltWUtIJEd/+7smiIsMguxwMrcSPqNtyBKCgcvokKKDTSPDuMXdsI3m8U=
X-Received: by 2002:a0d:cd45:0:b0:651:79ee:d14b with SMTP id
 00721157ae682-675ba704897mr56298307b3.29.1721991958488; Fri, 26 Jul 2024
 04:05:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240725184644.135185-1-ojeda@kernel.org>
In-Reply-To: <20240725184644.135185-1-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Fri, 26 Jul 2024 07:05:47 -0400
Message-ID: <CALNs47sFD_GqhXNa7v+eC=O96A+SpPm4QtZ3=GbSxZ4zkTm3Zg@mail.gmail.com>
Subject: Re: [PATCH] rust: macros: indent list item in `module!`'s docs
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 25, 2024 at 2:47=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Like commit e516211f615f ("rust: macros: indent list item in `paste!`'s
> docs"), but for `module!`.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  rust/macros/lib.rs | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/rust/macros/lib.rs b/rust/macros/lib.rs
> index 159e75292970..5be0cb9db3ee 100644
> --- a/rust/macros/lib.rs
> +++ b/rust/macros/lib.rs
> @@ -94,7 +94,7 @@
>  ///   - `license`: ASCII string literal of the license of the kernel mod=
ule (required).
>  ///   - `alias`: array of ASCII string literals of the alias names of th=
e kernel module.
>  ///   - `firmware`: array of ASCII string literals of the firmware files=
 of
> -/// the kernel module.
> +///     the kernel module.
>  #[proc_macro]
>  pub fn module(ts: TokenStream) -> TokenStream {
>      module::module(ts)
>
> base-commit: b1263411112305acf2af728728591465becb45b0
> --
> 2.45.2


Not much needing review here, but

Reviewed-by: Trevor Gross <tmgross@umich.edu>

:)
