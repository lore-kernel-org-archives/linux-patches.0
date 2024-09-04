Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1E3155730;
	Wed,  4 Sep 2024 20:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482689; cv=none; b=I+68vnro5Gs6GEvTcld7isdPjRgtV4oYEcbtLs7JIjr+NCxPPWRgP028eA42pb9WLEFncDUhOqhseb0zLQ91wkvYYNl5Gd3326yVvclDp0CJf+4i0MtyozXU3Dk7pofjXFyfAjDTIqaoLUmn1QU2283bjD5UONeF9UKz8aGEkNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482689; c=relaxed/simple;
	bh=n+H0WVK71AlS2DbgqqLYwugZDAwCnU45IJ9wYNEw5Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3ubY5AgmlNtD5uql80dX25vNzARGYo3fR7UDObZyL2S5+WKYTqHTY3DyvE+R1XKmwp04NcPHysoD5a8/KOwtxeAkhdKfl9VFZAJCZSBp6zrotARx7WUJDpOE24kJX5aLoX/R5ONIT2Q9LHHKNe9VTZz2XECXTg7sERYdmJ+89Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E/mxmall; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E/mxmall"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C7FC4CEC8;
	Wed,  4 Sep 2024 20:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725482689;
	bh=n+H0WVK71AlS2DbgqqLYwugZDAwCnU45IJ9wYNEw5Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E/mxmall0XlIt8dpA7ujiYjHOS1YypBu7tqQJRR0h55ErzVgoHST/P+vD40wLhL8U
	 Z+5/D0uI7SeR36G2pzypU4qOoXz4woAs+/eQXu75PoIXduQnTO0rh0sRb3S5sVQ68Y
	 Nz5V1waC5/vofwTxZFiI3q1ZdgviOgc8eGbOpHXwQTasVuAcwcj3SB62bFze42eLX4
	 1RjaTzN6xCrH/WbJDhuoX7wSZZEx9FXq2pwJSLnYIpivX/h52+C4+GsfBwfM2k7hQ/
	 FUxLNFnJmyRYkhgDCIbD2Zhd+/Z/4rLhUNR29I20HVialbuvf0CR+ygZytMJv0at5O
	 QlO7EI67crlNw==
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
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 02/19] rust: sort global Rust flags
Date: Wed,  4 Sep 2024 22:43:30 +0200
Message-ID: <20240904204347.168520-3-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-1-ojeda@kernel.org>
References: <20240904204347.168520-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sort the global Rust flags so that it is easier to follow along when we
have more, like this patch series does.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 68ebd6d6b444..7a97726f54f7 100644
--- a/Makefile
+++ b/Makefile
@@ -445,18 +445,18 @@ KBUILD_USERLDFLAGS := $(USERLDFLAGS)
 # host programs.
 export rust_common_flags := --edition=2021 \
 			    -Zbinary_dep_depinfo=y \
-			    -Dunsafe_op_in_unsafe_fn \
 			    -Dnon_ascii_idents \
+			    -Dunsafe_op_in_unsafe_fn \
+			    -Wmissing_docs \
 			    -Wrust_2018_idioms \
 			    -Wunreachable_pub \
-			    -Wmissing_docs \
-			    -Wrustdoc::missing_crate_level_docs \
 			    -Wclippy::all \
+			    -Wclippy::dbg_macro \
 			    -Wclippy::mut_mut \
 			    -Wclippy::needless_bitwise_bool \
 			    -Wclippy::needless_continue \
 			    -Wclippy::no_mangle_with_rust_abi \
-			    -Wclippy::dbg_macro
+			    -Wrustdoc::missing_crate_level_docs
 
 KBUILD_HOSTCFLAGS   := $(KBUILD_USERHOSTCFLAGS) $(HOST_LFS_CFLAGS) \
 		       $(HOSTCFLAGS) -I $(srctree)/scripts/include
-- 
2.46.0

