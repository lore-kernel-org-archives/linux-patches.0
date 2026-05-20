Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0DF3F54D1;
	Wed, 20 May 2026 16:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294495; cv=none; b=pOR39WmH41KG9VWj4nkGkgb0qw5OBHJVOoIPG/m2XR+5nqMwkhANHoHMVAPXoisEpPqG6FYQGOjLVKQjVk9KsaniuWmr1C7uGffpT+QfmMraxuCtHHOIrywVtzNXXUIakKQTZAoTNc3ol4bVHRmDryR0ZK+EKZQHzo3d3ZfIyRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294495; c=relaxed/simple;
	bh=sjjs1rhekNpMtoNeD0zi0o8oHT8h9pEILrkSSDM5Ahg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGEQE0l9Fv/BV1xnppbhzkv5o8wsE3zKrsuoQh8K0BnQPHtt/10KuDk3CiXMgDgPaajCCf6yb8UbwRCpVNdDtb42p2VG1fKr5DZnVtp8eNBAiUXK8WVvzZMN+/EOnzjRURSqTAmBA+zVj2cSTj3Lgi72XdhgwfroMbsto/B8czI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R50AA81R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R50AA81R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0E51F000E9;
	Wed, 20 May 2026 16:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294492;
	bh=sgU3TiSNCtYEpUfyZRFKRSmD8/Hi5KdgdCks6Spz6aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R50AA81RmhOSxi06hvMeVuKyLvHSS173O9ebQjQdKnxMIBBalg/C55Ocj6MbHM3MD
	 PunE9ftIDq77oNCwPOWo36Ey5bKCO89vql7o26QAuB/mjqX6Sr5qcy8ydxa7ZEFy1T
	 4RPuC2sKdmvXHrSDcIeAOOx7mPOBA3eokh1eHdh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Juergen Gross <jgross@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0060/1146] x86/irqflags: Preemptively move include paravirt.h directive where it belongs
Date: Wed, 20 May 2026 18:05:10 +0200
Message-ID: <20260520162149.728020196@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 36c1eb9531e0c9bdcb3494142123f1c1e128367b ]

Commit

  22cc5ca5de52 ("x86/paravirt: Move halt paravirt calls under CONFIG_PARAVIRT")

moved some paravirt hooks from the CONFIG_PARAVIRT_XXL umbrella to
CONFIG_PARAVIRT, but missed to move the associated "#include <asm/paravirt.h>"
in irqflags.h from CONFIG_PARAVIRT_XXL to CONFIG_PARAVIRT.

This hasn't resulted in build failures yet, as all use cases of irqflags.h had
paravirt.h included via other header files, even without CONFIG_PARAVIRT_XXL
being set.

In order to allow changing those other header files, e.g. by no longer
including paravirt.h, fix irqflags.h by moving inclusion of paravirt.h under
the CONFIG_PARAVIRT umbrella.

  [ bp: Massage commit message. ]

Fixes: 22cc5ca5de52 ("x86/paravirt: Move halt paravirt calls under CONFIG_PARAVIRT")
Closes: https://lore.kernel.org/oe-kbuild-all/202601152203.plJOoOEF-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://patch.msgid.link/20260119182632.596369-2-jgross@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/irqflags.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/irqflags.h
index 462754b0bf8ac..6f25de05ed58f 100644
--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -96,11 +96,11 @@ static __always_inline void halt(void)
 	native_halt();
 }
 #endif /* __ASSEMBLER__ */
+#else
+#include <asm/paravirt.h>
 #endif /* CONFIG_PARAVIRT */
 
-#ifdef CONFIG_PARAVIRT_XXL
-#include <asm/paravirt.h>
-#else
+#ifndef CONFIG_PARAVIRT_XXL
 #ifndef __ASSEMBLER__
 #include <linux/types.h>
 
-- 
2.53.0



