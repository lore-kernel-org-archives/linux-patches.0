Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6AA255F49;
	Fri,  2 May 2025 14:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746194581; cv=none; b=HUqadturRDXaqXK3setkQ9h7hD8oiB63oOIopj17NepAm6k/8c2unwbZ/FltdPgqwEyCT0TFT6gbyFB0hpDvhced/iNlOyEwbHtii1znDYvVmL86y9yY+WiS2y8pPhxL4pxH0dOZdGnHu56nmWkqcKAIMzGWCAox5NYQmL8qReQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746194581; c=relaxed/simple;
	bh=SIxigMeAMetVPFRmyic26ZlV4C8J7gDJlcnLm59bl3A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qOzIUSrfLZkuCEEicR8atwx3QVolVK/WAfkjM1UU8ZUTGOaxA61y6OkN4iUQRYsTmIEV1f4Ez211JIx+5k2i9qKpX0n5qEi/kySQrzFlahYfDG8JAx+7tmqjtqXD14jDHN3J4izsf0yx+uw64ZYEayMKjbodtDQNpkC18eHeQTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qu2ASfoC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qu2ASfoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A1AC4CEE4;
	Fri,  2 May 2025 14:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746194581;
	bh=SIxigMeAMetVPFRmyic26ZlV4C8J7gDJlcnLm59bl3A=;
	h=From:To:Cc:Subject:Date:From;
	b=Qu2ASfoCGmCaieKbL0gPCBWkMv9WtDr4iqtXo6YJdF/wDlQXIYQ5ydjNBRe06qYAl
	 RMhQmQ+7RfeYlJr81sDvmA5hl1Uhh43wLvfBebNuf4yhhWDf3pbEYoZoPuOpYw1CUO
	 M89CskVk45sEdDRxEeGzvd9NuRxJp33f3QMnU+67+kqsvMyFRGSzMFfL32raMmhIpD
	 XDLhB0y5ptjNBNja76gsc/DrWqcao8ANgVaRamfIKBF6hJMQzaN7CpaiLlf5Qkrvac
	 zxxEUyHC40xl6jahdHVoOMbCjMTgnG4d5lSpkQHNbtC+k9OUVrFbVY+JaIfKpalZJ8
	 Oa7LHsnzu/L0g==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 0/5] Rust beta (1.87) and nightly (1.88) lint cleanups
Date: Fri,  2 May 2025 16:02:32 +0200
Message-ID: <20250502140237.1659624-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that Rust 1.87.0 is close to release, clean up the new lints that appeared.

It may be that one of the patches is not needed by the time it releases, but
I prefer to not wait much longer since I would like to land this for -rc6 so
that it is clean for release.

In addition, clean some nightly (1.88.0) ones too.

Miguel Ojeda (5):
  objtool/rust: add one more `noreturn` Rust function for Rust 1.87.0
  rust: clean Rust 1.87.0's `clippy::ptr_eq` lints
  rust: clean Rust 1.88.0's `unnecessary_transmutes` lint
  rust: clean Rust 1.88.0's warning about `clippy::disallowed_macros`
    configuration
  rust: clean Rust 1.88.0's `clippy::uninlined_format_args` lint

 .clippy.toml                              |  2 +-
 drivers/gpu/nova-core/gpu.rs              |  2 +-
 init/Kconfig                              |  3 ++
 rust/bindings/lib.rs                      |  1 +
 rust/kernel/alloc/kvec.rs                 |  2 +-
 rust/kernel/list.rs                       | 12 +++---
 rust/kernel/str.rs                        | 46 +++++++++++------------
 rust/macros/kunit.rs                      | 13 ++-----
 rust/macros/module.rs                     | 19 +++-------
 rust/macros/paste.rs                      |  2 +-
 rust/pin-init/internal/src/pinned_drop.rs |  3 +-
 rust/uapi/lib.rs                          |  1 +
 tools/objtool/check.c                     |  1 +
 13 files changed, 49 insertions(+), 58 deletions(-)


base-commit: b4432656b36e5cc1d50a1f2dc15357543add530e
--
2.49.0
