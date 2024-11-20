Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111101E515
	for <patches@lists.linux.dev>; Wed, 20 Nov 2024 18:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732126168; cv=none; b=oVnX/+kHOeky6zjvItg+PX19LAmRMRMm742UUO7MxhXIHJ+NV0Ygcaakj3wmfsj9k6Caajz4TyiNQahGamV7I6a2bgWG8zJn968h8J9JujA98ySsKz+chpME5TDP7I9/tEr3o0Oad91ocYfkXXY3RX2dRzoT5brmf5OT0XgZM8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732126168; c=relaxed/simple;
	bh=hrt55QuxvsEKUiAA4HEO76X7BtbxVjTpwF/QOzkat+E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nzSzwk4S+UlQq2X5zSQMA3guAJumOLLOuian2aoAGLtSfZp4NC8Bg6V2ruyfR9KyVDSUuzn/fBQ4cBliWnhcuzyYajIPz21Hqo3Tjcb4BrcPUJ902QMskMDIXRPt7vhKZQKwWM414a7Yu/Dlzt4bkadXpPMkGxiPot1oAXMsdLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nh8AgRuR; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nh8AgRuR"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7247888f092so13619b3a.0
        for <patches@lists.linux.dev>; Wed, 20 Nov 2024 10:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732126166; x=1732730966; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hrt55QuxvsEKUiAA4HEO76X7BtbxVjTpwF/QOzkat+E=;
        b=Nh8AgRuR5ZPhlhN4v/rpaFbcRMazj0n7MDEs3PxU52IEJvgJ/VB1XdTcczCt0aCfbz
         uDVnDoyxJGI+ZyFDyum51MhaYMPpf8UQAv0CmAIlhREXc/S8UT6sF5yK4UbkCyd+vNJ8
         8EL31SQwJ8iAzjiu26+O4GJyVlPOniMKL+KYaSSvA78x8sOnHudU2zwAni2t+t2Tvolo
         GtQ2cJMUBwMo0u5jN+uQUicRPG/RZbn47Cz6DYllQymmusYofVHcgSBsTLxlJ7FjYnEK
         Qk+lHWXXMD3MIkPzfIqsuZmEn5HLDgi17EaOcyIdJXPU5PXmBsFFyd2KxWSJR0c0A2SA
         9HPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732126166; x=1732730966;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hrt55QuxvsEKUiAA4HEO76X7BtbxVjTpwF/QOzkat+E=;
        b=mnsVi4GRWMtWipP0cTiKlG9+h7EMbX/Rc7WA6tw3s+vItQb+nbsEN2NtwzbCfllWfX
         M88yzColjViIuKA+4lcigBJurDgQSOypo04BAmiRhRma5j6HT9VDB6oiBGHifV5L+6pp
         dbf7nvxTs0EKJL1zPnpFw50MvIBplaHLDirJm4Iy+43ud6LhgbnYnTXMASQNe1qV4AiD
         xE4HVe/tG4fzM/vyBh6Y7wv4Cmpn6fVA2T+GKx5U5yluKyTi0UfKid8QsR/+MCfpJ4bU
         8GkmQKyAXKiKlUMMVN/SYrXwdvtGafpMSG9ddt03xxxO1Fv3u1ht+lFa0Yt0eZUv0r4J
         DUZw==
X-Forwarded-Encrypted: i=1; AJvYcCWcgdvCo0IKHAoxEui67qq+jNvWr0oTqMU/uxLCkbFVXoT7algWOEeVcKw5n1CB1h+cCmSgLEkE@lists.linux.dev
X-Gm-Message-State: AOJu0YxuHg7clQYoK4dJUr54t2XFlSPsurD2/HpfKpOTibftsj5eBQyZ
	svRiLbbPY3WFNNJxv5I/sxTeB4FFU5ZbzhgrG+CRPJD+bv0L2Y+v3J0mBEQZNPnHe/DNgmY8PpT
	NyMb2tPkW5Oyx0y6PoG+J/0AQp8s=
X-Gm-Gg: ASbGncu+Mn4V+V2f7MlUn+JnwH5YVmNpSinIdllS533l7s4w1fQvFyA3yt/tkLkJ0uU
	FG3CUQqGtmGcrT2PdRIGpoQPofv86RkE=
X-Google-Smtp-Source: AGHT+IGGm6PRqmhlAaTH3tQW6D/vi0ZzgDVzpl6/FwqRUDcQ8DS8p+rcMu6VIr3hyk0xwtPaOfPObtumwIW9c+K3IAU=
X-Received: by 2002:a17:90b:33cd:b0:2ea:aa69:106d with SMTP id
 98e67ed59e1d1-2eaca80f5f3mr1895605a91.8.1732126166357; Wed, 20 Nov 2024
 10:09:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241120175916.58860-1-ojeda@kernel.org>
In-Reply-To: <20241120175916.58860-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 20 Nov 2024 19:09:13 +0100
Message-ID: <CANiq72mOoAxA9nW+5=kJMmet7JarT7TAADejXK3XCAcVe0A-bw@mail.gmail.com>
Subject: Re: [PATCH] rust: jump_label: skip formatting generated file
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 20, 2024 at 6:59=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Thus skip formatting it by prefixing its name with `generated_`.
>
> Fixes: 169484ab6677 ("rust: add arch_static_branch")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Steven: if you could please carry this one too before you send the PR,
that would be nice. Apologies for not noticing up earlier, I noticed
when doing some manual merge tests for the Rust subsystem PR.

If you happen to rebase for the other sample/test that you asked
Alice, then please feel free to just fix the original directly. Same
for the other fix you already applied -- both are really just renames.

Thanks!

Cheers,
Miguel
