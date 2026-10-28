Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216237;
	b=reYRcPf0MlzPbKwxaB2hQmzNQp8dKl/QRh8CXOefBrM9XCKKMGwPmvDLODAKEI7OY5lC
	 x8us/6ksMbebGzBOLlLZZL+65MQy6v+Ypcy4gjIvA5cDXT1yXgoLImDhB1w9LB8PHxVHa
	 xvF01VJ76bzp2HFsv71Mjnj5hGLgAuwUWW+xszIgK5238kBP0THaROfYDSjWGMapxbAdO
	 o0crXVIDm3J82N6mhou2Ep/jFsdiJSJYRcDnKWUnd+TvR/VokPE97SGkdHaNj3MO8Z5PI
	 Tv0sD987kVTOaVgCBoxbpB92hAxFKdm+LBLk4uVBsXcttpBrUpgdL0b6t45l9IYvLjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216237;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o5+6gjC9jek6n7vAwJN7kbmOpUitPBfHrycbX9qZmZY=;
	b=vw3E6iKaLskSBF4KO8cSIKcehglX1VEwKrLlDheqqTUkKcgvFULUoew9sHUoxrer1y1P
	 F5pXUV+lDJLpesbzrmsh/JIIhv1HE3q02UBbDhWOhyLQjnjBR97tzKvPrcFTEnIDiPWUv
	 rV2RKagVtOlcB2y1kozv04Kri/8ehCX5KXPy4TidPJZlfzIz6BcdCMyOlMt36eHTUchzy
	 eZ6f9y4G4UO0WCcvre+WqdSZbFVgVikTzdeFaHYH9dEre7brGRWoT07Rfx71XBoXhSwOp
	 dLWLbL1f+9MmvRkasYRzeDTAb+KRNme9HptHxzZN/JALhvkTzuXVVto4lwtVq4Bfeow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=COblz+ii;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E44606A31F;
	Wed, 28 Oct 2026 19:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=COblz+ii
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36441F01828;
	Wed, 28 Oct 2026 19:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216236;
	bh=o5+6gjC9jek6n7vAwJN7kbmOpUitPBfHrycbX9qZmZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=COblz+iiVHIigkNTxRE+QzfDh9DpSk+iPF7EykBSIL/6sYWJ5VVEgllalIl8hqDZX
	 7cQBcIvcAIDCHp7Vka7usbhYwYSaROC+Fv5MwnWjmMLuZjfo5HWBUR3plLdF+f2R3E
	 ioBBJhdveY4W/90faH63WFSWbpqJp2GqJiK+Qc3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1487/1887] f2fs: convert to use sysfs_emit
Date: Wed, 28 Oct 2026 17:59:43 +0100
Message-ID: <20261028170533.290174905@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit 084e15ea14bbb1ad40163438cfa74a76a1521c16 ]

Let's use sysfs_emit.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 5cb33b00c8fb ("f2fs: avoid NULL checkpoint thread access in sysfs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/sysfs.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index b0607fdd5ad40..031dd0079dbd6 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -326,19 +326,14 @@ static ssize_t f2fs_sbi_show(struct f2fs_attr *a,
 
 	if (!strcmp(a->attr.name, "ckpt_thread_ioprio")) {
 		struct ckpt_req_control *cprc = &sbi->cprc_info;
-		int len = 0;
 		int class = IOPRIO_PRIO_CLASS(cprc->ckpt_thread_ioprio);
 		int data = IOPRIO_PRIO_DATA(cprc->ckpt_thread_ioprio);
 
-		if (class == IOPRIO_CLASS_RT)
-			len += scnprintf(buf + len, PAGE_SIZE - len, "rt,");
-		else if (class == IOPRIO_CLASS_BE)
-			len += scnprintf(buf + len, PAGE_SIZE - len, "be,");
-		else
+		if (class != IOPRIO_CLASS_RT && class != IOPRIO_CLASS_BE)
 			return -EINVAL;
 
-		len += scnprintf(buf + len, PAGE_SIZE - len, "%d\n", data);
-		return len;
+		return sysfs_emit(buf, "%s,%d\n",
+			class == IOPRIO_CLASS_RT ? "rt" : "be", data);
 	}
 
 #ifdef CONFIG_F2FS_FS_COMPRESSION
-- 
2.53.0



