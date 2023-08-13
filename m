Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A639443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47160C433C8;
	Sun, 13 Aug 2023 21:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962025;
	bh=tpfOpc5fjInSeYhRCSKyhk2jYzfs2VEeDrACHRpsV0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdCBhIYSKYZnrUM+u74hYWpLyiFxABkEdJW4PaV4o4M7ffevKFynDXZoIiPCsPxxu
	 K69JjZNCBqOwd4PyjjW+d2x+eRu30mt4Z5bmnxNyshOM8+lFAJ/Suy/hdB7AyqgNwE
	 IqrHqGlcV07jRPk+6+iGa8Eyo6NIp9rXPLG8+7Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinghao Jia <jinghao@linux.ibm.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	stable@kernel.org
Subject: [PATCH 6.4 085/206] x86/linkage: Fix typo of BUILD_VDSO in asm/linkage.h
Date: Sun, 13 Aug 2023 23:17:35 +0200
Message-ID: <20230813211727.509987866@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jinghao Jia <jinghao@linux.ibm.com>

commit 7324f74d39531262b8e362f228b46512e6bee632 upstream.

The BUILD_VDSO macro was incorrectly spelled as BULID_VDSO in
asm/linkage.h. This causes the !defined(BULID_VDSO) directive to always
evaluate to true.

Correct the spelling to BUILD_VDSO.

Fixes: bea75b33895f ("x86/Kconfig: Introduce function padding")
Signed-off-by: Jinghao Jia <jinghao@linux.ibm.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20230808182353.76218-1-jinghao@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/linkage.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/linkage.h b/arch/x86/include/asm/linkage.h
index 0953aa32a324..97a3de7892d3 100644
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -21,7 +21,7 @@
 #define FUNCTION_PADDING
 #endif
 
-#if (CONFIG_FUNCTION_ALIGNMENT > 8) && !defined(__DISABLE_EXPORTS) && !defined(BULID_VDSO)
+#if (CONFIG_FUNCTION_ALIGNMENT > 8) && !defined(__DISABLE_EXPORTS) && !defined(BUILD_VDSO)
 # define __FUNC_ALIGN		__ALIGN; FUNCTION_PADDING
 #else
 # define __FUNC_ALIGN		__ALIGN
-- 
2.41.0



