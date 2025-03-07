Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C22C20DD67;
	Fri,  7 Mar 2025 22:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387878; cv=none; b=AiRlZB6Vfi4WEtLntyG1ksIb6Wjvw0i9sdq77D4yEwBJioGAC0TgN7ReIUZetn/M5HR8Lgg3oGybniwROKmAMNy/m1CptMEHaanoZX8ps76wL5yY2IVzjJ3gdI0WdLQL26CpkX2PtpL87VIeyqbMGpuFY1/9IxYJKC+glG0GgWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387878; c=relaxed/simple;
	bh=xcF79j4axFxbKhi89xl2t9Hpdb6RmQORVJuFcjHHRvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8x37qT15zvFtaVFi7V7/It77ntF5HpvsNPodlhzNhLjJU3DQqWrndGU51fcv1l3wn14GzOJJn8uUoiWKXR6Dgx+EAXaTUI2GdlofBl87VG47TBHgVmNn3j9rsCgtjyhGh79Ro4rvRUuJuLoKYmOs0W1R9x1gGPL2tR6moMST2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cdQC1JzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cdQC1JzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25E3C4CEE9;
	Fri,  7 Mar 2025 22:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387877;
	bh=xcF79j4axFxbKhi89xl2t9Hpdb6RmQORVJuFcjHHRvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cdQC1JzXdTdNquqfDQ0b4KTPXesbjqTcGCEuI1NcAMv+Hfl9bi+Mnt3t6Gspbmr7o
	 1Z9D+oGL/PbupQ42/Yxy3hCoSD6yaCXYfoIttaDzvZfyRN7fogkDNyQ+r3luUKzm8t
	 vQy3xCbKiEFdBebkmtcj/7DObErcuAlRxP6T9eAyx2dFJTVLzSlqcWi+aym0q/dhNL
	 k6MpVEkAPFeKadqkA749t7mlQ4ZdggrG6yXCEOhzCqy5LSuVZ4jmzh4abmV+BeRP/D
	 6njFLFGK/MA3v5lmxqRFELabYIv/y1k1rkkeFt+jVhkHKlS4KW/rVjw6jmOlSzJrAj
	 yDtKd2POsX9FA==
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
Subject: [PATCH 6.12.y 15/60] Documentation: rust: add coding guidelines on lints
Date: Fri,  7 Mar 2025 23:49:22 +0100
Message-ID: <20250307225008.779961-16-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 139d396572ec4ba6e8cc5c02f5c8d5d1139be4b7 upstream.

In the C side, disabling diagnostics locally, i.e. within the source code,
is rare (at least in the kernel). Sometimes warnings are manipulated
via the flags at the translation unit level, but that is about it.

In Rust, it is easier to change locally the "level" of lints
(e.g. allowing them locally). In turn, this means it is easier to
globally enable more lints that may trigger a few false positives here
and there that need to be allowed locally, but that generally can spot
issues or bugs.

Thus document this.

Reviewed-by: Trevor Gross <tmgross@umich.edu>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-17-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Documentation/rust/coding-guidelines.rst | 38 ++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/Documentation/rust/coding-guidelines.rst b/Documentation/rust/coding-guidelines.rst
index 329b070a1d47..6db0420f0cea 100644
--- a/Documentation/rust/coding-guidelines.rst
+++ b/Documentation/rust/coding-guidelines.rst
@@ -227,3 +227,41 @@ The equivalent in Rust may look like (ignoring documentation):
 That is, the equivalent of ``GPIO_LINE_DIRECTION_IN`` would be referred to as
 ``gpio::LineDirection::In``. In particular, it should not be named
 ``gpio::gpio_line_direction::GPIO_LINE_DIRECTION_IN``.
+
+
+Lints
+-----
+
+In Rust, it is possible to ``allow`` particular warnings (diagnostics, lints)
+locally, making the compiler ignore instances of a given warning within a given
+function, module, block, etc.
+
+It is similar to ``#pragma GCC diagnostic push`` + ``ignored`` + ``pop`` in C
+[#]_:
+
+.. code-block:: c
+
+	#pragma GCC diagnostic push
+	#pragma GCC diagnostic ignored "-Wunused-function"
+	static void f(void) {}
+	#pragma GCC diagnostic pop
+
+.. [#] In this particular case, the kernel's ``__{always,maybe}_unused``
+       attributes (C23's ``[[maybe_unused]]``) may be used; however, the example
+       is meant to reflect the equivalent lint in Rust discussed afterwards.
+
+But way less verbose:
+
+.. code-block:: rust
+
+	#[allow(dead_code)]
+	fn f() {}
+
+By that virtue, it makes it possible to comfortably enable more diagnostics by
+default (i.e. outside ``W=`` levels). In particular, those that may have some
+false positives but that are otherwise quite useful to keep enabled to catch
+potential mistakes.
+
+For more information about diagnostics in Rust, please see:
+
+	https://doc.rust-lang.org/stable/reference/attributes/diagnostics.html
-- 
2.48.1

