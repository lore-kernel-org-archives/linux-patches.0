Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B86E6FC5
	for <patches@lists.linux.dev>; Mon,  6 Mar 2023 19:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E811C433D2;
	Mon,  6 Mar 2023 19:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678130246;
	bh=zfeqXa4yi5h4NtK+t86GihYz4lj1WFK1jtkGq+VhM8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/ZzcVmFDSRLmhGNOZ3jMTfF9EjUyeRSOMxUp2b/rZU7YskmcuMFsJHQYEN3CCU91
	 vqkKjzKwT1gKJ0hInoylqpNPcPfmJUZNnjv3wSimz/psHY23Y/w8yu7eBMjRlFURUY
	 WsOwbO4YHwzX9B855A8rxjAIS/y3DtlWiYXkvzSFiUVdnOvvvrnrVDquAkIZy5TN3L
	 7V4xcyhIV6PM6dDJcLLCBoYvOZqF4TV5C0fFa7QrvEFu4p6x0zrkKqUXzK9yG2tYTb
	 XMCiCj+t49hfyB3ZFAKSrmzCdbIlxhC/jPLw1pUoTUR3DsHPzMXwz5jHmzn96R+VsH
	 3YRBJhdO8zWRw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 2/2] docs: programming-language: add Rust programming language section
Date: Mon,  6 Mar 2023 20:17:12 +0100
Message-Id: <20230306191712.230658-2-ojeda@kernel.org>
In-Reply-To: <20230306191712.230658-1-ojeda@kernel.org>
References: <20230306191712.230658-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Following the C text in the file, add a mention about the Rust
programming language, the currently supported compiler and
the edition used (similar to the "dialect" mention for C).

Similarly, add a mention about the unstable features used (similar
to the "extensions" mentions for C).

In addition, add some links to complement the information.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 .../process/programming-language.rst          | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/Documentation/process/programming-language.rst b/Documentation/process/programming-language.rst
index 10dc772671d8..bc56dee6d0bc 100644
--- a/Documentation/process/programming-language.rst
+++ b/Documentation/process/programming-language.rst
@@ -31,6 +31,20 @@ in order to feature detect which ones can be used and/or to shorten the code.
 
 Please refer to ``include/linux/compiler_attributes.h`` for more information.
 
+Rust
+----
+
+The kernel has experimental support for the Rust programming language
+[rust-language]_ under ``CONFIG_RUST``. It is compiled with ``rustc`` [rustc]_
+under ``--edition=2021`` [rust-editions]_. Editions are a way to introduce
+small changes to the language that are not backwards compatible.
+
+On top of that, some unstable features [rust-unstable-features]_ are used in
+the kernel. Unstable features may change in the future, thus it is an important
+goal to reach a point where only stable features are used.
+
+Please refer to Documentation/rust/index.rst for more information.
+
 .. [c-language] http://www.open-std.org/jtc1/sc22/wg14/www/standards
 .. [gcc] https://gcc.gnu.org
 .. [clang] https://clang.llvm.org
@@ -38,4 +52,7 @@ Please refer to ``include/linux/compiler_attributes.h`` for more information.
 .. [gnu-extensions] https://gcc.gnu.org/onlinedocs/gcc/C-Extensions.html
 .. [gcc-attribute-syntax] https://gcc.gnu.org/onlinedocs/gcc/Attribute-Syntax.html
 .. [n2049] http://www.open-std.org/jtc1/sc22/wg14/www/docs/n2049.pdf
-
+.. [rust-language] https://www.rust-lang.org
+.. [rustc] https://doc.rust-lang.org/rustc/
+.. [rust-editions] https://doc.rust-lang.org/edition-guide/editions/
+.. [rust-unstable-features] https://github.com/Rust-for-Linux/linux/issues/2
-- 
2.39.2

