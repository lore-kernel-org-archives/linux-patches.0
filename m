Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953CB2FF650
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 16:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760458154; cv=none; b=l+JQPe4V4LSZ/v8HGmM3acBBjdnDUh5nLkma1bWrb1uKDd8OxchdX1AXEAnCZkKrfo0Njzqgd58lNfWVtXbww64lB/lsIhKA2lE6HH0WI0Dm0gLE7vgoinVjlJUyOEn8mVUK/msW9jSKpCpz1Ics3fy+qemQjVMr52tluEEn8UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760458154; c=relaxed/simple;
	bh=MyDZ+5xbfpDbRdcjNPPtRkhMLKRMmMRRRYNXyrRIfp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hhsWCb0Kc/sFgIWtPlk0esft6oo5tjT5L34Q2RMGfZl7OCCs4Kj9eiTZ5ww1JpouDkQpiE+3rFrWUP4qUzv7HGn05xNJVnwOW4tVL7KpEhQZxE3FgLBNnzr4SkARxMBJsc7oUMIkN5F73104axP2SCAzN6xe+tDItIiBXuQaewI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ANo71AXg; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ANo71AXg"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-854cfde0ca2so1151546785a.3
        for <patches@lists.linux.dev>; Tue, 14 Oct 2025 09:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760458151; x=1761062951; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N4lRqPExRAyMWRp9Rfjmg4SkkmqlcZGNh8vWt5+XF28=;
        b=ANo71AXgG6mV7XsPBz6vFK9E16SoOCwyduUuc4eddIxjxRvHJSPy8IgtORoGq6/+D1
         wK5uHWefzsDl2WQVfVIaeHkUVrQdQOOdq9EALHmlTuTv8zC1jBMByWphycWYG+NPe9uS
         IaBbsZqdXciIwZdNb6D8jRYppDZNsl9QE8bb61I3WZ+bT/FFnn6ZqHPBmTKhPZMHBlwl
         TbUFets8ZPOjVlFwhCz98D5Z3y6v3laM0e+mtuGVapSY6tvdIOS5cfcB+jwR/l8nNxxW
         TCpRPZlfxN+cNZPeU7yYXaidJ4Xnc2ZP/OlqRPUtiB50A5bCUsiM6AXNd3fXIK3unInb
         hr9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760458151; x=1761062951;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N4lRqPExRAyMWRp9Rfjmg4SkkmqlcZGNh8vWt5+XF28=;
        b=eMLzAFUcCfqUoBZS8s7zDqOgvH9kksll90et20l3pt9DgzmTJv5YuK7ddyV6ahwXNT
         fehSAeOSpd2vWuO3ZlS5azmVe4pYzEw3HmzFKOJRFC1am5gLXDP+BnUoPfkkEbqFt6Dm
         vplYtLMDyJkTa/rNKPwqN248/VeudRRJdr18bhJKcl8YRjk9Yra0KCpzIQxKQlKyPAYz
         6MvT0KJ8IQ9YPo/ntVhM/xwGPe47TLios27AyPChX6sn/U/DbauM8x9gkA5xlHAUyvd5
         Ja0Wmkr1mboTq72ARL00UOz0H/2jneh/rx8Dfda2OZgKqGXYJqnS6w5psP+WJkC1w1Qy
         ycZg==
X-Forwarded-Encrypted: i=1; AJvYcCXjPlTChWq8L9TXhb5uioA6YmGxhmjHMttYS29rHDOkAF83hCD8pthJZjVX7eEDfG5lrjP7lzVX@lists.linux.dev
X-Gm-Message-State: AOJu0YwpH66+afCuaO+CKJsDV7qxYcFD3pnJO56CsQHQmlMLyQ0wP1AQ
	kvpEUwBqY2Oy6jfu1JzfOcIaMEUA7NL71KXBvb5ItAMoySkzSdIkcdq4
X-Gm-Gg: ASbGncsu4HifoQiBJaSS1nWZOfbv3kfYTF3oa5nNxD6iT0wfwl6WbxQ4PhgPZpuTOSi
	Txfj0Cac/Bie/HnRDJXaeIWFuq8UrnFl112gQW1oPIBNHUaBsqlqw+0+AnnsIaMXi28NxZXKGqK
	J6rq25GjG8CuSemVQ7GM8JzL1Yjuawa1NuPaCKnCwSR5PFd9T+NJwjqi8o5+iblW8eKDYuWv1pZ
	5+PCzVvxuCoevjM9v1RMYoWGKvgXcQ8o4cqAEmjfqPZmKiMO023b3bntrLuAceE9Pr8SlXqY9qH
	BzWoSB3FxOVjAfnEgepblU5kxdvnWEDczDwOoJQhZq+cRkhWqFo2JvcXjJBQNEGc0zndw0C1VHL
	0ZSgqnvg+D8f+ifAIx9CPqn1dKkVHtAxosDQt751dMye1uA1f
X-Google-Smtp-Source: AGHT+IEoehLXwqxEN/cc9TnKoWCH0/efz6jmoKuyzf/OPOzqS4tT8DPcYGiD2jioZTZbNhTh/I2HrA==
X-Received: by 2002:a05:620a:a515:b0:886:ea5d:9270 with SMTP id af79cd13be357-886ea5d939fmr1674523285a.72.1760458151266;
        Tue, 14 Oct 2025 09:09:11 -0700 (PDT)
Received: from localhost ([12.22.141.131])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8849f3d70easm1249358885a.12.2025.10.14.09.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 09:09:10 -0700 (PDT)
Date: Tue, 14 Oct 2025 12:09:09 -0400
From: Yury Norov <yury.norov@gmail.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
	Burak Emir <bqe@google.com>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] rust: bitmap: clean Rust 1.92.0 `unused_unsafe` warning
Message-ID: <aO51pV5WSmqnT4rL@yury>
References: <20251013001422.1168581-1-ojeda@kernel.org>
 <aOzET46lagm-p8go@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOzET46lagm-p8go@google.com>

On Mon, Oct 13, 2025 at 09:20:15AM +0000, Alice Ryhl wrote:
> On Mon, Oct 13, 2025 at 02:14:22AM +0200, Miguel Ojeda wrote:
> > Starting with Rust 1.92.0 (expected 2025-12-11), Rust allows to safely
> > take the address of a union field [1][2]:
> > 
> >       CLIPPY L rust/kernel.o
> >     error: unnecessary `unsafe` block
> >        --> rust/kernel/bitmap.rs:169:13
> >         |
> >     169 |             unsafe { core::ptr::addr_of!(self.repr.bitmap) }
> >         |             ^^^^^^ unnecessary `unsafe` block
> >         |
> >         = note: `-D unused-unsafe` implied by `-D warnings`
> >         = help: to override `-D warnings` add `#[allow(unused_unsafe)]`
> > 
> >     error: unnecessary `unsafe` block
> >        --> rust/kernel/bitmap.rs:185:13
> >         |
> >     185 |             unsafe { core::ptr::addr_of_mut!(self.repr.bitmap) }
> >         |             ^^^^^^ unnecessary `unsafe` block
> > 
> > Thus allow both instances to clean the warning in newer compilers.
> > 
> > Link: https://github.com/rust-lang/rust/issues/141264 [1]
> > Link: https://github.com/rust-lang/rust/pull/141469 [2]
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> 
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>

Added in bitmap-for-next.

Thanks,
Yury
