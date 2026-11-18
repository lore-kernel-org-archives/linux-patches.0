Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037427;
	b=2nUiG3XPTJxIMVa57dPRqz7ythUlUoe98GFYUD0KNY0mkzc26yEvO01skJ6OHQozRUTp
	 ThjMH72b5zitrOpvSroNsVbPzXuzyy1oxgeWYde+pC3vx9yyhEDudENxTXwqV3jpKxKzp
	 PNkb4/TriGOxEpGNIG4FtMQ9ovraD/rV6FovOceuVf0ZJJfLn1NCaip/Jten6C66DGB60
	 H7xVwbalPjeVq0ZKDpYKDWbqMIsvMzeAftQzbCjHwxa9ReT1LBLnHYMeZ92bwQ9YRZTK/
	 rOZQn4T9fqHQPOn0HnBnVTVhmriRGQyoloc3V6zt54KLxKtS5cx+AiO+VxkSmXqnNjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037427;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wOr7WagjPo66qMRRtMyjTWlO3xEHAQoNh78VC63cDoQ=;
	b=Xt5DCrobVu0oE9uku6jddw2eajnokCe27yIQNOb+mAoEGQNDuY/fOKv4qB8g4aWgC4W9
	 N/7Lwhxj3WS87GJ0Ur339g418AmSlcWgQ4L91bdFP8jSbSmeiUQ38oGUyTJUjejHBwYMw
	 6vq6s8C4ImGrcLUIFq2CSoHE6mQePmQGjCT6jn4tcE0jqHfLwqBW5vmpVqitIDxK0c0Va
	 uQ76sMjoV9BNUvK1nyDzEx8AhHDbBzDLY2uHBu+yZCdg1jEge8OwSV0fGHdrYw85+L2Up
	 OmjqCbbLXKO3C8es4RO47xhuhMNasBnE5RKoawLRu/XGvvh39MqNW0SskLr7TsvKYnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IfAS2aE+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15029606A325;
	Wed, 18 Nov 2026 21:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IfAS2aE+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147821F000C4;
	Wed, 18 Nov 2026 21:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037426;
	bh=wOr7WagjPo66qMRRtMyjTWlO3xEHAQoNh78VC63cDoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IfAS2aE+jRmJoFDKzCuiX0vwoaFUt26tgyrnhR50njgriHMwKHrdGC94k1vXV+w5P
	 XPKI+JG+4gNWnCOchfKKGNoMs0T3ecC1D2DU/HBAygWoTI2jO5/+2/wVyfvwAzNC/O
	 AVVH/GhXogTrviiMZe3Nr29NG7nCidZ56TZ6c2/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Yingjie Wang <x-professor@outlook.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1397/3318] scsi: handle out-of-range SG_SET_TIMEOUT values
Date: Wed, 18 Nov 2026 15:33:39 +0100
Message-ID: <20261118150402.505051217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



