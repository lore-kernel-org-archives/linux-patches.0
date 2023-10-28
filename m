Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8806B63A5
	for <patches@lists.linux.dev>; Sat, 28 Oct 2023 17:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XnuSl/PE"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-5a90d6ab962so25243457b3.2
        for <patches@lists.linux.dev>; Sat, 28 Oct 2023 10:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698515178; x=1699119978; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sFhnQuUqv8UTHRqRrIkRXb7c02Iw0Hc4wKGalfdouzc=;
        b=XnuSl/PErkyEOBApDIYEraerfRhaeQAKULuAP4LluN2L3UkLUdHFiRxrr2lP6KU4xt
         Isw/uNdOweaKlQOdYE0ST0QSHlzn2etCQ4VFWZVdqcRDhjttFyvVkltmIte8tUMrR8pI
         Mo+NIgl5fY9vDrnqpyupldbCRt/9f2fqSIuyIP51uImQav2I6CFxn1w5riRc9qpm9yMy
         Kixkz/5/YIBNTjfjasOliFuTWLnt2OvLOQ4DKJzD+DP33c+01ucnSejfiPM57sEDHNnp
         bSTIcRm7lVAElko4EVqksStE5Cpq+Dwt6p5FMoB/W3lEs05FExma3tB3EDZ3rZIblgJW
         rPyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698515178; x=1699119978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sFhnQuUqv8UTHRqRrIkRXb7c02Iw0Hc4wKGalfdouzc=;
        b=i8jiUQSERfJJBx0yEpYpDqyAYh5EIGw+ghXa6+VJHnCudiD6HE3ROMAxSwGnDtE/X4
         GzXATBLSvqccBKxStK9Y8QcXufV5NKpItPonppYLdHohPFwRoLX5ea6SqZh1YYPMrVCT
         LF6JctkGHO47g08zBNgTO4Elm4EJs1N/5cHBEX8GLvuim7QTiYoBd3u1CkHn7TDLsXC+
         C2SlsSPCD8tsDFDfaAbdJbYrlKzz0Mc21Yv6J2nvFIC31Sqd45h2PltvTZua3d4Z2/w9
         lh5TerFSqZN0Oeqr5NleWBLmOWt2z51iDiDOdfDN0m3x4bWiE4epNIWKZiOss7kOh6sv
         AEsA==
X-Gm-Message-State: AOJu0YxjZdIw8dyfLm/hTW/JFV97ExU2OhrOjC1XL6cIB+FR+axjzehp
	WPt6x5rWnL3ZxBZZ8j7F6n0mzloBGuu57QqC+ho=
X-Google-Smtp-Source: AGHT+IHAxMPBGirG7gH46wHtSu0aBHOeNtb/ZOn1UoqO0DTDtNy8aeRXKoNbZJXOEdCZkY6oxpO+PxGDP+soAskdUW8=
X-Received: by 2002:a81:e445:0:b0:5ae:b86a:f384 with SMTP id
 t5-20020a81e445000000b005aeb86af384mr6227239ywl.2.1698515178514; Sat, 28 Oct
 2023 10:46:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231023174449.251550-1-ojeda@kernel.org> <20231023174449.251550-3-ojeda@kernel.org>
In-Reply-To: <20231023174449.251550-3-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 28 Oct 2023 19:46:07 +0200
Message-ID: <CANiq72kmtSPp_qi7BWexfr5eOBCSVMgkkYaivtboRrNexKWMpA@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86/rust: depend on !RETHUNK
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, x86@kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Andrea Righi <andrea.righi@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 23, 2023 at 7:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> The Rust compiler does not support the equivalent of
> `-mfunction-return=3Dthunk-extern` yet [1]. Thus, currently, `objtool`
> warns about it, e.g.:

I just realized I did not Cc Andrea when I sent this, which was my
intention -- done here, sorry!

Cheers,
Miguel
