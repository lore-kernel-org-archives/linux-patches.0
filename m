Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D9E14A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwVcvdVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41DFC433C7;
	Mon, 23 Oct 2023 11:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059642;
	bh=HIB4hfIzPw92Q0R5HZdWSxd+jQZN+wF90wZ8EqEgW50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwVcvdVk6CJZjbDl+zRlKlqdzKouJ5atwB/OTK2Bsd6WdXvz755rC+2df4Z9lketi
	 yBlDaGT2LrpNTrhptCIJsQmppYrz3x7Wa9t/uwB6XAaBbL4P8wyb78tGT7r4Q9YO1X
	 N/v41VT+yfsqGb4OuSef6HEYxCqk7Hmq1t4UxB1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.5 238/241] kbuild: remove old Rust docs output path
Date: Mon, 23 Oct 2023 12:57:04 +0200
Message-ID: <20231023104839.676054166@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 1db773da58df20772dcc037a47163ce472d39c4d upstream.

The Rust code documentation output path moved from `rust/doc` to
`Documentation/output/rust/rustdoc`. The `make cleandocs` target
takes care of cleaning it now since it is integrated with the rest
of the documentation.

Thus remove the old reference.

Fixes: 48fadf440075 ("docs: Move rustdoc output, cross-reference it")
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
Link: https://lore.kernel.org/r/20231018160145.1017340-2-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -1595,7 +1595,7 @@ endif
 # Directories & files removed with 'make clean'
 CLEAN_FILES += include/ksym vmlinux.symvers modules-only.symvers \
 	       modules.builtin modules.builtin.modinfo modules.nsdeps \
-	       compile_commands.json .thinlto-cache rust/test rust/doc \
+	       compile_commands.json .thinlto-cache rust/test \
 	       rust-project.json .vmlinux.objs .vmlinux.export.c
 
 # Directories & files removed with 'make mrproper'


