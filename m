Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE7932548A
	for <patches@lists.linux.dev>; Mon, 17 Nov 2025 21:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763414833; cv=none; b=br1bSuVJaEbqctdib83PtAvYnpLhh/OOMVdZJR0xyBHWV8pU55cVaAuzk/dDcz8cwfu0NwQacwwbYSbDSsVAnqcyPogAbSszi9Sld9AplsWH3LJXo+g/SmrpLfSf+tzxDyp+oubKzIq5BqtnV0ovFIHRi0kQP9HxF1YbF4jNlYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763414833; c=relaxed/simple;
	bh=7fPlXJYjsSilCDIe8k2o+rTnQyrHViW9qFIFSlnjorI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mnEiHzsp+C9WXX+9TVtYmR84IhS1Owo7ezyk/YOuXk2+C+kBSsQM2Kc8asXIgv8TdDY5ffeLDH203E8heZEumCtF2Kgm1wq7UqM+AF/fvDOvtt5Lc9KcT+WnO8UPpaQAIeay1XbgDuk/xQKVDF59gin+qIAVIfpKHRXdAcAcxQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LBHFMk0W; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LBHFMk0W"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b983fbc731bso344114a12.2
        for <patches@lists.linux.dev>; Mon, 17 Nov 2025 13:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763414830; x=1764019630; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7fPlXJYjsSilCDIe8k2o+rTnQyrHViW9qFIFSlnjorI=;
        b=LBHFMk0W/h3UnDVJmZ9WTbvdIhB9ku4nvtPfzz0L097VGSKjqVV9lU6izinxZi+Sza
         Lbx4rc4I4q6OqY+li72y48PBGdjsjrmEgNOK8cmFnX6jSqFXAQ1ZoTPe84bcomfaD4aA
         McCjT0OOD9/1P4Qc2ezI4tma/lQ6ynIEtkq2ZaMZ4A5PDU0ZxJYn8d6uvBvkATU01Evg
         cx2dC7XpWeVQY9DyBlGeODWko+EgXADUCAS+tcnJL734fNVnU8YQRgsHovzMuxILPRqU
         0Th2HxtWpbDpz+U6CXQf+tM3rHH11kJuHFraB2HZvOxTMce/tQ8oWxwrvuUnujkf50Fj
         rT7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763414830; x=1764019630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7fPlXJYjsSilCDIe8k2o+rTnQyrHViW9qFIFSlnjorI=;
        b=Fmkt0y3TvPEWCjMb18akDNxsAVVFVvjdc5rszXCi0XYfrYdgvPJ1G5ioktGO3nTFRA
         J/bFWXkA7k6jVbG3WBpKHuTFiTG5nEsaIgqDUyPtcqvQE1DBqjWPdv2dny/LkOq8Ikk1
         iMcvLZxZ+yaG8hI2Yt53IU/uvSlHYM4U44rr629JvP1nNSD3C8vjGQtCUjZkCYkEP8cV
         wPbnsa2ms1JGq6MFCDCrmASGU++b/1jT+kyioG4ZVIzlFNdwkmRPk7OzrPzpIcoUGxHt
         Fe+Fxs34h8KHCeqxZONtzAQGtLbJk4d8+FgEjn7IZfxNHzlSX284T+sZbsvjd3ppcBV0
         tfOw==
X-Forwarded-Encrypted: i=1; AJvYcCXRZCDjOF8bsXrytM2nqZelOOKw+NHYmV4E1197Mia+M3rDQGDeUjhWmyX1fzq+5xgF8s2d30V/@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3iSb+sdCszd6PUtjXvFrviaZWRT/W3WNBQ9t3tVQrwpAnjYGH
	mRgMcYuEc5mDrvdqJgZ2KH4kbf2jJ34UxRr/g+NyGco7cbtdbr6DJbVYS6tLAh+mXBDiAWCvziG
	FbsR5nmUQHbDJ2cY1tMWerjXVkJv1x9Q=
X-Gm-Gg: ASbGncvlak0Invclpn7RIBi/MotKZkY62Q//Z21Uyl5KqKViH8LeiPFegZnkrz1e/Yx
	ksUzJIZ8x68cyungtB0kLkHkNMl4f0i3Zyexnl4KZ0LVDZCJcbL1JOU3P9wrySvFCrJyx5DLRs+
	vX7Q8mK28iytDrXcbd26DCGaBV2GVr80SpqVSGUrC4pYk9ch53hQPismi7cEA6/J5vUnQW3YPUl
	I6Y91n4jxmX3TRMGV3mVfZQzCmrqGAw1MfkNU82fkqe3dL/pTsZpt5OfmHvWpX7liEeWOlLtqNC
	IiVAHdYNotA7e6zpSyR8z1/N5tgKxCLmvuDOWAPIKyAhLorAHaGRAjPrGERyY6D9yrZKLSrFCVw
	BOhLRshyyN8vTSQ==
X-Google-Smtp-Source: AGHT+IEdsu/Qgk454YfNKkEm3dxgZd63f+Euy5hTycBzZybjRHcCjF7RFqpoUEYdE2tEOHrEkK6aqX8cPhz5W4io1bA=
X-Received: by 2002:a05:7300:d0a7:b0:2a4:3593:5fc7 with SMTP id
 5a478bee46e88-2a4ab8a954cmr4688445eec.1.1763414830128; Mon, 17 Nov 2025
 13:27:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251117080714.876978-1-ojeda@kernel.org> <CANiq72=-w2p8sQgUKYgPG3Tx9GSUNgcVUp24k0ck2RqYgupCVg@mail.gmail.com>
 <da4877d2-65fd-4ad2-ac31-68d55bda7c07@nvidia.com>
In-Reply-To: <da4877d2-65fd-4ad2-ac31-68d55bda7c07@nvidia.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 17 Nov 2025 22:26:57 +0100
X-Gm-Features: AWmQ_bmCoQhe0tDaYS23xSdPDegbNWBwAWpbPsNqHFk8KCfWm6zlxE8mP2aCibo
Message-ID: <CANiq72mXN3U-oZDMfkCNTNLtvReZjROdgNmUDQ0H=kDP5FbopQ@mail.gmail.com>
Subject: Re: [PATCH] rust: allow `clippy::disallowed_names` for doctests
To: John Hubbard <jhubbard@nvidia.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Benno Lossin <lossin@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Brendan Higgins <brendan.higgins@linux.dev>, 
	David Gow <davidgow@google.com>, rust-for-linux@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Rae Moar <raemoar63@gmail.com>, 
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2025 at 10:13=E2=80=AFPM John Hubbard <jhubbard@nvidia.com>=
 wrote:
>
> The current set of disallowed names is inherited from clippy's defaults [=
1],
> which are "foo", "baz", and "quux". This may be extended via .clipy.toml,
> which so far has no entries for disallowed names.

As for this paragraph, I am confused why we would want to add it.

This isn't about extending the disallowed names or about how the lint
works in general. It is just about disabling the lint entirely for
doctests.

So adding that paragraph would make it the commit more confusing.

Cheers,
Miguel
