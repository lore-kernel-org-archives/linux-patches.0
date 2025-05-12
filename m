Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AEA81C4A0A
	for <patches@lists.linux.dev>; Mon, 12 May 2025 13:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747057793; cv=none; b=KpNt+Dd4+VagdnofN53JC5tehcZ8kLEUkxeblExHe3bsQK3lPe8Alf/vf7RQPCdeHdHxM1gcIx7PfjJ67ZnWND2zmWz+VEY48wEPYkiA+JoqexO0ZHKcsjHJ9ExYYi5bX8cq8UBevtgyXOQxvIBUQw9xdta9Bb6w4P5ur/u68kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747057793; c=relaxed/simple;
	bh=BwKMHNk46nx0iDLRjjsuetWJO7bT/ag+FjZ3BGd5c1M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ruArtR+lAC0EmcvUmiS/tPrYDWWqNuVX2HC9M48Dvfm/+G6Le63AUBXQbFA9NFy6yj/5XwkKCLQezfM2uy6g725rCOWXIE4B6IdznmVcdJtIujvBYdBklKjxNjCq8N+sZglAtxLmMQMyj8zgRkvCHX0/w6qCelIOyvNYTcr1TVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GqKiFadf; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GqKiFadf"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b2000b439e1so306382a12.3
        for <patches@lists.linux.dev>; Mon, 12 May 2025 06:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747057791; x=1747662591; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ONr9pUwOkrrYsVUHFahI1KAKvWDR1kObJv/cAcfXBKs=;
        b=GqKiFadf6yonWzbaRfoXwMXu447MbVih8+y49ULV7aKX20qnFqmmlSgNlZS+AE2DIY
         TIPnUpjHEboeXsScwEL5A/zhELaxm1s1xXphByGX44T4IoztUvwrP1od6tczjP1c8bm+
         bcfJz6mvrf4Xq/0je+Gn5EHHzGYVBUT71uhlZhO4+GhgyKm9xAiU+haPTyPs5NXJkCrG
         CDpXhWgPOpJrdkzncpCVAbLqWfSAosCz5Zz4Sf/D0FfUsVDgoToRg0P/69hlw+VeiF2h
         2fMhWclarpDcMcW96RbtJuyUp5tWF2/5Xg2TXJGOUw4Mvxag6NIjnTDdrWhl2KFz8Wid
         Kzcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747057791; x=1747662591;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ONr9pUwOkrrYsVUHFahI1KAKvWDR1kObJv/cAcfXBKs=;
        b=uI4TeOpBN3YCotT96nv05Z1labapQVCAg+6dep/X4K8bFrPg2UaBPdvGa9W8k1M+pH
         BBkwqPznAqmYyheFXf95hoTyEL2/11Mn0tm1paySasUJthssuwSMr3LxGd8IW1z7cwxE
         ywDnKXlUerEICJdMiQZaSU0+yUsAtU3CcyMDxOzJNznFfbvJXwdp/m648jh6tVAtJXbo
         jfDthijGzamUZTtx+ktvksg/O+0wl7562DLjf6c6eL77FCemxvYRCguV+I44pZx4Age/
         Pxmo0QUByLFA9tGiXpmB9bYcehpPFFtt8DAAhPUBY7CHJXJRayLfU5XuD96B8C+obwZV
         47GQ==
X-Forwarded-Encrypted: i=1; AJvYcCWllyHvA9lkbTirZQS9KuyPTQffvD6xJKGldHoWpgkPAfnlE2sQnejDPRZrx7iBP8sKw2LZ7W8L@lists.linux.dev
X-Gm-Message-State: AOJu0Yymd+QDykwhRuSUYxvZyPMeDBqNLkyLRx2d/PjgFDWu845XhCZI
	LfVvz6G3aphTWacnzTp9mURI1ftiysHCS7MSiUgn36RWKcUpBBMiJhVhypYY+Q8u7TeQbkv5tIR
	64Tb6xUOl2ca4XTYp+nqSzhO4kIQ=
X-Gm-Gg: ASbGnctPkXGFHTZFrTqIhdY9LtGe8ZvGNvebFwknoBVtt3KAubJNtynzGMuyAmnixiV
	l4d/gI6EtP/QD1ZyJKlV1RTkTViawTWox4cSl2Gf8sOSYGdcRxOQONozvSN3pkWfU4W14272Uyr
	LAfqLCUo58sZ4WGyfQd/KjJHMm1ScDTPKMcdhX/QZ09AA=
X-Google-Smtp-Source: AGHT+IHIl25ChJIz78mbrp/wCk/S79hnnperr7Lp/0TI4fOTmWRRNl7PkRoCoOqHLna78ZBwvPPDoZZ7qG9tueIxlM8=
X-Received: by 2002:a17:902:d491:b0:223:5525:622f with SMTP id
 d9443c01a7336-22fc8b0b64cmr67620375ad.1.1747057790728; Mon, 12 May 2025
 06:49:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250327211302.286313-1-ojeda@kernel.org>
In-Reply-To: <20250327211302.286313-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 12 May 2025 15:49:38 +0200
X-Gm-Features: AX0GCFsycteckP67naBfmZSgXZjiR08AnYUU9QZvM7ex2TtZdM9R3s2AEMWWHjM
Message-ID: <CANiq72=moB37Kj7kLrEe20hXXYe9q5A9==EyAy+SOPb5mY5HxQ@mail.gmail.com>
Subject: Re: [PATCH] rust: clarify the language unstable features in use
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 27, 2025 at 10:13=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> We track the details of which Rust features we use at our usual "live
> list" [1] (and its sub-lists), but in light of a discussion in the LWN
> article [2], it would help to clarify it in the source code.
>
> In particular, we are very close to rely only on stable Rust language-wis=
e
> -- essentially only two language features remain (including the `kernel`
> crate).
>
> Thus add some details in both the feature list of the `kernel` crate as
> well as the list of allowed features.
>
> This does not over every single feature, and there are quite a few
> non-language features that we use too. To have the full picture, please
> refer to [1].
>
> Link: https://github.com/Rust-for-Linux/linux/issues/2 [1]
> Link: https://lwn.net/Articles/1015409/ [2]
> Suggested-by: Andreas Hindborg <a.hindborg@kernel.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks everyone!

    [ Improved comments with suggestions from the list. - Miguel ]

Cheers,
Miguel
