Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218D94C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7150EC433D6;
	Mon, 14 Nov 2022 13:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430818;
	bh=QzDoCeRUTCwNPJcyLxwgsBADC45GJK/Z22LEz49Wp6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cILkgi2zvCnasaFVGBjH/boSCuUDPIxRC5BdD+LREOCQ9JKsbnmpnRNN//YlusfXJ
	 b8awqbdDwP8Y5B3hKbwX3ik6r7oKtdLv6LwdAwx8nyjUb/Acl+WbYpLysfiaz8Zk8I
	 ZRGNTdASGcB9RZw8RgfTbfnyruY5U8Oq7xLDhMJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anders Roxell <anders.roxell@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 129/131] marvell: octeontx2: build error: unknown type name u64
Date: Mon, 14 Nov 2022 13:46:38 +0100
Message-Id: <20221114124454.157191211@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anders Roxell <anders.roxell@linaro.org>

commit 6312d52838b21f5c4a5afa1269a00df4364fd354 upstream.

Building an allmodconfig kernel arm64 kernel, the following build error
shows up:

In file included from drivers/crypto/marvell/octeontx2/cn10k_cpt.c:4:
include/linux/soc/marvell/octeontx2/asm.h:38:15: error: unknown type name 'u64'
   38 | static inline u64 otx2_atomic64_fetch_add(u64 incr, u64 *ptr)
      |               ^~~

Include linux/types.h in asm.h so the compiler knows what the type
'u64' are.

Fixes: af3826db74d1 ("octeontx2-pf: Use hardware register for CQE count")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Link: https://lore.kernel.org/r/20211013135743.3826594-1-anders.roxell@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/soc/marvell/octeontx2/asm.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/soc/marvell/octeontx2/asm.h
+++ b/include/linux/soc/marvell/octeontx2/asm.h
@@ -5,6 +5,7 @@
 #ifndef __SOC_OTX2_ASM_H
 #define __SOC_OTX2_ASM_H
 
+#include <linux/types.h>
 #if defined(CONFIG_ARM64)
 /*
  * otx2_lmt_flush is used for LMT store operation.


