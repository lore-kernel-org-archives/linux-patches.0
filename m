Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF57A307AE1
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 11:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762775235; cv=none; b=M7qcpFxGKjVFIq0B/UPLZuiGrTIxDWPkKDMBBuSbHqC4j00DJf66ZK1rKa4Feh5HAYNTNzBNNrUKk5BjdSVYLQnRDGeXxqA0wh0WBlGceUUnAcpyIUgz5BoFauT/4E/H1LxPl2MtceFHz+7VMLPdU9hSGC96DzgNO8BdctKzbk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762775235; c=relaxed/simple;
	bh=UHsZ8mNOG8p7kZWeRQbdvDX87iavcoicnA0ph7mCQpM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U1sChejIWzk5MgqQrZxt7xMKF4aKYuoDvrW8wmVFkl0XoB1MaTbvkeoHmTboX+vE+iTqO7/s8lfsroay7AqnMUiFKJ6SVV3H2zj6R9IRyn7aYkCdRLT0rKlrXda4LsCu2oGgl63R1LuK8sRVgg04DrY/W7Gt4grtCDCXdBNq/ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T1ygjFB5; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T1ygjFB5"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-64165abd7ffso1955971a12.0
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 03:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762775232; x=1763380032; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wUCZuS6iBZ+Cb2EbxYt/LbW22Q1kNekqfCyN5WYEYrk=;
        b=T1ygjFB5HIUaPk9cpmz3FeDF6Pldk5WDCSxjH0sEIV7ZZiUQg7HJUy2cj8t67X5+/B
         pTHvgO9wEobJgpdS8eW9qGNW2VqLvSXgo6Y0rjMgTX+jLu+/0B0gHVDBD8fiLjSoYfhF
         vuCUjthR9YwpDEfewJrv8xPA3n1IkMQc7t+7Tx8JQp5WaKQjQ3rSzS8pOLgSv/0KRbpw
         Cqo3nBo/yQPhy/ScQMVDbQN44BHtrC9JL1q0ZfJSt7Qb2ByMgpLeLSk5hlBygIU17otk
         yyWZ9bqG2lGnMvOEoGFpcqQtmcsJczoXVcNpJUZE0udqHGzOJtBaZv32R77ojkw6ST4o
         Qvgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762775232; x=1763380032;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wUCZuS6iBZ+Cb2EbxYt/LbW22Q1kNekqfCyN5WYEYrk=;
        b=hKlMLvn7HPV66YbTasG0QsGjk+c7DD6YC9gMJM61MECOMwgv1QXOoL9JULznxDG2xS
         Hs9GwZo7Kc8BRYzST7xMDBszquOaao8I9L9T2N+Bn+O/MM2/HK/d9aBB5YmCNKnka6kl
         PZBSayad5Aum26TstvyGPYZvvgItqeRJfUkNmLIcCW1pzGT4xB0JodVt7bE6WrAjzJ1Q
         jeSDBT23VOI2vAGnIxNq00sbDg9MAqOAv2O3QErVsZWq1Ipo2/qBFf4Kg4TxPBxydUik
         kCTDrf9UfMYOPTieiCO/b20r7HpYYT0ebvK60I8KvUF7WrGS3NGNdTV2aHR9LxLL2v1J
         K1dQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbqJm+iSVD6cpSCXtQMzfRgzyVtCtqd9guja/25E9Sj9dcgkFnWgW1AJeugol9/YLnYlego53I@lists.linux.dev
X-Gm-Message-State: AOJu0YygGy9VsXqmQTQXHwUwSwLHL3ZBtCNA8w05tlgwFPqAuQvwfNCs
	0fLpv6LNjw7UGXl6xhq6XYtALjAuVr1NQzhldZ27SCR9TS+TCjqS+a8BdiYUq5f8fq2Wrs9xynb
	5HyHVUl0w/RlwJSveRw==
X-Google-Smtp-Source: AGHT+IHn/ARWRXnaz/QbEvpiXa66T27fjTbhbGtpITormFJQJJtBcOuO5FmSZ0Htawn8t+iKKDuDiXxfGYOF77I=
X-Received: from edbin4.prod.google.com ([2002:a05:6402:2084:b0:641:8e3a:1196])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2106:b0:640:ef03:82c9 with SMTP id 4fb4d7f45d1cf-6415dc11781mr6885792a12.11.1762775232291;
 Mon, 10 Nov 2025 03:47:12 -0800 (PST)
Date: Mon, 10 Nov 2025 11:47:11 +0000
In-Reply-To: <20251110095025.1475896-17-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-17-ojeda@kernel.org>
Message-ID: <aRHQv14husHrYpl_@google.com>
Subject: Re: [PATCH 16/18] rust: syn: remove `unicode-ident` dependency
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Mon, Nov 10, 2025 at 10:50:21AM +0100, Miguel Ojeda wrote:
> The `syn` crate depends on the `unicode-ident` crate to determine whether
> characters have the XID_Start or XID_Continue properties according to
> Unicode Standard Annex #31.
> 
> However, we only need ASCII identifiers in the kernel, thus we can
> simplify the check and remove completely that dependency.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
