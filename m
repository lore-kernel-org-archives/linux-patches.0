Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405381C9DFF;
	Thu, 22 Aug 2024 17:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724348764; cv=none; b=StJ9goFHI8eBXHPD7f1oi8pripWJVhToz0togzACXVG6y2m1HuptWYvhTc8zIhcG0fFKr5BA+gSuZL0stmCUl7mQ0iFpC3p7oprmgfOyun8yxRDbQ0nyRkLMk4n2oM8EOwPr/9za1nHZQ3B16yZbxoNyKJSt1O31ACfspb0PTds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724348764; c=relaxed/simple;
	bh=TYo8dUyfmWRX/DrqBOgWoiKYNZJpR43q0RkHyYf+qf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VpTQuUXejNBd/TZ+OahklgS545y5BIvbKu6EBPguTr2gvp5MrEHfaCeX8EdONOqH2yXbmbXZS//HHgWKkkgTjWUktBPtvY7wFJnRKL2K9DlhY320STVnzBFhEQ2ZgHXKyCUfloys5eFrVdMWbGP9k/u5O5kI7loYzCAQjgWo62c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qAdVjhKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qAdVjhKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1ADC4AF0B;
	Thu, 22 Aug 2024 17:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724348763;
	bh=TYo8dUyfmWRX/DrqBOgWoiKYNZJpR43q0RkHyYf+qf0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qAdVjhKZ5WwINz9h50yVNb3I8kIYEVoNKU/ekw2+BmN/fPSmBJkdUUtGSbfJA/C9O
	 gZlI3gdBlRUgQdJftTstGOzGWB6trwqTWKgoxct1bRsBjXDb5AYUNfphjkUJTd8dil
	 KRCN4rC5no4FiXqFJ85zLhS1YKxb4vdPzzcsiaxz/JIVt8Bi7DtrfCeTR9ugPofrEv
	 TdCGzpKaid6al2L5mSDHpprugSJgVeQ/+Y8e71w/Ls0QzSB/gy8+yzrBmaHqbRHgAC
	 4C7ORInBPQkMU1Q9Z+ZKtcfGai97b9zPVyLBDv1uvBmz2QPoaPAT9/E9NoI8uOVY77
	 soXify7lG3/ug==
Date: Thu, 22 Aug 2024 10:46:03 -0700
From: Kees Cook <kees@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Zixing Liu <zixing.liu@canonical.com>,
	William Grant <wgrant@ubuntu.com>
Subject: Re: [RFC PATCH] docs: rust: quick-start: add Ubuntu
Message-ID: <202408221045.F65621131@keescook>
References: <20240816181545.45789-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240816181545.45789-1-ojeda@kernel.org>

On Fri, Aug 16, 2024 at 08:15:45PM +0200, Miguel Ojeda wrote:
> Ubuntu has changed their maintenance model for Rust toolchains and is
> now providing recent Rust releases in their releases, including both
> LTS and non-LTS (interim) releases.
> 
> Therefore, add instructions to the Quick Start guide for Ubuntu like
> for the other distributions.
> 
> Cc: Zixing Liu <zixing.liu@canonical.com>
> Cc: William Grant <wgrant@ubuntu.com>
> Cc: Kees Cook <kees@kernel.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Looks good to me!

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook
