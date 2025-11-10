Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCE82E62D8
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 23:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762817661; cv=none; b=RSWkOvS8SUeo0seNt2StNH6rdTUM7Jt3aX3loWygtyyWmHJLDnj2dBKF7B9Uit0ZnzoVKpEDtNv/Yp1a70wwWYToxn3xYKYXNrAwWVrpkfAiYwl5b2azHN0r5xZCi+WzXhVGKnJWw4MQH8b+rk7ASidtot/glIIUlD9Kf5lL8gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762817661; c=relaxed/simple;
	bh=K/cQ2C7Ez8KzP7o1OrB0lJTjPYc31Lv7MkdeLsPQ4ZI=;
	h=Date:Message-Id:To:Cc:Subject:From:In-Reply-To:References:
	 Mime-Version:Content-Type; b=EmF9Dd6x7cLBha56AOwI7FcDnDL8IovPeibCQJXMX5o5oAwDNmOzwHuxtYXqWU6EHm3nFDzdMcnyuQjtEzizlDVadIJjQLK7ppkGULkCKQhQYPgFo1IUXddhYHVyJSYiq1rl0/Pq74JGvfXPF/b9ivLL5fHe+A9trFseycJmuZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bcjSANnn; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bcjSANnn"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-297f8c26dc7so19215695ad.2
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 15:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762817659; x=1763422459; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Oy2n9G+dRBzJRRG/yf89aQd7NFJbeGk8QhHqO60fK/U=;
        b=bcjSANnn4RYxvJmipocdecZjNaOhPkE1rgpJ7lACTW2YKHntSdvL7Wx0BmI2awcqeL
         H42egr3fXk7M8OyBcI3E9S84TCGH1JfsEYpbAPUki1FXzRmpkBkewdb1FLUqpeKhBxHL
         Bv0cbimqEH+sxB9Avt+t0LIoTwEubdfakag3y3kQ+BbW3glBIoJJC1PulyexitJhmxP7
         hF6UHWYHD/rTORgTAeCuhNgw4kg9YpcN+buUGHNQ04ziPaIVB7z2f8gOipSfx25O9G/H
         gxyQQb4Oe46uuFmca3862gmm/4i+TyUWOc8l7eAtd4Pt+OcgtEaqIBo6D+gw/J5h2G7I
         ajiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762817659; x=1763422459;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oy2n9G+dRBzJRRG/yf89aQd7NFJbeGk8QhHqO60fK/U=;
        b=eF/p6P+XZTuXxGGQ65hwTxYGUc0XZgFCHgIDSYSM6PZ/2KIdJj65iECnjXesStXPWC
         6TFwiJkxUR8uWNmP/ujzz7IeTTSbb6AFNDcEBcvlzPfqEyBkcMBIHvNctKwyWRKxAzGl
         VuTlqUNmF5GxtH0iBMuAcPu0NCoEJkLkKpMAIVSSNXf4jlobXx5pAWW2NH8o+gWGBi8X
         VLnOXqc5ovfn2PywuCC9Jf7nLabxw1ylVvL6DfFk6hHfCEcTjUOtNyU634lgLU4/X9ot
         vTbvDCTYaOPr4AHquCOhu760lr/JB8HrCZrhqWj1mDzDm5/JwGSEYWyFNVDVCMx8KEsQ
         WSMw==
X-Forwarded-Encrypted: i=1; AJvYcCUkt5NJ7Tlpqs6AsBiNYXYuC5BHfA/S6EIieWFcvDXLLnpqmMuX2/2UYJ6Pj59axQs1XdJ3dbwB@lists.linux.dev
X-Gm-Message-State: AOJu0Yzhv/3ujlp/N+ZuINFWzPhpKvr1cNNiF4GyoJ7pwNBE6yK8SKB9
	tTdM0QajkqcLV6+CZhxwPvlh3/8JbSpVwvc6ooibodBAw3xFPZWMy2iFgcXiNQ==
X-Gm-Gg: ASbGncs33d16TnPhxEeByWLAkQN209LVFyQkUhEkjbpPzapFQeDxH0QpEF3lUwR9SzY
	/tHHL+XmqUfLJo3ERUKgbzIgggINia6wh9iPr2SqXiHOJN1wzcuzVs3Ezxo8toWsc/dzcZ21vcG
	vp84kbaAPbIEWw7IyyEt0AzgH5RdI4UnvuNQ+WslqcilVUkDIgExKRyjWi/PsiRP6yNMZ2Ke78N
	CFo9v4x4BwzWx9OAYlfr0o3TZ0XRgCm/cpkXElIH0gVT2ALWu708gSdABLTeJBuHp7GLY0U8YYy
	gnf4JUWIexgZSxV0rV2EiwpRxpqneSWpIlLPZPRxr0x/BS5yhDRlajRY9cNjtQWKyxKvNqVDmFl
	cT0WR3o3UBIEFf+pZc0kbEfdQU2KEf2e5ytQJSXa5aVI/IdCgS5FMoSNdAcClyB7zGlFYiW1Jlt
	N0oLlRwdozfzOeHOAw+AxEr+oOoCiqAOFpFQi2yqyTBh7exkiC/kSzH3SuAD3sAAQKup9hwHS6y
	8M=
X-Google-Smtp-Source: AGHT+IFfD56UHqe8xJ4zib+kMNCisvMUrImAWMr08SYb4N1rj4ajxA2f4+9t3KbkudcD1BAlAqplWg==
X-Received: by 2002:a17:902:fc46:b0:269:4759:904b with SMTP id d9443c01a7336-297e570bf23mr118686635ad.58.1762817658918;
        Mon, 10 Nov 2025 15:34:18 -0800 (PST)
Received: from localhost (p5332007-ipxg23901hodogaya.kanagawa.ocn.ne.jp. [180.34.120.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-297d4c54be0sm108297385ad.103.2025.11.10.15.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 15:34:18 -0800 (PST)
Date: Tue, 11 Nov 2025 08:34:13 +0900 (JST)
Message-Id: <20251111.083413.2270464617525340597.fujita.tomonori@gmail.com>
To: ojeda@kernel.org
Cc: fujita.tomonori@gmail.com, alex.gaynor@gmail.com, tmgross@umich.edu,
 netdev@vger.kernel.org, rust-for-linux@vger.kernel.org,
 boqun.feng@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com,
 lossin@kernel.org, a.hindborg@kernel.org, aliceryhl@google.com,
 dakr@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 2/3] rust: net: phy: make example buildable
From: FUJITA Tomonori <fujita.tomonori@gmail.com>
In-Reply-To: <20251110122223.1677654-2-ojeda@kernel.org>
References: <20251110122223.1677654-1-ojeda@kernel.org>
	<20251110122223.1677654-2-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

On Mon, 10 Nov 2025 13:22:22 +0100
Miguel Ojeda <ojeda@kernel.org> wrote:

> This example can easily be made buildable, thus do so.
> 
> Making examples buildable prevents issues like the one fixed in the
> previous commit.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  rust/kernel/net/phy/reg.rs | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/rust/kernel/net/phy/reg.rs b/rust/kernel/net/phy/reg.rs
> index 4e8b58711bae..165bbff93e53 100644
> --- a/rust/kernel/net/phy/reg.rs
> +++ b/rust/kernel/net/phy/reg.rs
> @@ -25,7 +25,16 @@ pub trait Sealed {}
>  ///
>  /// # Examples
>  ///
> -/// ```ignore
> +/// ```
> +/// # use kernel::net::phy::{
> +/// #     self,
> +/// #     Device,
> +/// #     reg::{
> +/// #         C22,
> +/// #         C45,
> +/// #         Mmd, //
> +/// #     }, //
> +/// # };
>  /// fn link_change_notify(dev: &mut Device) {
>  ///     // read C22 BMCR register
>  ///     dev.read(C22::BMCR);

I think that some code begin lines with # for use lines in a "#
Examples" section, while others do not. Which style is recommended?
