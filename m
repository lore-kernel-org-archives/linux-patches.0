Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E82D28F937;
	Mon, 14 Apr 2025 11:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744631937; cv=none; b=N0rxhjnJLWqWA/eOtF5+1GQK+Fr1pdS30Xdt04e8HXxZmmu51+A/wvb0KdEzRImpwi8xc6WSLh9TRCNQ3YRoBPAOZdxyCs9nb5r1WiJxqLFAxt7ill/2FKwxL/31ILWWsZ+T8cBClODlYvqwM1YjxiTZpYFYBneDrB41bnaBt3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744631937; c=relaxed/simple;
	bh=PTC6LedfIAUBT2DNzfN9PrguBnlJGCAmjb45BtfCNeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DHQJyme6ylsDRoHR7tGDX4BO2pBh7WgK6tAPgZRQZsksWQWgY02Ckv6n9QUyE0blDZTTsaC9RTQMemu0KyoOZaRp5PgBSlUUPjpNQ6svWB6QcNaVIw8Yp4cSUo1YJImmVZqhMtWDDfJZZxpj9+FMDDbVVGgGFdsZ1aENfMRR3UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r1sS/iXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r1sS/iXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED79C4CEE2;
	Mon, 14 Apr 2025 11:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744631934;
	bh=PTC6LedfIAUBT2DNzfN9PrguBnlJGCAmjb45BtfCNeE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r1sS/iXhVx5ab3qQDLgv0xBCv1Hq14JVqeqN38EYPt3OV2IWu6uIZDNAO1s2CHoiN
	 +9MPN3C4agm2qUJ5jvTuaY2SOeteZGTvXu2lmpb36+vgnpL2xqCkmK7HHzxjToRu84
	 nR3ax1dZvkF+/AfTGqqYh/c4PbLZ6J57hp1UadbAINgTJLWuJV43e7hN2wDuXBak+I
	 EzsbeG++A4uafganyu6OC1lkxLF8HU0V1yZssoS1CXYW5zKt9jZStSvQVtt8xQbqIp
	 d/r2kanMJS6xMTceEPAJiCMUvrvj1KIGaZrzfCzF/8fhXZKb1/u/NdSG7Bv0M8DMhP
	 hBILyMH4zhgGA==
Date: Mon, 14 Apr 2025 13:58:49 +0200
From: Danilo Krummrich <dakr@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] rust: add C FFI types to the prelude
Message-ID: <Z_z4eaYwADrHTVLW@cassiopeiae>
References: <20250413005650.1745894-1-ojeda@kernel.org>
 <CAH5fLgiF0kZdOYaQi18_LTNx6Onq-5PBomA=bwS0m0z+C0wtvg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH5fLgiF0kZdOYaQi18_LTNx6Onq-5PBomA=bwS0m0z+C0wtvg@mail.gmail.com>

On Mon, Apr 14, 2025 at 10:46:46AM +0200, Alice Ryhl wrote:
> On Sun, Apr 13, 2025 at 2:57 AM Miguel Ojeda <ojeda@kernel.org> wrote:
> >
> > Rust kernel code is supposed to use the custom mapping of C FFI types,
> > i.e. those from the `ffi` crate, rather than the ones coming from `core`.
> >
> > Thus, to minimize mistakes and to simplify the code everywhere, just
> > provide them in the `kernel` prelude and ask in the Coding Guidelines
> > to use them directly, i.e. as a single segment path.
> >
> > After this lands, we can start cleaning up the existing users.
> >
> > Ideally, we would use something like Clippy's `disallowed-types` to
> > prevent the use of the `core` ones, but that one sees through aliases.
> >
> > Link: https://lore.kernel.org/rust-for-linux/CANiq72kc4gzfieD-FjuWfELRDXXD2vLgPv4wqk3nt4pjdPQ=qg@mail.gmail.com/
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> 
> Yes please!
> 
> >  Documentation/rust/coding-guidelines.rst | 17 +++++++++++++++++
> >  rust/kernel/prelude.rs                   |  5 +++++
> >  2 files changed, 22 insertions(+)
> >
> > diff --git a/Documentation/rust/coding-guidelines.rst b/Documentation/rust/coding-guidelines.rst
> > index 27f2a7bb5a4a..d0bf0b3a058a 100644
> > --- a/Documentation/rust/coding-guidelines.rst
> > +++ b/Documentation/rust/coding-guidelines.rst
> > @@ -191,6 +191,23 @@ or:
> >         /// [`struct mutex`]: srctree/include/linux/mutex.h
> >
> >
> > +C FFI types
> > +-----------
> > +
> > +Rust kernel code does not use the C FFI types (such as ``c_char``) from
> > +``core::ffi::*``. Instead, a custom mapping that matches properly the C types
> > +used in the kernel is provided in the prelude, i.e. ``kernel::prelude::*``.
> > +
> > +These types (aliases) should generally be referred directly by their identifier,
> > +i.e. as a single segment path. For instance:
> > +
> > +.. code-block:: rust
> > +
> > +       fn f(p: *const c_char) -> c_int {
> > +           // ...
> > +       }
> 
> I wonder if it would make more sense to rephrase this section to first
> say that rfl has type aliases for the C integer types called c_int and
> so on, then mention that they are available in the prelude, and then
> at the end of the section have a note that we don't use the type
> aliases from core::ffi. I think focusing on how to use C integer
> types, rather than technical details about how they are defined, is
> more relevant for a reader who is just looking for coding guidelines.

I think that's a good suggestion. With that,

	Reviewed-by: Danilo Krummrich <dakr@kernel.org>
