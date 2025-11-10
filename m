Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9C126E706;
	Mon, 10 Nov 2025 15:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762789828; cv=none; b=mnRm/TtYcO7xJQqTg8XieTmjlHXjtOFUDXj32yKLS6Q1V6hdP0KnsRsobH6zKIpDfmBB1qwIKB9KyrDIbke4zzuyo5XxiwwVt+KC/MTZplYi/sVot6QquGRHL7JhcumICw9zCNefYHv07bLCRBqf08xYjDNZzuftSnsHb/SfjS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762789828; c=relaxed/simple;
	bh=dIbMT2XyfmkYVI8XJLQiVObQzFSS0VpVvhb2X74B4Gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EKY1sOhs5cwwo873AEN2lbHbL3m+nGz9k4OlUco+9XjNJ83ce80/uY1MI25MiZAANgvATgWXNnaIek1/lsaDY3Vc+R4iYHtJr5trQqLDkxELtAFckgcUaaEJpubHZcTsWvgdsMeiu4zfSBAWZAA02SLX9ZEOPLufSBMdz6J2/DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=0GPRZkvc; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="0GPRZkvc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=QwVCL0MZASuLfr95utdJV3EYFM1oMr5TPPap9WciiMA=; b=0GPRZkvcS3PsVbRQHpKHfF3XLk
	yjsdhTD6Lblld/gGEnIZehm+TxcobBFnVa/FKQhhIhD/eDDSd56tSaCay19L+e+X99ZjH2gXwCl6b
	G3v5iphj/Ol9HIjzQ8XaiWeaJdlRZTu6i1ZibPQJ5ItLZq3NJHbjeOSUdIJyKUqAgeaE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1vIU9e-00DXI1-H4; Mon, 10 Nov 2025 16:50:06 +0100
Date: Mon, 10 Nov 2025 16:50:06 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Trevor Gross <tmgross@umich.edu>, netdev@vger.kernel.org,
	rust-for-linux@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 1/3] rust: net: phy: fix example's references to
 `C{22,45}`
Message-ID: <ebc83a89-b13c-49ae-adc3-c8de6903b735@lunn.ch>
References: <20251110122223.1677654-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110122223.1677654-1-ojeda@kernel.org>

On Mon, Nov 10, 2025 at 01:22:21PM +0100, Miguel Ojeda wrote:
> The example refers to `phy::C{22,45}`, but there are no such items --
> they are within `reg`.
> 
> Thus fix it.
> 
> Fixes: 5114e05a3cfa ("rust: net::phy unified genphy_read_status function for C22 and C45 registers")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> Please feel free to drop the Fixes tag -- I generally add them for
> things that get actually rendered in the documentation, since the stable
> team sometimes picks even typos, but it is of course not an bug on a
> kernel feature, of course.

netdev generally does backport documentation fixed. There are a lot of
developers stuck on LTS trees.

Please submit this to net, and include the Fixes tag.

	Andrew
