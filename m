Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA72139D0B
	for <patches@lists.linux.dev>; Wed,  4 Sep 2024 21:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725484528; cv=none; b=jyCzYSanZ5fIAEv2E+TGK0SGf9ldvY8fEB9sBILwTNFco7wa2rK2DGDN42MMEhtVUrcVmIMnDiPrgluVvsyvj8N27hyfJg66t4twFI2UIfQ3zq1tB9Yaff5pnGAFz72L/RBQZGdmu5wEESyTfjtd0S905G1gxwH63KGuUgFi1Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725484528; c=relaxed/simple;
	bh=apdfSNyJqL10mkLY3LtYTC/6akJ9hEvc4z9zKzdH9xw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=scSDStBY6WvJV4OC+Q7EN2ZYPM66+ZxwgYOGUa6VUO9TscI9BnP6NTT7oqiceYLEWjcGRpIFeACvxG8LQV62vCLieP67kUnWo/pXe9v0qf9p60EixFHfgJKK+vlZdkkV9uRRuhrzVSNFFhvn+ESZRzF8EaOfoKFqNNCpeOYZwkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mhx1odYx; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mhx1odYx"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-20699ab963cso112375ad.0
        for <patches@lists.linux.dev>; Wed, 04 Sep 2024 14:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725484525; x=1726089325; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e2NDtCRBACEs0nrvdhkLL8awIsNK1GJ2z5Df4VJoj54=;
        b=Mhx1odYxgBT8F5q9sZ8ybAeuVKQbnfnhup1fa+74WLGZ5rXd1APOey6ha0/wvHcg4B
         hWrh8wnwkHSQlwE4OWFx30E34/e1tUhldvxHyNt18+Jq+BClwVN7eRPoDaRukCLEM7Sz
         Vf1X14w0FPy/Tm5oIThbebA2Up136kYb42OaMiFdYKkSTl1NufXeki878mnKUNIoGLXF
         HF/1B4J957ROFSW0e6vwsy3+9RBaRJW7FSqqK+UozlcLZIAUiQWu5mwAoFLUvbFm8Lyx
         Oa0dT8OhzblWDYAern2sg4QI/8H5Q3uUELhVeJQm4T+mZquSO7eYd5XdpOVLUPzi6Lyd
         4ngQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725484525; x=1726089325;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e2NDtCRBACEs0nrvdhkLL8awIsNK1GJ2z5Df4VJoj54=;
        b=S8XJDU6QszxIfSRy1a7H2KvrBQpAIey9yMxywA/uof84ajzsALcbGOzwds+CGoLjRC
         hofFCHEL4FtzCw4i92U1xVmNUoHZs/i79tMfSqgR7jrKllzpqiVMsonG0VqjzRIArzVx
         qGOAC5mKZg9qZ2xx69JxSVRW8JGSLJxw3eGw1Ztc9ETPSiqXQc1+XT5o1sqM2Ghv1Pjf
         7bUqoIVe28KGaw1QMttLzLbe/tveDQQNRD7/p5inpxRTiX8I0Wdb1rFrnmFAClkX1z7D
         8v6KyiPaYVjSXOs9XUfkLkZgYTCY7hiXh5lA61kBqH19RWfRPsKxZw5pJXiQpDXYV2RD
         mdMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWaibxdAsCP84C++uy69dEvgTfDsWPkUykGPHlvj5VqWEXkNR/HcckPlVmaCDuVzL4fTQrUxbf8@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3U/K/YlAipay50c1uhQBFUIf5ff9Lc0lxi7gRvpdpE1001Nvn
	5cBWxxkCfHjbh54uRYA8Uyvee7AfQOkVhNVVue1V7oDcR8rpCbxL5SWnoDuCVMpbTqgUT5M3/Tg
	hdAqn4g4ilzqBWrziSzPPPAaVlG8=
X-Google-Smtp-Source: AGHT+IEpNZEnODRv2C3k3FWwEmmvU2X2wTQwZbNIghh/NH54H+1xtdzyzD01T3Qjmc1g/hyeUwaZTvpQBnPEGBJIh6E=
X-Received: by 2002:a17:90a:ee8f:b0:2da:5aa5:5d5b with SMTP id
 98e67ed59e1d1-2da5aa560f4mr4434871a91.3.1725484525023; Wed, 04 Sep 2024
 14:15:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240902165535.1101978-1-ojeda@kernel.org> <20240904-cordial-zircon-grebe-ba4806@lindesnes>
In-Reply-To: <20240904-cordial-zircon-grebe-ba4806@lindesnes>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 4 Sep 2024 23:15:12 +0200
Message-ID: <CANiq72nEoJd4dJxt-OP6DHL=KgbHNtbDdd-fUPz2KcCOQDqBNQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] `RUSTC_VERSION` and re-config/re-build support on
 compiler change
To: Nicolas Schier <nicolas@fjasle.eu>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 9:32=E2=80=AFPM Nicolas Schier <nicolas@fjasle.eu> w=
rote:
>
> the whole series looks good to me.  Thanks for the good explanations.
>
> Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>

Thanks a lot Nicolas, I appreciate the quick review and the kind words.

Cheers,
Miguel
