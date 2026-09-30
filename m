Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F75A3DA7DB;
	Wed, 30 Sep 2026 18:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794127; cv=none; b=PZMwq5ai+WQnOF5YcJdQezMohovXWSKD+DypHIT2CCdvkyuftG4tcM0ydD6X0fcn8UYnAsTgBZ6VtPZM6jWyQXrLAiySDTUTJfA8Jrr6QsR7jo+1B+M+AGMLru4X7ER9CQDF0afHzdFJiGSz3FIIx51xAs6XY5EwBClVbkaVn7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794127; c=relaxed/simple;
	bh=hifv/KHyRZhR9uP++KSTNgAIuaRrKV9vstXwqU8Vggo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlQHMDaLHzq1L4ozR1kAL9UyFbtxt2jgwlhQFFt1Iu8T4e61EMDjeOYGM7qR64vS3TmzQNfV5fwpbtbjDlOvAUmBiekRe1xTGKch7IBaVwzfc8Ln3EV9b/526TOlStaRzwRxj4IOv5UfQU/ZrJL9mCHRrK8tv7ziNB+45nEw5t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTc8lsXE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTc8lsXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FDD1F000FF;
	Wed, 30 Sep 2026 18:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794126;
	bh=HI6DtRmDvy2a7TKpLmJqtSD3jFaWL5+366X0YoAPE3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wTc8lsXESy9yVTBWoR/mPSO0Ed/QfZwUwM2l+gaHsxqP7CVkLO5luEiC1OL7pZ90N
	 adLefWUhJGvziFYyuCowIxDH99RDI8n8+STzbTwiEGM/tKD4lCOKKB1c1Zt649xqsG
	 EXUVBO2n8CP8xiyk02ZZ/8w4JG84PMP7zgm2Hp4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Tellakula Yeswanth Krishna <yeswanth@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0099/1193] char/nvram: Remove redundant nvram_mutex
Date: Wed, 30 Sep 2026 17:13:03 +0200
Message-ID: <20260930152436.435531343@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e9f694b368719..bd7510abdc076 100644
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



