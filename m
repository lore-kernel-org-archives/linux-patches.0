Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BD828E0F;
	Tue, 29 Apr 2025 13:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745932767; cv=none; b=j73aGspN5O7qx49GfiGigBtPYgcY0xeiWB8Wxt06q0vtLub52Q1D3ZFHQE/Wk44/6IWM3FL3/BXIcj6nSNAmHAIelKjYGYn0ZJq23qvV2bDpzXH+KpFRU+OkkO83yEiKYCzhXHtRM/uBssKmzvHGPrmD9j6jgpC6iuY3XUvJJtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745932767; c=relaxed/simple;
	bh=q6pMNSJyTz849RKd8d/Eni1P8kzBFLPdHuoV6nEkUnI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dilVZXp6NUcYuTTjxwPm0D7T5A/zBHNS7qjlA2eia1JJgoNliLZFQwEwASemTgAQykznl5WO1pKai9W6ewBP4RflF/THxRYRH5Ain07MXnIUdCetz8p/XoH2DbOfl/R/pgDiC4DZdZYyQohw4YNkX7fZxNIkyPEAiOhUGLiV2do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LD1Vq1Ka; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LD1Vq1Ka"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-301001bc6a8so614615a91.1;
        Tue, 29 Apr 2025 06:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745932766; x=1746537566; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qfwi78OPJ+7NloXGVD0nV3Y/3cfDPkY2XA/mDHzCFKg=;
        b=LD1Vq1KaUkDwXRXsOlsHihh8sMbYXZOmAikYfhi5es9hGl7/tMErc2xTdcewFikS64
         BYSXvNkM3IuZcXXIM9zMhQdJHP58LDfPOeHin1nkEhvzXwHyVrktb8ZlrZamS5Zt/Vru
         PVlHbbyKT3z4c6ygRfvV34qxjGSGMKXrZu+ufwDu6tk3WuCKwI4L1tyTUpI4LLf3cQDl
         Er+D32wRwW/nb/JJ9m8CLThDT//+1DDAbNCwIxJM9lLQibjoVIpQE7cH4u++eyONITms
         Bq4/vvV1RL5sbP9ASTZFkZIwSyj0A6Il/0cYZ3sl76ij9qXetIn0uGPxO4yEP+X1ucLJ
         e4uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745932766; x=1746537566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qfwi78OPJ+7NloXGVD0nV3Y/3cfDPkY2XA/mDHzCFKg=;
        b=hU14O+HxZddH5PjapzJ1S7htD5H7nkBWOZZ+5+I4ZR9g8vcGHvAgEF24NzS1/BkmWx
         QAr08jwH/y52sTukS0zI9pvND3ZW9ZCxn2e53KGtgtFppiyfomz9HNNryaX7OOUGY+gu
         cl42I1vzgZiS5wi/Tq62k0P63c7XQDHJgcuUZdxFd+3fQacq1RNdf3AE/+H1+Ca/YSlg
         u9gSeaAbyYYBDIW94gxPnxspvWG5yt1keTYp99ZINY/ZvZDM9dTWtEQ8BKy1H4xMj+3I
         LYaBFp2ujZOPQ7rtZ7n/TFJAeXpsgROe9Ql12lAKG0pzh5O7d8ueISDlDo2UUlVuxFiy
         USPg==
X-Forwarded-Encrypted: i=1; AJvYcCV4DGz160QgLhEJOu5mbWQ87MuRkauH3u1phtPP8BuYUhks0SEhVVXz95A7R5Cimt3rZrbnHTCOAA==@lists.linux.dev, AJvYcCXOjMXRl/5w7SaN+og0hdMM4M1WNWyPgopH1zi9eboA1mOjrZVHifk+sQfJ8R2vMrTFIQXw@lists.linux.dev
X-Gm-Message-State: AOJu0YxYsOBnvyOmhxYArMeNjry4jRAnQ9i6f6MICXdoytXSYyI38zLj
	gpo1nzTF8AbidTdhaeEvtzxg2RyZ4u0/D6C9IbkaPBHi9sS5Gw6PFtVPGlNFx/LLzf0jUTUBP6p
	kzdVByvytD1ZupXJ1AC0YKBOkWbA=
X-Gm-Gg: ASbGncuILXB1MwfwVUCUJW153b6MzBDaTcnxiP152atrfKSXI62IWCSDUAa730TXSJs
	8sPNcjJNLmhJiihu3yu2XoSrw7k5m9Ser5E0TLFJKNnTxnlIkn2ZIdlmCOAH+4Kl5gyLQwzfblv
	OQOW8wrmXpTLquofbDRJQxYA==
X-Google-Smtp-Source: AGHT+IHxnj2vnGMV80DWZ4aFFXP8qUs5JrcNSGq2bKT98m93IjisoHwKfYDtOCPyJ/O9yqy7+8fVIugvKcq0lL0lIqo=
X-Received: by 2002:a17:90b:33c7:b0:305:5f20:b28c with SMTP id
 98e67ed59e1d1-30a220f061dmr1555914a91.5.1745932765639; Tue, 29 Apr 2025
 06:19:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241119185747.862544-1-ojeda@kernel.org> <CANiq72n4Fw96hcuqQeorsfH7z4Tb+R1gdf80H_XkD-oA6z5TSA@mail.gmail.com>
In-Reply-To: <CANiq72n4Fw96hcuqQeorsfH7z4Tb+R1gdf80H_XkD-oA6z5TSA@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 29 Apr 2025 15:19:13 +0200
X-Gm-Features: ATxdqUGN0dlLf5NE4vIholiXMZscWUbgyfznzqrixWlWYYWoan5VvhqtWa-4NWI
Message-ID: <CANiq72mNJrMMbEcfJMLT4kM-_iviM0AR6oeigCyrb5eMWkn3KQ@mail.gmail.com>
Subject: Re: [RFC PATCH] rust: allow Clang-native `RANDSTRUCT` configs
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Aaron Ballman <aaron@aaronballman.com>, 
	Bill Wendling <isanbard@gmail.com>, Cole Nixon <nixontcole@gmail.com>, 
	Connor Kuehl <cipkuehl@gmail.com>, Fangrui Song <i@maskray.me>, James Foster <jafosterja@gmail.com>, 
	Jeff Takahashi <jeffrey.takahashi@gmail.com>, Jordan Cantrell <jordan.cantrell@mail.com>, 
	Matthew Maurer <mmaurer@google.com>, Nikk Forbus <nicholas.forbus@gmail.com>, 
	Qing Zhao <qing.zhao@oracle.com>, Sami Tolvanen <samitolvanen@google.com>, 
	Tim Pugh <nwtpugh@gmail.com>, Kees Cook <kees@kernel.org>, Nicolas Schier <n.schier@avm.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 9, 2025 at 3:51=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> I may pick this very early next cycle so that we can get some testing
> during the -rc's, and just drop it if something breaks for anyone.
>
> But any other testing beforehand would be still very welcome...

I ended up waiting on this one since I think Andreas would be able to
try it with some actual workload (the nice benchmarks he has). Anyway,
it will go in sooner or later.

On top of that, backlinking the seed discussion since I will need to
update this patch:

    https://lore.kernel.org/rust-for-linux/CANiq72mwYbg_L8u9NEfRD0Fp9E_zhCi=
=3Dt=3DU2jyjsZe_Ls306hw@mail.gmail.com/

Cheers,
Miguel
