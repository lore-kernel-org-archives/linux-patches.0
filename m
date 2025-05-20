Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6A325CC45
	for <patches@lists.linux.dev>; Tue, 20 May 2025 19:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747770614; cv=none; b=jtPQpZK4y9pBA7IqwiK/WHaxw8Q+9YLhE4hC9k9eQBWLt8M62Xpo+WBeP5pmBOOohnros4nfHXcunZWcATEj7wONniTxjDthACt2dBidDzpz6Q9Knvr/1jDMRsdJUwM4bFUBubdB6kFsXWr/CiFhUC64Cw0k/PqTRagABZzsVm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747770614; c=relaxed/simple;
	bh=SwiwaSdg4eQ4oxNyBzoukE5k+V15JbB2nsJEKxCXjVE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lz4EYzOyS9pQAoE/mMWGvTyBEhU4SJlt04Q9IRRpx4D4QDfy30tjXwAqRnUxJ7aC+/mWh6NbqUf36rcFEvEs+RKbwsnNu/RQshT0VqQbpVLmaKCA3XKpdwgmlwo6kjS9jFKjSwcC0IDov+COFXCYxBA/MF3u0wrPUyMMG3hyYzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J6GtMfJN; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J6GtMfJN"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b26e6c551f8so509873a12.1
        for <patches@lists.linux.dev>; Tue, 20 May 2025 12:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747770612; x=1748375412; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SwiwaSdg4eQ4oxNyBzoukE5k+V15JbB2nsJEKxCXjVE=;
        b=J6GtMfJNplE8sXrBIUu/LSGxeXZBeKQuPAQHAWEY2J1wBCfpnHgr29KfJTr4Yt+jf+
         +tl0feBJRsEGos9bCUmKYDwUM68Lcy1EHuIyu8XJwypCSELgZFZBDGaOzQ3lnI6jqeqN
         WcHS6uW6saqJVVQTAuTUMNhO51hVAfRMWmBe0lbYniqRG0Fm7hCCoBwwCb8txurLkLyf
         DELkRnFqEbyNRARqIrwRKNAqzj0MdweN/HbcoXbYbOuXEIifT/fsV5sHTS3krpJBAcw5
         dzvHk4HxXmTIaM2iMTTbWacY6XMgGsHuCPjuNupZbulqeOqIV6i/TphyeRlDS3ipp81h
         N7FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747770612; x=1748375412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SwiwaSdg4eQ4oxNyBzoukE5k+V15JbB2nsJEKxCXjVE=;
        b=AegZTA0RYW1mdd3+eP4IQou24wMJfMpqNfDodXYzzHiTSjFTE+FcnIjdbkbDDQpUJr
         2uUAIr9MO23gtpUyRvvC6rD7s0yXzFqf2vv7JMIkAj125RT/wIrNrjgs7bRfs196/WaL
         suHHenHkxl77zQTSu3Gj553gmJrZPkf+Q0vdvLPxZyGPdJwDMYR/p/FrfipsHqrwBFRG
         W+LthCAQrClVCW4cikJGtI5tmjdbMmVjTcBAPcpm8jHOaDkU+iJZOoFw/mbFGM3D4RIz
         HTiJD6ipPOxR7PUigXrjtb7afmivkoUaC9MRH7V6eqYnvxJwE5wiJ6BGjyUTbm3w9jhP
         W2jQ==
X-Forwarded-Encrypted: i=1; AJvYcCXg86M7rMh3f7ky2QptBLCiSFVbs+zFzJAoxeRmbxZoko+mRKxkqdEIheSlXRvPjSZDlY3ygbAK@lists.linux.dev
X-Gm-Message-State: AOJu0YwwXGWEb1O6VAOGQqRiTzi9CQYi4cAc7vGO3YnVkL+MHZgNJFfm
	Z5OjVF+7IFsUYN0nGks5edskkzl16VBcaR5D39pF5V80+zBMkTOzsRzrJ2pyfioW2fdA6xbzO5f
	7LjLDWdWPqQrCG5dqO4xD62KnsS2DQlA=
X-Gm-Gg: ASbGncvh2p5JouljRH/crgdjOUAQxU9P+5Jb6qrdIWVQWUhr1pu6HkFuBwIA9lfRCto
	wtf1FEh7uFx4hq7e2s4ZZNeLL9UKtXPUItexYShhrR0vcs8b3XmIKWnkuUDJl4n0jqEqKT98C77
	Ru3hXSZ+zRPfF7Dj86VJEzZEZE/FladNik
X-Google-Smtp-Source: AGHT+IH/GtxXV7pO420TBwvo67pv/+vuSvNQns2cFPY0rjC4suXw7a7ox5Jd3eZobSFtn1EIW9pudsE+oeNIvVQpERQ=
X-Received: by 2002:a17:902:cf07:b0:220:e1e6:446e with SMTP id
 d9443c01a7336-231d437f0damr92624395ad.1.1747770612110; Tue, 20 May 2025
 12:50:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502140237.1659624-1-ojeda@kernel.org> <20250502140237.1659624-2-ojeda@kernel.org>
 <20250513180757.GA1295002@joelnvbox>
In-Reply-To: <20250513180757.GA1295002@joelnvbox>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 20 May 2025 21:49:58 +0200
X-Gm-Features: AX0GCFuOY7Kz9DRWzUOglkPbmrM_Bcksvg1f806Qs5Umb82adzvopIRqYuPJnhw
Message-ID: <CANiq72=kkejAwQJLYNjN=25Qf7qr801_Gr9zCZXJTEF9Ou54gQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] objtool/rust: add one more `noreturn` Rust function
 for Rust 1.87.0
To: Joel Fernandes <joelagnelf@nvidia.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>, ttabi@nvidia.com, 
	acourbot@nvidia.com, jhubbard@nvidia.com, apopple@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2025 at 8:08=E2=80=AFPM Joel Fernandes <joelagnelf@nvidia.c=
om> wrote:
>
> Any thoughts on how to fix the warning?

For future reference, this gets fixed with
https://lore.kernel.org/rust-for-linux/20250520185555.825242-1-ojeda@kernel=
.org/

I hope that helps (and apologies for the delay, a bunch of us were in
RustWeek :)

Cheers,
Miguel
