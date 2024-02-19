Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460F125603
	for <patches@lists.linux.dev>; Mon, 19 Feb 2024 10:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708337180; cv=none; b=XVQHD1ax6ulHbBRvJLNKuNofMURg9AZc1b7UcliAhDRAiailFA3m0yoxK4BBIf5ioYFtXEw0mhTyFgUlCwj8sD/QEFlAJ8E+kJYwGnqyIeo/5cGbOR3ngyFT1VFHngs8fqj4E2RCmWhFt62sDXak4utK1pLfkElo0sQhqwEwfqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708337180; c=relaxed/simple;
	bh=vYBRCWQn5pi6BftlC353rMYRDQYvAkyKACgB5eVnF3g=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=QwNdeVS0hKXUkI9RW/UORIKgXIxSPm6M3+vwgMzO3pg8OynZbBb+KOuMvDkqH2gO37MwygcdizfHVL6wExFUyw871ggyJtbsZA1kZeSugZ1IyED6sY1NnvrBfplq0YSiCN5kvNrutPcYkUJrew8Ng2XNhfFZ8lx5Y4QC9kIIjxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=metaspace.dk; spf=none smtp.mailfrom=metaspace.dk; dkim=pass (2048-bit key) header.d=metaspace-dk.20230601.gappssmtp.com header.i=@metaspace-dk.20230601.gappssmtp.com header.b=KZ+IC0wk; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=metaspace.dk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=metaspace.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=metaspace-dk.20230601.gappssmtp.com header.i=@metaspace-dk.20230601.gappssmtp.com header.b="KZ+IC0wk"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4126a159fa6so1440335e9.0
        for <patches@lists.linux.dev>; Mon, 19 Feb 2024 02:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20230601.gappssmtp.com; s=20230601; t=1708337176; x=1708941976; darn=lists.linux.dev;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=vYBRCWQn5pi6BftlC353rMYRDQYvAkyKACgB5eVnF3g=;
        b=KZ+IC0wkAjP9PIP0DwDYuorEDN/MNzpf6DR7ennX0r13oYKpTQ2ALpeNmzJ1ZvoLsq
         rUI4BkEjjJUZLyZy0aXn4kT9ogecH0t/8oS2VfpdC4+usthvBqTZMFS8IkmAsg50xdar
         L5kuSaul8PkQW9UfUdrqDXwYA+IuJ3OkrifNkaTosr4Y2M5mMRHZHQGEQNZ54cvxd/Ls
         zG4mnac/BxayezPlm2U2JeoIxX/TuECQN+iFIqq3Puf/FRXF5ItciTeyVXET0+qUm6jC
         MgsEpuxAvxq1FotOUR3a5YNFCFQFfcpwieA/SicMFix3lceD5d0yeR7Y03cxDCiwbGeI
         yuOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708337176; x=1708941976;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vYBRCWQn5pi6BftlC353rMYRDQYvAkyKACgB5eVnF3g=;
        b=u8GJi8kZs3mN+33ivxVORoNy3SnjDuI/ZtA5+iObYt8YKRX4PG9TEss3ZjTECnDCDc
         MB00Lf6u4HMTvxeWlYM5y2J0uyJc/mEroEZ1LHmKvGjlcD9Po/kTYWvdq2EHhuNCKurx
         atUdzdn8ZLz/Fqzmar5UsnPIWv4ZbA9uzVr3GprWKbrNrXHGu8UQTs0LkyjK88NTVyg/
         hBgavL2BLznnY8vQtYjDcY6FEbPsRdXEHD18bUNjv7XQjLB59l776rhZiFFMf/lGP88u
         7tsuFkUhK15SufD6Evm/hjP5w/lrRYiipWvPiFTPrj6EkzNBk+0ZtX/FU53YSUoJIaMN
         MMQg==
X-Forwarded-Encrypted: i=1; AJvYcCXaMWX7rYvCvEQZf5yxJmF3nkMTVMQfqz+pvVetO8XCdsnY+kQjjabnOdVIRTwOmzARBUqo03jEPuA04gba8IkthIyL0wK8uQ==
X-Gm-Message-State: AOJu0Yyh00tPt/56nvs5JYm3z9MxtuMzOCO/ihIxWQSh5Op01Ra20lwj
	vmD0W6KoOWKzMU0x7/DHdf2/SSxu+4GjVdorwHBk4RxuOiGIFiNs4cjyw5S/Opk=
X-Google-Smtp-Source: AGHT+IHvaWFWKJICK4F7j0G/eSgGRsIOQzy0vgHZmI/yLOGmIzrOYxDsz1f7pKjzXKmoo5Qyz8h8rw==
X-Received: by 2002:a5d:648e:0:b0:33d:3bc2:7acc with SMTP id o14-20020a5d648e000000b0033d3bc27accmr3045129wri.11.1708337176264;
        Mon, 19 Feb 2024 02:06:16 -0800 (PST)
Received: from localhost ([147.161.155.108])
        by smtp.gmail.com with ESMTPSA id n15-20020a5d660f000000b0033b1b1da2adsm9842143wru.99.2024.02.19.02.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 02:06:15 -0800 (PST)
References: <20240217002717.57507-1-ojeda@kernel.org>
User-agent: mu4e 1.10.8; emacs 29.2
From: "Andreas Hindborg (Samsung)" <nmi@metaspace.dk>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor
 <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo
 <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH] rust: upgrade to Rust 1.77.0
Date: Mon, 19 Feb 2024 11:02:33 +0100
In-reply-to: <20240217002717.57507-1-ojeda@kernel.org>
Message-ID: <87ttm4g462.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Miguel Ojeda <ojeda@kernel.org> writes:

> This is the next upgrade to the Rust toolchain, from 1.76.0 to 1.77.0
> (i.e. the latest) [1].

I am a little confused about this patch, since 1.77.0 is not released
yet and the link [1] (currently) points to the release notes for 1.76.

Will there be a new version of this patch when 1.77 is released, or do
we just expect no changes to alloc when the compiler goes from beta to
release?

BR Andreas
