Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA082D978A;
	Wed,  4 Feb 2026 15:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218812; cv=none; b=ssfhnmFuVkd392taLEV2oSUG+C1/g5TqOHa7OmNe8aOpSK94okjX67ipH8yMyUe1K1qGhhWAVMv33u/gYuADtUwJRP31dKZdzXWuw4ydl+niCeflNEYhK9wJx7NoAKv95ZKT2CQEtUKnTfV2aejPjTqdOhvV8CmPDgPQ6FsG02M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218812; c=relaxed/simple;
	bh=uynJEcHdUC2SlE8AcJnfPvOxWKUrA5tIlZ58XKOsxBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrjS4Ok1mOglPrc0GIhpHTb5/H+sYT3SOk+hVmnXn+ZavWxMla8nqpKhfLHXZLveTmN8+0xnh+f11fp7iK0Vq0NIBKRnJbmai4QcETXBBdK13C+q0mynQ3kJPj0JklHpij04v3Jfn0F8wJQp7f084vaFMCg9jn5xZfiwPqcd12o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLMc8SVQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLMc8SVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D422C4CEF7;
	Wed,  4 Feb 2026 15:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218811;
	bh=uynJEcHdUC2SlE8AcJnfPvOxWKUrA5tIlZ58XKOsxBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLMc8SVQN/jpiF1wWcEtL6G/w/ArQgRMKHzvYPOjb8P0NupLqLKBZwQ8p21MRE4L8
	 h42dWIeOh+3pXFkVictngXf+pUEsXMVbiOcVGqM5pVvkhayK8AmqWVfP34mlyir0iL
	 W9Nil0LBdof6qM7KzEJndUpEYWCb7r5hriWp0kOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Nicolas Schier <nsc@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alyssa Ross <hi@alyssa.is>
Subject: [PATCH 6.12 68/87] rust: kbuild: support `-Cjump-tables=n` for Rust 1.93.0
Date: Wed,  4 Feb 2026 15:41:06 +0100
Message-ID: <20260204143849.364553828@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 789521b4717fd6bd85164ba5c131f621a79c9736 upstream.

Rust 1.93.0 (expected 2026-01-22) is stabilizing `-Zno-jump-tables`
[1][2] as `-Cjump-tables=n` [3].

Without this change, one would eventually see:

      RUSTC L rust/core.o
    error: unknown unstable option: `no-jump-tables`

Thus support the upcoming version.

Link: https://github.com/rust-lang/rust/issues/116592 [1]
Link: https://github.com/rust-lang/rust/pull/105812 [2]
Link: https://github.com/rust-lang/rust/pull/145974 [3]
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Acked-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/20251101094011.1024534-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Alyssa Ross <hi@alyssa.is>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -109,7 +109,7 @@ ifeq ($(CONFIG_X86_KERNEL_IBT),y)
 #   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=104816
 #
 KBUILD_CFLAGS += $(call cc-option,-fcf-protection=branch -fno-jump-tables)
-KBUILD_RUSTFLAGS += -Zcf-protection=branch -Zno-jump-tables
+KBUILD_RUSTFLAGS += -Zcf-protection=branch $(if $(call rustc-min-version,109300),-Cjump-tables=n,-Zno-jump-tables)
 else
 KBUILD_CFLAGS += $(call cc-option,-fcf-protection=none)
 endif


