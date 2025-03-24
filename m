Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1762641E9
	for <patches@lists.linux.dev>; Mon, 24 Mar 2025 17:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742838250; cv=none; b=W2zdOnk31DibA86Lmsux4Q7UMpdrL1itqZBwVVVCICdrTfH1rn0sxp0V3a84eG4xvtUPmhNxS4a5mfETcmyej9Fcojj7MceL2g1foTXM5083bScSKF/VOXjVd72FpDFRpCGsgTuOeK/ZOEM75XlmuwJFazeiaq2tfocXXVsmsc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742838250; c=relaxed/simple;
	bh=P/9XwcXsOVbKjjIK2Rpo++6HrgceuJ+gEbpX1cDqB18=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qIEbetx80x/IvYPRp1btq7AGMNXSaZAf5F/XC5u237Q6HSXhZUYNk/3vclvkexXeCAh8FPMEu5m7njZuObOgXDLAcrI8Mo2pYNjV5+mOCAEMajODSMRsJJdU7IJmYVUYUL9YTH7bY3789ajhkzGjyaI7hfHCwOlIUTwpY48TWac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KY+iwOka; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KY+iwOka"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22409402574so10474305ad.1
        for <patches@lists.linux.dev>; Mon, 24 Mar 2025 10:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742838248; x=1743443048; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tr7fz1vFTN6V3l8Oj56sNPcrXIYTQ8WnJdNMz8DEkSI=;
        b=KY+iwOkacTsj1/weRjs2cOtqWoK3oZdgUL6z0WnBR55b5Fia9MGQy9GFNPeWbjeWW0
         D6PQ5fjlJkuKn0fZyPeNTkQIg+DB2nX3PWW/5lbBPZq8loF7GHEG6plTlRU0xs0Fq3w+
         BFn9ePH18h1jg5EOPRlFt1Qayc1sDjSSve5OTOvhvvDsuCu0HnwyPuBqcZQ2BJP4OAdZ
         BIpSxFH4S/17ZWexetE34gIoHFJaEyQrP/GbhCeKsbKcuh6lYY5RMg5hkNXqK/TU+2z4
         GS1mOtu9jSN9IjK0z9xEK+Pxl2qaARdgQFbZAviquN+1yuRI/xHusE2yFVJn9GqW77wU
         1mtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742838248; x=1743443048;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tr7fz1vFTN6V3l8Oj56sNPcrXIYTQ8WnJdNMz8DEkSI=;
        b=kEEecVvebSkCX86T2X+9FV1TSr8kjyvcWoNgCz6cbz5xi+t5lPxQYUiE4QQSCEKz2s
         pKlFfC124hXyKed3UplR8dUYDX3AY62Aw7qBddzWZY0PNdbvqVkXeFbYGtgBF0GelBXQ
         Pz2c2l3Q4/O4h9w6c2B0OcfACOZNzBwIG9Ubab6US0HbCq+zAtiiZTKEtruh18cLunmT
         m8z+KYbC/lYeRIgASy9lURoeQMzgDf3i8KP2GbEawfxG2thNS+ppJEdlX5iCl4sboSYK
         XBNcgoOAXfn6uyWffZqbEDS7a42L8SFJQWmRhfgQXpwJVBrs2ksLosSm/dG2028hoEdT
         kOww==
X-Forwarded-Encrypted: i=1; AJvYcCWxFJBoCeNzy/KSO6e7DPyql0P9MS9yri9Rz1zj+7RfHwfIhtgSEPuzgbLzTdM91iw0hVeI1LZj@lists.linux.dev
X-Gm-Message-State: AOJu0YyLQiRLtU9uYiuF6SMz6PJ8lhKay0TId5PX45ojssQqxfO2WY0H
	DVbsjDkjjjzpnfv9nDUuwbCVLN9GtKFT5lkfCPAkEn+Pm3kVslx1Tv2eSquU8YYN4lf4Ws+nclp
	nfEWuzXsXU1yY7vUahIoB/cq6M5I=
X-Gm-Gg: ASbGncscExe80O9RecgEyZK8GUSJ6m7pwI7TDzLZeh7F6gSyPQQQEMzUTjcWeWRRnF9
	yuQQ06e/KSg7KioAL8hNS8TWfkn7k9F2WWir9iILpVe8+3pDq/AjB53QbR7nWKcY81FCBI6KMd9
	n50CwWkKd/dD3vABGJ46pOsG1qQwSOuTEQKzW4
X-Google-Smtp-Source: AGHT+IHYp9P9Hd3H4WMAsbHt6gCS/M91bXqwUYnS4WNJN4VZ7p6l1yhJAh3NdyRbzI1+vwpRSq5rBe1g++hktt0Og2E=
X-Received: by 2002:a17:902:ce90:b0:224:10a2:cad1 with SMTP id
 d9443c01a7336-227913b859fmr49736135ad.10.1742838248360; Mon, 24 Mar 2025
 10:44:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250324174048.1075597-1-ojeda@kernel.org>
In-Reply-To: <20250324174048.1075597-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 24 Mar 2025 18:43:56 +0100
X-Gm-Features: AQ5f1JoAdDo2FferEGh4NhTQm25Yv727k5xcAQZM5n2ArJ6hFCIees06wSeNwIE
Message-ID: <CANiq72n-eP=gkfjLRA+F56WqaQwRZE2B0x4G9eF3W_U5eGxBbg@mail.gmail.com>
Subject: Re: [PATCH] rust: dma: add `Send` implementation for `CoherentAllocation`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Abdiel Janulgue <abdiel.janulgue@gmail.com>, Danilo Krummrich <dakr@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Robin Murphy <robin.murphy@arm.com>, Andreas Hindborg <a.hindborg@kernel.org>, 
	rust-for-linux@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-next@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 24, 2025 at 6:41=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> From: Danilo Krummrich <dakr@kernel.org>
>
> Stephen found a future build failure in linux-next [1]:
>
>     error[E0277]: `*mut MyStruct` cannot be sent between threads safely
>       --> samples/rust/rust_dma.rs:47:22
>        |
>     47 | impl pci::Driver for DmaSampleDriver {
>        |                      ^^^^^^^^^^^^^^^ `*mut MyStruct` cannot be s=
ent between threads safely
>
> It is caused by the interaction between commit 935e1d90bf6f ("rust: pci:
> require Send for Driver trait implementers") from the driver-core tree,
> which fixes a missing concurrency requirement, and commit 9901addae63b
> ("samples: rust: add Rust dma test sample driver") which adds a sample
> that does not satisfy that requirement.
>
> Add a `Send` implementation to `CoherentAllocation`, which allows the
> sample (and other future users) to satisfy it.
>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Closes: https://lore.kernel.org/linux-next/20250324215702.1515ba92@canb.a=
uug.org.au/
> Signed-off-by: Danilo Krummrich <dakr@kernel.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

If nobody shouts in the next few hours, I will apply it to `rust-next`
to clean the build failure for tomorrow's linux-next.

Abdiel: if you can give an Acked-by, that would be great.

Thanks!

Cheers,
Miguel
