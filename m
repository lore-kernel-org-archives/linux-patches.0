Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4913141C302;
	Thu, 16 Jul 2026 13:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208993; cv=none; b=MHlRjXB30YqEqqmGh4tpsriep3r7g6PdemwqkpxS2uaKBtw85uavhy4hDVxR1585QK5SwebUHsVIwXiPNxuQiNWBT7y1agv7l953vl1x9qy2uMxGc2sxcQQ5xck5ouERBQNAbJQzF4NOu8cEnfYyrX/auO+Xk6NC3t7Fws95ryU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208993; c=relaxed/simple;
	bh=xTWO/DJpB8jaP4xPHNqMgS5YxXAtqyUm+nC2yFqwo9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYygpJb7a7efwVa3e9W/G9GuF5ETTbOFEZCdYa47eL/eOJXSvPQVIdC85waezl4V29CfnNsPtYEfvkpPu6NAZTCFHnUukTpCKqr8/9MgPuZVZQc6qzhsfjIVwLWb9f0QvuBqFB1tOZswRWXKHsW9EF2qOp17kHOJfGJO5/IoTKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=whq8VB6J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="whq8VB6J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6671F000E9;
	Thu, 16 Jul 2026 13:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784208992;
	bh=IGUk/4MNVi28KF0qi2fcF8PRmJfIfMoa0JICN49H5hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=whq8VB6JXHnjbCkct3fnh2VlrdURh4qhYJpMjxVz6MZy+KIvFbiHD/kXE0vrd83wc
	 6neWPs24YyG61VZUWzxlXTmUlg/CxqR4J51HA4JSmydbjTokmWbzDlU68LhApdDqSC
	 2HOiE9dJQspf29m04iCx903Hs+KaR0WdlXIK3zzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.1 017/518] rust: kasan: KASAN+RUST requires clang
Date: Thu, 16 Jul 2026 15:24:45 +0200
Message-ID: <20260716133048.154850103@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

commit 5b271543d0f08e9733d4732721e960e285f6448f upstream.

Kernel KASAN involves passing various llvm/gcc specific arguments to
the C and Rust compiler. Since these arguments differ between llvm and
gcc, it's not safe to mix an llvm-based rustc with a gcc build when
kasan is enabled.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Cc: stable@vger.kernel.org
Fixes: e3117404b411 ("kbuild: rust: Enable KASAN support")
Link: https://patch.msgid.link/20260408-kasan-rust-sw-tags-v3-1-e07964d14363@google.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2198,6 +2198,7 @@ config RUST
 	depends on !DEBUG_INFO_BTF || (PAHOLE_HAS_LANG_EXCLUDE && !LTO)
 	depends on !CFI || HAVE_CFI_ICALL_NORMALIZE_INTEGERS_RUSTC
 	select CFI_ICALL_NORMALIZE_INTEGERS if CFI
+	depends on !KASAN || CC_IS_CLANG
 	depends on !KASAN_SW_TAGS
 	help
 	  Enables Rust support in the kernel.


