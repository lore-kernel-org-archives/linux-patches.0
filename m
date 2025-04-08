Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4676263C90;
	Tue,  8 Apr 2025 11:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111641; cv=none; b=iQGVAeAjauNRKmpiJ0XC8VtBrmQAC/RUcYkUvpGwznwkVQTeLRHgTcO39GG/L1bgJv5OFpROh9D1S+r9z/tkBdCfSpCg2lJZ/pJV1+MMDw3upippJH9SWyNg0VmLAn/UNaowyAoUcXFJ9wYYXgdCf6COSrgPgxQr6b0NyOryYMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111641; c=relaxed/simple;
	bh=v9G0gbZzbCuBhlpfT0OxHRy4TiJRCghwuuPUBqDKhY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6SdhmCQRBVxLMqMKAx2pTS2vdkps6oQ4EDxc10pNtUeFdql6ldMap3TlQxg4m5qz1T2pcSFYiYHq5VLvoRZXXFrlWvUx20c5lSDtu4A3rfa7sYZfX92n3G/Yy0zDElPQQ9D9wf6gkyRbUlq/7l1uXAAxqiRVBzKSarr4fDDQbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jEMw+Da7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jEMw+Da7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5FEC4CEE5;
	Tue,  8 Apr 2025 11:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111641;
	bh=v9G0gbZzbCuBhlpfT0OxHRy4TiJRCghwuuPUBqDKhY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jEMw+Da7nHZuuoryisqXUp1+lpqb7J/NZk9cuRGXT6RsBpfbnYE9kVddSsr6r+Qzg
	 Mcvpv06wPrgFGPJyj/kVpBErXiCZ0dYwrNCpx6ipz5nKW1cj5uhPnm+48WAp0Py45/
	 T+JcKf62f2oaJlIs6nvU456fNhO43msWwr7/jLQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 468/731] tools/x86: Fix linux/unaligned.h include path in lib/insn.c
Date: Tue,  8 Apr 2025 12:46:05 +0200
Message-ID: <20250408104925.163717713@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



