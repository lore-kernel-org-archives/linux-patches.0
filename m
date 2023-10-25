Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEEE250EA
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 10:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H2f80fXq"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3add37de892so3212981b6e.1
        for <patches@lists.linux.dev>; Wed, 25 Oct 2023 03:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698228783; x=1698833583; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l6sBwVBt8OxRl40mrORA03RRhCm4IDWP2fYbv2hXwz8=;
        b=H2f80fXq5x+UULOVTRA1Tv4LjHRRTeiqzzEFLr9OMpoc52D+PcX6lysB5P9fxkPKs6
         Pq+NVhbFHpdchwfK+TUY21PGglgRMSUfMfUVgtQO6U4qM+Etmi+XFLR0R3SKqnhBouod
         /A2SI/ZScxxCJUfk5lH/+aIIdCstr1aQPDV0eUBrFSy7T/T/rQdJMdbgTpIwFAKcy+5s
         wghneluRuNhAL47Sqmkaup6PCCtBu8oV/1u4J8aePtSzHqXtwyCrShNf0vsP9kmV+Uak
         2kL+kDWBtJsf8CEUOoH82o4ZTyM6vM0D9ST1kxr76ZdWvy+WKvQdl8B92iyBBJ9s7R2l
         msYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698228783; x=1698833583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l6sBwVBt8OxRl40mrORA03RRhCm4IDWP2fYbv2hXwz8=;
        b=tKDU2wnazQQoSm4wf4lpjV2SgtXaJel2yrtOmVF6NZXCXGsLB9Z9QTQkp/R+Etuzp3
         2z53V5GKLW853UPRnzVCprM5NS2XVjK7NMlTNAa1zIHiPqHHa9WoxPaXgg8B0YgXTIgI
         sWok5YePifcyUp4ohcBRDgINGiDBRT9vZ+J8e0M0HoPWlQ869A+gV1eLTbUzapFyGBrN
         fSE9JfSVqQ/IowPGiSIcHE//I25/WnfBSpUTJqkWIpZd+OkfPuDJ7FDBXsoamj0eRKmi
         txnkLamLuAdllVSS8Ybh8I/LARPcIwkbk2G0D4yWzsTgpatB6y7yvtpglFFC/eZ3hupg
         sDjA==
X-Gm-Message-State: AOJu0Yw8R2Te7j+7LAevzeEZB0MDTWCLwzxxBoTQICrxbhGUAsOWCBXX
	S1diUz4fyrGw62t79p3xmIISCdb3nO8uOY4DlDY=
X-Google-Smtp-Source: AGHT+IGdPmbTgUijRvTiwVeUamc6sPEBS/RzZl71q6s9s7fFlZ1Uy8nbWtq0fhT33/wRwFselXnTZPMPUwXcZT7qz78=
X-Received: by 2002:a05:6808:14d6:b0:3b2:e56d:b335 with SMTP id
 f22-20020a05680814d600b003b2e56db335mr15826575oiw.4.1698228782693; Wed, 25
 Oct 2023 03:13:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231018160922.1018962-1-ojeda@kernel.org>
In-Reply-To: <20231018160922.1018962-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 25 Oct 2023 12:12:51 +0200
Message-ID: <CANiq72m2s1SUa2DVSRZ+B+1v_Y4Cpa0Hz8cjRjHacGWh586+3w@mail.gmail.com>
Subject: Re: [PATCH] docs: rust: add "The Rust experiment" section
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Lunn <andrew@lunn.ch>, linux-doc@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 18, 2023 at 6:09=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Clarify that the Rust experiment is still going on to avoid
> confusion for both kernel maintainers and end users.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next`, with the new paragraph -- thanks everyone!

Cheers,
Miguel
