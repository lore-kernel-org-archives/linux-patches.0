Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5416AB9
	for <patches@lists.linux.dev>; Wed, 23 Mar 2022 23:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E40C340E8;
	Wed, 23 Mar 2022 23:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648076730;
	bh=qzPEvpcS85esCZPcARkrAunsQrdpfaijfD5tSNdHY2c=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=EqYGMlz8c1x9AGCLiCKb8neiuXhXMOpujg83gAHGUJD+eq2gx2yUa5banq856eT1B
	 dwGi956IEtibwqPXFkrT8iJq+Gqs01j0cK2FqfmIt8nqSlLKo2UWLWNH9SnuYt3X8n
	 P8jdzvHHQOR/NzTu0nu9SnzvIvpASEXqIPx84A6E=
Date: Wed, 23 Mar 2022 16:05:29 -0700
To: ndesaulniers@google.com,nathan@kernel.org,mst@redhat.com,corbet@lwn.net,bhelgaas@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 04/41] linux/types.h: remove unnecessary __bitwise__
Message-Id: <20220323230530.23E40C340E8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Bjorn Helgaas <bhelgaas@google.com>
Subject: linux/types.h: remove unnecessary __bitwise__

There are no users of "__bitwise__" except the definition of "__bitwise". 
Remove __bitwise__ and define __bitwise directly.

This is a follow-up to 05de97003c77 ("linux/types.h: enable endian checks
for all sparse builds").

[akpm@linux-foundation.org: change the tools/include/linux/types.h definition also]
Link: https://lkml.kernel.org/r/20220310220927.245704-2-helgaas@kernel.org
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/types.h  |    5 ++---
 tools/include/linux/types.h |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

--- a/include/uapi/linux/types.h~linux-typesh-remove-unnecessary-__bitwise__
+++ a/include/uapi/linux/types.h
@@ -20,11 +20,10 @@
  */
 
 #ifdef __CHECKER__
-#define __bitwise__ __attribute__((bitwise))
+#define __bitwise	__attribute__((bitwise))
 #else
-#define __bitwise__
+#define __bitwise
 #endif
-#define __bitwise __bitwise__
 
 typedef __u16 __bitwise __le16;
 typedef __u16 __bitwise __be16;
--- a/tools/include/linux/types.h~linux-typesh-remove-unnecessary-__bitwise__
+++ a/tools/include/linux/types.h
@@ -43,11 +43,10 @@ typedef __u8  u8;
 typedef __s8  s8;
 
 #ifdef __CHECKER__
-#define __bitwise__ __attribute__((bitwise))
+#define __bitwise	__attribute__((bitwise))
 #else
-#define __bitwise__
+#define __bitwise
 #endif
-#define __bitwise __bitwise__
 
 #define __force
 #define __user
_
