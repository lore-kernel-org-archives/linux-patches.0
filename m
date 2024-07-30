Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03081662F4
	for <patches@lists.linux.dev>; Tue, 30 Jul 2024 20:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722370976; cv=none; b=YWaXIPmrcbLODepFbroBuAg/eJOJT+IdI0LIA8zgcCPWfahTa9DKoL90qgg8eMm3ZjHt0qBelkKAsYn1x32ZuHgKMRLk3wtE2xdOCeRQpmt8rHpAMdp7EyzS2Bcb5ZaAP6WOfcAaCeTv8vaYgL7Q9t4zzWW+udABE6mB2OLNbF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722370976; c=relaxed/simple;
	bh=qgIM6c6I7ActKGrTkv0LUY7kFUEtEmpH3NypCwcOYbI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RiEcNDCsRc1OOnnYtCqNQrCbRxC9weJo09mLCrXyiWoPX7dPgnQcvcHXDq206V35gUAb9c6vsK7aycT2IIMIV6UpTmrlai3VIJR26xMmDet4uwbjSbN6iLrMbDZ+pArk/x+YDrgi2jrAvnbtuSVVi2FiiCkXUu/WODOsfTPuC5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U/pptMgE; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U/pptMgE"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2cd2f89825fso3273858a91.1
        for <patches@lists.linux.dev>; Tue, 30 Jul 2024 13:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722370974; x=1722975774; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qgIM6c6I7ActKGrTkv0LUY7kFUEtEmpH3NypCwcOYbI=;
        b=U/pptMgERUNgf3tRdffCA/kxxwiueQ1M1vtLJ5Z0+IzPF37oXhB9TXBGpjnPuKerJl
         DbweTI7e12yqrbwGr6TggB5ASAA6uiFX+kCGQ3H+ryQa5vu6LRMpF/B2Y1VLnwTZoZTv
         2fzlIMsmcniOeu/4RnMp9UbDIJ8dLl2DPtg7cMy88fzovPB7flosjZTzG+g2xHB+og7E
         aDtlNR6FeRbj8pTfu81i1nG9En+5M7w6yuUjaenpkna0H+T0Uz3DFf9lJYjoZ2N2jTQo
         F/jCW1EA4WmkN+0S9CplNssfMx3UOb7iIqzw9e3slKF0vIBFDtbDV2z8WM7z5PR72Nnk
         6hrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722370974; x=1722975774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qgIM6c6I7ActKGrTkv0LUY7kFUEtEmpH3NypCwcOYbI=;
        b=IEInMGLywNKibYT01OhVZ5gK8tCFQus5RKNXho/rCOtUcPcYnnTI5XT+kphdQXfyq0
         DcjSEUjk/lGKwklTAvOcPEOlVc3gieV0iJj0mtTMuirYeivLCDCwSVphS8K8ZOV14aLr
         NQ+0R6lNP5SZI8HTwbPAT7hrSUSL10KVQx+o77G9rnPVX4QRJPo3eoJBe8w5jjJmPdVm
         Yd+lN5cc7hGJyinc4cICBV0UGQAUfP8p70Vm7fA8bimPFjIJnaUQUvWNyARrXOAVardp
         pNVhxmqo9hxq4jh1AePZTZm53PO/9dyNVn6rTJjfkjfVvc7MAiPoY6WcfwpZgsHqcqDK
         IqcA==
X-Forwarded-Encrypted: i=1; AJvYcCWNZNniyTxEvbXO85jLKTzqaAm/sZEap7yE0tfqd0IgBYv+XgUE9UeiHYBScC2O4w8b0qARsCBWrqcT8aZFYYONYmkc2e1lBw==
X-Gm-Message-State: AOJu0YzpbOL1etJt4vhi7mDCjHKS2sp1ag31amc68Ug4n66mxCZFrzDI
	Clc9lKyAqC1oIJBPQ+PC80QWmZ3ZEaMIHuqkipBQY/RQCemzTL3+IRm6Qm/NCi7JFcjlw8+xj1Y
	VQzd2nMN0JUuJLEiTKf3yIFdIVQQ=
X-Google-Smtp-Source: AGHT+IHCzS/rd7b1oz4vmEzbNtTxafJlsZS84UjHMW+33i7wxde9VAxzqRvvwyZppvHikLIMBEJEM7F0XUjrbhZBkok=
X-Received: by 2002:a17:90b:2248:b0:2c9:74f2:3b24 with SMTP id
 98e67ed59e1d1-2cf7e1eda57mr10326001a91.12.1722370973899; Tue, 30 Jul 2024
 13:22:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240730155702.1110144-1-ojeda@kernel.org> <CAH5fLgj-0EsVjh8xdV1mXZBXPxKGnwUa8-R+Bg1eyjh0Gh_BWg@mail.gmail.com>
In-Reply-To: <CAH5fLgj-0EsVjh8xdV1mXZBXPxKGnwUa8-R+Bg1eyjh0Gh_BWg@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 30 Jul 2024 22:22:41 +0200
Message-ID: <CANiq72==6_Km_UYWaxxWw4gLS0g5yK5dQYvq+2xGTQvmm4aHyA@mail.gmail.com>
Subject: Re: [PATCH] rust: error: allow `useless_conversion` for 32-bit builds
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Russell King <linux@armlinux.org.uk>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Christian Schrefl <chrisi.schrefl@gmail.com>, Jamie Cunliffe <Jamie.Cunliffe@arm.com>, 
	Sven Van Asbroeck <thesven73@gmail.com>, linux-arm-kernel@lists.infradead.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 30, 2024 at 7:55=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> The formatting here is a bit weird. Perhaps we should swap the cfg and
> the comment?

Yeah, I don't like it either -- I reflexively did it because in the
safety series I am sending, there was a case where it would not notice
the `// SAFETY` comment if an attribute was placed afterwards.

But for blocks like this works fine, so it is not needed here, so we
can change it, even we may need to be inconsistent in a few places
about this, at least until it is fixed (assuming it is indeed a false
positive).

I created an issue in Clippy about it:
https://github.com/rust-lang/rust-clippy/issues/13189.

Thanks!

Cheers,
Miguel
