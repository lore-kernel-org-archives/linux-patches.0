Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D38119E7EA;
	Tue,  9 Jul 2024 16:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720541247; cv=none; b=tiY/ZzkzA8rNnQrDjNWmdANZFF+G+BFreLrAKumJJCMKdEXUx7n/X5gb98dyhWFWD+znxk2aGchf3KLa+l0aGkioHPjiF2FAhuNBHr5cpfrQGxX0tAZQWN6JQ9Hz1AW59+4Z5Pae4WQs1rdO2p1U0iZvF00gsLpqpVjZxiDglD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720541247; c=relaxed/simple;
	bh=BxoAN4lmNQraAC4bAp0pAC8a0CH5i0ji8ZhUUmuXkBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fRPy8VP/Vj7lz2gEZiHBFhE2YKz8REDEvluU9zS+tCYvAW3Lbm+iCD8TVjIDmazTNxKW3g/2HMShDcPI4C+OZ00XFG/xt5UtFIwgkZCoBxqraJPu5cayK93oflt+rBLrm48yCjUTaQycaly+bP79jeJ4m3MpkNNucKF1iZe8q30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uytXYJoJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uytXYJoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF19C32782;
	Tue,  9 Jul 2024 16:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720541247;
	bh=BxoAN4lmNQraAC4bAp0pAC8a0CH5i0ji8ZhUUmuXkBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uytXYJoJ4AIiXMWikKweXsRNX704B1h4UhYGtfh68aQTJJgiwVgH+8E+3xJhOa68c
	 WnHu6YdoPBgmOzoKnmbRpHjplfcw5/J0zbyyKYg3CXe5Pzka+v/cPsa+5lIVEi3Tq/
	 imjD4RGTJqomWV904le3VnL4I5FD02f68dwrFnM4WQtrkxkvp8SjATwpoplj9Un+8K
	 FYBnaHZAL2llssw1Gi3i+VadZTvC7MmGunR5ksMexCfHv94ventKGNUuMGRpM2lvtM
	 QWeBV2eLmXzhgxGOh+Ah2iNdCaeGIPl4k6OttyiiRTJnu2hULKpGIk2ois1QrML5H6
	 yuBPHDigsyrwg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Jan Alexander Steffens <heftig@archlinux.org>,
	=?UTF-8?q?Johannes=20L=C3=B6thberg?= <johannes@kyriasis.com>,
	=?UTF-8?q?Fabian=20Gr=C3=BCnbichler?= <debian@fabian.gruenbichler.email>,
	Josh Stone <jistone@redhat.com>,
	Randy Barlow <randy@electronsweatshop.com>,
	Anna Figueiredo Gomes <navi@vlhl.dev>,
	Matoro Mahri <matoro_gentoo@matoro.tk>,
	Ryan Scheel <ryan.havvy@gmail.com>,
	figsoda <figsoda@pm.me>,
	=?UTF-8?q?J=C3=B6rg=20Thalheim?= <joerg@thalheim.io>,
	Theodore Ni <43ngvg@masqt.com>,
	Winter <nixos@winter.cafe>,
	William Brown <wbrown@suse.de>,
	Xiaoguang Wang <xiaoguang.wang@suse.com>,
	Andrea Righi <andrea.righi@canonical.com>,
	Zixing Liu <zixing.liu@canonical.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH v2 13/13] docs: rust: quick-start: add section on Linux distributions
Date: Tue,  9 Jul 2024 18:06:08 +0200
Message-ID: <20240709160615.998336-14-ojeda@kernel.org>
In-Reply-To: <20240709160615.998336-1-ojeda@kernel.org>
References: <20240709160615.998336-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Now that we are starting to support several Rust compiler and `bindgen`
versions, there is a good chance some Linux distributions work out of
the box.

Thus, provide some instructions on how to set the toolchain up for a
few major Linux distributions. This simplifies the setup users need to
build the kernel.

In addition, add an introduction to the document so that it is easier
to understand its structure and move the LLVM+Rust kernel.org toolchains
paragraph there (removing "depending on the Linux version"). We may want
to reorganize the document or split it in the future, but I wanted to
focus this commit on the new information added about each particular
distribution.

Finally, remove the `rustup`'s components mention in `changes.rst` since
users do not need it if they install the toolchain via the distributions
(and anyway it was too detailed for that main document).

Cc: Jan Alexander Steffens <heftig@archlinux.org>
Cc: Johannes Löthberg <johannes@kyriasis.com>
Cc: Fabian Grünbichler <debian@fabian.gruenbichler.email>
Cc: Josh Stone <jistone@redhat.com>
Cc: Randy Barlow <randy@electronsweatshop.com>
Cc: Anna (navi) Figueiredo Gomes <navi@vlhl.dev>
Cc: Matoro Mahri <matoro_gentoo@matoro.tk>
Cc: Ryan Scheel <ryan.havvy@gmail.com>
Cc: figsoda <figsoda@pm.me>
Cc: Jörg Thalheim <joerg@thalheim.io>
Cc: Theodore Ni <43ngvg@masqt.com>
Cc: Winter <nixos@winter.cafe>
Cc: William Brown <wbrown@suse.de>
Cc: Xiaoguang Wang <xiaoguang.wang@suse.com>
Cc: Andrea Righi <andrea.righi@canonical.com>
Cc: Zixing Liu <zixing.liu@canonical.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Tested-by: Benno Lossin <benno.lossin@proton.me>
Tested-by: Andreas Hindborg <a.hindborg@samsung.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
v2:
  - Add openSUSE Slowroll.
  - Update openSUSE docs: both Slowroll and Tumbleweed now provide
    `rustfmt`, Clippy and the Rust standard library sources, so the
    comment about those can be dropped. (William)
  - I ended up leaving the Debian/Ubuntu docs as-is for the time being.
    Happy to get a patch for that later. We should definitely add them
    if they start working for the current kernel (currently: Ubuntu's
    latest versioned package is 1.76, and Debian's `web` one is 1.70).
    (Andrea, Fabian)
  - Move the LLVM+Rust kernel.org toolchains paragraph to the
    introduction that this commit adds, now that we have access to that
    paragraph since the series is rebased on top of `rust-next`.
  - Use plural for "release".

 Documentation/process/changes.rst  |  5 --
 Documentation/rust/quick-start.rst | 93 ++++++++++++++++++++++++++----
 2 files changed, 81 insertions(+), 17 deletions(-)

diff --git a/Documentation/process/changes.rst b/Documentation/process/changes.rst
index 0d0b7120792b..0ce96ae2588c 100644
--- a/Documentation/process/changes.rst
+++ b/Documentation/process/changes.rst
@@ -90,11 +90,6 @@ Rust (optional)

 A recent version of the Rust compiler is required.

-Each Rust toolchain comes with several "components", some of which are required
-(like ``rustc``) and some that are optional. The ``rust-src`` component (which
-is optional) needs to be installed to build the kernel. Other components are
-useful for developing.
-
 Please see Documentation/rust/quick-start.rst for instructions on how to
 satisfy the build requirements of Rust support. In particular, the ``Makefile``
 target ``rustavailable`` is useful to check why the Rust toolchain may not
diff --git a/Documentation/rust/quick-start.rst b/Documentation/rust/quick-start.rst
index 66cefbab8f9a..d06a36106cd4 100644
--- a/Documentation/rust/quick-start.rst
+++ b/Documentation/rust/quick-start.rst
@@ -5,24 +5,93 @@ Quick Start

 This document describes how to get started with kernel development in Rust.

+There are a few ways to install a Rust toolchain needed for kernel development.
+A simple way is to use the packages from your Linux distribution if they are
+suitable -- the first section below explains this approach. An advantage of this
+approach is that, typically, the distribution will match the LLVM used by Rust
+and Clang.
+
+Another way is using the prebuilt stable versions of LLVM+Rust provided on
+`kernel.org <https://kernel.org/pub/tools/llvm/rust/>`_. These are the same slim
+and fast LLVM toolchains from :ref:`Getting LLVM <getting_llvm>` with versions
+of Rust added to them that Rust for Linux supports. Two sets are provided: the
+"latest LLVM" and "matching LLVM" (please see the link for more information).
+
+Alternatively, the next two "Requirements" sections explain each component and
+how to install them through ``rustup``, the standalone installers from Rust
+and/or building them.
+
+The rest of the document explains other aspects on how to get started.
+
+
+Distributions
+-------------
+
+Arch Linux
+**********
+
+Arch Linux provides recent Rust releases and thus it should generally work out
+of the box, e.g.::
+
+	pacman -S rust rust-src rust-bindgen
+
+
+Debian
+******
+
+Debian Unstable (Sid), outside of the freeze period, provides recent Rust
+releases and thus it should generally work out of the box, e.g.::
+
+	apt install rustc rust-src bindgen rustfmt rust-clippy
+
+
+Fedora Linux
+************
+
+Fedora Linux provides recent Rust releases and thus it should generally work out
+of the box, e.g.::
+
+	dnf install rust rust-src bindgen-cli rustfmt clippy
+
+
+Gentoo Linux
+************
+
+Gentoo Linux (and especially the testing branch) provides recent Rust releases
+and thus it should generally work out of the box, e.g.::
+
+	USE='rust-src rustfmt clippy' emerge dev-lang/rust dev-util/bindgen
+
+``LIBCLANG_PATH`` may need to be set.
+
+
+Nix
+***
+
+Nix (unstable channel) provides recent Rust releases and thus it should
+generally work out of the box, e.g.::
+
+	{ pkgs ? import <nixpkgs> {} }:
+	pkgs.mkShell {
+	  nativeBuildInputs = with pkgs; [ rustc rust-bindgen rustfmt clippy ];
+	  RUST_LIB_SRC = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
+	}
+
+
+openSUSE
+********
+
+openSUSE Slowroll and openSUSE Tumbleweed provide recent Rust releases and thus
+they should generally work out of the box, e.g.::
+
+	zypper install rust rust1.79-src rust-bindgen clang
+

 Requirements: Building
 ----------------------

 This section explains how to fetch the tools needed for building.

-Some of these requirements might be available from Linux distributions
-under names like ``rustc``, ``rust-src``, ``rust-bindgen``, etc. However,
-at the time of writing, they are likely not to be recent enough unless
-the distribution tracks the latest releases.
-
-Prebuilt stable versions of LLVM+Rust are provided on `kernel.org
-<https://kernel.org/pub/tools/llvm/rust/>`_. These are the same slim and fast
-LLVM toolchains from :ref:`Getting LLVM <getting_llvm>` with versions of Rust
-added to them that Rust for Linux supports, depending on the Linux version. Two
-sets are provided: the "latest LLVM" and "matching LLVM" (please see the link
-for more information).
-
 To easily check whether the requirements are met, the following target
 can be used::

--
2.45.2
