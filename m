Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964351BF32C;
	Fri, 16 Aug 2024 18:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723832163; cv=none; b=fdMr68sdHmZuqOcqYyOvLAq6CxSgDj7dAvoub6Ur/pnd8N2VFZWuX1MEKypGtG695+qDt3lglY0rY+qKKMEW9M+30jgxHqKIB0HYO1usCN+EM54dnRrXeYTLTcD/2WlVCCO+Fwc8NsI019SWGsYO0T8usCx5dkBDjaplcqFBK3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723832163; c=relaxed/simple;
	bh=s13dFs+2zXKyXsfVO3/wT4TtdOpwfmNUKmCcTjIlGKk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tzKA3BQG5yxv1Xghpt2C/cicjeGYwSF7sHAh+M/aiChkG3N3Zatj6megne5ToqphUMlbkB9ftFOEJwF8H3P9EOdmkI3Xvkk2WZ8M5VyeLUCgrnFUfn6kmXXt2JiStWkFyfWywW/W1b1lxExBcPcdDDUvjjn5ekACUWoCZnlYDUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SVycFNK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SVycFNK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8D2C32782;
	Fri, 16 Aug 2024 18:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723832163;
	bh=s13dFs+2zXKyXsfVO3/wT4TtdOpwfmNUKmCcTjIlGKk=;
	h=From:To:Cc:Subject:Date:From;
	b=SVycFNK8rNFB0ited7aUBZ0GFv7uMM71RSmL1X5INtj3zCzCRMYN1QeoKCdFzjsXD
	 FnbjCxDyHEl0OPq2vxraMuW8Jm7E8rt2aeuiP66KirlMHtdNFCzDeHQ7GEPGiMkz6y
	 /5bCKgosMJrg8TbifmyX0V7zh67Cf2Jy4lj9r5J+ikOFitL8yTr1uAClQau9Yw2G7q
	 poUuD9sVbFBikHvvIOgA7DPWvSgO9a1RIO/iDoDGNg4dPPS/Izolqlbdg6mdhXN31V
	 6bid/Mia8aQnTkHNgPgeCAqtkQ4PUSPK6nnLa3qtWMyQjY2WYYNNmqzkhrEFKYbZlZ
	 FEUgrKWz9sLxQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Zixing Liu <zixing.liu@canonical.com>,
	William Grant <wgrant@ubuntu.com>,
	Kees Cook <kees@kernel.org>
Subject: [RFC PATCH] docs: rust: quick-start: add Ubuntu
Date: Fri, 16 Aug 2024 20:15:45 +0200
Message-ID: <20240816181545.45789-1-ojeda@kernel.org>
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

Therefore, add instructions to the Quick Start guide for Ubuntu like
for the other distributions.

Cc: Zixing Liu <zixing.liu@canonical.com>
Cc: William Grant <wgrant@ubuntu.com>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
This is a potential patch for the future -- Ubuntu Oracular (future
release) works today, but the Rust versioned releases are not backported
(yet?). If Ubuntu ends up deciding to backport them, which would be
amazing, or at least when they start to appear in an actual release,
then we can apply this. Thanks William & Zixing!

 Documentation/rust/quick-start.rst | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/rust/quick-start.rst b/Documentation/rust/quick-start.rst
index d06a36106cd4..af39c8e13558 100644
--- a/Documentation/rust/quick-start.rst
+++ b/Documentation/rust/quick-start.rst
@@ -87,6 +87,19 @@ they should generally work out of the box, e.g.::
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
+
 Requirements: Building
 ----------------------


base-commit: 7c626ce4bae1ac14f60076d00eafe71af30450ba
--
2.46.0
