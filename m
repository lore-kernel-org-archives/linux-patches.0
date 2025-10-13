Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F632701B8;
	Mon, 13 Oct 2025 14:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366893; cv=none; b=aB2OieeZobDbtD1IrlCvx0y0w/p9IkNHcdtOzPsuw/qz/pp54xlN96LI/+76BFmpS0s/dNeRL7+a1aY7FnjuzyHXECO7w4ySG/t1YykEO5V9/z8Nb+iSdAO4z6D4UkpYlxg+a0NmJwC8bOtLnxP3AGMF4WBE29x0b5rk2rqMlOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366893; c=relaxed/simple;
	bh=g1h7RDKpVsjyi5DiLVamPHph3EbplvhcTjwe6GV/7zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=II1cc3zfGKkuo/cedZRPd2HRc8QtQlLg3RqRVU8yOiBL51pNNuhsLXRsM9IjzURDKdpt2oNf3FKRn6jGfgxyi0UjQSLHamXXRbbC/yXzlLW4KMk9AP4BlwBAmdckQ/Ws8EgAfXhERTjlhKT8jqpBq/7gjkCiNMyG6q4uSv+8gVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvFiMGKz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvFiMGKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B61C4CEFE;
	Mon, 13 Oct 2025 14:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760366893;
	bh=g1h7RDKpVsjyi5DiLVamPHph3EbplvhcTjwe6GV/7zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvFiMGKzxetEgDngc9DkLg1wmJ8Tm0q8xuWDiu2FJWVL1rZ2DTCPYIJ7Vl818BSW0
	 wYTasf9KQwrdWCTtZFL1An1p+8pWxzdSki3hhaBOPGsxWYBePGr4b6xXC9G5VVtoaM
	 I+UOnS87GpK+ewCqsmihGz18O7oIczS2jHoytxa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Fore <csfore@posteo.net>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.1 009/196] gcc-plugins: Remove TODO_verify_il for GCC >= 16
Date: Mon, 13 Oct 2025 16:43:02 +0200
Message-ID: <20251013144314.899397365@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -196,10 +196,17 @@ inline bool is_a_helper<const gassign *>
 }
 #endif
 
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
 


