Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319BD281358
	for <patches@lists.linux.dev>; Mon, 14 Jul 2025 23:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752536336; cv=none; b=D2i4u5fXLfeqKDBWWfY6ngsBQKJz0FBOqz1aCs/SlBpA97hJpgP8ivfe8vFMj9Rtno/EcjrCNmqQL+2FWj9K7xS4IHRn1refpdgQ8Xp9xfHhDDRH1HGt55+UDYQzNHqc1gpduhnA72vJb5BKMwdVU4V48AUaw9FqO1j+1GrhPR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752536336; c=relaxed/simple;
	bh=1mQSQ1q5Ef2ZaE9QRvi6jo6G/wDdTRQ+ABIy3j1J+So=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fhjY+R/hxQ5cOYEanmFG8gUtRXHgDBN1cntZuv4Z/3pA9toTCRMp3gBXK8iF/tdsYtJxEyfVzumoUqjZAEK7mWnY4+O1ZrImirOQZXz/rVCDAfRm01Oz14Nq/r1aTJjvj5CFYpPqCwSTI/46h5FVUp1TWOCkc0xpTzFBVojB/o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RgdsZFWp; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RgdsZFWp"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-313dc7be67aso876553a91.0
        for <patches@lists.linux.dev>; Mon, 14 Jul 2025 16:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752536334; x=1753141134; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1mQSQ1q5Ef2ZaE9QRvi6jo6G/wDdTRQ+ABIy3j1J+So=;
        b=RgdsZFWpvq25Oo0CQ3BWSStjoQEjV7hF0msxekM1D43xO5c5gV1to9252ToCA9Q9b+
         DL8EgSeAV1a+5Aokiz6YMn4l2IT7PPp6JjFtt5ft/wLTHTVWAlTpnU3x8errpLidXJAm
         qf1bFmbpPp9N61UtRXk7oua8mIrfbTOQpZWft7567xVClyoRFqQyMHIzUdxk8vunlKru
         iIgJhXhhuwob5IE8Vy3zRIwRvHZsbtH9LThA5kdDT8/jKLKS48jUxRDzor5XTFouxHSV
         AdvI3+iBmFdcGemLx8i6YELX+WuIs7VDcdNLjRqyEa/MKjgVXaqp05UmaEXLmwFpv+Ht
         xKHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752536334; x=1753141134;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1mQSQ1q5Ef2ZaE9QRvi6jo6G/wDdTRQ+ABIy3j1J+So=;
        b=Yd1HvfWBRUHG9ID/BBaKzw1BNflS4fACpsHyBzLzL3krec8Q6BUSPFbjbIh4xPmQ6/
         6a/2+EU/3JTIzQVNDhzlIIA4E57lRGY/GLsBcu1/glljKi2pI06QLOk+Y/BIWRGL0nyS
         7W0v9LtTaeF1AD2S2rhbQddMQoYy+xdVA0rD0bf9CezsXMLfcCtE/SqQG1RVUeFlbBip
         +XYeWf+lkxAaU1HH4NRM2khxDEhpL66LJTG711aqmLg+tEHaZft/zg+5sR4a9VTMhi67
         8wuYK31VmrDxTduQoYZHSI7ArWjDEm3u7/qc4Wj0ybU3S9v+N7rr6xKCQFdxd3S8cCku
         tBvA==
X-Forwarded-Encrypted: i=1; AJvYcCVscKfHTZ6vTk1jlSXyJHBYSZVmIcXFhnojfHPY4cV5tboaMFaiO0e312IOrQy3+ZBCtSCzrUjh@lists.linux.dev
X-Gm-Message-State: AOJu0YwWFNTY2u0fGTk6/yq69tvOHWAwKUdvDd3A66T3pqxjBSR2HZEV
	dp7HTfmt4JZvoRQUqRVZyNdsT9f35HxEHoGiFL1U/CkDepKg4XVfZ/QdFfDGkvSv7xfnU2a5/TH
	ZapOq/m4vpQ1onvPJqrzLKd0mV65XSDw=
X-Gm-Gg: ASbGnctUoZcQiAIK9i1xnVpFhr/EmAtUFN1GbtC1mErrVTuacqxzRKc3g056+oNZnM3
	6q27yKAZBf/nTyEzOpTwLNlZQtGf+kVx25sJ5hsJcSctiRi1B7sY5XgKzs4RG161T02NYhsFPrB
	WpxIy+ulpp9HVCjBv8NHC9GS0LpdV65aK2B4XZtPoL7PjqQkbSi4LYQH7WcSiL7DouYri8KZ3Bl
	OfX4Lxs
X-Google-Smtp-Source: AGHT+IEH8rVzJYuZjkNiHEvXpl/aQ5FUz43PcZxZ03wCn/Hv7JuV3hihohjdpqQZU304hqy1Qoy6+GEIlWqZTE7QeJI=
X-Received: by 2002:a17:90b:5408:b0:312:1d2d:18f8 with SMTP id
 98e67ed59e1d1-31c4cd5c254mr8297687a91.7.1752536334389; Mon, 14 Jul 2025
 16:38:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250712160103.1244945-1-ojeda@kernel.org>
In-Reply-To: <20250712160103.1244945-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 15 Jul 2025 01:38:42 +0200
X-Gm-Features: Ac12FXxPmB-I9ermNetzFaG2Dns6GMapGpZ1IzJb2A4EEMsWtd0tM9lQI-XZ03g
Message-ID: <CANiq72nLfpO3neWTW-9mavZW+raDk+udU_zDmKbigTCiYZyU8g@mail.gmail.com>
Subject: Re: [PATCH 0/2] Rust fixes for the upcoming 1.89 release
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 12, 2025 at 6:01=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> A couple fixes for the upcoming 1.89.0 release, currently in beta.
>
> With this, current nightly (1.90) gets also clean.

Applied to `rust-fixes` -- thanks everyone!

I am applying these now so that v6.16 is fine by the time the compiler
releases, giving how their release weeks will likely line up.

(Added Acked-by from Bj=C3=B6rn to the second patch he gave me after
discussing it in private -- thanks!)

Cheers,
Miguel
