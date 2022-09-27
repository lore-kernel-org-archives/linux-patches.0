Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D710780C
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 13:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9F4C4347C;
	Tue, 27 Sep 2022 13:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1664284652;
	bh=EuqxGNkNupOc1q+c+aGyg7u/0Q2OwWn5PxUUFbdrTHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hS9UCUq4hozQ5ISCtbVU6IO4HTsXIKLenBOyX3W2hGB4Pja4aBEki3tcc/DoaWZb4
	 Az+A5g1NP8wIcUV1cCSqzyk5heOZMlTd5gnxyNkNR4K2AgDlVVAbvVoplbrY+a+gyE
	 SwhI3UcKiSh4hQbzSQlkdvzVgWDUuoJ4opT1MlTgNSCYYvtdrB6qK16cR8tDypuRcx
	 a7PxQpaCqar0Gt7NjzFtsyNNfXHIIzagh3Rfz6Y5DkB0ZNBL4B/uR2BhPSA4oM4OSa
	 ZFkKe7+upViVRdNOnCVRH+5PJMo6AF1Yl/x/xj0qnfshw5TwZtiflM0qZsiHGHLx2S
	 em0OrD3/DrQuQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>
Subject: [PATCH v10 22/27] rust: add `.rustfmt.toml`
Date: Tue, 27 Sep 2022 15:14:53 +0200
Message-Id: <20220927131518.30000-23-ojeda@kernel.org>
In-Reply-To: <20220927131518.30000-1-ojeda@kernel.org>
References: <20220927131518.30000-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the configuration file for the `rustfmt` tool.

`rustfmt` is a tool for formatting Rust code according to style guidelines.
It is very commonly used across Rust projects.

The default configuration options are used.

Reviewed-by: Kees Cook <keescook@chromium.org>
Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
Co-developed-by: Wedson Almeida Filho <wedsonaf@google.com>
Signed-off-by: Wedson Almeida Filho <wedsonaf@google.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 .gitignore    |  1 +
 .rustfmt.toml | 12 ++++++++++++
 2 files changed, 13 insertions(+)
 create mode 100644 .rustfmt.toml

diff --git a/.gitignore b/.gitignore
index 80989914c97d..97e085d613a2 100644
--- a/.gitignore
+++ b/.gitignore
@@ -97,6 +97,7 @@ modules.order
 !.gitattributes
 !.gitignore
 !.mailmap
+!.rustfmt.toml
 
 #
 # Generated include files
diff --git a/.rustfmt.toml b/.rustfmt.toml
new file mode 100644
index 000000000000..3de5cc497465
--- /dev/null
+++ b/.rustfmt.toml
@@ -0,0 +1,12 @@
+edition = "2021"
+newline_style = "Unix"
+
+# Unstable options that help catching some mistakes in formatting and that we may want to enable
+# when they become stable.
+#
+# They are kept here since they are useful to run from time to time.
+#format_code_in_doc_comments = true
+#reorder_impl_items = true
+#comment_width = 100
+#wrap_comments = true
+#normalize_comments = true
-- 
2.37.3

