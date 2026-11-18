Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055258;
	b=p/dBJG2Qz98far9NFwV5S87Y/CFqC2k9f1IpSKrSYiUYGeISWPilF0Tg5CdxKSCi1hGH
	 IJFC15w4h1DgqVzPfIO/qkH3YRp6UbQIFxbnxG6Lu57nQl7WimYQxzrWC88G16YixqBeQ
	 Rmdc34JQrubtKTdq0O7j35PbrNdgv1WtG4ZvuEk8aoSH9PBk9mBlG+bY0F9k6Ih+ptw0A
	 xcFq6vOrFK22K7qn1KpW5twLH8rUci9gow8ZyXqmR5tkJqSev3TCxST/1wYxp5ZJFXrK2
	 o5wzwHlRujqseCkF5V7dkHNN9g5mYvwhx7Xgi2iJNvcC45OcwhDwpdJ+AK1bOEyhMRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nGlvK2Qm6UV+gD/DGgyd380h3l2Q0OUA/oLwOVR/jNI=;
	b=wxLA+wrm4Jrwj2HNodwGZpH+9u7NeHSVn+szcb4ouX6HEHwbt1lRXSfRqAf+n4VjD9G9
	 Jd6HyvAcHhrRIXA7SPl89pPbxYueuidsjdntngKLYJEKgya5uD0uk6zjF0PsTaVjhqLAC
	 8UBEyqRUKPf/F91R93Ar5VZNs01ucjn33JljbaXZV4kGHZITxgRZfYzAQRBnpLJfij0Ti
	 2N0b3Mne0bZmznfDEc0Zh9XOgEMSTzKei4C+fT2AbrFpmLoP7xVoeEeTAZoWBhTVX6tm9
	 T5U6rMQdlXFXbgC2ms/cBYTT8gRh4xHZMjmNj1YX64MzSknX8eqWSZ/CTPKgH7uWTrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nmRLg6CI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7DA60A2605;
	Thu, 19 Nov 2026 02:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nmRLg6CI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633F11F000C9;
	Thu, 19 Nov 2026 02:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055257;
	bh=nGlvK2Qm6UV+gD/DGgyd380h3l2Q0OUA/oLwOVR/jNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nmRLg6CIQWjB4Nk9dFsWO1u01ZVgKaybqFomH9POJNKySe5M3EGfHEaXubfXZEGpj
	 BvFM/5uQ42jMwnus6q3DbWbCEdE5Ned+zerLayE4uPiw+B+LYElJxectlqE0KM5cnR
	 +PobDXglN51n3oX2bIhKVpODYDQKmCrlZp9psCPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1568/2214] swim: add helper for disk cleanup
Date: Wed, 18 Nov 2026 15:54:04 +0100
Message-ID: <20261118150114.777772864@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit 4e9abe72530a2baf5f80d60e8d0bcdb84964d2e4 ]

Disk cleanup can be shared between exit and bringup. Use a
helper to do the work required. The only functional change at
this point is we're being overly paraoid on exit to check for
a null disk as well now, and this should be safe.

We'll later expand on this, this change just makes subsequent
changes easier to read.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20210927220302.1073499-9-mcgrof@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 994a778d9665 ("swim: Configure parameter memory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 2934b7dc02bb2..f32fb9b388c13 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -783,6 +783,17 @@ static const struct blk_mq_ops swim_mq_ops = {
 	.queue_rq = swim_queue_rq,
 };
 
+static void swim_cleanup_floppy_disk(struct floppy_state *fs)
+{
+	struct gendisk *disk = fs->disk;
+
+	if (!disk)
+		return;
+
+	blk_cleanup_disk(disk);
+	blk_mq_free_tag_set(&fs->tag_set);
+}
+
 static int swim_floppy_init(struct swim_priv *swd)
 {
 	int err;
@@ -848,12 +859,7 @@ static int swim_floppy_init(struct swim_priv *swd)
 exit_put_disks:
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 	do {
-		struct gendisk *disk = swd->unit[drive].disk;
-
-		if (!disk)
-			continue;
-		blk_cleanup_disk(disk);
-		blk_mq_free_tag_set(&swd->unit[drive].tag_set);
+		swim_cleanup_floppy_disk(&swd->unit[drive]);
 	} while (drive--);
 	return err;
 }
@@ -924,8 +930,7 @@ static int swim_remove(struct platform_device *dev)
 
 	for (drive = 0; drive < swd->floppy_count; drive++) {
 		del_gendisk(swd->unit[drive].disk);
-		blk_cleanup_disk(swd->unit[drive].disk);
-		blk_mq_free_tag_set(&swd->unit[drive].tag_set);
+		swim_cleanup_floppy_disk(&swd->unit[drive]);
 	}
 
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
-- 
2.53.0



