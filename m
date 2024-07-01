Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F3616EC0F;
	Mon,  1 Jul 2024 18:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719859068; cv=none; b=WgnXuhEtd3Uf6w62Ong+NRRvxVbizq2ztFKxuCr1k1uyAI+O7eyMndafClBPmgl6FzAlFnqnqmx07wlTsp81asZBWsEH9lGUtPRpJS6x3zASUrJ3/CdPtreHa2C4JC9j9gdpXX1/qNdG2HF2po3F6UuDll9RBWmYnOgOjQcqrGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719859068; c=relaxed/simple;
	bh=AOrqewpmo3+XMOPNv8O3XmSJfqYus/NPWk7kj+7SfIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lROtEcios58SvxIMm15HJWXtm0AFL/iKv+t/4IH3DgDwoMqbXzVK7zJM+sJSt/tGxT6cAWvtqIKWjUrbR/DZon/PQBnQUsQFHLmjFKjuxqZ46JfzHSTX8tBltLSvY1NKor4roZyp9IA2uBpMmPxMFFGNfHq7/jIgBmYzpt1vGuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B+IGRoqX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B+IGRoqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80560C32781;
	Mon,  1 Jul 2024 18:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719859068;
	bh=AOrqewpmo3+XMOPNv8O3XmSJfqYus/NPWk7kj+7SfIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+IGRoqXbOqjfzM3t6kEYMadiwnbMJQ8J/igQBEqS1MPRwhrMDjygFhKkjFtdID2C
	 sarxRKfJeexmt45ww1XF4AqqH/EgLNNrrz2qfXf/vwNEhbuU8PWkBQH3GCtfDZKpoH
	 To2ku5h2susyntctwh98HmUISl8ZGl0g53206t9IET/4ghGf2zMNZeuxwpP9lYQatl
	 UjvXs7BDewmQcHm2JW3ytVbWiQ5ZibqpsP/edubE9ipXWDfbqIHSU+hWjUU8HDY3dd
	 olm4qwALzvksdTQljYoAI40I5omT8jF67N0BzZaIHMOzp5nMbPwfHPNVWL7+fUlbqv
	 e/HTj6YPjjHfA==
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
	Jonathan Corbet <corbet@lwn.net>,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH 13/13] docs: rust: quick-start: add section on Linux distributions
Date: Mon,  1 Jul 2024 20:36:23 +0200
Message-ID: <20240701183625.665574-14-ojeda@kernel.org>
In-Reply-To: <20240701183625.665574-1-ojeda@kernel.org>
References: <20240701183625.665574-1-ojeda@kernel.org>
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
to understand its structure. We may want to reorganize it or split it
in the future, but I wanted to focus this commit on the new information
added about each particular distribution.

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
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
Note that openSUSE Tumbleweed is adding the Rust standard library source
code, `rustfmt` and Clippy, so we may be able to drop that small note in
their section in a few days (possibly before this gets applied) --
thanks William!

 Documentation/process/changes.rst  |  5 --
 Documentation/rust/quick-start.rst | 83 ++++++++++++++++++++++++++++--
 2 files changed, 78 insertions(+), 10 deletions(-)

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
index f624b913ff89..65a34a9a7089 100644
--- a/Documentation/rust/quick-start.rst
+++ b/Documentation/rust/quick-start.rst
@@ -5,17 +5,90 @@ Quick Start
 
 This document describes how to get started with kernel development in Rust.
 
+There are a few ways to install a Rust toolchain needed for kernel development.
+A simple way is to use the packages from your Linux distribution if they are
+suitable -- the first section below explains this approach. An advantage of this
+approach is that, typically, the distribution will match the LLVM used by Rust
+and Clang.
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
+release and thus it should generally work out of the box, e.g.::
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
+openSUSE Tumbleweed provides recent Rust releases and thus it should generally
+work out of the box, e.g.::
+
+	zypper install rust rust-bindgen clang
+
+The Rust standard library source code, ``rustfmt`` and Clippy are not packaged
+(yet), thus currently they need to be installed separately.
+
 
 Requirements: Building
 ----------------------
 
 This section explains how to fetch the tools needed for building.
 
-Some of these requirements might be available from Linux distributions
-under names like ``rustc``, ``rust-src``, ``rust-bindgen``, etc. However,
-at the time of writing, they are likely not to be recent enough unless
-the distribution tracks the latest releases.
-
 To easily check whether the requirements are met, the following target
 can be used::
 
-- 
2.45.2

