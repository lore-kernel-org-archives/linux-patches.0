Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6028288C;
	Fri, 16 Aug 2024 18:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723832138; cv=none; b=N+KUjvqz+LFLvu/Ma3sVLITfEZdN/9NiTp7khxteCuHR13ynHepN5scDLpW9PzRfDbKJH6QojZRy7VUEMGQrLkugV8aq/yw0s1IAOCJJA3QgEDgspYMrXTUh/DYJJQMwwN8IbUAuCHrk9m5Qf9cR/HIRNruUVUnD/CyLvB71nY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723832138; c=relaxed/simple;
	bh=YUt2/pe6iAs+TkYT8g42GYFWjweeJHYBiqNpeTfkS6A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mb06qtqfYSpjrrf/aaF7R8qQRA3lfFcEzaz3FYGiWGOcZ2ZyFvDOvUgS73u5NbDRk166mfGI5/tMhKw15itdwz1JV9lTcbUWkC1Hz4uNcnXXjqft+U9c1FurjcI1jkB1W2xvetgiuYtGZECN46iXLgGDzXhvH074xOzAZMXm9aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LelS2RTi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LelS2RTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAC4C32782;
	Fri, 16 Aug 2024 18:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723832137;
	bh=YUt2/pe6iAs+TkYT8g42GYFWjweeJHYBiqNpeTfkS6A=;
	h=From:To:Cc:Subject:Date:From;
	b=LelS2RTi1k6RhhtqjK28hT4t35xW3pAEw82mK1CW1aBULknwHg33a/iV2TGt+QD+R
	 BHTIJACdb5zA+o2Ip92hASf5hLn5XmC0hfhGV/Yx/uuhUVR12X8icoEfrA1FBXPCP7
	 dVXmVbWiDDEjh6cGabXhv6HbSJ4doJBKxLuV41kI0M2Xm07Oa8PDXgJDrLcsOrYipk
	 nyLckwsRs2swE/skSzMwyUk/nLm74Bu+9JIEFxBjnZgoYITcz2Opzm+bEAQmTva0r8
	 gzOKUZbKi+xF4T4Y7j2HnebIgrDWIaKTuu4n2TKcOgm5dkxeW17MiBnmtFPG7z0H41
	 wklIE06Ab2uXQ==
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
	=?UTF-8?q?Fabian=20Gr=C3=BCnbichler?= <debian@fabian.gruenbichler.email>
Subject: [PATCH] docs: rust: quick-start: add Debian Testing
Date: Fri, 16 Aug 2024 20:15:14 +0200
Message-ID: <20240816181514.45696-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Debian Testing is now also providing recent Rust releases (outside of
the freeze period), like Debian Unstable (Sid).

Thus add it to the list.

Cc: Fabian Grünbichler <debian@fabian.gruenbichler.email>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
Debian Testing is now providing a very recent Rust release (1.79), which
is good enough for us, and as far as I understand, it is the intention
to keep Debian Testing (outside the freeze period) close to the latest
release of Rust upstream. If that is correct, then we should add it to
the list. Thanks Fabian!

 Documentation/rust/quick-start.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/rust/quick-start.rst b/Documentation/rust/quick-start.rst
index d06a36106cd4..ed5af2b5339a 100644
--- a/Documentation/rust/quick-start.rst
+++ b/Documentation/rust/quick-start.rst
@@ -39,8 +39,8 @@ of the box, e.g.::
 Debian
 ******

-Debian Unstable (Sid), outside of the freeze period, provides recent Rust
-releases and thus it should generally work out of the box, e.g.::
+Debian Testing and Debian Unstable (Sid), outside of the freeze period, provide
+recent Rust releases and thus they should generally work out of the box, e.g.::

 	apt install rustc rust-src bindgen rustfmt rust-clippy


base-commit: 7c626ce4bae1ac14f60076d00eafe71af30450ba
--
2.46.0
