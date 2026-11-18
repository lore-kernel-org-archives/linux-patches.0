Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040182;
	b=kM6ujLy7SdVkcXr/JYtM4sXQ6SSlXOR1MRJ1hcUIWLWonJYlB3IJWTa4y7guavhhBGmy
	 5QiWPvpcVgeKboZQp2Q/RwTeFfKFXTcLB4CU6FhC3zJs0Xkw25HkHKHmaecfzyP82LdzD
	 s09TkE1/Dm4OH2CEaw/eoAjPJrHzh17X8o8m0gv8MoajsGZESUkwITjHMsmKfpg3D9mq2
	 nSpW8lGFVU3s2i44CXPk0anVMqiSfN7HFybYUHcrtsntjClqJFFU9fPR/9Zies8hkbFx5
	 01IzXWvZ4bn3TEFddp53hKA17dmnEYQYYn3B9doh51hvIeafkGOceB1hHzo+24VGHSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oT7GrsOQRGsdcPo7cn9nZQoX7VEe0PvanEhTqY/eDU4=;
	b=B0X7vXPmVHlK34KKcxAiBxr/lg1qgbnFyv7vSaK8TJ8vPHKY15FBTvZY/IjELiDH6HP/
	 jtX+QhapJrjdDfgHWVEagtrjB+qUkNJwNsrrdTx8kuPH87F5yIJJFgF936aR4tta3l04G
	 yxOSnX0rtVda10NL6F1ovRd2y5U9EWuX2nnn45ymXEPjWleE4EihGq0kL0Czr20YdW878
	 lBAUkVKOxmxMZAL4D3IG0Aq306zrFeh9UWmWBYSkEP+fExYaZDwBA6qW3Vn4OAOiSo+Ae
	 7AMADo/FM+/JAoo+NMoWml8DBc/15KLM/H6m+hvgHFvCXyl3ZbwYhMiunqZvJI6BL/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MsWRbLpm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3182606A32A;
	Wed, 18 Nov 2026 22:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MsWRbLpm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B900C1F000C4;
	Wed, 18 Nov 2026 22:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040182;
	bh=oT7GrsOQRGsdcPo7cn9nZQoX7VEe0PvanEhTqY/eDU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MsWRbLpmYZnuylmWC/ImmgSi5qkVOj+6VjAlap4kUTeGyIXagdzIRr5Ck4y0O9adf
	 kNJT2g0dxTXCqRpjfAhUZD4Gi1MqqANiuM6vxoRCTMVFyHRbiq8dvCX1sECN8aRl52
	 5GVt6TLYg0OYsr6knzOQA5czzbp8bwO1vSy4vEzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2314/3318] swim: Recalibrate when drive is probed
Date: Wed, 18 Nov 2026 15:48:56 +0100
Message-ID: <20261118150431.111693681@linuxfoundation.org>
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

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit ba087774a1493ade524f8a783461fa8be9c75039 ]

Track zero recalibration can be slow and is normally done only once i.e.
during system POST or boot-up. Recalibrate once after the drive is probed
rather than every time the device is opened. Don't register the drive if
recalibration fails. Park the heads before ejecting.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/119e799afcc00d6bd4a479c31e0c960cb1a1d71b.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index bc30382731cb8..70b5d5dfb6079 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -412,6 +412,7 @@ static inline int swim_track00(struct swim __iomem *base)
 	if (swim_readbit(base, TRACK_ZERO))
 		return 0;
 
+	pr_err("swim: track zero recalibration failed\n");
 	return -1;
 }
 
@@ -456,6 +457,7 @@ static int floppy_eject(struct floppy_state *fs)
 	struct swim __iomem *base = fs->swd->base;
 
 	swim_drive(base, fs->location);
+	swim_track(fs, 40);
 	swim_motor(base, OFF);
 	swim_eject(base);
 	swim_drive(base, NO_DRIVE);
@@ -596,13 +598,6 @@ static void setup_medium(struct floppy_state *fs)
 		struct floppy_struct *g;
 		fs->disk_in = 1;
 		fs->write_protected = swim_readbit(base, WRITE_PROT);
-
-		if (swim_track00(base))
-			printk(KERN_ERR
-				"SWIM: cannot move floppy head to track 0\n");
-
-		swim_track00(base);
-
 		fs->type = swim_readbit(base, TWOMEG_MEDIA) ?
 			HD_MEDIA : DD_MEDIA;
 		fs->head_number = swim_readbit(base, SINGLE_SIDED) ? 1 : 2;
@@ -610,7 +605,6 @@ static void setup_medium(struct floppy_state *fs)
 		fs->total_secs = g->size;
 		fs->secpercyl = g->head * g->sect;
 		fs->secpertrack = g->sect;
-		fs->track = 0;
 	} else {
 		fs->disk_in = 0;
 	}
@@ -760,24 +754,33 @@ static const struct block_device_operations floppy_fops = {
 	.check_events	 = floppy_check_events,
 };
 
-static int swim_add_floppy(struct swim_priv *swd, enum drive_location location)
+static void swim_add_floppy(struct swim_priv *swd, enum drive_location location)
 {
 	struct floppy_state *fs = &swd->unit[swd->floppy_count];
 	struct swim __iomem *base = swd->base;
 
-	fs->location = location;
+	swim_drive(base, location);
+	if (!swim_readbit(base, DRIVE_PRESENT) ||
+	    swim_readbit(base, ONEMEG_DRIVE))
+		goto out;
+	if (swim_readbit(base, DISK_IN))
+		swim_motor(base, ON);
+	if (swim_track00(base))
+		goto out;
 
-	swim_motor(base, OFF);
+	fs->location = location;
 
 	fs->type = HD_MEDIA;
 	fs->head_number = 2;
 
 	fs->ref_count = 0;
 	fs->ejected = 1;
+	fs->track = 0;
 
 	swd->floppy_count++;
 
-	return 0;
+out:
+	swim_motor(base, OFF);
 }
 
 static const struct blk_mq_ops swim_mq_ops = {
@@ -819,14 +822,8 @@ static int swim_floppy_init(struct swim_priv *swd)
 
 	/* scan floppy drives */
 
-	swim_drive(base, INTERNAL_DRIVE);
-	if (swim_readbit(base, DRIVE_PRESENT) &&
-	    !swim_readbit(base, ONEMEG_DRIVE))
-		swim_add_floppy(swd, INTERNAL_DRIVE);
-	swim_drive(base, EXTERNAL_DRIVE);
-	if (swim_readbit(base, DRIVE_PRESENT) &&
-	    !swim_readbit(base, ONEMEG_DRIVE))
-		swim_add_floppy(swd, EXTERNAL_DRIVE);
+	swim_add_floppy(swd, INTERNAL_DRIVE);
+	swim_add_floppy(swd, EXTERNAL_DRIVE);
 	swim_drive(base, NO_DRIVE);
 
 	/* register floppy drives */
-- 
2.53.0



