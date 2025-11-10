Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E07525A340
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 15:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762790374; cv=none; b=HGG38xmizOlWS0BrCppIb+uZFAwEJukLaI+1wDv1A3EOLp5P9PVGW+Mz0eCPv6ZV80NA50YwOVW4z0yI40A8eN3BOxaJBz44I2kkvFW3p8HWyYD4ZMGGLOn8mQpbnTLG2qEx1GpIlRz1zziVMkw0vhE2O0HM0U/C7uLE0R8NIZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762790374; c=relaxed/simple;
	bh=gZKxNyrE0sD4Ub1Vp21weYbIAfnS5QGtyu7iDsvgYQg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KNA5Q0YvCzt1ScQ4fNw1vLtvCjWB+JkS9H5EEzLMBf6IJsl8NfGjV4NBbP/QH+TgAVrchntvlTylYWVx/1//0naqgjCfOYMlrXlsFPji+8CQh9Yn3Q29ZxegwAain8Z0EnxZ/1xXlBHupfFKP45QU4KhXhqf3wLIvMVhDz/m7CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=e0QCiNxE; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="e0QCiNxE"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 35ED040B69
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1762790372; bh=Hw+JoTlh+fN1+Vj5gYyi6iRz4VoCII4mPEe6jsXkwAM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=e0QCiNxEJiNsmAymdVvzafHbL4N3MlHG/hLKh2dZAeFddQV+VBU0pTJBiqdwrntWP
	 GGCK/cDT9+FpOqaj4+oIAe2UflenT4JcnFjD/M3vYPdTCrhQb8a9JbCIBKjqIFEMjf
	 EFdM2k5tlwDvmyEd7jOFDdmxb7J5g4TW+Pye+4ER5gyQeldu7JTMQ1jpi1ltrgfYqN
	 Xz4D949JKTwHaVmsVt8hJ/lELpYQx+/3JUDxk1M/A9XMbcYv3B0Ne4EL04aN7GUYXg
	 1g00E3bAner5Gj+nhgB8i7Gl03CNkqG6+fF33udgQgSVnAfn/INQfvRDlrBhMHvllw
	 LzBkzQ5sl7cJw==
Received: from localhost (unknown [IPv6:2601:280:4600:2da9::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 35ED040B69;
	Mon, 10 Nov 2025 15:59:32 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Miguel Ojeda <ojeda@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, Alex
 Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>,
 Nicolas Schier <nicolas@fjasle.eu>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl
 <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo Krummrich
 <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH 00/18] `syn` support
In-Reply-To: <20251110095025.1475896-1-ojeda@kernel.org>
References: <20251110095025.1475896-1-ojeda@kernel.org>
Date: Mon, 10 Nov 2025 08:59:31 -0700
Message-ID: <874ir1zxng.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Miguel Ojeda <ojeda@kernel.org> writes:

> This patch series introduces support for `syn` (and its dependencies).
> Having such support allows to greatly simplify writing complex macros
> such as `pin-init`.

Just in case I'm not the only ignorant person who didn't immediately
know what "syn" is and why we might want 57,000 lines of it in the
kernel... :)

    Syn is a parsing library for parsing a stream of Rust tokens into a
    syntax tree of Rust source code.

    Currently this library is geared toward use in Rust procedural
    macros, but contains some APIs that may be useful more generally

https://docs.rs/syn/latest/syn/

Thanks,

jon
