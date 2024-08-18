Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7418D8F66;
	Sun, 18 Aug 2024 14:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723990340; cv=none; b=tjLjeL3GPLWeEAPJODZoym6VPDqdvsDV6ZqomFDIHPx78fZg7xA7R+/slhL28ErUCtjbGeGQczIe1jdKDlEUjw117Gvr8iHfiiXgvEFZ0trg8jP1Wc3Z4+DT1eM1QSqcD/MpS3Qr5S2OuYrX1vrdGab11WNBitOhtTdka+/Zttg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723990340; c=relaxed/simple;
	bh=yz2o5dNGK6ftsUgbLKxuKrLyioWcjS160l4A5ZnuwHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGiCPKkzfoHVXtg524ct3sX+GXMshonlmsnDFUuMt6uS6eNyGs7EFyO/5M00Kwjif2/mYqXmoUmuA24ywDpjLvd3ogQ2MwAGke1R8Cf/gglkFwX+LhL+m2/HWdQfIcWfKzgmn2JCGp77EvaDujqf8X3us5oX6NMGja3yqxAGBEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pg5yU4CZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pg5yU4CZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77420C4AF0B;
	Sun, 18 Aug 2024 14:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723990340;
	bh=yz2o5dNGK6ftsUgbLKxuKrLyioWcjS160l4A5ZnuwHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pg5yU4CZOfCOSzOTS/TXP/A6MV8ThsGmWPHNoIWpN84901otcCeWbJfntNAgThu/Z
	 IM0pbk/kjlGDzAV1y8tqL3MHBas6Vnl180gp871xVdq/7YklVUrvaPTwD2zRpDhiG/
	 FGpeMIr9CukSPgqN2/CkLQfQ4cWx/WGZwpINs4uyNZOz0Us3JeCY3ILyBXZ59lO2n0
	 eGhCZ8SoS9FIWsidYQEHn95LbD1y4S5Zc9WKFvqWy7LnXSr+EPjxkinKfmc2qiQeyl
	 /jcAPRy/vBWfvMJEhd0Vrk/pmTiGJVpAP7yYckUNo/d3qtd/3UIirdGXXt2DMTPhCb
	 /+cx6+LUTsf5g==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	rust-for-linux@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: [PATCH 2/2] docs: rust: improve main page introducing a "Code documentation" section
Date: Sun, 18 Aug 2024 16:12:00 +0200
Message-ID: <20240818141200.386899-2-ojeda@kernel.org>
In-Reply-To: <20240818141200.386899-1-ojeda@kernel.org>
References: <20240818141200.386899-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clean the "Rust" main page by introducing a 'Code documentation" section
to separate it from the rest of the text above.

In addition, introduce the "Rust code documentation" term, which may be
clearer than referring to a potentially unknown tool.

Furthermore, for the HTML case, homogenize both `rustdoc` and
non-`rustdoc` cases and use the term introduced above instead.

Then, always generate the pregenerated version part, since now there
is a section that is always generated and thus makes sense to do so.

Finally, finish the new section with a link to more details about the
Rust code documentation.

The intention is that:

  - The non-HTML case mentions the code documentation too, making it
    more prominent for readers of non-HTML docs.

  - Both HTML cases read more naturally.

  - The pregenerated version is always mentioned, since it is likely
    useful for readers of non-HTML docs.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Documentation/rust/general-information.rst |  2 ++
 Documentation/rust/index.rst               | 19 +++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/Documentation/rust/general-information.rst b/Documentation/rust/general-information.rst
index e174327ad361..357793f83c28 100644
--- a/Documentation/rust/general-information.rst
+++ b/Documentation/rust/general-information.rst
@@ -15,6 +15,8 @@ but not `std <https://doc.rust-lang.org/std/>`_. Crates for use in the
 kernel must opt into this behavior using the ``#![no_std]`` attribute.
 
 
+.. _rust_code_documentation:
+
 Code documentation
 ------------------
 
diff --git a/Documentation/rust/index.rst b/Documentation/rust/index.rst
index 5e51bfb248a4..55dcde9e9e7e 100644
--- a/Documentation/rust/index.rst
+++ b/Documentation/rust/index.rst
@@ -25,16 +25,27 @@ support is still in development/experimental, especially for certain kernel
 configurations.
 
 
+Code documentation
+------------------
+
+Given a kernel configuration, the kernel may generate Rust code documentation,
+i.e. HTML rendered by the ``rustdoc`` tool.
+
 .. only:: rustdoc and html
 
-	You can also browse `rustdoc documentation <rustdoc/kernel/index.html>`_.
+	This kernel documentation was built with `Rust code documentation
+	<rustdoc/kernel/index.html>`_.
 
 .. only:: not rustdoc and html
 
-	This documentation does not include rustdoc generated information.
-	A pregenerated version is provided at:
+	This kernel documentation was not built with Rust code documentation.
+
+A pregenerated version is provided at:
+
+	https://rust.docs.kernel.org
 
-		https://rust.docs.kernel.org
+Please see the :ref:`Code documentation <rust_code_documentation>` section for
+more details.
 
 .. toctree::
     :maxdepth: 1
-- 
2.46.0

