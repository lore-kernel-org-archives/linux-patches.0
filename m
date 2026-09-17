Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3484E36F7;
	Thu, 17 Sep 2026 17:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667575; cv=none; b=apTtBspnMdJfBKiEWPDD6eXu3Nn/zSv0mP67L3uy8OUD7EQUYdfeLDSATZ8/Gq0LwRDwDNBfO77cwBN7pz1icj9fCniC6F0svWykjJVqq+ST+rs1eDCQELlrpSB7fcgyk4erh0uZODzsowcMTU9SimIHBnsxImCMtSr81PCvR1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667575; c=relaxed/simple;
	bh=wITgjrHicPrwonSvW4uCdn2um+t+o4mu4RcK5wXEftc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnEewkWZjy2C/wbWX75gNnacIjNV375GtwwgLANivSEbQAWDVbZ99gVzHNsBfMxWtDg2OzloeO4jePMhKigolzi5nUSJbNP3k50MTFb145jfkzqoZLQVFcU/bxpSKnR6B6SYfE4jyuNrIcNXDbfXH4QKRLj1qR+BdWstvDbtG70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P4ge1aoR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P4ge1aoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1A81F000FF;
	Thu, 17 Sep 2026 17:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667574;
	bh=XP6s6UY6RKFEjnQZoOo0xd3CIVoyz8TsoV2xwgLvvNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P4ge1aoR6TQG8LaCxN9bV2jtE1W24BPfc0OmhViDmH+qym2s5gSajBMJJSPenQG8q
	 xW4B/M1IIJDDGLDPx2mKF+efeMGJmzuh88B2+bQcpk+pChk4Z7Q32/WSl7wJCDBOs2
	 ZwIPIrdPe3bADVxG46IlARLJah/ZJe3fjoyLTWDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Tellakula Yeswanth Krishna <yeswanth@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0139/1102] char/nvram: Remove redundant nvram_mutex
Date: Thu, 17 Sep 2026 16:01:22 +0100
Message-ID: <20260917151543.011916848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>

[ Upstream commit e8c715f3a7dae43fabae261493a26474fec11863 ]

The global nvram_mutex in drivers/char/nvram.c is redundant and unused,
and this triggers compiler warnings on some configurations.

All platform-specific nvram operations already provide their own internal
synchronization, meaning the wrapper-level mutex does not provide any
additional safety.

Remove the nvram_mutex definition along with all remaining lock/unlock
users across PPC32, x86, and m68k code paths, and rely entirely on the
per-architecture nvram implementations for locking.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Tellakula Yeswanth Krishna <yeswanth@linux.ibm.com>
Signed-off-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Tested-by: yeswanth <yeswanth@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://patch.msgid.link/20260428061540.73668-1-venkat88@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/nvram.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index 9eff426a92865..e89cc1f1c89ea 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -53,7 +53,6 @@
 #include <asm/nvram.h>
 #endif
 
-static DEFINE_MUTEX(nvram_mutex);
 static DEFINE_SPINLOCK(nvram_state_lock);
 static int nvram_open_cnt;	/* #times opened */
 static int nvram_open_mode;	/* special open modes */
@@ -310,11 +309,8 @@ static long nvram_misc_ioctl(struct file *file, unsigned int cmd,
 		break;
 #ifdef CONFIG_PPC32
 	case IOC_NVRAM_SYNC:
-		if (ppc_md.nvram_sync != NULL) {
-			mutex_lock(&nvram_mutex);
+		if (ppc_md.nvram_sync)
 			ppc_md.nvram_sync();
-			mutex_unlock(&nvram_mutex);
-		}
 		ret = 0;
 		break;
 #endif
@@ -324,11 +320,8 @@ static long nvram_misc_ioctl(struct file *file, unsigned int cmd,
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
 
-		if (arch_nvram_ops.initialize != NULL) {
-			mutex_lock(&nvram_mutex);
+		if (arch_nvram_ops.initialize)
 			ret = arch_nvram_ops.initialize();
-			mutex_unlock(&nvram_mutex);
-		}
 		break;
 	case NVRAM_SETCKS:
 		/* just set checksum, contents unchanged (maybe useful after
@@ -336,11 +329,8 @@ static long nvram_misc_ioctl(struct file *file, unsigned int cmd,
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
 
-		if (arch_nvram_ops.set_checksum != NULL) {
-			mutex_lock(&nvram_mutex);
+		if (arch_nvram_ops.set_checksum)
 			ret = arch_nvram_ops.set_checksum();
-			mutex_unlock(&nvram_mutex);
-		}
 		break;
 #endif /* CONFIG_X86 || CONFIG_M68K */
 	}
-- 
2.53.0



