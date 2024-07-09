Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9A927713;
	Tue,  9 Jul 2024 07:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720510421; cv=none; b=Pi6/NQWEqiSwENfEMZIFTs1wCbp51GIB1SfgAwftfy/HNvTvIHqZD5Ce/bQJ3rVLTRGAj9zaA8d7ZcspnT91HCIiTRK1WnlGKF+rqU86KtRvHiUYgB3AQ9nEDlaI1Awazw0qoHgpHExBBRFULWyCgUMAaVB72srucbATX2xDf64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720510421; c=relaxed/simple;
	bh=klDpcD1FMiSPwckMUv/XYdW7oQQyHXH58rQmFc+F2uc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dLhEwgIJqG/xDueC/Je1GGe6nsMX05O+HeokW3azkTBeH/U7PHcRDjwXmULeM9BhBykJ1FXhzOkEM61Gy8dFnvQpARRBkZBSbuYwEvDAxI3YMd56xXdZSI+A5GczHuET9dezBVEuBr48mKhoDklWkVZP8Wkuet68ddQfyKP3iJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NvMgviXF; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NvMgviXF"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2c95ca60719so2836210a91.3;
        Tue, 09 Jul 2024 00:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720510419; x=1721115219; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=klDpcD1FMiSPwckMUv/XYdW7oQQyHXH58rQmFc+F2uc=;
        b=NvMgviXFBHQ+Y++YO7GysEqcscG+O6As1lhd/MrxU6BQAiCWIsSxuH/WmFmFYtvDEW
         KJKQUmSr18Gz1NTKh8fA0iV5ZGVjzCHxwlaNNNdPuoxU/kkXYBJnvYplFYz4sbuJzSeW
         7zIBF0w5qtNeQCg7wkz9MQkCjRVEBtfqSBNpQelzDIpcm5AZLK/xe59b/WewdvrLOn5L
         gnVxmEWI57z6u7lXjUT/0+5YJ9ewIEdz1MsWPlYFHAh9GyW6MZJXz8Hi+muHw9pR/5GB
         +n0vrEPo7sGexegNEHkBbJM5T/V8iGPXk1r1hauM9x8EcDHN4tI860f06e+82/9tCdVS
         V4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720510419; x=1721115219;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=klDpcD1FMiSPwckMUv/XYdW7oQQyHXH58rQmFc+F2uc=;
        b=TJ5aMKEa0kHU28DJXe0XK4EzoU6t0Pv92tbykrVnp1BhrsrNRa1tXxjvenV6tWjiTP
         UvI+cJc9uwUZ6fOUtrZkl595qMswWVsL6Ou2zP/uXL/g02owwIL+EEXgyYasEz4tEDx2
         w6bHb1oJKT4Wu11mW8LSSp8pa3cEaYqKOOGRV1C7441Gtsqa7UjBP0Sok+aYPqd6EOQE
         inBH3fuFKH7irQvIKT5+wcUdNq2U7roG21YNlCB4i81949i74vbI/fXZ4a0jqAtSZrT7
         K0OVdLuC3xk3ae2ODMwr+PS2b/gYQlJ32e+vZTL/S2CZmo+WCDLSz1q4BuR2Z7JJ6bhf
         tfrw==
X-Forwarded-Encrypted: i=1; AJvYcCUfLATD9vozaQds7581zCAQzQG8FzOWVk1rHPnjafaIWi+Mc1MspfTkQhi3qrodAzJ5ksGnx12WnR4LLYsYvT5sbdjy03PPHXwuoCut7ze5uLyfx0Rk2m1adMGmR5E=
X-Gm-Message-State: AOJu0YwcTtALgaFVkiH+SclLcp2KgBsEUTs7+5QtVDC+9Scu5GPGyYxX
	f2AAzl72sxrvNoOAYAPy1JAgtwqMTf5l06h6PbbCJGoJYa2hX/WAz1NuptxN53A8/6bfErNh/vL
	6FXI9yfXkQCx381SC1uTkUj5/nss=
X-Google-Smtp-Source: AGHT+IG6TEMVsFcPVSqBsELWwJyFpRuf/hY2SNbScRZLiS80tCn6X3wHejySkfVx75KATLP9w2HFi1CxI+Ms7haSFkU=
X-Received: by 2002:a17:90b:3ccd:b0:2c9:887e:46de with SMTP id
 98e67ed59e1d1-2ca35c310f2mr1323804a91.12.1720510419506; Tue, 09 Jul 2024
 00:33:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240517170615.377786-1-ojeda@kernel.org>
In-Reply-To: <20240517170615.377786-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 9 Jul 2024 09:33:27 +0200
Message-ID: <CANiq72kS3f0QA+p6dpkA79G3h57tDVS_oNiO9hm9xY-aJ+9jyg@mail.gmail.com>
Subject: Re: [PATCH] docs: rust: introduce the new kernel.org LLVM+Rust toolchains
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, llvm@lists.linux.dev, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 17, 2024 at 7:06=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> From: Nathan Chancellor <nathan@kernel.org>
>
> These combined LLVM+Rust toolchains are now available, thanks to Nathan
> Chancellor (ClangBuiltLinux).
>
> Thus introduce them in the Rust Quick Start guide.
>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> Co-developed-by: Miguel Ojeda <ojeda@kernel.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks!

Cheers,
Miguel
