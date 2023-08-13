Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63EB9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B93C433C8;
	Sun, 13 Aug 2023 21:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962382;
	bh=MUmgrlAwWufSWeWUWj0Ex5Q6lW7QL6hPmoGGuN4BYak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yttRTc28dCzWCfIst/FwGogEQUWwS3Tt/IT2BRalL+/rR0Tc/6BHfPECsyrp2lvZF
	 h6isNJS3iMUqaQwAJaaFYbCFTg7Twt8ngEDZOjAwQNNFWYi4W0DSJ+gx8D40TN+DMs
	 ycM0e19uKTv87etXEIvB0NtH1a3MTtGuuA/TgqqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Palmer Dabbelt <palmer@rivosinc.com>,
	linux-hardening@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH 6.1 001/149] gcc-plugins: Reorganize gimple includes for GCC 13
Date: Sun, 13 Aug 2023 23:17:26 +0200
Message-ID: <20230813211718.802552390@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

commit e6a71160cc145e18ab45195abf89884112e02dfb upstream.

The gimple-iterator.h header must be included before gimple-fold.h
starting with GCC 13. Reorganize gimple headers to work for all GCC
versions.

Reported-by: Palmer Dabbelt <palmer@rivosinc.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Link: https://lore.kernel.org/all/20230113173033.4380-1-palmer@rivosinc.com/
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gcc-plugins/gcc-common.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/gcc-plugins/gcc-common.h
+++ b/scripts/gcc-plugins/gcc-common.h
@@ -71,7 +71,9 @@
 #include "varasm.h"
 #include "stor-layout.h"
 #include "internal-fn.h"
+#include "gimple.h"
 #include "gimple-expr.h"
+#include "gimple-iterator.h"
 #include "gimple-fold.h"
 #include "context.h"
 #include "tree-ssa-alias.h"
@@ -85,10 +87,8 @@
 #include "tree-eh.h"
 #include "stmt.h"
 #include "gimplify.h"
-#include "gimple.h"
 #include "tree-phinodes.h"
 #include "tree-cfg.h"
-#include "gimple-iterator.h"
 #include "gimple-ssa.h"
 #include "ssa-iterators.h"
 


