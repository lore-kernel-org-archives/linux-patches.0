Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3338C21C187;
	Tue, 12 Aug 2025 19:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025779; cv=none; b=QYD28N/iNyQuObORMDiesnj6xRyzCTS4IUc//Vd1DfqRh3qTzJNI/mbAVJEcO7WgHLDsKOFLHWI+0e50hV/SAsZfhJ29siRmVDCGQvh4NBWUULiaZoeB3CcqJFmCjUjFBXB5Xy8mwLQFuCPtjTPWPCw0RHQGT7xKwymPvewQaok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025779; c=relaxed/simple;
	bh=LvZNxTA/XdUFkun/KxvVg6Qvu5B2F0JIqObjZjqM9RU=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:From:Subject:Cc:
	 References:In-Reply-To; b=KTGY8lqZ17go7WeziAhn43ZU1P5f1e9eWoSquFS8i3lPBXOvKAR6qky878Sk6m1AlmnyDzNQp7/rUcyI614nUiGC5f3ubNOj5HoQh4jpJsIFYJS4gFVaCqxk7tbQorW93782gG3B3Xkyf7LjA9QJqq238tGHnpbIM9F1cYCYCXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dbvTCkRG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dbvTCkRG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30440C4CEF0;
	Tue, 12 Aug 2025 19:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755025777;
	bh=LvZNxTA/XdUFkun/KxvVg6Qvu5B2F0JIqObjZjqM9RU=;
	h=Date:To:From:Subject:Cc:References:In-Reply-To:From;
	b=dbvTCkRGH7zxEuwPOPFE7SMDjqBZzXLbVBc6MJzEcigcIvqGLi3A+U9RBIMhT7enU
	 lJIyUeuj61MfT7VbIYBIxrPQf5IlRj49bLm57C8hxXyY87FHqvoZuA9ZY3DIv8eX+B
	 hsxC7Tj6Eee/x6s90+3HZJsrH1klY71CAAJydGTnX7bxC+EIRYuDcs1kqjIR/By/iZ
	 rFC9XTi5VJ0PRHF5V5TWKG1vqdG4Rm35eEN2Yg7A4PMQWi/7Ntg+9WOKvM+ZoFru7u
	 1jjgA1IbJ2hnb8V8lHNk6zJAOBfr3ZfDjJzoh54m+cAZOvBLn+F96DdHMaOR3S2OQL
	 hpq80ry96hdNA==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 12 Aug 2025 21:09:33 +0200
Message-Id: <DC0OPPWZ9175.108IURNC3VEM1@kernel.org>
To: "Miguel Ojeda" <ojeda@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add "DEVICE I/O & IRQ [RUST]" entry
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J. Wysocki"
 <rafael@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>, "Boqun Feng"
 <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <patches@lists.linux.dev>, "Daniel Almeida" <daniel.almeida@collabora.com>
References: <20250725202840.2251768-1-ojeda@kernel.org>
In-Reply-To: <20250725202840.2251768-1-ojeda@kernel.org>

On Fri Jul 25, 2025 at 10:28 PM CEST, Miguel Ojeda wrote:
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
> Link: https://lore.kernel.org/rust-for-linux/20250717-topics-tyr-platform=
_iomem-v15-0-beca780b77e3@collabora.com/ [1]
> Link: https://lore.kernel.org/rust-for-linux/20250715-topics-tyr-request_=
irq2-v7-0-d469c0f37c07@collabora.com/ [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to driver-core-testing, thanks!
