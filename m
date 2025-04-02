Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982481E8837;
	Wed,  2 Apr 2025 09:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743585499; cv=none; b=vF4Y8fZM82yLeNcNNQRNtmVcgUMM/d7C/tpOhTS1m1jFTWDrOX3WKKSF24TpK1oCIfLWXrCuG4A71UchFeaU6wLPOR3QIyGOllqJKrKEG69D6AKOqMchXkoloRCaXl7QocsPNEf2wqWsRQksoGbqavjMXiAa2Z3OqA83Bg9Ik+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743585499; c=relaxed/simple;
	bh=D1VZOI93g+UMw9rkKet/q9DRT20qfJr+OLiR+LLC+OM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oCOPoFJuEzjzK7OPc3R4HIPXi4iEFPDMLz2Q2jP/bg1AbooJYLbtKjRVcSvNhe8gt02WSWg0G/E+Eg3wT0smbIyFFrkeVEOIC8NDLrlssp2dcPYofdJ8VstVGHWLzQ4VxSTDHdJ/jRqgIFHesRy3RHI9Nrl3n2lMfoVWc9AsDEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iT2kyKPZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iT2kyKPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0F0C4CEDD;
	Wed,  2 Apr 2025 09:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743585499;
	bh=D1VZOI93g+UMw9rkKet/q9DRT20qfJr+OLiR+LLC+OM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iT2kyKPZO0UbWb7bufpiAlv54j2t0pLoLZU6Y4IFLjIfIw3LrEP6NADL0CvZ527Jg
	 qqKcUOvnGK1nffjKDkCcRghRmwOxa9rQe0JCOQ2s7U9zbsMGCBhFTnRuwR9wXGTY1b
	 KvDiXw3AyxZTqGBP2qSpHNQ7GhnvjjLjDq/lVjCUFRUw/5odqB50HYc0FtduKTeqhV
	 tlopI/HsnbvstzhRTMmyyIfeIeGAYV5DenutBRJuNswMKoEwV+EfIRtkJ/ELPt8FpI
	 RO85YoQqojqeIAHTWHhXh0sRfV8aFEHsWBlaSl69mJjczFJSQy0ASzQFk+eEAT2SAG
	 i7uJgTY+aXCdA==
Date: Wed, 2 Apr 2025 11:18:13 +0200
From: Danilo Krummrich <dakr@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] rust: clean Rust 1.86.0 new `clippy::needless_continue`
 cases
Message-ID: <Z-0A1a3nvqFiEVtE@pollux>
References: <20250401221205.52381-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250401221205.52381-1-ojeda@kernel.org>

On Wed, Apr 02, 2025 at 12:12:05AM +0200, Miguel Ojeda wrote:
> Starting with the upcoming Rust 1.86.0, Clippy's `needless_continue` lint
> complains about the last statement of a loop [1], including cases like:

Not related to the patch itself: Don't we need to disable new lints anyways?
Otherwise we'd get warning when compiling older kernel with newer compilers /
linters, no?
