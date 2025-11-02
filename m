Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6C41A9FB5
	for <patches@lists.linux.dev>; Sun,  2 Nov 2025 22:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762122044; cv=none; b=XNZP0KLwWwlTVdUgiy7no2W4IXUiNmw4HscVl7nuW7ybWvvP+aNBEBPUMkoELyurhbHfGmXRHw8RXHwGEYBJHsVNDAuX4RmLe4VB+rmCwh9Why+OeEma8cgictK+XpG+pYFwXNf2vG2gM1FnyF8nZRKTnDTsL1MV8RSI4goewNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762122044; c=relaxed/simple;
	bh=vZO3PHgqOIKSLpT1XNcnJgC5AHDehu62cqI6I9Q+irs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RdaXcytPr/vrRAupr7oKBl9tq5NcxUCfobM5l9xZdeuJQ0fX3M+iOFXnskzTXEj8Lk0nAo+gmVS4jbssJprWMawkFtCHtvFfkDmZ+qyV5W1EgaUPo3Std5IC8UwaZIseMjPMrSPlIZFoh/2GjFEuFg4FHMs+gNmogUdOvW/e864=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rb9I45dM; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rb9I45dM"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-340bb45e37cso494579a91.3
        for <patches@lists.linux.dev>; Sun, 02 Nov 2025 14:20:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762122043; x=1762726843; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EyIK1ilUw35FUA5u8sORs0QLERPXEburx1e7TliwGA0=;
        b=Rb9I45dMuZbgV2o1FpXoLMY5bOM9lnOFbwALJfxd2saWDxSAHBE/2KD8PpAhs4V/Nq
         iW38M7huGi0K94hNUzr9H7EmTC6VivojShOscnFtQWDiYVkkxuuYNPkqXgpQmWF2/PHj
         /GTvlqxLEjQqMEZKgQzYuaNmbbAFKHgOjyzBnf37BIbSUHuEeSjZjXTeZksq3/8f3skg
         iAK7JVrQPLWuG17SrU3go8jI9kq1Zu1IwYcVrGwm5tEa9Xhrc+rIaNrEh+UBvoUfATAr
         qJsvnavdTSDLBeWHFTvcxCXj8LzWOam1Y6Af13TT3gyGeYDpfxfdR8sk6/cYfUUVl9DO
         cGLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762122043; x=1762726843;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EyIK1ilUw35FUA5u8sORs0QLERPXEburx1e7TliwGA0=;
        b=tQG+GF3PhJbV13QRybSWcyXhW7OxqRH5Q3mSZvKLQdB+F2TrPO5ZqBYrS4KV8ppSQO
         NcB4rCoBOjtUuxT5to6DCttiB/RKz4U3Dl0qiYv+S17hH154FT69cZQFF+ckRk5DXa4K
         mREEgm3QSNizEFxjuMujGV5oXyw4YHndNvclNjAqlyrtHuWqo3dnN8YbJGE99kakN7Fz
         RxxHFvVjcDr+nHwpkB2Z8fp1PO/Rdh4gWqhmddq8fBXajqdUOC+RQq/gU+1HPRQ8/OkH
         yrdOLLQBrAMAg2hYi7Q0bf6I0zQAzodl9LgRIHzJk3pd9HQp8dclBczrXDjyWNQVMzGq
         F5MA==
X-Forwarded-Encrypted: i=1; AJvYcCUUQ9+tqqEr/Me9/bc8evGo1zcqgDqDJDM5qMgiTlNSqSoGjg7t0WJ/9Erhv1XdQRVBUgdvN3Qf@lists.linux.dev
X-Gm-Message-State: AOJu0YxMqHG6s+gIq8e+7R9EtH0TQrJMHPlhlCXg7LKDt3nTTYB48ICn
	iqY/UIOvNTAnP7T0N5nhGx2QKFd1we+ba75DpYvQMxL/UlL1NS5kPPTFGGvbO1IZ/xvcolYXG8L
	djQ7/MUS0DuHjYRW5X33hBHVzparepSU=
X-Gm-Gg: ASbGncsA19x76dEeVdVlAB1iZd+0Yei+3qkHQHk7xOSi9uur50YAeohw8aeIq8SisA5
	P3mlcyIZ+4VGifbQ4NVoMb9qBJ6N9uaOwbZzhsuZ9ODiA1nC7Q5GEsfZXgkmYQzUgW4uiHxp/Gw
	5KethDTclb6PUfM+gKWDlmp9tUwmvKTkzyxgfmDEV9MwNzJGJAAh/fcIYbguo44VU4IApEQxfxl
	v1d0RcnqfkK6A8jPjvhMPTB99LTIO/JrWtWNG4F3V65JMBMjHRDlrV3XkiGUkn5JujEPTK2Obpb
	18gdSqIsni/gbT7M5lvhtsTxDBT3a9ABKUecJf2bx+w61azHHeiXF3is8CpZgdtDWeyDVA7aDPh
	49tU=
X-Google-Smtp-Source: AGHT+IG0gQL4wpqk/N4eVevZ6EiRRAV29O6T0xOWLIHtqG3MysFxyrTz0rHu6gvrEfX+GEpHUZmKMf3I7Bn4K3wt4cg=
X-Received: by 2002:a17:903:2346:b0:295:586a:7644 with SMTP id
 d9443c01a7336-295586a77ecmr35979015ad.9.1762122042760; Sun, 02 Nov 2025
 14:20:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251029073344.349341-1-ojeda@kernel.org>
In-Reply-To: <20251029073344.349341-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 2 Nov 2025 23:20:29 +0100
X-Gm-Features: AWmQ_bl3OkSjDsxEokBQbHWG2tBRxHmsdbaPCFuCFuWjjrdm7lQYLIM3Vzk9M-g
Message-ID: <CANiq72mKjZfR5jfzra-EEDx1BVJ23iwJgRHuFf+3wJh+iE=T1A@mail.gmail.com>
Subject: Re: [PATCH] rust: condvar: fix broken intra-doc link
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 29, 2025 at 8:34=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> The future move of pin-init to `syn` uncovers the following broken
> intra-doc link:
>
>     error: unresolved link to `crate::pin_init`
>       --> rust/kernel/sync/condvar.rs:39:40
>        |
>     39 | /// instances is with the [`pin_init`](crate::pin_init!) and [`n=
ew_condvar`] macros.
>        |                                        ^^^^^^^^^^^^^^^^ no item =
named `pin_init` in module `kernel`
>        |
>        =3D note: `-D rustdoc::broken-intra-doc-links` implied by `-D warn=
ings`
>        =3D help: to override `-D warnings` add `#[allow(rustdoc::broken_i=
ntra_doc_links)]`
>
> Currently, when rendered, the link points to a literal `crate::pin_init!`
> URL.
>
> Thus fix it.
>
> Cc: stable@vger.kernel.org
> Fixes: 129e97be8e28 ("rust: pin-init: fix documentation links")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-fixes` -- thanks!

Cheers,
Miguel
