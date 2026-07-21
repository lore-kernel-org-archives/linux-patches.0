Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D1346C4AE;
	Tue, 21 Jul 2026 15:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649425; cv=none; b=WDr6v8+0e7rN+r8ITopqjv058SrzMU4Eza5j299JUHLuO+/gacsxe3mk9bmny4JVoDgfVUrPwXNvMPryuX4PKkvxx1OZPuYF67ZOo86oWm6oYi/3ggg7AsHLcloCKANiVwtoK+7DaitiJOZ3G+NG1cC9nhx1Vn7/UyJGFQX/vJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649425; c=relaxed/simple;
	bh=O8QeVon+k51no9n3wwJ579+nM0qKDCxRhLEBSXwKGPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRAX3LQNR3RPSjlJdcNpE/Zr6UPtyKEsDtyHHX/JwNxMNRFpRy2EtZf6akKkzi+hW6D1V+QiPE6yOnSbfifebUM5SS5OgWMQYKrqP7M6JHOo8/9tZ7Ttp5rTVHcfYdHJgF9RqyYCnu9DLeZgw5sfVO07kzTMaoslkiyMT9OL3Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bn55EyNL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bn55EyNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59F51F00A3A;
	Tue, 21 Jul 2026 15:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649424;
	bh=nm3nJrMFe9kRjnMbMGaTgc0ex6TfqeDlVpPJZpwHkZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bn55EyNLqOWBPn1UYpV2JQ0zZKrfrPY+qTCKTg1InNUr+t7zIAtX2ZsemV7crqaGL
	 N3sxiV06pRbZpuQajJBaR7H36dUzCJGck/8kxh3x+aiwHXv0TOjPQDpmnlLh5mg2aT
	 DEz55eNIPp6bFCj7s+v/LCbdkvsCPw34xpdqt/q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Schier <nsc@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0573/2077] rust: kbuild: show the right `quiet_cmd_rustc_procmacrolibrary`
Date: Tue, 21 Jul 2026 17:04:06 +0200
Message-ID: <20260721152606.322486987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit 70a8d5ada9fabf4a34732b718f9c992195eed2ea ]

When Clippy is skipped, `RUSTC` should be shown in `quiet` instead of
`CLIPPY` to be accurate and to avoid confusion.

Thus do so, matching what we do in `quiet_cmd_rustc_library`.

Fixes: 7dbe46c0b11d ("rust: kbuild: add proc macro library support")
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/20260608141439.182634-3-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/Makefile b/rust/Makefile
index b9e9f512cec314..bec9726f256ce9 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -517,7 +517,7 @@ $(obj)/exports_bindings_generated.h: $(obj)/bindings.o FORCE
 $(obj)/exports_kernel_generated.h: $(obj)/kernel.o FORCE
 	$(call if_changed,exports)
 
-quiet_cmd_rustc_procmacrolibrary = $(RUSTC_OR_CLIPPY_QUIET) PL $@
+quiet_cmd_rustc_procmacrolibrary = $(if $(skip_clippy),RUSTC,$(RUSTC_OR_CLIPPY_QUIET)) PL $@
       cmd_rustc_procmacrolibrary = \
 	$(if $(skip_clippy),$(RUSTC),$(RUSTC_OR_CLIPPY)) \
 		$(filter-out $(skip_flags),$(rust_common_flags) $(rustc_target_flags)) \
-- 
2.53.0



