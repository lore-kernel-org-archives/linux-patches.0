Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6811F206F18;
	Tue,  8 Apr 2025 12:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114738; cv=none; b=nyLUKtfp2EjTob1LdHhQhTuA//A72UWrd4jfmehTLBnZYq4tvQhMsVGY1Ykeh/2v8X2Veyqe06ByiYr7X3ml+FeI/SwQYXjyI9pmWpKq2hV/BzQkmV4fT1Bsb91xDIOf0PZQaOBEqVi9u6uGkyLTHjBU2lMDMTb7T5m5kHKyBr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114738; c=relaxed/simple;
	bh=NZw8VKq7/cGWtoPAWsCPqfvuSbkN63KOiNp8Bys2Y+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwaRb7+yQmuP4Mlc4tOwf4VvOTHg3RgG64dj3x0lQbkdtuuv1cs/kV1jENuo4M99KbgdaL4jg7OSAhKVR4JbmVJnu6csOkzR4zuBc0FNCUNxOthy0lXhLfxtwbaOKCynFebiCJ3mdiAbAYu2QR8nkxJW6NoAO81o+gFA17uWdLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XO+CIYef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XO+CIYef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E352DC4CEE5;
	Tue,  8 Apr 2025 12:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114738;
	bh=NZw8VKq7/cGWtoPAWsCPqfvuSbkN63KOiNp8Bys2Y+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XO+CIYefSW1DF1bturc/9O6I/dHpw1f2XwMU8p0vmnxZTrCG5GwJdrYgDoySzKGSM
	 nO7KRomyodm4/HFAyObfOVmAgYhJ7Z0Q2uS5Z6llwvHCv0we4oGoCCJjDLxNYQTwGL
	 sg6gBhXyoAZf8JBGbAikAn7rDTKezduvC8J0QFpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 218/499] tools/x86: Fix linux/unaligned.h include path in lib/insn.c
Date: Tue,  8 Apr 2025 12:47:10 +0200
Message-ID: <20250408104856.643829895@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit fad07a5c0f07ad0884e1cb4362fe28c083b5b811 ]

tools/arch/x86/include/linux doesn't exist but building is working by
virtue of a -I. Building using bazel this fails. Use angle brackets to
include unaligned.h so there isn't an invalid relative include.

Fixes: 5f60d5f6bbc1 ("move asm/unaligned.h to linux/unaligned.h")
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Link: https://lore.kernel.org/r/20250225193600.90037-1-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/arch/x86/lib/insn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/arch/x86/lib/insn.c b/tools/arch/x86/lib/insn.c
index ab5cdc3337dac..e91d4c4e1c162 100644
--- a/tools/arch/x86/lib/insn.c
+++ b/tools/arch/x86/lib/insn.c
@@ -13,7 +13,7 @@
 #endif
 #include "../include/asm/inat.h" /* __ignore_sync_check__ */
 #include "../include/asm/insn.h" /* __ignore_sync_check__ */
-#include "../include/linux/unaligned.h" /* __ignore_sync_check__ */
+#include <linux/unaligned.h> /* __ignore_sync_check__ */
 
 #include <linux/errno.h>
 #include <linux/kconfig.h>
-- 
2.39.5



