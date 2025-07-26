Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9233017A317;
	Sat, 26 Jul 2025 06:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753512428; cv=none; b=dNpxbVkdTL7FOkACh8JdISQ3L9S3mV2xLRicKjNLarkp+braiZ2nXQV3BBp1BtYRex7iFuMPQaJTrCDAPMriF0gb27LQj7Q7VRiPuAD3YlFgdhd0qbxkn66yDQzWSb0g8A8N9AQ88Q0BAR2yrrY+LDR/mMVosAgNcztOLXsjJ2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753512428; c=relaxed/simple;
	bh=1aSJGaabBb0DAn6eDpk1lw68m8J48ib5wrwSM06FVgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nbt1a7K6lB9GOM5bksynNDkNrQttybCug9gop8hMYp8HgRRjEGnnT/Mmx0rf3OxUmmLxV+y0QLobWnxYr1B/UIUxp1AALQ4sJ1Nq1fZ3bJo/GADjjWoL9cx/bLIowenafD2ySqa+pO2A6Fmx9hGMVW0nA1EBoqFQKPTfx6lNvXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dvIeHZgh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dvIeHZgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B7BC4CEED;
	Sat, 26 Jul 2025 06:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753512428;
	bh=1aSJGaabBb0DAn6eDpk1lw68m8J48ib5wrwSM06FVgI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dvIeHZgh0VhuQFoxG9H8MmXVo/xZLD8piMOcx64ieTjq23h2hcOhVyzw/H2REN+HG
	 DrQH2KUWJWbl3PG2hcHomFN1tJKtph/blWBRJm+wHJYPVIcz9uB56adj8F5VIAgV2r
	 Rr3soFbLMFBbXDqlHCG7jZp+219GPcna00BR0QsU=
Date: Sat, 26 Jul 2025 08:47:05 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Daniel Almeida <daniel.almeida@collabora.com>
Subject: Re: [PATCH] MAINTAINERS: add "DEVICE I/O & IRQ [RUST]" entry
Message-ID: <2025072654-amicably-denim-e6da@gregkh>
References: <20250725202840.2251768-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250725202840.2251768-1-ojeda@kernel.org>

On Fri, Jul 25, 2025 at 10:28:40PM +0200, Miguel Ojeda wrote:
> This entry will handle device I/O patches and abstractions (such as
> memory-mapped IO and system resources series [1]), as well as IRQ ones
> (such as the `request_irq` series [2]).
> 
> Patches will flow through driver-core, at least for the time being.
> 
> Danilo, Alice and Daniel will maintain it.
> 
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: Daniel Almeida <daniel.almeida@collabora.com>
> Link: https://lore.kernel.org/rust-for-linux/20250717-topics-tyr-platform_iomem-v15-0-beca780b77e3@collabora.com/ [1]
> Link: https://lore.kernel.org/rust-for-linux/20250715-topics-tyr-request_irq2-v7-0-d469c0f37c07@collabora.com/ [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
