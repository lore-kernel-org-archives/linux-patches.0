Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB1F2DCF6B;
	Thu, 24 Jul 2025 17:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753376732; cv=none; b=kP9CMi/7X6Fc/Y0DANrhiwjcRQZHEE9aVOW7Y5SZVKohrgy7CSXAhMpCP8zVbfHMPUQyLvJrtJwTuXeo+zgdDsSN+qRnUxLjec5IO5Mgex9xBWbJ7JIeMcJNPx3Z966tH+r7mghk8VtyXaGqd9QuXtCvuj6GC3jQO69wPNYOY1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753376732; c=relaxed/simple;
	bh=sg3NW9AjretcgkE6d+kewjNw2dnztGx4Ya+hYU2OpQc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=LhSjm0eWg4VrmsYI1jw2WGBasOnI+5t6jxNJHUfK5LpX0KpS1px0m1+/PKwt7+GjeEjPci4oYhpVbh2Lmw7krigcdCncO6mRHtNbSzKf3b8iHAu1Tm2TgrI/q8eQ6453P/ZNeki4rlqL7a4k04BDhJyXDSdBEqGUJEMXDzwF77c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HRJnJSQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HRJnJSQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBD1C4CEF8;
	Thu, 24 Jul 2025 17:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753376731;
	bh=sg3NW9AjretcgkE6d+kewjNw2dnztGx4Ya+hYU2OpQc=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=HRJnJSQR+MK9Oxsd87E6Fac8XKPvf1Qd97ZHcE/xZ6lVVOgaVltIC89t11uYBwJ2w
	 MEorXePy7QsGfObA8m2y+mV5jY9WKjWBDCvK0/oIdlyd6T3QwE8IoxV05g8BIRH4Ew
	 08sAjcD44S0Me6cNaCxw25YUNZRbVcJae/ijfWKKj+70N1EzQoQISa80qqiWNEZVt0
	 Eay+rWLHD6J27K8mclV247u2nLNLTs4DtCXsmm4kEHVFR+pFe5mWj//b5+ZmYVXHUQ
	 XEwnAva69qbiKTEy6R+ndUYvduz9cq8tCcUy9PLoERluxdL8W3Mkv6ARAffG7/UVHT
	 JF70LX/uKROUg==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 24 Jul 2025 19:05:26 +0200
Message-Id: <DBKG6CA32OO0.368N1Y6VMIUTL@kernel.org>
Subject: Re: [PATCH] drm: nova-drm: fix 32-bit arm build
Cc: "David Airlie" <airlied@gmail.com>, "Simona Vetter" <simona@ffwll.ch>,
 "Alex Gaynor" <alex.gaynor@gmail.com>, <nouveau@lists.freedesktop.org>,
 <dri-devel@lists.freedesktop.org>, "Boqun Feng" <boqun.feng@gmail.com>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
To: "Miguel Ojeda" <ojeda@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250724165441.2105632-1-ojeda@kernel.org>
In-Reply-To: <20250724165441.2105632-1-ojeda@kernel.org>

On Thu Jul 24, 2025 at 6:54 PM CEST, Miguel Ojeda wrote:
> In 32-bit arm, the build fails with:
>
>     error[E0308]: mismatched types
>       --> drivers/gpu/drm/nova/file.rs:42:28
>        |
>     42 |         getparam.set_value(value);
>        |                  --------- ^^^^^ expected `u64`, found `u32`
>        |                  |
>        |                  arguments to this method are incorrect
>        |
>     note: method defined here
>       --> drivers/gpu/drm/nova/uapi.rs:29:12
>        |
>     29 |     pub fn set_value(&self, v: u64) {
>        |            ^^^^^^^^^        ------
>     help: you can convert a `u32` to a `u64`
>        |
>     42 |         getparam.set_value(value.into());
>        |                                 +++++++
>
> The reason is that `Getparam::set_value` takes a `u64` (from the UAPI),
> but `pci::Device::resource_len()` returns a `resource_size_t`, which is a
> `phys_addr_t`, which may be 32- or 64-bit.
>
> Thus add an `into()` call to support the 32-bit case, while allowing the
> Clippy lint that complains in the 64-bit case where the type is the same.
>
> Fixes: cdeaeb9dd762 ("drm: nova-drm: add initial driver skeleton")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Thanks -- will take it through -fixes once rc-1 is out.

> ---
> As discussed, it may be best to have a newtype, or at least a function
> to perform this -- here it is the minimal fix nevertheless.

I think I will follow up with a function to perform the conversion in a sin=
gle
place, but I really like the idea of a special clippy annotation to tell cl=
ippy
to not warn about unnecessary into() conversions for a specific type alias,=
 such
as ResourceSize.

Do we agree that we want something like this? Do we even have a feature req=
uest
for this already?
