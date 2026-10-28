Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216243;
	b=h8y05we1UunfK/9aWuXnRLUS9l1K4FGGrbHtOt+PANDoRy01uP8kaVsbpnxrmweDCAE/
	 gVlkBlSsNGWOBYHhbe0ITEqkPDV2kEtfXHV6pIqNFBqgpbF2/AREAfm0y5zgFRRElA8jO
	 M1Ip8VPDcqSAFqPXYHAvg3aWNi+EJv8Mh76yGeBz5UTgvcK+qM1Y3T2zJryzToXGCICNt
	 MdO5I0Jebhn1QfLHrXmyl2TqpamKFJ2+E3MbKR3L6gDMubx2iOGJnBYeszawiRT76slFS
	 L+ljS7GCTPhMTxKg69R6tpwIBXZflbxuN21rVd+lDUjocBxaUfps3rFyqMjRGM8tRIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J+84uEYLLF+/0gCsYVmpsNvOudHikJhL16xj/D610jM=;
	b=0EB2aPvyE4yMcAlvZZlVpDeFsOUf/UhOwoJAIb/0n2P+Dwn08CRoWBuYFDmqI8uRqwAc
	 RiTupbUYGzRAWO+PzzIIviu7ceqXxmkV339G5XSEJj530eDPdSRVI4DUbF15cexsqGMD/
	 LmMGy9GG6Fqro0WQM4El0QuEGLjKShs+Hl3UaIOPxtxfDgQeFp8KcweSdwPu0a/DsFaBx
	 1tN5HO+rBMsTQD2NfS/b305KtYhsFFuTI2d8q9HPElTXCfonpqp7DKcpBXcyHWSvBBy/B
	 7u6x7GJ1iOmaS4jYaRRokQhWxNHz0F79OzVSk5RDRPOsVeJYg9NKLiNI7os5MnJe82Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P4XutEJm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7174606A31E;
	Wed, 28 Oct 2026 19:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P4XutEJm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32021F01825;
	Wed, 28 Oct 2026 19:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216242;
	bh=J+84uEYLLF+/0gCsYVmpsNvOudHikJhL16xj/D610jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P4XutEJmXjTiyfvasDrWMZr/xSojkJh3Fr21MtmvyvMdAqB9DgPUHeluNUmOnAuIG
	 lIyzvlU8zVlb+s9r9qq/7+lYa8NS1Osfam0bGak04QOlWx1pgAZtmEtAsTnpMO8dTZ
	 f12IozWq7hR9KXh7GJzlf361pMiAXztm6BM+KLB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1489/1887] f2fs: use new ioprio Macro to get ckpt thread ioprio level
Date: Wed, 28 Oct 2026 17:59:45 +0100
Message-ID: <20261028170533.338237840@linuxfoundation.org>
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

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit 270b09313b4e16cdfd01d8371023a1661dd1112e ]

IOPRIO_PRIO_DATA in the new kernel version includes level and hint,
So Macro IOPRIO_PRIO_LEVEL is more accurate to get ckpt thread
ioprio data/level, and it is also consisten with the way setting
ckpt thread ioprio by IOPRIO_PRIO_VALUE(class, data/level).

Besides, change variable name from "data" to "level" for more readable.

Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 5cb33b00c8fb ("f2fs: avoid NULL checkpoint thread access in sysfs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/sysfs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index 031dd0079dbd6..f6f5da3b2a376 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -327,13 +327,13 @@ static ssize_t f2fs_sbi_show(struct f2fs_attr *a,
 	if (!strcmp(a->attr.name, "ckpt_thread_ioprio")) {
 		struct ckpt_req_control *cprc = &sbi->cprc_info;
 		int class = IOPRIO_PRIO_CLASS(cprc->ckpt_thread_ioprio);
-		int data = IOPRIO_PRIO_DATA(cprc->ckpt_thread_ioprio);
+		int level = IOPRIO_PRIO_LEVEL(cprc->ckpt_thread_ioprio);
 
 		if (class != IOPRIO_CLASS_RT && class != IOPRIO_CLASS_BE)
 			return -EINVAL;
 
 		return sysfs_emit(buf, "%s,%d\n",
-			class == IOPRIO_CLASS_RT ? "rt" : "be", data);
+			class == IOPRIO_CLASS_RT ? "rt" : "be", level);
 	}
 
 #ifdef CONFIG_F2FS_FS_COMPRESSION
@@ -453,7 +453,7 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
 		const char *name = strim((char *)buf);
 		struct ckpt_req_control *cprc = &sbi->cprc_info;
 		int class;
-		long data;
+		long level;
 		int ret;
 
 		if (!strncmp(name, "rt,", 3))
@@ -464,13 +464,13 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
 			return -EINVAL;
 
 		name += 3;
-		ret = kstrtol(name, 10, &data);
+		ret = kstrtol(name, 10, &level);
 		if (ret)
 			return ret;
-		if (data >= IOPRIO_NR_LEVELS || data < 0)
+		if (level >= IOPRIO_NR_LEVELS || level < 0)
 			return -EINVAL;
 
-		cprc->ckpt_thread_ioprio = IOPRIO_PRIO_VALUE(class, data);
+		cprc->ckpt_thread_ioprio = IOPRIO_PRIO_VALUE(class, level);
 		if (test_opt(sbi, MERGE_CHECKPOINT)) {
 			ret = set_task_ioprio(cprc->f2fs_issue_ckpt,
 					cprc->ckpt_thread_ioprio);
-- 
2.53.0



