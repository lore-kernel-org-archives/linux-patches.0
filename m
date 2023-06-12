Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C2A1951F
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAF5C433EF;
	Mon, 12 Jun 2023 10:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565970;
	bh=c7IlnrlA2Yxrp30Q52gHwzxuRfWVGZqbiKzCiQOiR2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sf7HRTUs5GwdIZs8AAc8eLnpCJ9paRc9cjAxONEWnWWkFhuWXq3Ww4IN1aljGWEWb
	 5dYri3HX7LPzSGhG54xyCzadPqQ7Ws1J9I1xqBrJyQrWClfJ+NKCq83gIItoxkzWba
	 wuGBnZ7haYYmwZPoaA+DW83qxXLAzNxM0DnXIZ/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Palmer Dabbelt <palmer@rivosinc.com>,
	linux-hardening@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	Paul Barker <paul.barker@sancloud.com>
Subject: [PATCH 5.10 02/68] gcc-plugins: Reorganize gimple includes for GCC 13
Date: Mon, 12 Jun 2023 12:25:54 +0200
Message-ID: <20230612101658.540867935@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101658.437327280@linuxfoundation.org>
References: <20230612101658.437327280@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

mainline commit: e6a71160cc145e18ab45195abf89884112e02dfb

The gimple-iterator.h header must be included before gimple-fold.h
starting with GCC 13. Reorganize gimple headers to work for all GCC
versions.

Reported-by: Palmer Dabbelt <palmer@rivosinc.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Link: https://lore.kernel.org/all/20230113173033.4380-1-palmer@rivosinc.com/
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
[ Modified to handle differences in other includes and conditional compilation in the 5.10.y tree. ]
Signed-off-by: Paul Barker <paul.barker@sancloud.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gcc-plugins/gcc-common.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/scripts/gcc-plugins/gcc-common.h
+++ b/scripts/gcc-plugins/gcc-common.h
@@ -108,7 +108,13 @@
 #include "varasm.h"
 #include "stor-layout.h"
 #include "internal-fn.h"
+#endif
+
+#include "gimple.h"
+
+#if BUILDING_GCC_VERSION >= 4009
 #include "gimple-expr.h"
+#include "gimple-iterator.h"
 #include "gimple-fold.h"
 #include "context.h"
 #include "tree-ssa-alias.h"
@@ -124,13 +130,10 @@
 #include "gimplify.h"
 #endif
 
-#include "gimple.h"
-
 #if BUILDING_GCC_VERSION >= 4009
 #include "tree-ssa-operands.h"
 #include "tree-phinodes.h"
 #include "tree-cfg.h"
-#include "gimple-iterator.h"
 #include "gimple-ssa.h"
 #include "ssa-iterators.h"
 #endif


