Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF84381C8;
	Thu, 25 Jul 2024 17:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721929648; cv=none; b=XPi5cVGibqudvCqG9P2C+Rw/IGXRj0Bh5op+e89zHNZJqx56ktccfCxTPJxOiHJscIxfnFkCLCVmS6gCNkKdHu4fIasTrSWRI6NarI92MOVYFtccFKza7UpK9VZWinHeDo1LBfyab2qNgk8+VZaRAyLyvBahJRTdN6iEtFlwjtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721929648; c=relaxed/simple;
	bh=brGtcMltNc5qyVro7QoNysIIShWxU3siffgKjgWUwjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cE3nRk607gg5cuyaXvX/mhymYvdTJZhH5byplE+Of6jUTk0QfoXYyz8FUDJMClN2vos2DbIUhbbnPaUyflCz7pJL/oEzm/c41GYCeevtd8KmLG+ElxpT6W9GbfT7wohvg3mkkFtxmqqrgbRhCysXYbNF01gc8InVaU9UOM7HrGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L3xz1gwD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L3xz1gwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F5CC32782;
	Thu, 25 Jul 2024 17:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721929648;
	bh=brGtcMltNc5qyVro7QoNysIIShWxU3siffgKjgWUwjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L3xz1gwDOOO5vZFDO+s0upF8qVfCQKyggUdqbRVP+e+AqWB8jltx3m+dICiPROAV+
	 yh824BEe3mPEZ5N5zmgFBs9pQ4PkJVTicOOW5HesfpMOO6s0ouGXWyFshfs7betdJg
	 xknBzZQNfHZknZ5ejt9H09pr9rxyIlCh90wOOZq17JJVD2lMOh3xQn+iNH+GDZfQre
	 mzavMShTcOmEuRcs2gPdq7Nq0mPH4exsKRQJWRIKFQt5Bp57HKDboQezsrb5Dyev8z
	 r6vJ6FDLB48hn4oROBP5RoLq50HhFr7mfR/7dIqrdqyaz+kBNrO/2IHNa/NS6tv4pl
	 QLc9XmfzP+oYg==
From: Miguel Ojeda <ojeda@kernel.org>
To: gary@garyguo.net
Cc: a.hindborg@samsung.com,
	alex.gaynor@gmail.com,
	aliceryhl@google.com,
	benno.lossin@proton.me,
	bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	jpoimboe@kernel.org,
	linux-kernel@vger.kernel.org,
	masahiroy@kernel.org,
	mingo@redhat.com,
	nathan@kernel.org,
	nicolas@fjasle.eu,
	ojeda@kernel.org,
	patches@lists.linux.dev,
	peterz@infradead.org,
	rust-for-linux@vger.kernel.org,
	tglx@linutronix.de,
	wedsonaf@gmail.com,
	x86@kernel.org
Subject: Re: Re: [PATCH v2 1/6] rust: module: add static pointer to `{init,cleanup}_module()`
Date: Thu, 25 Jul 2024 19:47:13 +0200
Message-ID: <20240725174713.103150-1-ojeda@kernel.org>
In-Reply-To: <20240724204649.7de3ffed.gary@garyguo.net>
References: <20240724204649.7de3ffed.gary@garyguo.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 24 Jul 2024 20:46:49 +0100 Gary Guo <gary@garyguo.net> wrote:
>
> Should this be in section `.discard.addressable` instead?

No, we need to mimic the call to `___ADDRESSABLE()` (i.e. the one with
3 underscores, not 2), which passes `__{init,exit}data`.

By the way, thanks for the reviews Gary!

Cheers,
Miguel
