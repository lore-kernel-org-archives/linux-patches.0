Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216239;
	b=TJibyXCGmx6y+7Lmos5fE5dbDGLzmA6AomObM86rNGPYCxezLbVpOwJxxgtyluEKp805
	 tpK7tOzSjzhcTp35pLK3ADjkIJdXUkTUiJIpWapo9efG0L/sX8J2Ru5kEYyaKBdf79LvO
	 Qd7CMYFS61GradyDOh7WF+YQ5IngDnMC2Xaj/3yEmsai73RNdI4cwltBv7ZTnRObycqdg
	 Ua1nPJQy/HmgsWyOQ5haKZpy0VDgyBys6QCL82pHgtLm9eqoz8Gpnp4A81YQkgffHuo3m
	 bH9eN8fPVulWD0yvdQmApSDQJk6Is5mG9RUST7HJU6kscPVPD7wZW29thlWcI9bGp9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qn0sDG4lmKFDKWjd8qd0PT/lf1LIXGZ5+DWy5MA4HZc=;
	b=qOmdxa9MYRa6mSvTgERJrq+i6fVJ39JNqB9257aDW4snInPgyHzwIGfdJgnFq331mzS3
	 tXYJoULtuPQtkzHplEm2ii6LIu6F8IIYm8WvH9hJPqozKPt7Ev496WIl0yVS/7+kgpmqr
	 AqS9WaBXS9VS3b2GVbPo8W+8JDMslLvMyymV2SvUJwSiWYlYZEoqjV7qsumsYZV6rLBHB
	 GjHmbjV4NvEFvhuWV88hR8tVsJvffnQk7pzzGhLIkE5lVcxU6WO3QfJTCUEgOntXmsKEf
	 h1kJppTM5fQibu+yY+dXllrUpLJjPBeG117zbpxoebbtDi3yuynk2PIxfpuxa03JwvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MQvocNgo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942AD606A325;
	Wed, 28 Oct 2026 19:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MQvocNgo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E811F01825;
	Wed, 28 Oct 2026 19:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216239;
	bh=Qn0sDG4lmKFDKWjd8qd0PT/lf1LIXGZ5+DWy5MA4HZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MQvocNgohO5T83O6nmYxtaCRawkpxmBSOtW/PKXHZlwW4GAoLllKkstVTCvC/0+rJ
	 AX5vE1kqC8kRbWp5BbvYtqxRq4dgDVOfaJQ+oIU1wcxZ8PbIumLz0549RzMO4I09CY
	 kfEhrPbT7UD+g0MEYcnQGaG2ya3ZcZDrIpmp8uzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1488/1887] scsi: block: ioprio: Clean up interface definition
Date: Wed, 28 Oct 2026 17:59:44 +0100
Message-ID: <20261028170533.313894435@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit eca2040972b411ec27483bf75dc8b84e730e88ff ]

The I/O priority user interface defines the 16-bits ioprio values as the
combination of the upper 3-bits for an I/O priority class and the lower
13-bits as priority data. However, the kernel only uses the lower 3-bits of
the priority data to define priority levels for the RT and BE priority
classes. The data part of an ioprio value is completely ignored for the
IDLE and NONE classes. This is enforced by checks done in
ioprio_check_cap(), which is called for all paths that allow defining an
I/O priority for I/Os: the per-context ioprio_set() system call, aio
interface and io_uring interface.

Clarify this fact in the uapi ioprio.h header file and introduce the
IOPRIO_PRIO_LEVEL_MASK and IOPRIO_PRIO_LEVEL() macros for users to define
and get priority levels in an ioprio value. The coarser macro
IOPRIO_PRIO_DATA() is retained for backward compatibility with old
applications already using it. There is no functional change introduced
with this.

In-kernel users of the IOPRIO_PRIO_DATA() macro which are explicitly
handling I/O priority data as a priority level are modified to use the new
IOPRIO_PRIO_LEVEL() macro without any functional change. Since f2fs is the
only user of this macro not explicitly using that value as a priority
level, it is left unchanged.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Link: https://lore.kernel.org/r/20230511011356.227789-2-nks@flawful.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 5cb33b00c8fb ("f2fs: avoid NULL checkpoint thread access in sysfs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c         |  8 ++++----
 block/ioprio.c              |  6 +++---
 include/uapi/linux/ioprio.h | 19 ++++++++++++++-----
 3 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index d1c62a4e8c357..e9fee4d9d08a8 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5496,16 +5496,16 @@ bfq_set_next_ioprio_data(struct bfq_queue *bfqq, struct bfq_io_cq *bic)
 		bfqq->new_ioprio_class = task_nice_ioclass(tsk);
 		break;
 	case IOPRIO_CLASS_RT:
-		bfqq->new_ioprio = IOPRIO_PRIO_DATA(bic->ioprio);
+		bfqq->new_ioprio = IOPRIO_PRIO_LEVEL(bic->ioprio);
 		bfqq->new_ioprio_class = IOPRIO_CLASS_RT;
 		break;
 	case IOPRIO_CLASS_BE:
-		bfqq->new_ioprio = IOPRIO_PRIO_DATA(bic->ioprio);
+		bfqq->new_ioprio = IOPRIO_PRIO_LEVEL(bic->ioprio);
 		bfqq->new_ioprio_class = IOPRIO_CLASS_BE;
 		break;
 	case IOPRIO_CLASS_IDLE:
 		bfqq->new_ioprio_class = IOPRIO_CLASS_IDLE;
-		bfqq->new_ioprio = 7;
+		bfqq->new_ioprio = IOPRIO_NR_LEVELS - 1;
 		break;
 	}
 
@@ -5791,7 +5791,7 @@ static struct bfq_queue *bfq_get_queue(struct bfq_data *bfqd,
 				       struct bfq_io_cq *bic,
 				       bool respawn)
 {
-	const int ioprio = IOPRIO_PRIO_DATA(bic->ioprio);
+	const int ioprio = IOPRIO_PRIO_LEVEL(bic->ioprio);
 	const int ioprio_class = IOPRIO_PRIO_CLASS(bic->ioprio);
 	struct bfq_queue **async_bfqq = NULL;
 	struct bfq_queue *bfqq;
diff --git a/block/ioprio.c b/block/ioprio.c
index 32a456b458049..f0d9e818abc53 100644
--- a/block/ioprio.c
+++ b/block/ioprio.c
@@ -33,7 +33,7 @@
 int ioprio_check_cap(int ioprio)
 {
 	int class = IOPRIO_PRIO_CLASS(ioprio);
-	int data = IOPRIO_PRIO_DATA(ioprio);
+	int level = IOPRIO_PRIO_LEVEL(ioprio);
 
 	switch (class) {
 		case IOPRIO_CLASS_RT:
@@ -49,13 +49,13 @@ int ioprio_check_cap(int ioprio)
 			fallthrough;
 			/* rt has prio field too */
 		case IOPRIO_CLASS_BE:
-			if (data >= IOPRIO_NR_LEVELS || data < 0)
+			if (level >= IOPRIO_NR_LEVELS)
 				return -EINVAL;
 			break;
 		case IOPRIO_CLASS_IDLE:
 			break;
 		case IOPRIO_CLASS_NONE:
-			if (data)
+			if (level)
 				return -EINVAL;
 			break;
 		default:
diff --git a/include/uapi/linux/ioprio.h b/include/uapi/linux/ioprio.h
index f70f2596a6bf7..4444b4e4fdad9 100644
--- a/include/uapi/linux/ioprio.h
+++ b/include/uapi/linux/ioprio.h
@@ -17,7 +17,7 @@
 	 ((data) & IOPRIO_PRIO_MASK))
 
 /*
- * These are the io priority groups as implemented by the BFQ and mq-deadline
+ * These are the io priority classes as implemented by the BFQ and mq-deadline
  * schedulers. RT is the realtime class, it always gets premium service. For
  * ATA disks supporting NCQ IO priority, RT class IOs will be processed using
  * high priority NCQ commands. BE is the best-effort scheduling class, the
@@ -32,11 +32,20 @@ enum {
 };
 
 /*
- * The RT and BE priority classes both support up to 8 priority levels.
+ * The RT and BE priority classes both support up to 8 priority levels that
+ * can be specified using the lower 3-bits of the priority data.
  */
-#define IOPRIO_NR_LEVELS	8
-#define IOPRIO_BE_NR		IOPRIO_NR_LEVELS
+#define IOPRIO_LEVEL_NR_BITS		3
+#define IOPRIO_NR_LEVELS		(1 << IOPRIO_LEVEL_NR_BITS)
+#define IOPRIO_LEVEL_MASK		(IOPRIO_NR_LEVELS - 1)
+#define IOPRIO_PRIO_LEVEL(ioprio)	((ioprio) & IOPRIO_LEVEL_MASK)
 
+#define IOPRIO_BE_NR			IOPRIO_NR_LEVELS
+
+/*
+ * Possible values for the "which" argument of the ioprio_get() and
+ * ioprio_set() system calls (see "man ioprio_set").
+ */
 enum {
 	IOPRIO_WHO_PROCESS = 1,
 	IOPRIO_WHO_PGRP,
@@ -44,7 +53,7 @@ enum {
 };
 
 /*
- * Fallback BE priority level.
+ * Fallback BE class priority level.
  */
 #define IOPRIO_NORM	4
 #define IOPRIO_BE_NORM	IOPRIO_NORM
-- 
2.53.0



