Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FD035962;
	Fri,  3 Oct 2025 16:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507701; cv=none; b=XD3x/8ptjG3dpGMvE0SW4ELvBgNmxmb8/NByg6blUtx6iCX4VobEsntmGBLYCCGu7MMjOal8Yf+8b3HyuM9wkuUkDYEBsaWSDky5o3janybeVXHkmRdH4iDOD005dyVXgrLExO1bGjdLimWA+CvpHA/69haJ6PI0tzN5pSTgInM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507701; c=relaxed/simple;
	bh=oa1/KGFHapj1AKgPynRJqGsoFaFnKf/24G/DohVYbVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKxaW+x7zdugPxwwwENRjXHVpCyVmPspdkX9C3ogo7xH9Q9HLBIwk6ZPyqdC8vvbrNdUJlW8AersHPxYvexqoChrng+DBaplPw3pGb2q0J0B0ZrhfGvxgYxz/luEOp/Wr34tH9TqEC5uNZmjntkNcJQmbutmGfksNYcyz/LPn10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUvwAsNm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUvwAsNm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7F1C4CEF5;
	Fri,  3 Oct 2025 16:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507700;
	bh=oa1/KGFHapj1AKgPynRJqGsoFaFnKf/24G/DohVYbVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUvwAsNm5QBPwOAv5r6m8XsioXj0BqKA14S1JK723EgV5LxpCEmSSbPROy1iXAvTr
	 tKEXm9+ZqNGMnsPpysPtytjGBy4VSkT5oKDYQnUNJ4KPIOm/gdbfPP4D3koL943nbe
	 DRjrXRJsPUYEI4zRTgiLaHsbmN3WEFKvYMradBZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Fore <csfore@posteo.net>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.12 02/10] gcc-plugins: Remove TODO_verify_il for GCC >= 16
Date: Fri,  3 Oct 2025 18:05:49 +0200
Message-ID: <20251003160338.533978422@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251003160338.463688162@linuxfoundation.org>
References: <20251003160338.463688162@linuxfoundation.org>
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
@@ -191,10 +191,17 @@ inline bool is_a_helper<const gassign *>
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
 


