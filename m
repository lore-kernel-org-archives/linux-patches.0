Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827501AA782;
	Mon,  9 Jun 2025 19:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749498868; cv=none; b=YyvC1b1nRS193Ype8nY23NJHwMea0wDuWIyI9nJ9otpOMFN8yGN/kITlpm65d6dnNGyDMNlyzo/hk1qQ2ZuTMpAEHBlzMIPFw/is/48ZdOmnSEZ2qyqFOaot3liREd96jgykp5jGWLwljWtnYCFiaV5OVuoNnfPA4I1fSrdn9Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749498868; c=relaxed/simple;
	bh=Q9oZ98zRJrOtPlfbVOHTllvnh7Bm6mewGYSRUnWyPDA=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=pPUIN9VjVu5WMeeyiBvXpC2O+8uVRm6zaijwlKAT6/W9mBJeId4DMB/R643Rm2PHufOO0+6SVh10yvnn6qBsnKLewgYp9HvvEkYYuu5E7K+oSU7rQQSgzTQX9M4PBdFFG4Ws72AwlvHkn4hiFPzjBBEiGZ7PjjsI4bbMH+ZfgQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HfdMbwuB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HfdMbwuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4517C4CEEB;
	Mon,  9 Jun 2025 19:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749498868;
	bh=Q9oZ98zRJrOtPlfbVOHTllvnh7Bm6mewGYSRUnWyPDA=;
	h=Date:To:Cc:Subject:From:References:In-Reply-To:From;
	b=HfdMbwuBvADHP0WRYIwLfiId7ALsfOmlWb8jUgLw4BFoavZ3vcRHt+iRGcuaX2lvg
	 Puk5PW2VAVz/tlY07L+r40EO7Nn5S/vD2ucTFoYTj4JrX5klKdCl0xo2w1O6ZzCv3d
	 7I/bcyKxoQk6mvpAHYhOk5eRELmXw9atKvA20qKqXLOOf5j1zXG4Lr2nwkyo3++8HJ
	 4+8LsRyQsbsfr43uqAX5Nj5A97WQAQcNLJy5kdqXimaP5Q1sO/tor+/I172egaDDLb
	 QPMyY2QoZJ9MtaYqxMKolUpBnryXAVfgjJ12qeASmfpp3dHeVIGB2NPqwwj8G+uznE
	 QMlcU8cT3Zf6A==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 09 Jun 2025 21:54:24 +0200
Message-Id: <DAI9L6TYQTEB.3M08GVEIDXTGR@kernel.org>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>
Cc: <rust-for-linux@vger.kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Andreas Hindborg" <a.hindborg@kernel.org>,
 "Alice Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>,
 "Danilo Krummrich" <dakr@kernel.org>, <linux-kernel@vger.kernel.org>,
 <patches@lists.linux.dev>
Subject: Re: [PATCH 1/2] rust: init: re-enable doctests
From: "Benno Lossin" <lossin@kernel.org>
X-Mailer: aerc 0.20.1
References: <20250526152914.2453949-1-ojeda@kernel.org>
In-Reply-To: <20250526152914.2453949-1-ojeda@kernel.org>

On Mon May 26, 2025 at 5:29 PM CEST, Miguel Ojeda wrote:
> Commit a30e94c29673 ("rust: init: make doctests compilable/testable")
> made these tests buildable among others, but eventually the pin-init
> crate was made into its own crate [1] and the tests were marked as
> `ignore` in commit 206dea39e559 ("rust: init: disable doctests").
>
> A few other bits got changed in that reorganization, e.g. the
> `clippy::missing_safety_doc` was removed and the `expect` use.
>
> Since there is no reason not to build/test them, re-enable them.
>
> In order to do so, tweak a few bits to keep the build clean, and also use
> again `expect` since this is one of those places where we can actually
> do so.
>
> Link: https://lore.kernel.org/all/20250308110339.2997091-1-benno.lossin@p=
roton.me/ [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  rust/kernel/init.rs | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Applied both to pin-init-next -- thanks everyone!

---
Cheers,
Benno
