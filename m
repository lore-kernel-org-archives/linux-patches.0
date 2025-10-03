Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AE429BDB5;
	Fri,  3 Oct 2025 16:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507664; cv=none; b=kgxIJEHnX1KbqTYu2iGJEaW083CJbSovELtQC6+enYi0eWnAQy+rei1swlPM2xm0KfO4VUoww+7ZKS+A6TEcbCGh3Ic+B3cEVJmqAeHYgj48OJTerq+Wm3mteGjJKexthE9qBKS3wKvHfcDepnd59AKUVcolzeJFdnbxxy7f9i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507664; c=relaxed/simple;
	bh=wLbfskF9ilofgWRa85Vq/NfnP8zYoBMT2HhU6yIf10Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCEQew11Krfe4khhPVo9hpX4s6HPV/4/sQiCGb0DCHa03lh3mJwKYbys9+BVQNP1Y5MkUA7b4fofXaQq5XOQOaYzIH/E3kFaFdxazy3IdIc0Jt8F8Ma8SNHFUQ2Odwy7FYaxIK1OSsXW+g/E/yNoWHLYoZpXCeE36uxdWFD/7Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2y0I7u3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2y0I7u3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707D6C4CEF5;
	Fri,  3 Oct 2025 16:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507663;
	bh=wLbfskF9ilofgWRa85Vq/NfnP8zYoBMT2HhU6yIf10Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2y0I7u3+ZwkvN1tNX1TIOPAOMy2q82kMOM2hDEcfJNgGzQ63SNE8CwiZJzIijwnN
	 UOlGzEwIcljvQ9v2/R2O7b84rESKEbIY13dJK3hBevsyRp8tyqjIUETqEnXGpY9oOe
	 0SOiSk01YAhlQiYoNvnlr3eB4PM1b65J4WeCMyp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Fore <csfore@posteo.net>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.16 02/14] gcc-plugins: Remove TODO_verify_il for GCC >= 16
Date: Fri,  3 Oct 2025 18:05:36 +0200
Message-ID: <20251003160352.783394369@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251003160352.713189598@linuxfoundation.org>
References: <20251003160352.713189598@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

commit a40282dd3c484e6c882e93f4680e0a3ef3814453 upstream.

GCC now runs TODO_verify_il automatically[1], so it is no longer exposed to
plugins. Only use the flag on GCC < 16.

Link: https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=9739ae9384dd7cd3bb1c7683d6b80b7a9116eaf8 [1]
Suggested-by: Christopher Fore <csfore@posteo.net>
Link: https://lore.kernel.org/r/20250920234519.work.915-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gcc-plugins/gcc-common.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/scripts/gcc-plugins/gcc-common.h
+++ b/scripts/gcc-plugins/gcc-common.h
@@ -173,10 +173,17 @@ static inline opt_pass *get_pass_for_id(
 	return g->get_passes()->get_pass_for_id(id);
 }
 
+#if BUILDING_GCC_VERSION < 16000
 #define TODO_verify_ssa TODO_verify_il
 #define TODO_verify_flow TODO_verify_il
 #define TODO_verify_stmts TODO_verify_il
 #define TODO_verify_rtl_sharing TODO_verify_il
+#else
+#define TODO_verify_ssa 0
+#define TODO_verify_flow 0
+#define TODO_verify_stmts 0
+#define TODO_verify_rtl_sharing 0
+#endif
 
 #define INSN_DELETED_P(insn) (insn)->deleted()
 


