Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82781199221
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 08:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725524163; cv=none; b=Ibtzpxzo12sH5ptOm0vViN+71ElMryLO/SUHHaMgBoaSWbAVlm/iMJhFDQaCZjCcUYJguCbNb+/c2zzlq8RRV5sCG5+ldPmkuk5eAk+Ts/5ISK9eL2kU84ntAfldTD5ZgHAxUDZbE3isxdCRoE/RVa8CzFuBBB5YIDNE7LF6K3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725524163; c=relaxed/simple;
	bh=zzEfaENRIqRQl0JbYcNKk5MHDb85IJy5SJDJt767CxQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nb7SpJzLMvrtwoIvxkP8mlfs2J0stnlxErt24Mbkbkt9XgL6jArU62PF6VBw4UUww284eZqdAdZZJb7IqWWcD8868OkIK7B2gCEks3pKRUOgg2pG45bfqOSP+xyAvyXQyQTFwybbOi3gGq4pHPtEhdsKkEISnn2hVfQdobORcDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PZYjo5EO; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PZYjo5EO"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-42c7a49152aso4323245e9.2
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 01:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725524160; x=1726128960; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zzEfaENRIqRQl0JbYcNKk5MHDb85IJy5SJDJt767CxQ=;
        b=PZYjo5EOmxkQpcwIkRHIdqvMD8mFfp8bNvrypHQyW8cE729wJFRXmponospvrznO+z
         YpMXuDx8RyKJWFiDcBuGW0QPyuAlnCw2GRpbZqS0Qvy50ILSr6ROE22YRxuxZu5fQa8s
         iqM8B6i7/CtCkeOcKNmPRtd3ak4qh2I20I8eHfrP5OJUIgUqWlCI7d80v3nd23Fswfb7
         3Y/aGZgVFYQF8bz3pTHeJa/EKjLvEUoxOFtZ2umXWnZ9LaT5nE3PR5TaIQ1rxtrzegTD
         7ExyQX5pCfpXysbSYREscWX1zx9HQVat3AYlz1JzSOzlQWQQt35e1iuGIWrcApOHE40V
         690g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725524160; x=1726128960;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zzEfaENRIqRQl0JbYcNKk5MHDb85IJy5SJDJt767CxQ=;
        b=PVC1IAlYcj9YeO+7atzcgAL8ennHmpNu9Grby0pKyU+AAZ1abuUkStkiDdng1OLyrF
         GaiLPMsGOedjjNgoXXi4gvo2LaYOoFin5ALhEBDtZqm/pPYrXkGzN4fvMlu294/Ui7xi
         5fkby1sbRc/b4PoLrnLSwEOIz3k3f46xY/dFqhNN8VS0Dh42oMypEGKeOXHZKUPZZhpG
         WyRaTOQbCLM7j7uUD9ckgg7oHcC7U24erB0bmsEfXSxB11ACxm8K/AnhCBRt8yHGX4i9
         hMh8Q6BW0jUeY0Cl9JvEHWHCsffSL+yL6SyZv6YsvXV0n+8KxFu41wrn1dfPZldimHkO
         D1hw==
X-Forwarded-Encrypted: i=1; AJvYcCU8QIPuEOxNvCE3vMoVn0Tud67SYEM9lEVXlOJZA8TIeFSvp6KAwEe/xExXWh8DWqEjARd2JFTm@lists.linux.dev
X-Gm-Message-State: AOJu0YyFFfbq1JGtlKazcw3uwix+v6Ju542QnIcuBF9Cn2I2wVRHPXiE
	oiiE73g0zzRmRgcOZ3ua9eCb3k0XxdW9P77/YDbtIcMIs3VMkVmciXCHR1+8XEQmcMcXfUFu8xS
	pVkFSM2Ep8izfMPnNdmZTDgHKn4ZjCQOKoRen
X-Google-Smtp-Source: AGHT+IFGe9FwF4ew6fPFdL2Ygl8vPEA3LpCNMQCfRGgsrU2sesbleRr+RS60eiRwK9tP5YwgxFA3l6MeMRDAa53pyQU=
X-Received: by 2002:adf:e6c8:0:b0:374:c3cd:73de with SMTP id
 ffacd0b85a97d-374c3cd74d5mr12499736f8f.35.1725524159551; Thu, 05 Sep 2024
 01:15:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-17-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-17-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 5 Sep 2024 10:15:47 +0200
Message-ID: <CAH5fLgg20kDCJfD_6+fTSogOnpqK0x3a6eKaTahgSvdgfFzSEw@mail.gmail.com>
Subject: Re: [PATCH 16/19] Documentation: rust: add coding guidelines on lints
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 10:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> In the C side, disabling diagnostics locally, i.e. within the source code=
,
> is rare (at least in the kernel). Sometimes warnings are manipulated
> via the flags at the translation unit level, but that is about it.
>
> In Rust, it is easier to change locally the "level" of lints
> (e.g. allowing them locally). In turn, this means it is easier to
> globally enable more lints that may trigger a few false positives here
> and there that need to be allowed ocally, but that generally can spot
> issues or bugs.
>
> Thus document this.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Wow, does C really not have an easier way to do it?

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
