Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3DC33F3
	for <patches@lists.linux.dev>; Sun, 27 Jul 2025 09:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753608707; cv=none; b=tYA1gRLQW/DpBfMPCBWk1odlz7bTiBTkNan1u9nMTIHP1XDaG2+kgaFm9TsViCzx7Vggn9+7KybZxdM55I/q1Y6E3z70RxD3qOBOaqiLEQDBSDuMQcWiwNLhzPOA3vlNjnZmVI9FEKcg9bxvWDRLsVGbFziHENiNyGZDLRWogmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753608707; c=relaxed/simple;
	bh=gDbSYc8pmLjUYSA7KcBarXcm5lMdG+b1p6ndEBx0i3w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cd2oe+p4agLImfgKZR9gOhD4AzNSgRs6v47EMkt5nHObn0KBbfUw8GY9jG0vF84wemhEEUBR0FsVTnKeZhWDASae6Gd1OXdgVd77dyllBkVOeAB0+nTZWb1ldxKopQegZkDdrNL+QI6C3JpqT4DCxH0PyVZYCtroJ9hNya12+xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IhOMZZcF; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IhOMZZcF"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-31305ee3281so531944a91.0
        for <patches@lists.linux.dev>; Sun, 27 Jul 2025 02:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753608705; x=1754213505; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gDbSYc8pmLjUYSA7KcBarXcm5lMdG+b1p6ndEBx0i3w=;
        b=IhOMZZcFZDrHo6BPAnFaARP6PH/u5Kop47jz9ujLAHny415ahMY+N3h1PutJZ9rhxA
         LJtiyP1x8LryFQyH4i1LEmriSpP8US7/2AYOWkeHsLiX0m3QxJXu3eMoaNc7BEe90LKr
         SMu4WPWJb8kWW3RoFBYL6NN7Qt6zk9OwKKrQ+kGigKhzx8AVbEGngrvz5wgyQi7M/4V2
         M6Gm7bq2ZCKyTixv18gX99dj9RWy75J7d9J1rqg1+BpbqHTu62Gj61lnsjc4IL8Jbd1e
         m2W4i1i9JPyXUFYNfHQ8NZymwl+0NGeVwgsF8NtHRoLOZ/WbsuuG/ex/+1r1/8/hqb3y
         W42w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753608705; x=1754213505;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gDbSYc8pmLjUYSA7KcBarXcm5lMdG+b1p6ndEBx0i3w=;
        b=Do2/U19QzC5lsVxsf8KVZB+ypzr7RLkyTo9sNtMM0r17q4rj7shzRUka3BEjgW1oc7
         dO8QrGCxXTj+KJjIMEin/ffkjYlP4aBysnsoeepRa7h+LYnBImNUTq9Dmblr8fKH7dR5
         ElPNrnl+BcggbmGMgu2bKMEXJgBDmJNHVqfNJJZN1fFp/WHxF3YeqmB3h3U0oTpiSMvc
         fHb/0u4N2ihQ+rW+ZBbuZsIyUK5EDEwhe+ZEa9a9KdGLLK8s7DQg6bBSx1of0KXNjM2V
         EouJvG/iW14Jaq0lEtvmkHlHDdKXg6UPFjHmsHjaORWqChC5YevoCwLvhAiGZkw8lLtR
         YfpQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7nO7cGngwqOUR3IMj0nMP9J8n7BBR+F9oR6PzJVBRs1c9BFxctIbKr65nzgMzJL3zOqSLpRQo@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+Iwnb3DBMqIPHQRrbTbOx1Of1wMUXOmTc4FtYoE1W/u1ZAl8X
	3uzp52Gg/DczZ3C7HfUOvVGI6A8xki5HFcPfsZ317Gv2HjKHWOn6heWyEdrtv0wuesx/wA4K4LB
	bAxb/N6Mi5ezjGB+WHWIxGnnYWAUjr48=
X-Gm-Gg: ASbGncvL2qrikJvUKu4l0ORl1zA055+kQoU8IJV2CbxNfEkC4z9QNVXy+VXFKqDEtyd
	QbB4s1cSsSoh0VBZHS8ATiPgAEhtQooa9EgN4rN/C+H+LNPqfOqtSH7aXXUe56v67PHYCnzNrVQ
	9bHKIoBm4qFEdkVheN6c/LUca2107GfvDUOH2M9GxCBb1k0aGXJpSfk/O7cecB8V4CI4g3rwbKT
	kKSyc7x
X-Google-Smtp-Source: AGHT+IHwyqPcMJ6XaVtzcngEGA52+QC98OcB+ztkimhreGhuBj2aWm4Lacehn7M3roIqN3sGDv+fQ22VOSX40WhoM/g=
X-Received: by 2002:a17:90b:4a81:b0:31e:cdc1:999e with SMTP id
 98e67ed59e1d1-31ecdc19b15mr687988a91.1.1753608704960; Sun, 27 Jul 2025
 02:31:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250727092317.2930617-1-ojeda@kernel.org>
In-Reply-To: <20250727092317.2930617-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 27 Jul 2025 11:31:32 +0200
X-Gm-Features: Ac12FXzSNfd8ysAf4soSdl5HrXnwH9bMPWruUS5fZU1uCrkYeE6TPwm812nNyZg
Message-ID: <CANiq72=Y3i-WeygLix6j-sPZwE2QTOkaZDQOrED1aCiMoH3Cqw@mail.gmail.com>
Subject: Re: [PATCH] rust: workaround `rustdoc` target modifiers bug
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 27, 2025 at 11:23=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Closes: https://lore.kernel.org/rust-for-linux/36cdc798-524f-4910-8b77-d7=
b9fac08d77@oss.qualcomm.com/
> Link: https://github.com/rust-lang/rust/issues/144521 [1]
> Link: https://github.com/rust-lang/rust/pull/144523 [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

And most likely:

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is
pinned in older LTSs).

Cheers,
Miguel
