Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE171922C6;
	Wed, 25 Sep 2024 14:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727273215; cv=none; b=kCasAGL+iedcT+agORyTfMaG3/xu305QlgUTBlVlh30o7NigL+Y70TZJuX27YAd6slbowN8q5CO7YXCEjA62hOGBCQyul2W8FPdHcxlqTh///gMbBStWXGEG2B9Ju/1OkFmtSwcHsEFVXHPDhYhQOM964jIzS8GDqkjqyNYEJUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727273215; c=relaxed/simple;
	bh=3vvdp1yQQNf/xwOS6Vizv6KAU4OM+82E1VYtghgaJJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p1u0x4RKqv0FKjh0C7g2478sn/ooiPkiL1qS2MnaWKsue1XGeW7cvLRSNMTGPNA/TPf5tcq/Q4oKCGcJ0yvq6gF7BdhiMIS+ar8SvY9CMqCiDf9WJUEJ0Perw4Go78hXBesTXqfcgZId+ZFKIrYPwmxn3pc8Sug14x+srXYmW/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SdCPP5vw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SdCPP5vw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82DBC4CEC3;
	Wed, 25 Sep 2024 14:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727273215;
	bh=3vvdp1yQQNf/xwOS6Vizv6KAU4OM+82E1VYtghgaJJ0=;
	h=From:To:Cc:Subject:Date:From;
	b=SdCPP5vw76qXysR37EwC5f0TZptfGY+fbumb14ld3aoPEJwrUgxjrz5CSUAjddzO+
	 0u56l9TARvh40PdmXSoeeEyD2wZ59LXX6MaD1K7XFhbs5HMFYHaxhazlWcqf4WH8/k
	 EMA1RVmYy7DbIagUx/IAlFRGZYVWHUwYOosukpvRAePJV2S4sFGfJSZLbIA/QZ+Cxf
	 RRyKUUuT+W2l7Yek4xVSux02HACPjdmma47VlvY3ygIOt5dnIS/A2v9b34mprWsm/u
	 6JutUtZrDepuUkal0ZHzLRS1OzAtW1bVthFfF6mfNM5v/OIUwjhQmwSlQDHFssuA98
	 w8KRjn+OidfpQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Zixing Liu <zixing.liu@canonical.com>,
	William Grant <wgrant@ubuntu.com>,
	Kees Cook <kees@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] docs: rust: quick-start: add Ubuntu
Date: Wed, 25 Sep 2024 16:06:00 +0200
Message-ID: <20240925140600.275429-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ubuntu has changed their maintenance model for Rust toolchains and is
now providing recent Rust releases in their releases, including both
LTS and non-LTS (interim) releases.

Therefore, add instructions to the Quick Start guide for Ubuntu, like
it is done for the other distributions.

Link: https://packages.ubuntu.com/search?keywords=rustc-1
Link: https://packages.ubuntu.com/search?keywords=bindgen-0
Cc: Zixing Liu <zixing.liu@canonical.com>
Cc: William Grant <wgrant@ubuntu.com>
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
RFC: https://lore.kernel.org/rust-for-linux/20240816181545.45789-1-ojeda@kernel.org/

Compared to the RFC, Ubuntu now provides the versioned `rustc-*`
packages in older LTSs (the ones with standard support), which is great!

I can confirm I can build the latest kernel in 20.04 LTS (using a
newer LLVM), 22.04 LTS, 24.04 LTS and 24.10.

The `bindgen-*` versioned packages are not backported (yet?) to the
older LTSs, so I added a note about that compared to the RFC patch.

 Documentation/rust/quick-start.rst | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/rust/quick-start.rst b/Documentation/rust/quick-start.rst
index ed5af2b5339a..393b3e2f2a05 100644
--- a/Documentation/rust/quick-start.rst
+++ b/Documentation/rust/quick-start.rst
@@ -87,6 +87,23 @@ they should generally work out of the box, e.g.::
 	zypper install rust rust1.79-src rust-bindgen clang


+Ubuntu
+******
+
+Ubuntu LTS and non-LTS (interim) releases provide recent Rust releases and thus
+they should generally work out of the box, e.g.::
+
+	apt install rustc-1.80 rust-1.80-src bindgen-0.65 rustfmt-1.80 rust-1.80-clippy
+
+``RUST_LIB_SRC`` needs to be set when using the versioned packages, e.g.::
+
+	RUST_LIB_SRC=/usr/src/rustc-$(rustc-1.80 --version | cut -d' ' -f2)/library
+
+In addition, ``bindgen-0.65`` is available in newer releases (24.04 LTS and
+24.10), but it may not be available in older ones (20.04 LTS and 22.04 LTS),
+thus ``bindgen`` may need to be built manually (please see below).
+
+
 Requirements: Building
 ----------------------


base-commit: a2f11547052001bd448ccec81dd1e68409078fbb
--
2.46.2
