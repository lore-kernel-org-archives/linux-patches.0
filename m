Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4363093BA
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 10:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762770388; cv=none; b=o9xZ9Vpg/cSN719KY0yZj+MewECVsIoTsmXB+2i8647p3sIokrMIKcRC0fzoKzCYWdsDyPLx8sDYb1ln1R8pSGuqInx0S89ntopRgQ7StvgLTJT6tZ+c0ah5ooU1KbihLqiSuLt+a2dTbWMeWUoXr8G+b98Nq7j+00bAQ/5Qro0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762770388; c=relaxed/simple;
	bh=by8TIrFWHwZKFzoVR4uqzhkqjIaA/Zdl/PpOV94g580=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l4ivc55EMxSX4glqAmHjFapQsayyUncv/7R8tft2Zz6FbWTB775OWhAYYNGl0leOR2YKhXlyPilFUmE2zivI1/mttLeuq4ZDqIRq1y7ENJbigQv6sTAmjio87a9AMqIdDTP78pVS5rEyalBvoUC1OL4EF+HAomCjonqNcL6JykU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WIkdQrXg; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WIkdQrXg"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b6a42604093so248552a12.3
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 02:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762770386; x=1763375186; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=by8TIrFWHwZKFzoVR4uqzhkqjIaA/Zdl/PpOV94g580=;
        b=WIkdQrXgmCl7ZwZX/O7icdOwYcqtkhjuZFYeBtzPbpVUIIQmwX8x59oZAgU1FHeJQ3
         JfXxEGID2gzEMkjWuVQhm50/ZRj59BYvD2Qi3xC45is3hD2poeUufZtUwKkaVj2FRqtZ
         ZP29yS9oKsI6Lu6D28PYlqrSBQvID6Nfzm/lUbJ2mhxQVzXIL9gpUc+EuATkmePwIGN7
         JXnRvtWujLvc+/+6aeKZYyl9x8aaulrBsyfTgH1UKkjcPt3O/HLQGrHrES8rReFRy903
         NiYbb2O919KKQWYsOwHKitHe9Xo4vhWf0NFAVUlaNAB+CEHxMISbB61MyVutJdK6o2rJ
         d97A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762770386; x=1763375186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=by8TIrFWHwZKFzoVR4uqzhkqjIaA/Zdl/PpOV94g580=;
        b=vMl46JIpG9SZ4OzSIbJCNK0dOzb36J7YluTUBSepW3nLs840sU8QKmO7taGETKbw56
         JnE3RRP418ZTHib0wVOsw8wozV4Duycn0o+SbJXJ0AHZv03Cvmxj7kxmLV1j9KKtQhdG
         BBoOIJdAFqN8q9fVwZ7NwPKBKC3v5fqQVRYw9vzI8eZAMmQjxjmWLLNNSKOafw2PQDpZ
         DXZOX8IQSpdmA9fb5BNLM+0XFVFFz1hliY6wqK9DrxYMj7cPO6f1fJ/7s7yIzxkV8DVd
         TvDNcryR2joi2YEjfNB2St/8Rpfcku+TLFEvQCRdI/Y3jjtST6For9koMIFSNBoPgy64
         mfYg==
X-Forwarded-Encrypted: i=1; AJvYcCUs9TLVooayKBG4xpu8GPEg0MBVYpUy76d7ULF3iQfPXFJw28IsopwbsV/23sm+8evMWOzLsXs+@lists.linux.dev
X-Gm-Message-State: AOJu0Yxh79Vvs/UplXinwyNv5P8OZoomDqb/h5O+VUaYtwYRTqfOCLdz
	5I3fYkHja1v0oGdDrAfHEQRnVEB9tAvuQY689tFhVouAwb3B8q0hFi5HdqAH6SBo/KnaXXYW4FB
	F/GEdD0ynBzetAwGsFl/9MUIo5GCv5hA=
X-Gm-Gg: ASbGncuDL4KfF6kDfvBmweOazrtzibmBpMc8FFC453A3mLRn62ZCc/meUF7e5YNj8P1
	YFoD1EB2J/cr2w1rMXVyykjGb4aUPUymhj9R9TgoAudH1yb4Qpp7+ax0jIyTw3b2886YCtAUqTa
	KUJHZ3kDaeyfJHN5aawMPvoVP5hoZwV21XIf98g6bjnjv/wobQ1NFmJ4BpPagU1OGw7lXPOOIlq
	CLPkXAS0jeheFZaB1vyLAH5sWZOcbEv5A1pFbSryB2uN2S2b5oBodo5tpfRmng4uahAykTnkzyW
	Bd9k1PdG036LS+f4qq1HtP80ORKB8LO39WBj/69UgBnKdGhXt2dq5oWCsxqgzpGSiRKjpSCZdx7
	94yg=
X-Google-Smtp-Source: AGHT+IHj/Ik6F63wXenE2lPX1U/3plGIyl6aQSJtE99W3m5oMNrVCs+apSxU4qv0V2MoDNiFGSAPl7exsm++cKNsBSE=
X-Received: by 2002:a17:902:d4cd:b0:295:a1a5:baf6 with SMTP id
 d9443c01a7336-297e56d674fmr53416745ad.6.1762770385914; Mon, 10 Nov 2025
 02:26:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-15-ojeda@kernel.org>
In-Reply-To: <20251110095025.1475896-15-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 10 Nov 2025 11:26:13 +0100
X-Gm-Features: AWmQ_bmNF1aFkVdyK0tmwwbxBOtgx8yYVE_IklxhPzUh7f2u3k4oJdZwWsz3eYg
Message-ID: <CANiq72m=dacZijsyb82HYRWc_PgzBOQA9YCSJQPOkUT1O-y2gA@mail.gmail.com>
Subject: Re: [PATCH 14/18] rust: syn: import crate
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 10:52=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> This is a subset of the Rust `syn` crate, version 2.0.106 (released
> 2025-08-16), licensed under "Apache-2.0 OR MIT", from:

In case someone is wondering: I didn't use the very latest since it
was quite new (even if the diff was fairly small).

Same for `quote`.

Cheers,
Miguel
