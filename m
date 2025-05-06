Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74691218EBA
	for <patches@lists.linux.dev>; Tue,  6 May 2025 22:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746570164; cv=none; b=WdNxqdH+BfXQt9agtTE44Hdlx8KNJxhhUa3bnr+s49A+lCG3RDKPTf9+cUu2SivlhPuPSM+xpSVpoKZiV1g7UePIaQmxen2Hu2AdQMlytzPciif0dx5InDnZRvjF2GKLX0IPETVLs//rhEcb8FpnWiT2DPznvkewu8djIaByDcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746570164; c=relaxed/simple;
	bh=Fjs8/oqdYEN5TLsTGrbw69UBcedciUbp7Y1O4mot1nw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QVIbwaF8/obEDypukufiEz8/7uUrr/HdqgaRIq2iJB/vFZKEKwo6SoTW3IxBp4yNTGEOEWqsSkbNTf/yGLg7J1QxCmB0yrX6gxwh6245Sq4EUM8dEMcsjwkSron4ocpzwtB4A1Kt7/0SxgrcteEWtmyEDXFrBLDmJ/YBZ1QTfWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i5mI2i2J; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i5mI2i2J"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-30a80e3222fso208907a91.3
        for <patches@lists.linux.dev>; Tue, 06 May 2025 15:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746570161; x=1747174961; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EJu/VrmZH7dKgyhsnTdC5BHM2TwuIMvm6m0HjhtoteQ=;
        b=i5mI2i2J27gAEmZysZuICaBj4l5e0e/uxw5i9Aklo+fDGMH1JD+WTZXH+Ddmgmj8i4
         iXDbpYoIft6xEA1MxSGSkjyFf0ljmuOGBn2if508chlJ3X30nHneSXo2Mu1rI6QapqnG
         sSFgOtmfIExqkI6z+FU4S47R0/2YV249tYmdyJn68PcPu3OYtS59qvuioTaj26DHdYUB
         dcJLBq2xsFVi04gQgdAN8x9GqdRFZjc3QQtmXeTDUUs+hO3jPFcKOWXaOWBAJm93s31q
         f/W6FBdIZCLVs75iVaHlBr/E1AZbNrUh39d72OJDzjkkA9SW5rwe517cOgOR3l9Re4h+
         ebRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746570161; x=1747174961;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EJu/VrmZH7dKgyhsnTdC5BHM2TwuIMvm6m0HjhtoteQ=;
        b=fwDlDSHjY4jcyC7UtVQ2Q1pxpO7Ft7wY4auAXbxF2R6flBXE9CMQiG7T+Ftxc0dwGI
         mizzAT7PFewAFYMa6GiBifi7WbJLXja42gpn0L2ervMm7tqf9Ttvtg9Pfx6dlcQWXTGi
         r3J4vCA4WboivODWAvJDz3Mc+/4IrJox+vWAytbQb+bpkG/sTxRiiHC4Wc6a5g+KDiQA
         SQVrZ0ewtj+dBqb2a3tZ4DuoPAnQqbF0Ld1kxErnU9hFgy7xJ1AdRq0BQwVZaWQ937e3
         H1e1QYSqPU59hkfwcPT00IXSklILWeOT3HUDTghKaUoHNwboej/Sq1D20qc7Dlck+RAT
         Qi0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUsDdcN3pOx6cQJJGR1d51L7Amaz+aNdv5PY7TiPIvtOlh8L74KJN5r49o5FWUujyqcoX0wO/MB@lists.linux.dev
X-Gm-Message-State: AOJu0YxNc4izL3iHDz+2rMKB+7mPLqLLGTZHpm/tU/QJNjXX3nLSmhO0
	+zPs8kNrX7Xz61gaM3iuJNQluFheQp7yZkgk1u0gKMI8y3JJXeHs4qBoSwd8Kk8JEpPhUBYWaXr
	0Ud29G3v3Xkyk4a27sU+yAHD19bM=
X-Gm-Gg: ASbGncs68acP1+5YHHgPByUMy+uPyCpwrrTm3h3sJ49q7AFGgpDB7TBTJN9XJ5V+ZWp
	pSKMBEaRMQvhr44hb5rpBbCvd5piXPV2hIlnaspdlOR3XSxwynXeRbImtoQPm8APmuQiTeU4XlH
	PYLOOm7mOaDZTVYjCKEgh8gg==
X-Google-Smtp-Source: AGHT+IFVLfOMX/7uUSXM/y7pjZowtfQ1j0vsDZTjQNHCA4pIMb9jQEvGqs1TBHX2E5FSF2e0ZGIxAaTuGCDFxHIVLrs=
X-Received: by 2002:a17:90b:33c1:b0:2ff:5759:549a with SMTP id
 98e67ed59e1d1-30aac16c2e2mr652470a91.1.1746570160569; Tue, 06 May 2025
 15:22:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502140237.1659624-1-ojeda@kernel.org>
In-Reply-To: <20250502140237.1659624-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 7 May 2025 00:22:27 +0200
X-Gm-Features: ATxdqUHsnz3OpIfXfRrsahxajrnMcgxR0wuYrhnN4_-kpgUu_iZsj3JsP3IAULE
Message-ID: <CANiq72kb69a8=2GR32_+NeJ0TsBM2XP2--tJf75+JDLjkaPZ5A@mail.gmail.com>
Subject: Re: [PATCH 0/5] Rust beta (1.87) and nightly (1.88) lint cleanups
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 2, 2025 at 4:03=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> Now that Rust 1.87.0 is close to release, clean up the new lints that app=
eared.
>
> It may be that one of the patches is not needed by the time it releases, =
but
> I prefer to not wait much longer since I would like to land this for -rc6=
 so
> that it is clean for release.
>
> In addition, clean some nightly (1.88.0) ones too.

Applied to `rust-fixes` -- thanks everyone!

    [ Converted to `allow`s since backport was confirmed. - Miguel ]

Cheers,
Miguel
