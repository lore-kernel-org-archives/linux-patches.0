Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028766;
	b=NaQkjRUPAGjxWkmjzWNgo2u4lb66t3S5UhbxvaRggJeFfguGrfpe/XQh7Hvjit96aXmx
	 bA5AolDSbBzeee0QGnn2MWWdMd/onJK9EE6YprLg1BqdSkHLLfahpbvegrvNwWZcYx3C7
	 zXD3n3I7Bkj2BX+psXIAcbUcqysxe2DaZCOtmyY71Kat8W14NNqbalSuttsWxnAPQ9cO6
	 SnkKM6mvl0d1lh+tqPbL+mZYFTCNdZzh2Ok4EWad0o9rnVDkttwT4brgfZ3mdncPCUZDs
	 F33NEl6e9g8YC6JpI3K+oTH7WVd3lN4uWuTJGm/l/IfVGLzyESHx3LA8SJWXCiMfqew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RZvzfr8+4MSGcplFSNdGCmuEUWv0r8g41F4lco+iq6g=;
	b=25bVzxQNjoYuWejKhpI7cHPvwxOpFGvBmKJqQWH2aIX33Mwlo0OMrNrQEdYJXLAuZW3s
	 ZuEov6h9WSK+pYL94cCYIu4NSmVAwHwhC738eL+itF8+BYFwQDntvmDEBFhNKlScWIYB4
	 VDJjVSdu0xHKULyeRk67tbYChdJJiaOS7yS14RHnPoZ8BPMTlMIImaQDZ3ZpM7uEE4D9z
	 e9XxOzPcrvkkJf544ZbPvUVGz5lqUJu9btbGqEb1YZuG8mXEOuGECKfMvRb8chl1HJWTD
	 bCf+fHv6/k8geZgcwiHS3Dl6xZzp/H4V8VkwJFR/gx3C+ApaqyMe8qJIZpSi2MQ+AcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nUz0OZs3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C43606A33A;
	Wed, 18 Nov 2026 19:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nUz0OZs3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522331F000C5;
	Wed, 18 Nov 2026 19:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028765;
	bh=RZvzfr8+4MSGcplFSNdGCmuEUWv0r8g41F4lco+iq6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nUz0OZs3p+amHIN1Ajgo8bBwvnSeyMQgA7GF19HoB5j+TGnxBDmvizea9rz+7iKnK
	 9T7tg/xc9OktPdi5UubZhcS/lSt9T0/GFeXn5NVf6WjtcqeQcKjg92dy88z9aImQqf
	 /d/R6z7i+XjMvnUU0clba946EgURy4O4QZfTqvTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0071/1756] scsi: target: Fix LUN/device R/W and total command stats
Date: Wed, 18 Nov 2026 15:36:38 +0100
Message-ID: <20261118150011.144877233@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 95aa2041c654161d1b5c1eca5379d67d91ef1cf2 ]

In commit 9cf2317b795d ("scsi: target: Move I/O path stats to per CPU")
I saw we sometimes use %u and also misread the spec. As a result I
thought all the stats were supposed to be 32-bit only. However, for the
majority of cases we support currently, the spec specifies u64 bit
stats. This patch converts the stats changed in the commit above to u64.

Fixes: 9cf2317b795d ("scsi: target: Move I/O path stats to per CPU")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Link: https://patch.msgid.link/20250917221338.14813-2-michael.christie@oracle.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_stat.c | 24 ++++++++++++------------
 include/target/target_core_base.h | 12 ++++++------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 576d07a8484e3..cd57db809d31e 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -282,7 +282,7 @@ static ssize_t target_stat_lu_num_cmds_show(struct config_item *item,
 	struct se_device *dev = to_stat_lu_dev(item);
 	struct se_dev_io_stats *stats;
 	unsigned int cpu;
-	u32 cmds = 0;
+	u64 cmds = 0;
 
 	for_each_possible_cpu(cpu) {
 		stats = per_cpu_ptr(dev->stats, cpu);
@@ -290,7 +290,7 @@ static ssize_t target_stat_lu_num_cmds_show(struct config_item *item,
 	}
 
 	/* scsiLuNumCommands */
-	return snprintf(page, PAGE_SIZE, "%u\n", cmds);
+	return snprintf(page, PAGE_SIZE, "%llu\n", cmds);
 }
 
 static ssize_t target_stat_lu_read_mbytes_show(struct config_item *item,
@@ -299,7 +299,7 @@ static ssize_t target_stat_lu_read_mbytes_show(struct config_item *item,
 	struct se_device *dev = to_stat_lu_dev(item);
 	struct se_dev_io_stats *stats;
 	unsigned int cpu;
-	u32 bytes = 0;
+	u64 bytes = 0;
 
 	for_each_possible_cpu(cpu) {
 		stats = per_cpu_ptr(dev->stats, cpu);
@@ -307,7 +307,7 @@ static ssize_t target_stat_lu_read_mbytes_show(struct config_item *item,
 	}
 
 	/* scsiLuReadMegaBytes */
-	return snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
+	return snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
 }
 
 static ssize_t target_stat_lu_write_mbytes_show(struct config_item *item,
@@ -316,7 +316,7 @@ static ssize_t target_stat_lu_write_mbytes_show(struct config_item *item,
 	struct se_device *dev = to_stat_lu_dev(item);
 	struct se_dev_io_stats *stats;
 	unsigned int cpu;
-	u32 bytes = 0;
+	u64 bytes = 0;
 
 	for_each_possible_cpu(cpu) {
 		stats = per_cpu_ptr(dev->stats, cpu);
@@ -324,7 +324,7 @@ static ssize_t target_stat_lu_write_mbytes_show(struct config_item *item,
 	}
 
 	/* scsiLuWrittenMegaBytes */
-	return snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
+	return snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
 }
 
 static ssize_t target_stat_lu_resets_show(struct config_item *item, char *page)
@@ -1044,7 +1044,7 @@ static ssize_t target_stat_auth_num_cmds_show(struct config_item *item,
 	struct se_dev_entry *deve;
 	unsigned int cpu;
 	ssize_t ret;
-	u32 cmds = 0;
+	u64 cmds = 0;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
@@ -1059,7 +1059,7 @@ static ssize_t target_stat_auth_num_cmds_show(struct config_item *item,
 	}
 
 	/* scsiAuthIntrOutCommands */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", cmds);
+	ret = snprintf(page, PAGE_SIZE, "%llu\n", cmds);
 	rcu_read_unlock();
 	return ret;
 }
@@ -1073,7 +1073,7 @@ static ssize_t target_stat_auth_read_mbytes_show(struct config_item *item,
 	struct se_dev_entry *deve;
 	unsigned int cpu;
 	ssize_t ret;
-	u32 bytes = 0;
+	u64 bytes = 0;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
@@ -1088,7 +1088,7 @@ static ssize_t target_stat_auth_read_mbytes_show(struct config_item *item,
 	}
 
 	/* scsiAuthIntrReadMegaBytes */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
+	ret = snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
 	rcu_read_unlock();
 	return ret;
 }
@@ -1102,7 +1102,7 @@ static ssize_t target_stat_auth_write_mbytes_show(struct config_item *item,
 	struct se_dev_entry *deve;
 	unsigned int cpu;
 	ssize_t ret;
-	u32 bytes = 0;
+	u64 bytes = 0;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
@@ -1117,7 +1117,7 @@ static ssize_t target_stat_auth_write_mbytes_show(struct config_item *item,
 	}
 
 	/* scsiAuthIntrWrittenMegaBytes */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
+	ret = snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
 	rcu_read_unlock();
 	return ret;
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 05e3673607b8c..69efd10e2844c 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -670,9 +670,9 @@ struct se_lun_acl {
 };
 
 struct se_dev_entry_io_stats {
-	u32			total_cmds;
-	u32			read_bytes;
-	u32			write_bytes;
+	u64			total_cmds;
+	u64			read_bytes;
+	u64			write_bytes;
 };
 
 struct se_dev_entry {
@@ -805,9 +805,9 @@ struct se_device_queue {
 };
 
 struct se_dev_io_stats {
-	u32			total_cmds;
-	u32			read_bytes;
-	u32			write_bytes;
+	u64			total_cmds;
+	u64			read_bytes;
+	u64			write_bytes;
 };
 
 struct se_device {
-- 
2.53.0



