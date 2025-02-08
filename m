Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DE62C6A3
	for <patches@lists.linux.dev>; Sat,  8 Feb 2025 07:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738998875; cv=none; b=Xshmg7pu2S67xICoOLBoRXUeoeLKkJzWlprGwDXv2x2V251i5xqRFER1j6Tv9DzKVnnvFeQvYBJWJV3WICgHtyt63LKd4ZxzQ4fbuDLyb7Qpkgrh6qlHF5cxcc7Ii5vRqovCJK4vYPbwyMeaFyt/3zsKbaTLSyhC78geHiV0aEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738998875; c=relaxed/simple;
	bh=5PPzswXLCYycw4FzLaiLH/vyU5KIFGf5TLEB/UdgT0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bpBcGvjTI7B4Na9AMLM+0OrfZDnj19GfVSJoffM/5h06lUrHVHDM+zq5Ksz/yT6TCy6WWXyXhsA4ZgHik3I/geWY06rWG1XjbPlqSrofzmXi3+cuRRUGWmpQxqV+0kxEJzxkMfbCMvjL6AS79FXo56hG17wCZ0HBcHlKbcvr0i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FKpMLfwa; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FKpMLfwa"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2fa44590eebso751287a91.3
        for <patches@lists.linux.dev>; Fri, 07 Feb 2025 23:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738998874; x=1739603674; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c8AtJO3Auz+wNQ7YcvRVGGTP1+wDxutvZ8uaptDjAaE=;
        b=FKpMLfwaUvivxDacPwhDnQRCyb8JVv7GqNhWV4lRQyDSPM75+xyH+mkklWx+rvsA0A
         IMRDesVw9l49hn5pLjdaNy1gOhfewMxyC9q8hPEdErwIHZnCB7GCc/77Kq0b+uKxe0yI
         wBiElqGfaWx+K7K+32CZK22pKnnIMITa2v7sBO/TE/sxIuSm4aHumDU41Wn9+RnRxSFT
         kbgx51wO2SyXAIZaRKqWj/jL2UqunXm0Og2s3B3gHrj1gFdw9Utyc06cUKmTWUDYrpt4
         nUu31ZxeL4hhwFv38+g9o3yOLt6BGIafA3ksMZH95Z7CvLSIqlBastJWKTAz6CnVM4Kv
         Nv1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738998874; x=1739603674;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c8AtJO3Auz+wNQ7YcvRVGGTP1+wDxutvZ8uaptDjAaE=;
        b=HkMtEGKu/Emke6tO7XUWNzqtfB/OPnteSglnnCXTUFdu1P869woqvkZy9DORL0AMFE
         RxxnGgrnLFRMCCX3fSJUGFKbeDolu8AWLjAwQRcTfLmnOG1ckGWtmVhC/PGaT6PKX713
         Bm3PwqTV6lXw+ewvD5r+3oPXzENzSis9/lp6e1FINw7ARodaX4JgKXB1im2viwEhIEl1
         efXBWRGJ7Sv4NcSUqX3DLVnX9lQ9q127ejIZfj0TAXZrvhtWDX8EI8pcCoBUvQyTj2Or
         gYD+KVFcW7AZqs5tNQmKB/LOLhlnGNx2acUt/MrNEZ5ZMJ4/Qs1P1KoMHKaFEfDGdJ+Y
         rDYg==
X-Forwarded-Encrypted: i=1; AJvYcCVf5AmWxhXUrjIei9CRabTpQ0Bn49Le/4nSHM8PlEPT7em1165i1w93SUVvUuoT8CNJGcDxDymq@lists.linux.dev
X-Gm-Message-State: AOJu0YydukPA5oF5p2m1p5JJGp8Mjb6diHT5C79NP+De+nVz5IqdPdQL
	DNoY+wdDzhhDRUejUsJbsz/hvqkIhR23e170EvIRr1VA1TLoKLam
X-Gm-Gg: ASbGncuhe1PZ3dBFUJmpqf0hjM/f6hO0TzHsoo8zZ7OaUVu/p6IMTDKLJ2Z+pa6f0Hk
	8vphVKUrW7a1cAY62Y8Aiz7YNZHdfESWlkxN3HG7J6g8zHZ4kEI/M0Tk9oBLA51oX2TK9xud1Xu
	k+cGA6P8FRS9oEkZZKEyasCgbslHpY7xgmLuaeO6ZiBLw4rqgmOZeOC8A3FA4OgARl2GjMp0vsq
	+g8r1zZT66N3huLAUTn6Y/tVACOAGpQ9cdNNNzAx/o6VqnA9v8IuUB9ZWONDxlVMN77H6j5xSmY
	c9I5r+jXY7w65s2y
X-Google-Smtp-Source: AGHT+IEH0fRD2QBs5bdODlFNhgw4SMnj2geK3gnFsTsUxiB7yi52Yig5fr8iMNQ8Mlq7WbrzHMPldA==
X-Received: by 2002:a17:90b:4d05:b0:2fa:d95:4501 with SMTP id 98e67ed59e1d1-2fa24177388mr10674686a91.18.1738998873593;
        Fri, 07 Feb 2025 23:14:33 -0800 (PST)
Received: from ohnotp ([2001:f70:860:4100:e712:ac1a:da07:2e53])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fa5312f4c5sm285405a91.8.2025.02.07.23.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 23:14:33 -0800 (PST)
Date: Sat, 8 Feb 2025 16:14:37 +0900
From: Yutaro Ohno <yutaro.ono.418@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] rust: rbtree: fix overindented list item
Message-ID: <Z6cEXXvAbbDa13j5@ohnotp>
References: <20250206232022.599998-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206232022.599998-1-ojeda@kernel.org>

On 02/07, Miguel Ojeda wrote:
> Starting with Rust 1.86.0 (to be released 2025-04-03), Clippy will have
> a new lint, `doc_overindented_list_items` [1], which catches cases of
> overindented list items.
> 
> The lint has been added by Yutaro Ohno, based on feedback from the kernel
> [2] on a patch that fixed a similar case -- commit 0c5928deada1 ("rust:
> block: fix formatting in GenDisk doc").
> 
> Clippy reports a single case in the kernel, apart from the one already
> fixed in the commit above:
> 
>     error: doc list item overindented
>         --> rust/kernel/rbtree.rs:1152:5
>          |
>     1152 | ///     null, it is a pointer to the root of the [`RBTree`].
>          |     ^^^^ help: try using `  ` (2 spaces)
>          |
>          = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#doc_overindented_list_items
>          = note: `-D clippy::doc-overindented-list-items` implied by `-D warnings`
>          = help: to override `-D warnings` add `#[allow(clippy::doc_overindented_list_items)]`
> 
> Thus clean it up.
> 
> Cc: Yutaro Ohno <yutaro.ono.418@gmail.com>
> Cc: <stable@vger.kernel.org> # Needed in 6.12.y and 6.13.y only (Rust is pinned in older LTSs).
> Fixes: a335e9591404 ("rust: rbtree: add `RBTree::entry`")
> Link: https://github.com/rust-lang/rust-clippy/pull/13711 [1]
> Link: https://github.com/rust-lang/rust-clippy/issues/13601 [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Hi Miguel,
Nice to see this change so quickly.

Reviewed-by: Yutaro Ohno <yutaro.ono.418@gmail.com>

Cheers,
Yutaro
