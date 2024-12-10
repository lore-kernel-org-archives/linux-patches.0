Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED368632C
	for <patches@lists.linux.dev>; Tue, 10 Dec 2024 18:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733853693; cv=none; b=WobgJfKj/FIAZ5DNcAipAZcXbUqJ5SM7+v1ICrAUTSa6ZYSddDJAND+uTDiIwHnJt2dqj4CHIPg8S2S/YV2To4j3R5bGF2p9AeSMBE20ev4RPof/PHlRJFZILCAQyen4zVM04XuMgG9qjq2+PK6AaBoirCecJR5FIFCYlmBffjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733853693; c=relaxed/simple;
	bh=JNsfJ5pdWNc2079cGlyKbP97GYc87y3iN+nIMeKFqCk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NUxTnYO44jquQOjNQejP7aKgrEfSvN1DQQ6uzndxshIV4DKXpS8m1dHMbTBzAk9KISjBgQPPJwJEy8he0i1lA2BInJyV89eu7/pIDtvCZO9gwQjnwgZKvc0PsUHp2F4oZuarGY3ZGZql6JQeaOWMK63h8GPWpeLmoMP0shuJWB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jt4x0zq6; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jt4x0zq6"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2ee4b72d4d8so866973a91.3
        for <patches@lists.linux.dev>; Tue, 10 Dec 2024 10:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733853691; x=1734458491; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JNsfJ5pdWNc2079cGlyKbP97GYc87y3iN+nIMeKFqCk=;
        b=Jt4x0zq6TNfvlKj5HG8QyDgVUVvql1pi/YAoNZjELEf0stWdS3boWP+PXf3nBRWtnP
         mBs5EJSAnNPLmOaRWe9F6ZO6saNKpRFvb7Dx2E29kELGUxXluua8Y47frEYuOJJplH4V
         JEzUL7XWPKhG9XLO2ha3dK63psfVJt5wyQAh7pkYb2c3R/kvb38nj7uqpXhywPkBjINj
         2NWjcxnospsDsbXXgKabr67cU7WPa1C5XUZRBe+jvN0Xtc25FKKXvO3pGJ26KAIrb95w
         RjOrQ80NvuMOAEG4FPqE1v4BwnE7nBXHUYfSs56XD/LHzgzYOfHj53rxnkkSJvf4pguc
         jw8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733853691; x=1734458491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JNsfJ5pdWNc2079cGlyKbP97GYc87y3iN+nIMeKFqCk=;
        b=Ly40NxN19aITYKLrVMQ0tHsjaknjQ4gctjPcnFlAH5coJwHzPLxJ0H3nKgOipFi6Tm
         ZfBfoU8iwogyd2WJBQAuPPAGCHsT/TMdP0A3qSu6E3M953zqIyu9UgtdZDVK00t1yOhg
         hRM5Yabf4TBFVyYCxaJNzyjOBu+hlu7Veh3tPcRh6QNm1cUnIAg4k8UT5WGxBmiIszGp
         /LJ4rnCnDCC5ajAwFWYOFpUSD/m8x4m3N6mmgAQ6DNg5Dc+g2RtkszDA3k617An8oVUc
         o4y8vOmtBLnHrGtK94geYXUUroAyaleMp7jHHf0NNQpRfId3T8uLD6LLdU+55ATJD+IC
         MoJA==
X-Forwarded-Encrypted: i=1; AJvYcCUlIoq/QpYt1nK0VnsucizjavOlwVssUBhlnmZ0CnBwXSNgIH2rbn4CmfxgbuWTscH9goMqRQca@lists.linux.dev
X-Gm-Message-State: AOJu0YzSDX0FNWGl/4G2xNS4teck0+3/oum9+EGybUMVHcKOrfBMRTnP
	XOMy/R4ofO7ikIcUDBc/ZMBxjIwVywBqfgzQd7GCvy5nP6pbjxZxkmaSOR8aQyl1oCgGw1STv7u
	N5v+1NAFCVlQ170YmcKLG78/TjE0=
X-Gm-Gg: ASbGncsIAfv9+ZBRh3kLLc0oo/mgnUzwYxO2yYkiSLA6VDr96g5yfc0Tp5843Swbch2
	2StHFGzVUeZSIThHyrBk8rctfKj/f0eGgLQk=
X-Google-Smtp-Source: AGHT+IEOx4TLwYTEx0tez22Ay9j240MtFpVMbkftbBFXYTPrYlXiCjSnJ2j0pJzk51KujYrWBs+KGwyhX9ukXvtPB3w=
X-Received: by 2002:a17:90b:3b4c:b0:2ee:f59a:94d3 with SMTP id
 98e67ed59e1d1-2ef69196c7bmr10125270a91.0.1733853690916; Tue, 10 Dec 2024
 10:01:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240817070955.75717-1-ojeda@kernel.org>
In-Reply-To: <20240817070955.75717-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 10 Dec 2024 19:01:18 +0100
Message-ID: <CANiq72ksDpJz2M=qPmx7F+MxpiY5ms8zUpdkTL4BQ+EvOS21Zw@mail.gmail.com>
Subject: Re: [RFC PATCH] rust: use the hidden variant of `rust-project.json`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Ali Bektas <bektasali@protonmail.com>, Lukas Wirth <lukastw97@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 17, 2024 at 9:10=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> This is a patch for the future -- we need to wait until most Rust kernel
> developers are using a new enough version of rust-analyzer. Thanks Ali
> & Lukas!

For future reference, this has been available starting with Rust
1.82.0's rust-analyzer.

Cheers,
Miguel
