Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44BD34BA59;
	Fri, 10 Oct 2025 20:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760128278; cv=none; b=sNb2v+sJQmSJKO+iav8R/E3QEkpmalbYWjyhX7DQhlADTNgsp9oPhIj8GzIDi3jyT0MnMhv98k+uRFWAr8dWqWfP4rv7b30YkoJrdoYq9aTr9OIZ+zMOG+4P9Q+ULcq1Poe8LKBCyElLjJW1m+e6sn4VlVrdkwCA3Am087kQbhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760128278; c=relaxed/simple;
	bh=eggSn5LlxKRQWD7Ws1HDr05Ffg355jCEdHCW7vcC0Zs=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=nc7JXJvBNWMrrmd+f75q7qMxjncSCzTDd5zYXsbPIeWZT97Z9SD60U9SBuTl6nAkIfJovxDHTZt6LyAq5CwLUjx/T4v9oNwstEvCTAE4YIzIalGJqaEgAUlyNsyBPx4kwOZArbksSbwKN0CUW34i9lHemmU5KKErftju7WpOkEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EqanuGgL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EqanuGgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C332C4CEFE;
	Fri, 10 Oct 2025 20:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760128276;
	bh=eggSn5LlxKRQWD7Ws1HDr05Ffg355jCEdHCW7vcC0Zs=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=EqanuGgLmqxFTxbDMfJJqTBcVItfxgdbHgHJrZ1pz2HvxB8pFWBaB8mmDk8pqEnXf
	 tplXxPiEvU3RP6eAh4bU7r51qaELqX2AW5n7s0zUlOIoOh6gP0gc10L4kOj5T2AfK8
	 h7x6b27nIoRw/IZ5GR7IpuNQzpdXzZ8LW3dawvZQC7t062UBBdIMP+vw/GmJpG7MDb
	 k3uktIBtziZcJ1apQAC09nyx9vpbJIRfbVsNZYEZOh2XG+cAwSYJXEofxiqXrOfsjD
	 Y/tBSm2TBlU29IbGZfLT6aeOxrAevFT78FWfNZa3Vh9DmSKjDZm5aHt6kQBe0FoK3b
	 ULHj2KlLhOung==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 10 Oct 2025 22:31:11 +0200
Message-Id: <DDEXED467W7D.ZK32X871Y1TL@kernel.org>
Cc: "Alex Gaynor" <alex.gaynor@gmail.com>, "Boqun Feng"
 <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, "Viresh Kumar"
 <viresh.kumar@linaro.org>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 0/3] Clean `rustfmt` formatting and define imports style
From: "Benno Lossin" <lossin@kernel.org>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Linus Torvalds"
 <torvalds@linux-foundation.org>
X-Mailer: aerc 0.21.0
References: <20251010174351.948650-1-ojeda@kernel.org>
In-Reply-To: <20251010174351.948650-1-ojeda@kernel.org>

On Fri Oct 10, 2025 at 7:43 PM CEST, Miguel Ojeda wrote:
> Hi Linus,
>
> Please see these commits, especially the documentation one. It is a
> follow-up of the discussion on `rustfmt`.
>
> If you are OK with it, please pick them up for -rc1 -- this should make
> CIs green and let people work easily after -rc1, which would help even
> if we decide to do something differently later on.
>
> I can send a quick PR if you prefer.
>
> Thanks!
>
> Miguel Ojeda (3):
>   docs: rust: add section on imports formatting
>   rust: alloc: employ a trailing comment to keep vertical layout
>   rust: cpufreq: fix formatting
>
>  Documentation/rust/coding-guidelines.rst | 75 ++++++++++++++++++++++++
>  rust/kernel/alloc/kvec.rs                |  2 +-
>  rust/kernel/cpufreq.rs                   |  3 +-
>  3 files changed, 77 insertions(+), 3 deletions(-)

For the series:

Reviewed-by: Benno Lossin <lossin@kernel.org>

---
Cheers,
Benno
