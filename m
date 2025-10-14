Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D2C255F22
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 16:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760459021; cv=none; b=YnIg+lLdB9hT5mJNBTJPZW773GOOSCZ86WdQXWjnCsowgkpbrHZu1QuagmOToLl2KrGgZ5uqspIKBoZF42JeUrpwx8V1wEHOrGjnFkyfu+QTy95GaqRPm5k7A1cIXXW8zfcYxHxH7fVesreDvGzRFey1q880YN0Tei41YIp3Hjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760459021; c=relaxed/simple;
	bh=nLrVSbJF/dsM8EOkqzzEHEEEJ04HBU0HW1wHxoyhlPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kUejUaTLUdXvxV/3Opg2ltfijW9lQV6ea2Xygnw/o8x+OZ2Y8K3R5T2IifxCGonVMRXk7Z6nNu/DLOgUebK42YRSk9t2+PnFwQQSEfVZuHDlgmxCbgtDZ4YXteFJ8lW7kP4cWoWwZhydWu73izbwgaSL25zvhIh08h/8rfvZ798=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GAR/0Syh; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GAR/0Syh"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-85d02580a07so7535585a.0
        for <patches@lists.linux.dev>; Tue, 14 Oct 2025 09:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760459017; x=1761063817; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7CUMJDuqtfI1vdOSW6FkgvPnhx2KWnxWXMO5VApQeZE=;
        b=GAR/0SyhVZmrg963v5htg9xMRnbCTFIoWd4wGILYC9gwPQ/1dW2W/Rs7aGm7nR/MVt
         ZRCDNO2uwFi580KVVVfyoorbqyyLPm+8lt/QpoE+RrsAFn9hI3CPzhyKKIGP+UctEQUH
         Hmms1egQ0/FDBuHSmXKOlqq96yDR3PokJTt606FgqS08rKh2QhUX1/RmZB6+92+Tlo8h
         4YUaqM/rje5eIqnr6q2Mi2uCqSusMklvvCoAGy8XgQNIYjiKPHSVMKAemxtT5bsrhYD8
         fpYWoTJWvjoNP9XlGe+8tkYSCm3N6JUi/2r1JNWaaoIlbv/I6s8bgvN8JIC0F9Yw29kx
         K8FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760459017; x=1761063817;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7CUMJDuqtfI1vdOSW6FkgvPnhx2KWnxWXMO5VApQeZE=;
        b=LrPYBS7NqQ2HWtzaxCUbWm5YgW2x3AJ/8oN4UFrGv96tkk3OrdCUYJF9lmownhoQgm
         bTrSyFJMPC6ymJKkvIM9H9R/+WroQQNQqeQr1ijt2O/B8GJu0cxKbU11L1RhymW/zRvs
         R2rGUKLndsWeI6koItJl4E2mMbDzuhTjhDwWbM/+AvUXc3xph82PzFAurZouSFOv8hvt
         HN+UfJHN/VYCwDfHFHfcT++JEB9eKemCsODFAwIdHaktkT6trnNRCDyw4dhbcdVdMrNT
         SpPOe6lQVho+TitKymC6U7kqEYEk6dXmExtpz0pn13PYUY5GitjLxJq3lclUskYc7LqU
         ufRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfPqdAoRpmIJTfRt2m4VqB0mF+kc+ABZth8zu37I64OmlTaYyfOiTkR+jjWptES4D9yr8BKskz@lists.linux.dev
X-Gm-Message-State: AOJu0YzGnLSjk+aSDfvawbUri33gVklCoz61Yn1aReASLJt2KLxcO5xh
	/lpAoBslhbDWCF14069s5PuPSN9CBImTWn3lTEd5I3BKKcvhrPMb8dXb
X-Gm-Gg: ASbGncuBVD2fUQykXnwUszBVg1OfPqegXdT1xIZyr/kfiEEYeHIfw1DYO0dNOyo176B
	joCsSG9FrPBMzou3VT4oL5DEUipyPZ4pGyv1O+4zn6a2agZipcACuycso3moT9buzXpUP02eDkL
	7FqbVkS++2WGRHNtwmfOQCEtte4Z9cDsFKxIDvem1w1YmfmSBFrOhgDfW2arixG0SladQNExcc+
	iFCtwSFNM71pcGSHS7getEp/t46b9fc/Dz9Z++DRFw1Ywn4CGFAMXvvk1M09357ZE3cJPLv3+j+
	COXQ/1mYf+prxrWa6O7kSq77xSOrglLhAJdpCf1xUT4dzpnKgOEsqR0jE43mDN9UwMjBbMMAM0h
	rgXfXb/hN0f8KZFTvlJT06V2RDt/48abozEf5Wg==
X-Google-Smtp-Source: AGHT+IGb3LYxLUu0gNLKSrBv3dHhkBztOS9rJ5f0Uu7ubH+luxyqfSH/R31aRzsAnX4WaPCwDZbGSQ==
X-Received: by 2002:a05:622a:109:b0:4c7:a8ed:af3e with SMTP id d75a77b69052e-4e6eb068d26mr360037541cf.40.1760459017010;
        Tue, 14 Oct 2025 09:23:37 -0700 (PDT)
Received: from localhost ([12.22.141.131])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e881b10bbesm1938161cf.0.2025.10.14.09.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 09:23:36 -0700 (PDT)
Date: Tue, 14 Oct 2025 12:23:35 -0400
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
Message-ID: <aO55B_ishdHO2uiW@yury>
References: <20251013001422.1168581-1-ojeda@kernel.org>
 <aOzET46lagm-p8go@google.com>
 <aO51pV5WSmqnT4rL@yury>
 <aO54nxGil6a5hLQN@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aO54nxGil6a5hLQN@google.com>

On Tue, Oct 14, 2025 at 04:21:51PM +0000, Alice Ryhl wrote:
> On Tue, Oct 14, 2025 at 12:09:09PM -0400, Yury Norov wrote:
> > On Mon, Oct 13, 2025 at 09:20:15AM +0000, Alice Ryhl wrote:
> > > On Mon, Oct 13, 2025 at 02:14:22AM +0200, Miguel Ojeda wrote:
> > > > Starting with Rust 1.92.0 (expected 2025-12-11), Rust allows to safely
> > > > take the address of a union field [1][2]:
> > > > 
> > > >       CLIPPY L rust/kernel.o
> > > >     error: unnecessary `unsafe` block
> > > >        --> rust/kernel/bitmap.rs:169:13
> > > >         |
> > > >     169 |             unsafe { core::ptr::addr_of!(self.repr.bitmap) }
> > > >         |             ^^^^^^ unnecessary `unsafe` block
> > > >         |
> > > >         = note: `-D unused-unsafe` implied by `-D warnings`
> > > >         = help: to override `-D warnings` add `#[allow(unused_unsafe)]`
> > > > 
> > > >     error: unnecessary `unsafe` block
> > > >        --> rust/kernel/bitmap.rs:185:13
> > > >         |
> > > >     185 |             unsafe { core::ptr::addr_of_mut!(self.repr.bitmap) }
> > > >         |             ^^^^^^ unnecessary `unsafe` block
> > > > 
> > > > Thus allow both instances to clean the warning in newer compilers.
> > > > 
> > > > Link: https://github.com/rust-lang/rust/issues/141264 [1]
> > > > Link: https://github.com/rust-lang/rust/pull/141469 [2]
> > > > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> > > 
> > > Reviewed-by: Alice Ryhl <aliceryhl@google.com>
> > 
> > Added in bitmap-for-next.
> 
> Is there any possibility of landing this for an -rc of 6.18 instead of
> for 6.19-rc1? That way, the warning won't be present when compiling 6.18
> with rustc 1.92.0 and newer.

OK, will do -rc1
