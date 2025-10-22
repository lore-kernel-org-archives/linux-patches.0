Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAA3302CD7;
	Wed, 22 Oct 2025 08:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761120820; cv=none; b=rsS1EvC9fD2SMLU8lK0Y7QieiMGBOZ5bfhhKj60Rhyt39Fz7+j9wC+s5gNwGtOlrNAn4HUHsElIygBer3lDEGXfI/wkuS4Cm4uBeB6cno46JfHaHdVZlTcDKJKWrUT/ZBJDDMHPkVujl9Oq5UdApv06vMCWvsX9Jo1ofroEb1fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761120820; c=relaxed/simple;
	bh=wuFKp7wVKGv7PxIwB3wTcUJzK/cF02oGo1qGZ7cCaaI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PQQ2qN2BOOCQQATHEx2I0RBPO/j6JjeMBwRPznVpocfx81ZqQOAt2l8Sx6F+yzixBaGtJiVOh+AMyJ4VqfJK0qSggUSieQ0pYzmyc+O5LKmsSgZmKW5Au4aO8HJWe5kUKuMWPaH2zYJW6XWiC+Eq6WuCdiDHcuAIPjIm/PjZOV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GZ9DMzin; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GZ9DMzin"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=Dg1Y08ybKAYmv4kbw7GmgeGRx4rZ+X8n9sBGCrSRBGU=; b=GZ9DMzin4MAQCShxEKq7jllj2o
	6G2s8ConHG8zGICW8cFsNhPES60m2FRMTyN2udlPNKEdsL6Xt9v+JfXLsehLQ7H2sMCJiLTeu9Gu8
	LwhLniGAdCyoFmur++KfC/tEE9UqEPlqzuMjKGaL82B0ZpMk7PPDR+EJG28gQSSW4izCE4AQUjjVc
	2MmybLPDgfmcV0+HsSnaD+42KinoeLAbT+yIWfvUVm5zRuUJGe6zDa4VM+DKN69xVz0xxaJsCCGzo
	UcY/VMdtWryQy+4K4udRQsCTwuf54j+Xd8kJa+u1uuEpguLFO2KTk2W72xdgJzNQpg8jkoUGXeviO
	IzUAcQzw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBT6i-00000000Or0-0BCT;
	Wed, 22 Oct 2025 07:18:04 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 4A0B830039F; Wed, 22 Oct 2025 10:13:31 +0200 (CEST)
Date: Wed, 22 Oct 2025 10:13:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Gary Guo <gary@garyguo.net>, Miguel Ojeda <ojeda@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] objtool/rust: add one more `noreturn` Rust function
Message-ID: <20251022081331.GJ4067720@noisy.programming.kicks-ass.net>
References: <20251020020714.2511718-1-ojeda@kernel.org>
 <20251020105154.GR3419281@noisy.programming.kicks-ass.net>
 <CANiq72n_AnCJYw6R2XecapW9wZqs_Saa4t8BNgrPub2u9=9_xA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72n_AnCJYw6R2XecapW9wZqs_Saa4t8BNgrPub2u9=9_xA@mail.gmail.com>

On Tue, Oct 21, 2025 at 07:25:11PM +0200, Miguel Ojeda wrote:
> On Tue, Oct 21, 2025 at 7:19 PM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > I'll go stick it in tip/objtool/core; but I gotta ask, where are we with
> > the toolchain support for noreturn?
> 
> Thanks Peter!
> 
> We discussed it with upstream Rust, and they understood the need, so
> we may get something like `--emit=noreturn` or similar, but it is
> still open (and not too high in the priority list since we can survive
> with this for now and we have other things that we really need them to
> get stabilized etc. But if you feel it should be prioritized more,
> please let me know).

Nah, as long as its not forgotten I suppose it'll show up at some point.

I would place including C headers in Rust at a *MUCH* higher priority
than this. This bindgen nonsense is a giant pain in the arse.

> I have the status under "Export (somehow) a list of all noreturn symbols." at:
> 
>     https://github.com/Rust-for-Linux/linux/issues/355
> 
> In particular, Gary proposed an alternative during those discussions:
> 
>     "Gary proposed reading DWARF instead and wrote a quick Rust script
> for it via object and gimli, though DWARF would need to be available
> or generated on the fly just for that (and we cannot commit a fixed
> list since the kernel config may change and we support several Rust
> versions and so on):
> https://gist.github.com/nbdd0121/449692570622c2f46a29ad9f47c3379a."

Right, the problem with DWARF is that you need to have DWARF and debug
builds are *SLOW* :/ But perhaps rust compile times are such that that
isn't noticable?
