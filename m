Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8623E1AF0BB;
	Mon, 10 Mar 2025 17:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627110; cv=none; b=Q7pptshN6e3MXOablk18c4CGkbmOczP5B3jlk07G8InrcRzOIRnB21/1RInOocctj5TI1/jOb9BClKnQ3qPYGIEpqrwdIV4GUFpLjrbExXdiezKjpZHnCb1Tyx/mXyPAsO9TJANB6MXPNh5JfVOMfaeiYLLQ/bJQaE7l0qPeFIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627110; c=relaxed/simple;
	bh=YiBo7Hk9XqA/bdQdwnLpZPoYKJNb0Hyo9UgnRBwW3iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYa3j4JjVj5g1eYGOweRFcUVQB2cTJ5mmM3mUwMZ80G+XaOFAlNvxheHmif1MoX/zA9pibsgCQGg+L4FKMc9rWlLGBuzLM/15U0od883rtqTqsyvxww+C+8pKbL7Arq1lzG6mr1vjmvvlGdJKnbTNjlwxsVsBxUoztGN60D9Fz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RwxwUkHZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RwxwUkHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FFEC4CEE5;
	Mon, 10 Mar 2025 17:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627110;
	bh=YiBo7Hk9XqA/bdQdwnLpZPoYKJNb0Hyo9UgnRBwW3iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RwxwUkHZSTj6UmlJUWDQUFhhc/qNpF1QzInzvalR8GDoBKhQsNqtAaq2SKbKF3Tjs
	 wGBeLYQKLgclFnY1t2MmQ6hVjzJuO2k+57k8ozZuOZcrHYwDzejT1Qows7zXyTg3Yo
	 EGsJm55aKAyBeH5qd5fzgufKwRPzUXZrYSGRSaM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Gross <tmgross@umich.edu>,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 017/269] rust: enable `clippy::unnecessary_safety_doc` lint
Date: Mon, 10 Mar 2025 18:02:50 +0100
Message-ID: <20250310170458.394932131@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 23f42dc054b3c550373eae0c9ae97f1ce1501e0a upstream.

In Rust 1.67.0, Clippy added the `unnecessary_safety_doc` lint [1],
which is similar to `unnecessary_safety_comment`, but for `# Safety`
sections, i.e. safety preconditions in the documentation.

This is something that should not happen with our coding guidelines in
mind. Thus enable the lint to have it machine-checked.

Link: https://rust-lang.github.io/rust-clippy/master/index.html#/unnecessary_safety_doc [1]
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-7-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/Makefile
+++ b/Makefile
@@ -460,6 +460,7 @@ export rust_common_flags := --edition=20
 			    -Wclippy::no_mangle_with_rust_abi \
 			    -Wclippy::undocumented_unsafe_blocks \
 			    -Wclippy::unnecessary_safety_comment \
+			    -Wclippy::unnecessary_safety_doc \
 			    -Wrustdoc::missing_crate_level_docs
 
 KBUILD_HOSTCFLAGS   := $(KBUILD_USERHOSTCFLAGS) $(HOST_LFS_CFLAGS) \


