Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0170F1E5B9F;
	Sun,  2 Mar 2025 16:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740934228; cv=none; b=LFzvbZrGscVh+5doFeXqHQ6Sv/PcBIiIvlHd/mpfADAsRyTUsftjMZk+7Pu02/sNXIl9tpHbnXlf6CXeqlV6UbWfCiuGlqwLPiAsWR2Rc3yX6sVBHXhuYcUj9nc7mQGPJeXEDMWU5lwG0QcZL2qdlIL3VlF0m5m7BD5vG8SlVs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740934228; c=relaxed/simple;
	bh=6niMakNmxQ42IQ7lLQeVf3Z8esUZUgPAraWkiGzNLgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KUcWm0xGFUCG+tnmmdPNQX8C55D+xTPpil/hte95z/CZAzH1K/XMG212kamr4pk0gxrXoZYfibC/zFSvI6mTayeHw6McJxhRc916Ak20UkBhBp/qAUzHXkvxyiKasVzAM0bkaOVb71cVOYZ/0Gxq7zuKMrXycHtxsc9EzE3eoTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZNeTWvmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZNeTWvmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6053C4CED6;
	Sun,  2 Mar 2025 16:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740934227;
	bh=6niMakNmxQ42IQ7lLQeVf3Z8esUZUgPAraWkiGzNLgU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZNeTWvmOBG+e9QTaXxEf/O2mdaTSldTRwrGlX36XLJy907Jvtf3noPrQKUs3enZ5i
	 lz+e2LmqkIkEMS5tzuScZyo5gvMZmL4rx9YsvrZN6IwpjVpr/RH5YjcH5kWkDbKsan
	 rd1FDkDXubsTffR1t9UEZgHKNHa2UwVNg5zloVxaivebjcawKR6m/OHrBcqZUAYLoz
	 AGIuQO700jKig9ZQOGsVhf2TfRgUo29WFfqqWplrHOOt8j12vC8hiTSKUhzOg7bGoT
	 9mOdzuRo5tSZ4/RgS1lEV2v4yAexdURNENLUbYvQ8hVvSi424wMmGlG9aBae1oPqKE
	 T9SR+w+rNV3ig==
Date: Sun, 2 Mar 2025 18:50:22 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Jocelyn Falempe <jfalempe@redhat.com>,
	Thomas =?iso-8859-1?Q?B=F6hler?= <witcher@wiredspace.de>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	dri-devel@lists.freedesktop.org, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 2/2] drm/panic: fix overindented list items in
 documentation
Message-ID: <Z8SMTiWzTDjIwGfO@kernel.org>
References: <20250301231602.917580-1-ojeda@kernel.org>
 <20250301231602.917580-2-ojeda@kernel.org>
 <CANiq72=69XAOapYBurbwsQOEaw2uamZ6ta=DT6cC-om9XK3dvA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72=69XAOapYBurbwsQOEaw2uamZ6ta=DT6cC-om9XK3dvA@mail.gmail.com>

On Sun, Mar 02, 2025 at 07:54:00AM +0100, Miguel Ojeda wrote:
> On Sun, Mar 2, 2025 at 12:17 AM Miguel Ojeda <ojeda@kernel.org> wrote:
> >
> > Starting with the upcoming Rust 1.86.0 (to be released 2025-04-03),
> > Clippy warns:
> >
> >     error: doc list item overindented
> >        --> drivers/gpu/drm/drm_panic_qr.rs:914:5
> >         |
> >     914 | ///    will be encoded as binary segment, otherwise it will be encoded
> >         |     ^^^ help: try using `  ` (2 spaces)
> >         |
> >         = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#doc_overindented_list_items
> >
> > The overindentation is slightly hard to notice, since all the items
> > start with a backquote that makes it look OK, but it is there.
> >
> > Thus fix it.
> >
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> 
> Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
> Cc: stable@vger.kernel.org # Needed in 6.12.y and 6.13.y only (Rust is
> pinned in older LTSs).

(cosmetic) Nit:

I think you could just:

Cc: stable@vger.kernel.org # v6.12+

> 
> Cheers,
> Miguel
> 

BR, Jarkko
