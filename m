Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE8F2CA8;
	Mon,  5 May 2025 16:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746464274; cv=none; b=FHZmucL7HUnWeR9Zz08UbNBb5vOzAd877/AXQtk5SHoR5ogvKIu+jpI8tsDhfmpNpVsb77/XGoKLJyyMZkodpoZatB6a5g3xrLUbB4AN9Tk77kQaSMfAwe64p+chWgiVOkoUiVGRpiPz2gmfMdAU28SA0UK1HgjiFAGju9wxuq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746464274; c=relaxed/simple;
	bh=TUCtJ6Yg8ksEmkieMo2TtohPX7JoQpYyPCv1v2b5s0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l85bJwgFbW541byv0DqZLicPWRrdUEABam46hV3+sl+4m9QALZo6Cc8g74aDXbbAVksnv3M1IgO+0UWlf9XnfsKVXMh7z2OG1Yod7NREhTNoWI4aAfR1WahING1lm8i1gXMY/DRAn4AdCNFyY0QSPIiG9yg9Gw9OjvVyol+589c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j0pXbjxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j0pXbjxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA25DC4CEE4;
	Mon,  5 May 2025 16:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746464273;
	bh=TUCtJ6Yg8ksEmkieMo2TtohPX7JoQpYyPCv1v2b5s0E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j0pXbjxXvdnkjnmTxcWwdvJ2MwJLeX0HYQg6ntdTGcyc0sVnXM0A6PdEUGvKAv6lt
	 ozYDMQRrpVdQm4Ykisc7XJP3x2VJB+qpCLnfvu2oD0irO3EDSRUo8u0rkRktBGqi70
	 tZiAFm0zKGYgiBPcbueQzsmk1XqoAnlZJh9vtCBYZGAnFe030H3FipA2lERRJ1p2Fy
	 IyxrEOz7wO3vHAhYnHyUpdxN6hIuPD7FxZwFy4+5Q7eHWJticwR9nLgH4mRfB/gUTF
	 GdInL9UGQErOlDnFVQsfgf5I7B2SMvUMIvBXghHuiMDim9oYVhlrHqVPXLOzb48Gzx
	 m0OKdh4yLP43A==
Date: Mon, 5 May 2025 18:57:44 +0200
From: Danilo Krummrich <dakr@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>, Rae Moar <rmoar@google.com>,
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 0/7] Rust KUnit `#[test]` support improvements
Message-ID: <aBjuCIHH1ZCIVs_0@polis>
References: <20250502215133.1923676-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502215133.1923676-1-ojeda@kernel.org>

On Fri, May 02, 2025 at 11:51:25PM +0200, Miguel Ojeda wrote:
> Improvements that build on top of the very basic `#[test]` support merged in
> v6.15.
> 
> They are fairly minimal changes, but they allow us to map `assert*!`s back to
> KUnit, plus to add support for test functions that return `Result`s.
> 
> In essence, they get our `#[test]`s essentially on par with the documentation
> tests.
> 
> I also took the chance to convert some host `#[test]`s we had to KUnit in order
> to showcase the feature.
> 
> Finally, I added documentation that was lacking from the original submission.
> 
> I hope this helps.

It does -- thanks for this series!

	Acked-by: Danilo Krummrich <dakr@kernel.org>

>   rust: str: convert `rusttest` tests into KUnit

With that, do we still expose `alloc` primitives to userspace tests?
