Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972EE8F66;
	Sun, 18 Aug 2024 14:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723990336; cv=none; b=ZUgsZWyLCBl6I9JB1xAdVj73nCe6y6P4pOpvWokOKpeq7ztv224doevanjOPCd9H8bMMFc4XrN9pjDGZ3odkozXN6Y5iRoH8ZaWoBETGf47pl705m5RGcTeOoNf3KFVUsuOwK0hFXFD9w1QIe4QkR96NmRvOwQXwLYonEAs5d7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723990336; c=relaxed/simple;
	bh=Qz+yNv/sbLh3s6hFYGhJd0002JWVp9ZyYnfE7jmmIM0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MZH7MDDqbg6PyYkbjKviu6/+2U544ZC+qcqNauhbNL6sjjeLFpOTSjmJaNFR1xO/+y1HUxLWCzva/ewTqtx8U2/SWHmDTF9YP1z2V4G8T+dmIfbLBJSDO/XBb6HceokEEpaMjg9Hn01TpJ3rQ9cQzQxXLWTR3a/SrZAmVgJ5H3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b/RgDozU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b/RgDozU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680B5C32786;
	Sun, 18 Aug 2024 14:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723990335;
	bh=Qz+yNv/sbLh3s6hFYGhJd0002JWVp9ZyYnfE7jmmIM0=;
	h=From:To:Cc:Subject:Date:From;
	b=b/RgDozUyt6LKnGWQ4oo4AyQ0/fYW0K2vMskFsTYluqlnTTTL65VhOR21C9KPvwOl
	 TLxj6aYIIzlSN+gITD/3jBb+lHT/IavyzigUy+wPJwLtBgsEaJvAg39v6SX1ZwQz2i
	 dhf3RPQMCoB8A4/QoPGUcCXPBtYuHSlsFmgtv2QY8yP2oCYVNZ0qFlW6QC0B++R4rH
	 aMV18ckrZJbZY/5lTPNhDO4T83ysVOeeFLQlS6GYuB9YHvuF4T/G1vSnaErNylzhRc
	 Ke3khe042cFbJ4q4oWri7VMuGpIZMZdPcwvpKGZ6D8j9XPfLo/lx3CE+tAaA1qp1H/
	 GUwk0/FVAuP8A==
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
Subject: [PATCH 1/2] docs: rust: link to https://rust.docs.kernel.org
Date: Sun, 18 Aug 2024 16:11:59 +0200
Message-ID: <20240818141200.386899-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Rust code documentation (i.e. `rustdoc`-generated docs) is now
available at:

    https://rust.docs.kernel.org

Thus document it and remove the `TODO` line.

The generation uses a particular kernel configuration, based on x86_64,
which may get tweaked over time. Older tags, and how they are generated,
may also change in the future. We may consider freezing them at some
point, but for the moment, the content should not be considered immutable.

Thanks Konstantin for the support setting it up!

Cc: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Documentation/rust/general-information.rst | 13 ++++++++++---
 Documentation/rust/index.rst               |  3 +++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/Documentation/rust/general-information.rst b/Documentation/rust/general-information.rst
index e3f388ef4ee4..e174327ad361 100644
--- a/Documentation/rust/general-information.rst
+++ b/Documentation/rust/general-information.rst
@@ -22,10 +22,17 @@ Rust kernel code is documented using ``rustdoc``, its built-in documentation
 generator.
 
 The generated HTML docs include integrated search, linked items (e.g. types,
-functions, constants), source code, etc. They may be read at (TODO: link when
-in mainline and generated alongside the rest of the documentation):
+functions, constants), source code, etc. They may be read at:
 
-	http://kernel.org/
+	https://rust.docs.kernel.org
+
+For linux-next, please see:
+
+	https://rust.docs.kernel.org/next/
+
+There are also tags for each main release, e.g.:
+
+	https://rust.docs.kernel.org/6.10/
 
 The docs can also be easily generated and read locally. This is quite fast
 (same order as compiling the code itself) and no special tools or environment
diff --git a/Documentation/rust/index.rst b/Documentation/rust/index.rst
index 46d35bd395cf..5e51bfb248a4 100644
--- a/Documentation/rust/index.rst
+++ b/Documentation/rust/index.rst
@@ -32,6 +32,9 @@ configurations.
 .. only:: not rustdoc and html
 
 	This documentation does not include rustdoc generated information.
+	A pregenerated version is provided at:
+
+		https://rust.docs.kernel.org
 
 .. toctree::
     :maxdepth: 1

base-commit: 7c626ce4bae1ac14f60076d00eafe71af30450ba
-- 
2.46.0

