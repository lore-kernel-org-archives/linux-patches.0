Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FAD36AFD;
	Wed, 18 Oct 2023 16:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n9AT1Bxb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92826C433C9;
	Wed, 18 Oct 2023 16:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1697644926;
	bh=UUb5tWHJhw3ZVTTxx162aDZgpzTjS6VXclV4Y7Ipafo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9AT1Bxb2Noz3VcHVd34N9fA5590gJ9qzsyLlSGzHV3fCcR6DnzlNQdZqs7xbI0h/
	 XCWPHpZ+nSG2N5W6Zz/qXP410lm7wFo0F8YT7PH6/8LOjraIfXtxLBXoeHqN0d4U7y
	 r3ZHwxZoSWnCnAhbSHkpaHP4c79v1Qlj7ws6JQAe/eXiEaotIrVfniCPV90lcZ5a9l
	 cdMJEFBbsfxXUcHiSQVLgITuU8aCsuAz15i4D37uk6oPMdN4y9WTGAET+Yg0XYqzmi
	 8hBpCUnnz702QkUV+6Y3IcBJEk81IN7fncUpVdaSlOXdkIZWxwS/Zg6jI7mzvM+fVx
	 9nL9N9kKnvM4g==
From: Miguel Ojeda <ojeda@kernel.org>
To: Masahiro Yamada <masahiroy@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Carlos Bilbao <carlos.bilbao@amd.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	linux-kbuild@vger.kernel.org,
	linux-doc@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Akira Yokosawa <akiyks@gmail.com>
Subject: [PATCH 2/2] kbuild: remove old Rust docs output path
Date: Wed, 18 Oct 2023 18:01:45 +0200
Message-ID: <20231018160145.1017340-2-ojeda@kernel.org>
In-Reply-To: <20231018160145.1017340-1-ojeda@kernel.org>
References: <20231018160145.1017340-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Rust code documentation output path moved from `rust/doc` to
`Documentation/output/rust/rustdoc`. The `make cleandocs` target
takes care of cleaning it now since it is integrated with the rest
of the documentation.

Thus remove the old reference.

Fixes: 48fadf440075 ("docs: Move rustdoc output, cross-reference it")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 373649c7374e..040018111f32 100644
--- a/Makefile
+++ b/Makefile
@@ -1474,7 +1474,7 @@ endif # CONFIG_MODULES
 # Directories & files removed with 'make clean'
 CLEAN_FILES += vmlinux.symvers modules-only.symvers \
 	       modules.builtin modules.builtin.modinfo modules.nsdeps \
-	       compile_commands.json .thinlto-cache rust/test rust/doc \
+	       compile_commands.json .thinlto-cache rust/test \
 	       rust-project.json .vmlinux.objs .vmlinux.export.c
 
 # Directories & files removed with 'make mrproper'
-- 
2.42.0

