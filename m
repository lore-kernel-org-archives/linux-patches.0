Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED7621D3E3;
	Sun,  9 Mar 2025 20:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741552952; cv=none; b=K049rae2PTVyaTQth/dDRt9pFg/3/VD4wBr/UWlfSQ5G3DdTapTwRIZFZGUxDGvQO6D6DH+8hVvsRL0kzv8uxLoJgfhZdnvslGiRHZo41zN/Dt8jq+OfB9OzwuJqKeRQUd8YdgNuqCnaikXPQ3PiLUw8ysEkxJKy2CXq1hfljEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741552952; c=relaxed/simple;
	bh=xg3grOAubyXXiXrwLWjPk8Fl4ld99W6xOCLZ6xT3pSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtFxHMJ13VbRvSEAS4LhysShKGjAlgHTprbNKcpE10DQPLI/n8FQzXisF1PqOaau7V4vKB4XmvW5s3pfDTH7NWuPLMEOPpzoMfsMcwrYOk5hihpi8uxHjwVRgZ5lAB8Ms4hvtee/OXcQJwCi7CmR/ZGKRVMv4wg0U6WN6Y6Uj8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cIeAu0XI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cIeAu0XI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3937C4CEE3;
	Sun,  9 Mar 2025 20:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741552952;
	bh=xg3grOAubyXXiXrwLWjPk8Fl4ld99W6xOCLZ6xT3pSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cIeAu0XI3KV4dki35e4YoaIvqYVjOkVygTxXFs8xHCzcZhUdyhCwZsxR829cE+nI/
	 mhnUDVfDJd8N1KaB3RTPxknGroc7Rcpo34UqiGBv80vQVDXkMi2Cwvlrubkkx+r9tb
	 tBY6rXb4OqxyRKterliJdw6q9cWeQzpJOdqm5X1lJ4BncGAXaQQIwBunwAdvGscU33
	 ghLAUyNeKbRQNivtsUUastsXxV3AaWLnMhGTB6Uq1tgBoJB0jphRzzdMI4+axy4kWw
	 lsrOHn25iYouSMAFhcYZ8yUfC5Y/94kYf7a5lHro5rU0Q8m70MSKNL6YAJL5CPH0zE
	 xmKU0Cuzd7G7A==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 0/2] The two missing ones
Date: Sun,  9 Mar 2025 21:42:15 +0100
Message-ID: <20250309204217.1553389-1-ojeda@kernel.org>
In-Reply-To: <2025030955-kindness-designing-246c@gregkh>
References: <2025030955-kindness-designing-246c@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two missing ones on top of the other 60 -- sorry again! I tested the end result
of applying the 62 on top of v6.12.18 with all combinations of:

  - The minimum and maximum Rust compiler versions (i.e. 1.78.0 and 1.85.0).

  - x86_64, arm64, riscv64 and loongarch64 (this last one with the other
    unrelated-to-Rust fix on top).

  - A defconfig with Rust users enabled (rust_minimal, rust_print, rnull,
    drm_panic_qr, qt2025, ax88796b_rust) plus a similar with a couple debug
    options on top (Rust debug assertions and KUnit Rust doctests).

All pass my usual tests, are `WERROR=y` and Clippy-clean etc.

Plus x86_64 out-of-tree build, a x86_64 subdir build and a x86_64 Rust disabled
build. On x86_64, it should still build commit-by-commit.

Cheers,
Miguel

Gary Guo (1):
  rust: map `long` to `isize` and `char` to `u8`

Miguel Ojeda (1):
  rust: finish using custom FFI integer types

 drivers/gpu/drm/drm_panic_qr.rs |  2 +-
 rust/ffi.rs                     | 37 ++++++++++++++++++++++++++++++++-
 rust/kernel/error.rs            |  5 +----
 rust/kernel/firmware.rs         |  2 +-
 rust/kernel/uaccess.rs          | 27 +++++++-----------------
 5 files changed, 46 insertions(+), 27 deletions(-)

--
2.48.1
