Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590988;
	b=ZBvz73GVtnmRrV2zqbWcnA0LY//FXESfKyHorm7uFhBthc+4xWpRFfMwOtNxTAJ1M8Kb
	 leSaUbtqC8i9qIeMI5ye2WUI/b80dEB6BK6fPVTsr/n+pjhOFq5SQNGREQZg3Wp+t+a+X
	 RXiPls3FLQ/ibOwIyZwg1W6pa0veVMpoMREekguDiYbxKyIaOaJpgxMc2nADqZXWWYuAk
	 8ygBhNRVTre49TN92+7uF7lkOk/GBAbi7VzjhL+lUZ8kUcFab5g6CaxNBqPILO3FtGFtE
	 l6KYvviKN+/S5Xi7NBfRumE4bAYYfC8jFFtejkiZ69SLsuCuYDFbrDzm/ZyaphMFk2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zi/Ts6+QrxqhWGqkIXpsmI1aFFlc4cKS5cHUMaqjkLU=;
	b=NajIwKWHw83X5ffB6eR9QAKfF/j28BjtwQK58EY/LzhjQigjks5OB5XeJniNlDWdbO/E
	 WzkhSYyp5mEs2R0yNhMIgDm+ZLfbDmMdd5g3gUZtgHjJhZ7nJGavULhSEJ5ftA1aAOKGW
	 AqrFfAkxEkakyyfO+q7VHokPHBxzJQGhF3Jxk/qz7NoZwBzu/tiuN7M3ov7www0I3bIZA
	 JLCo1D92Vk1F1fnB/VmUvAIKvllu8HqZkynL/j6YQCSy1QS1VJ3i7dJnFPYxKsJ9ZPfX2
	 jBYYPtrlS5WMW5peJJtHSj+PBfN463/IoQpjN1UEQ9nOxDAI0jbJyoWrJThHDgybq7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jJDPTI1U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F4060703F9;
	Fri, 13 Nov 2026 17:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jJDPTI1U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F461F000C4;
	Fri, 13 Nov 2026 17:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590988;
	bh=Zi/Ts6+QrxqhWGqkIXpsmI1aFFlc4cKS5cHUMaqjkLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jJDPTI1UHxx3/rPDjquc+q/Br8OTA5a/MJWui931ANQBJjVAU3QxXdqIm80Za3WSs
	 WHyh6C6pv01RnrnZA3OpEo7MmVA5CwauyCjOrKb4DDsp+mSdvK6Z2wS/w8ortJTITl
	 CCD53nhj7ZSIbpFDM09+cRPPcX2PEe2eBRWK++Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Yingjie Wang <x-professor@outlook.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 163/670] scsi: handle out-of-range SG_SET_TIMEOUT values
Date: Fri, 13 Nov 2026 10:45:27 -0500
Message-ID: <20261113153817.616826702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Yingjie Wang <x-professor@outlook.com>

[ Upstream commit 9a6cb1da4f3bc4633bf6669faed25a361834b1b9 ]

SG_SET_TIMEOUT accepts a signed int in USER_HZ units. The sg character
device rejects negative values and limits positive values so the converted
timeout fits its destination field. The block SCSI and BSG paths instead
pass the value to clock_t_to_jiffies(), which accepts an unsigned long, and
store the result in an unsigned int.

Negative values are converted into large unsigned timeouts. On 64-bit
systems, large positive values can also exceed UINT_MAX after conversion
and are truncated on assignment. With HZ=1000 and USER_HZ=100, for example,
429496730 clock ticks become 4294967300 jiffies and are stored as 4
jiffies. On 32-bit systems, an overflowing conversion becomes ULONG_MAX,
which is an unsafe relative interval for the block timer comparisons.

Reject negative values with -EIO, matching drivers/scsi/sg.c. Saturate the
converted value at the smaller of the destination field limit and
MAX_JIFFY_OFFSET. This preserves successful ioctl behavior while avoiding
both narrowing wraparound and an unsafe 32-bit timer interval.

The block SCSI behavior predates Git history. BSG has exposed the same
behavior since it was introduced.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: 3d6392cfbd7d ("bsg: support for full generic block layer SG v3")
Cc: stable@vger.kernel.org
Reported-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/9321a59c-c560-4742-8b71-5b0ec1f30c2f@acm.org
Signed-off-by: Yingjie Wang <x-professor@outlook.com>
Link: https://patch.msgid.link/20261022025508.294713-1-x-professor@outlook.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bsg.c               |  5 ++++-
 drivers/scsi/scsi_ioctl.c | 11 ++++++++---
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 72157a59b7881..7231b1de663fe 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -130,7 +130,10 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case SG_SET_TIMEOUT:
 		if (get_user(val, intp))
 			return -EFAULT;
-		bd->timeout = clock_t_to_jiffies(val);
+		if (val < 0)
+			return -EIO;
+		bd->timeout = min(clock_t_to_jiffies(val),
+				  min(UINT_MAX, MAX_JIFFY_OFFSET));
 		return 0;
 	case SG_GET_TIMEOUT:
 		return jiffies_to_clock_t(bd->timeout);
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 6f6c5973c3ea9..1e969f78f0608 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -9,6 +9,7 @@
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
 #include <linux/errno.h>
+#include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
@@ -180,10 +181,14 @@ static int sg_set_timeout(struct scsi_device *sdev, int __user *p)
 {
 	int timeout, err = get_user(timeout, p);
 
-	if (!err)
-		sdev->sg_timeout = clock_t_to_jiffies(timeout);
+	if (err)
+		return err;
+	if (timeout < 0)
+		return -EIO;
 
-	return err;
+	sdev->sg_timeout = min(clock_t_to_jiffies(timeout),
+			       min(UINT_MAX, MAX_JIFFY_OFFSET));
+	return 0;
 }
 
 static int sg_get_reserved_size(struct scsi_device *sdev, int __user *p)
-- 
2.53.0



