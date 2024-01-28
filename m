Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344D714288
	for <patches@lists.linux.dev>; Sun, 28 Jan 2024 18:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706466418; cv=none; b=hke1ticScDbmUUW7RyzmDInydVwaPjKMpbVM3VH8N74XxRX5vqFawkAFO/K7gQyO7/PZcv6L5mQ1nDj9EyVd1g57XzI6FV+T5lxzg/EejWj0A0N9PGK6eSXuojhd17E25l0Hp0Hk5f56bDP+lNYkFsrAPCsDy9MeMqUnqL0fH1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706466418; c=relaxed/simple;
	bh=UXTngv2IRaXa+2eC4u2kVj1o4DgKsM6J1Yyn4x6/qHw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rP4CaSKzKBI65DvKzM8UZewPQGhW1EZB4EKAfjJImUTINmnJSoycRfxzNl9TurKgJT+6K4uUNGK/h2laky2NeSlkLHAgwojHfBANVMPFA12gHVZmgw3pWtDJcxJpQMG/nBEW/6F4pg9f2Z61jHCppIFqGIUO11/RzHaw8FNYPKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OWcag+vE; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OWcag+vE"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-602ab446cd8so18959007b3.1
        for <patches@lists.linux.dev>; Sun, 28 Jan 2024 10:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706466416; x=1707071216; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UXTngv2IRaXa+2eC4u2kVj1o4DgKsM6J1Yyn4x6/qHw=;
        b=OWcag+vE6mHq0xdFYHNUnEokHBDEFLtoGUtzzWDUXnVxJ1a2jntCtdpFZGUpqn9jLv
         3+Z7g6/Kaou9iPT4gwq037cIH8YL6vIho14ayuxc0ws/VkRMYFKHmwH6hW29kg56R98k
         UyFr7KFj3ot1+CglBDjb/i5Kaq4CALv0d6f12BMuCoByUWSaeyNQT/0x0vMoC8VKFUi5
         iXwMFj9OsYkTj2FZ6J1JdVQkLseEUOXjYh6K9BnAQxFX+beVU46hUN+MG6l8B3t+K/gO
         viEYvf0wXnZMY80CHfW0gEKEuMLAlLZh95n4AkZ/FN6j9wXQ5HKzkHXpaetjeQhrC/uZ
         33Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706466416; x=1707071216;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UXTngv2IRaXa+2eC4u2kVj1o4DgKsM6J1Yyn4x6/qHw=;
        b=qB23+euJNRuI1walA/jwJAhSseOww9DVojIANNMYlmFNRWXeBD/dcK0w2TeoHzhewk
         ch/IFA/MNsGk7ziVgeePA+GpUlt+DRHCyB6xifCK9vpRCdDxkL5Hy0wIm4IX/sRPsLF4
         Z3AbD2zK9mh9Qe9QnxRTzC2Kl//O7ZlCamhKEvBtBtTkrBubbeEShI3dEJZ1m8wjiNSK
         qMQ7OXObCY+e9GxKl5FmYpU/zzKk/Zb7I/RxPjsdIPsz1TgeCSkuJr8yJmwcPQ0kSdZ8
         yNd0Zc9MYpOKvdU5TSOdat/vPfRMnOzw3S3vdxDM5Pj0stRqW9zeATSxfTcEXiqXxJ9U
         OxBQ==
X-Gm-Message-State: AOJu0Yzhr1vQd69wUNNYzIQ3fSurqaEcxsIlF1GDXaHZVeNJT15MOKtV
	naWhAZZ9i9y9joaZZHnuyyKOOn6awZGLr4TCNXJwPKcIkgouCSEn0h321htGUf8vKB/FwJu9zlN
	vHr8/8P0lbg+wybqAIVJh5PdEmC4=
X-Google-Smtp-Source: AGHT+IH4qPrdNAcAUFXsMfaYWG5heoS9259jnH7OV1Wc3BHu64nL+mQKDxGhwtH2ZbLGQ3WmWJjvggFPbjyNKRDRnPc=
X-Received: by 2002:a81:4006:0:b0:5ff:9810:e8d5 with SMTP id
 l6-20020a814006000000b005ff9810e8d5mr2500689ywn.87.1706466416118; Sun, 28 Jan
 2024 10:26:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231023174449.251550-1-ojeda@kernel.org>
In-Reply-To: <20231023174449.251550-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 28 Jan 2024 19:26:45 +0100
Message-ID: <CANiq72kGPTxC09GigzcLdD8qP6QPch0M7FB8iyqNHNnXN52L4w@mail.gmail.com>
Subject: Re: [PATCH 1/4] x86/rust: support RETPOLINE
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, x86@kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Daniel Borkmann <daniel@iogearbox.net>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 23, 2023 at 7:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Support the `RETPOLINE` speculation mitigation by enabling the target
> features that Clang does.

x86: do you plan/want to pick this series up?

Thanks!

Cheers,
Miguel
