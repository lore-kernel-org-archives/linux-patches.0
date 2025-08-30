Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6A922F764;
	Sat, 30 Aug 2025 06:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756535287; cv=none; b=d/xgBjyJa0c9GIb7EbwU6MWeK9lnepuSzVKIxHDnITufWS0dQIe+xOeaePe7WaZd0wOq27up+a4LeAmsNz/2P2oXSuzJu15G1AEFS2RuztdQHEaB6N14hZ+h+8EvvrK8d5fRxgeD8PKSKURreVjHMe8lPw4j5z3x8NOztH5Zh3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756535287; c=relaxed/simple;
	bh=R47y7v6HJG2x1zkCAn8gdJy9W57/R9Xx76r/aYCkEW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tdl97U5KX6dqLHPN/C0CFB3KJhOaR46F89qXaufccDpxCeoQcgRezpgXEvilASZQN6PNF0Hl4vi50JN+R0w7A+YftSCOaD5m5Sh7VFuLiXZ8CuM+UT/I1OLxsV30TlWEgzOAu2uTl2OTO1SZMka+yhVPpw0vvb+VH1g9omgCmhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vH6sxtRG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vH6sxtRG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02060C4CEEB;
	Sat, 30 Aug 2025 06:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756535286;
	bh=R47y7v6HJG2x1zkCAn8gdJy9W57/R9Xx76r/aYCkEW8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vH6sxtRGYtqef+qr98zpP/4/NeITXxMO1LFyFx8qvixWdiiyI0sJTLeD9WT6wvge6
	 CcIVHrRjnkI5se419PdYODv5nOXDgKu3XSQw5j6vUnsM9FGHM7N35AjK8TsEJ0HacU
	 yqpmMzwrBU5MYSG9exDaW4XX/JHsPOBBLzwfEUtM=
Date: Sat, 30 Aug 2025 08:28:03 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 3/3] rust: error: replace `WARN_ON_ONCE` comment with
 `debug_assert!`
Message-ID: <2025083032-barmaid-rising-a977@gregkh>
References: <20250829192243.678079-1-ojeda@kernel.org>
 <20250829192243.678079-4-ojeda@kernel.org>
 <CANiq72k7_GbFwRxW5vikF_SpiNcNm7Ff0oe6jyYX_voDg92QFA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72k7_GbFwRxW5vikF_SpiNcNm7Ff0oe6jyYX_voDg92QFA@mail.gmail.com>

On Fri, Aug 29, 2025 at 09:43:24PM +0200, Miguel Ojeda wrote:
> On Fri, Aug 29, 2025 at 9:23 PM Miguel Ojeda <ojeda@kernel.org> wrote:
> >
> > Thus, instead, use a debug assertion -- this assumes hitting one of them
> > is not going to be considered a CVE (which requires
> > `CONFIG_RUST_DEBUG_ASSERTIONS=y`).
> 
> Greg: RFC on this -- this is the usual conundrum around `WARN`. I
> would like to have an assertion or `WARN`-like entity for developers
> that doesn't imply CVEs when hit by user interactions. More generally,
> to know that such a config option is OK as long as it is labeled
> clearly a debug one like this one (we can document the CVE bit
> explicitly if needed).

I do not understand, if there is ANY way that a user can trigger a
WARN() call, then that is considered a "vulnerability" as far as CVE is
concerned and so I need to issue one when it is fixed.  This is entirely
because the panic-on-warn option could have also been enabled.

If you wish to state that CONFIG_RUST_DEBUG_ASSERTIONS=y should NEVER be
used in ANY shipping Linux system, then yes, we can carve out an
exception for this (we do that if lockdep is enabled as that should
never be in a running system, only a development one).  But I thought
that some groups wanted to have that option enabled in their running
systems to provide additional security overall?

And yes, the fact that enabling an option for safety can actually cause
a CVE to be issued is not lost on me as being very odd :)

thanks,

greg k-h
