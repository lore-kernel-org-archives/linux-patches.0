Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059946;
	b=LxR99p3GH1SjFfVKZMcnQs57IbAFbdrfpJrMq/lPL+QuNmt1Ovl+u4MaEfcXpTgxnTzc
	 lKhvmliNoz/Afr2p+wefarBhnOcCSitp+JtZTAGqiftAbg8iJT5++jPqg0+TY+NcLp1HB
	 e4VLibdgOJM0gOVnN3+xvWT+y7SO2NK4Y/d0t1ns2O/tHwI2KFxlbHFsxZBQaT5wtGfB3
	 s0WoZhLb0B9n2KZsyE5ron2V0K50c0B1+065KDYWyca6IRL2htmxlxz4W1FfXPA0mI44v
	 Tq7o8XuSXWuDliGD+b2pbKd2ByEDeURXuRbKye1g1Qi9BUn1jIGxARkF0/9dnb8U1Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bUmO+ecNjb3ubchf2B7xMCkCoNt7sCuaeGbaLXWFois=;
	b=z50ZaeLgxXYJdqomBMjSNXii5SXLKRjJWNKiZgmX6o2CK36rUy6VbygR2Y3HzhkPcxD2
	 GTlTTjt0rYuWaw+TfxbyAV1lV4xXiZa16OV9Yv0/TDYXpdkOwCsSuS+ZAGczo7eGV8d5m
	 nU1p73XdYrJ0VNOq1bvceuvPDQTyZFSQnIxsZJvM1MGo/RhKDdArVhNdYCAgXOzLdTOGe
	 riT8pCqWwfid3cagbK6M70cFJwxNfTkctCKCcDTrAiC+9KIq4GpdFVyRrm9bhDHyjUx55
	 H6gMaDx7U66qHv9BmY+d5UGnMpgc8jE152zRjnhKRNf25o+ZmwFaOX+HQpiYyRx3vLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c0KQKLQp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA260606A32F;
	Thu, 19 Nov 2026 03:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c0KQKLQp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5BE1F000CB;
	Thu, 19 Nov 2026 03:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059946;
	bh=bUmO+ecNjb3ubchf2B7xMCkCoNt7sCuaeGbaLXWFois=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c0KQKLQpwhk3CWUisHuKH8FkNge85LY8U53EBy7v4zjnCvXIHARvs1X/r7WIr3hNj
	 pUVLgL9RYprJe5T/V0jAKwVMTNDo29cn4Twirbbje/ipj7IN/47fcDC4l+QHhJDk3/
	 3Q1JDztjrVbOU8PRPexQcFysUoV+qcc/gtoYzItA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Yingjie Wang <x-professor@outlook.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0982/1848] scsi: handle out-of-range SG_SET_TIMEOUT values
Date: Wed, 18 Nov 2026 15:50:20 +0100
Message-ID: <20261118145958.025887896@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted separate SCSI and BSG timeout changes to the shared sg_set_timeout() helper using q->sg_timeout. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/scsi_ioctl.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index c9f009cc04460..1039b0dc81d00 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -5,6 +5,7 @@
 #include <linux/compat.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
+#include <linux/jiffies.h>
 #include <linux/string.h>
 #include <linux/module.h>
 #include <linux/blkdev.h>
@@ -62,10 +63,14 @@ static int sg_set_timeout(struct request_queue *q, int __user *p)
 {
 	int timeout, err = get_user(timeout, p);
 
-	if (!err)
-		q->sg_timeout = clock_t_to_jiffies(timeout);
+	if (err)
+		return err;
+	if (timeout < 0)
+		return -EIO;
 
-	return err;
+	q->sg_timeout = min(clock_t_to_jiffies(timeout),
+			    min(UINT_MAX, MAX_JIFFY_OFFSET));
+	return 0;
 }
 
 static int max_sectors_bytes(struct request_queue *q)
-- 
2.53.0



