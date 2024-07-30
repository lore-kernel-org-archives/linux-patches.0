Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC05D189503;
	Tue, 30 Jul 2024 16:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356411; cv=none; b=gOlsENLoNPEdhtrMXK2Oi1lZ/GAJmViZzt0jwrgXMo50lifHE19gxfsAHsd6KkDk/STL2pi25uhJWAhygTYrqvtTwejYjVArJMrpHAlyYRUgPwPuWAreN00W5CxlwpRSQ7DeMI6/2OZ/EzEBiJdyxhF9AZMBdBSKv5tnTaGkURA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356411; c=relaxed/simple;
	bh=G/BEGf08i/6kyCRlRnVthOwKO7iwpbaSiMWKMadq/MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhxRq97cT1o4gfdb/lNJwdvcE51jXBo6gRHaiUqvQit5oxI0qFE9+56EMN/mlRbaH2RPdhJgMo7F4vVjj8xCfqZ9ESsPFx76AlYWzJDjQWqPzalB0WhEGm3Syu1ukp1bplm1HisWec9nkgQ+fVOlcOJK7S/O/akxB8pK9S83tv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxF6ehSs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxF6ehSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F558C32782;
	Tue, 30 Jul 2024 16:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356411;
	bh=G/BEGf08i/6kyCRlRnVthOwKO7iwpbaSiMWKMadq/MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GxF6ehSs8efBl9jcugeBKZB1AThS5czPDphOhz876dQabRmRB9ClmUu8nL8S6MIir
	 pdfJwLyWMXdEkkrLCOzOhKtear9yVMTZONce3lRJAm38+EJ1rUXXb2s/LKx4QDDzbv
	 OgvHVsyThde6mJkQfUXKTWXL5nAxuOhKISLKBrzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell Currey <ruscur@russell.cc>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 189/440] powerpc/pseries: Move plpks.h to include directory
Date: Tue, 30 Jul 2024 17:47:02 +0200
Message-ID: <20240730151623.255648651@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Russell Currey <ruscur@russell.cc>

[ Upstream commit 90b74e305d6b5a444b1283dd7ad1caf6acaa0340 ]

Move plpks.h from platforms/pseries/ to include/asm/. This is necessary
for later patches to make use of the PLPKS from code in other subsystems.

Signed-off-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230210080401.345462-15-ajd@linux.ibm.com
Stable-dep-of: 932bed412170 ("powerpc/kexec_file: fix cpus node update to FDT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../powerpc/{platforms/pseries => include/asm}/plpks.h | 10 +++++++---
 arch/powerpc/platforms/pseries/plpks.c                 |  3 +--
 2 files changed, 8 insertions(+), 5 deletions(-)
 rename arch/powerpc/{platforms/pseries => include/asm}/plpks.h (94%)

diff --git a/arch/powerpc/platforms/pseries/plpks.h b/arch/powerpc/include/asm/plpks.h
similarity index 94%
rename from arch/powerpc/platforms/pseries/plpks.h
rename to arch/powerpc/include/asm/plpks.h
index 07278a990c2df..44c3d93fb5e7d 100644
--- a/arch/powerpc/platforms/pseries/plpks.h
+++ b/arch/powerpc/include/asm/plpks.h
@@ -6,8 +6,10 @@
  * Platform keystore for pseries LPAR(PLPKS).
  */
 
-#ifndef _PSERIES_PLPKS_H
-#define _PSERIES_PLPKS_H
+#ifndef _ASM_POWERPC_PLPKS_H
+#define _ASM_POWERPC_PLPKS_H
+
+#ifdef CONFIG_PSERIES_PLPKS
 
 #include <linux/types.h>
 #include <linux/list.h>
@@ -93,4 +95,6 @@ int plpks_read_fw_var(struct plpks_var *var);
  */
 int plpks_read_bootloader_var(struct plpks_var *var);
 
-#endif
+#endif // CONFIG_PSERIES_PLPKS
+
+#endif // _ASM_POWERPC_PLPKS_H
diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index d54188a355c9c..1c43c4febd3da 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -18,8 +18,7 @@
 #include <linux/types.h>
 #include <asm/hvcall.h>
 #include <asm/machdep.h>
-
-#include "plpks.h"
+#include <asm/plpks.h>
 
 static u8 *ospassword;
 static u16 ospasswordlength;
-- 
2.43.0



