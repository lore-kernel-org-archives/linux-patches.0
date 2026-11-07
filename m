Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064594;
	b=h1YnbCmv2BqTy7pJBsZPEhtTApdkXloccKxXejUg770mXl3DDBYGZ7/0pV9byXAutiNh
	 hPavKOFndeVx0VQKQk+ORFFW/gvdOboUNyXMsGQKw4KXcKq1xapNFpLyt4BXL7xisUbtj
	 RQdMGLftyvi+9IwomioIuwRGkilJh8QSJcCpG5QGlJrEPAewW0LFf4CHk6OTX3r9L09nY
	 9ZQ6M6VL4/YSOFufIGx/dEfxqXOOurJLfbQfu1yY6FsCY5T6sC6aXmKo3O9seXeYvkSGf
	 gaUG+HeHU6ADZ+Hr72ba/L5z6g3I4kuuBLvE9uaIPDbONg/T+F0POCE6b/HSlxAqLsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+uNluHznprbR0qGi4RDGgZ+gFFV5hdnBNL+zH0C49ow=;
	b=l+doExszrkjy7gFj+0wCMcjeddN91ZkbXkXuKpmHo25ie6a+U4Un/nNxCGlY+SVT+V1w
	 dWEfE4d5Jeolm8hCBRD4uJDZlGpiq3nShkDIV0fuChXzrmKVgbt2AKJJTYNc1jeEZw3xI
	 I302fl2QNTaEx1c8G3wSrv8G5d9cPnfW2iev3s077JLCqE9xCLdSAhnD0pe17k0P/D6pm
	 chowM9OmyQ6Ui9iPP+zE7F1UbSunMXIlyKnIaWKLJpgO7xvIOrtJn8xJpk64MbPt6lRsE
	 vUvkQqYNd7OZtYBA5+nn8qm0qrJ3/tiJb/g6ptNmwfQdWFnucbJKHcYTNyi4g4Al3BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MtbpV2x3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D5D606A9D0;
	Sat,  7 Nov 2026 15:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MtbpV2x3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFE31F0089F;
	Sat,  7 Nov 2026 15:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064594;
	bh=+uNluHznprbR0qGi4RDGgZ+gFFV5hdnBNL+zH0C49ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MtbpV2x3cvg4S4G5NrpUDyAYKG87t6nP613rKVAdO3so1ryVqHGgaNhGyEeXnIvsg
	 n+dPvyWyrEdxX+jjsq6+d4bUWJnyGpsfcPhn3hqsncrch5xKuCw7nctM8gov+Iod2R
	 tqdwmsunllOlF15QkMlGkKNzFzlKrh4e72g3dCU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Lagerwall <ross.lagerwall@citrix.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger@xenproject.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0609/1257] xen-blkfront: Fix IO race during unplug
Date: Sat,  7 Nov 2026 08:48:25 -0500
Message-ID: <20261107134956.129205186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ross Lagerwall <ross.lagerwall@citrix.com>

[ Upstream commit 61b6d1df1d6234c38a6ea7e4f58e7da035ef6ab4 ]

During unplug, blkfront stops the hw queues and marks the disk as dead,
then later during removal calls del_gendisk(). However, IO issued after
the hw queues are stopped but before the call to del_gendisk() will be
queued but never handled. This causes del_gendisk() to hang forever
waiting for the queue refcount to drop to zero.

This can be reproduced by issuing IO during an artificial delay after
stopping the hw queues.

Fix this by simply not stopping the hw queues directly. Marking the disk
as dead already freezes the queue which prevents new requests being
added and it synchronously runs the hw queues to clear anything pending.
If the hw queues are stopped when calling blk_mark_disk_dead(), running
the hw queues is a no-op and can leave queued requests unprocessed.

Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Acked-by: Roger Pau Monné <roger@xenproject.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20261006163411.2583538-1-ross.lagerwall@citrix.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/xen-blkfront.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 86f5dd3aced13..ad0cb42c10197 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2142,10 +2142,8 @@ static void blkfront_closing(struct blkfront_info *info)
 		return;
 
 	/* No more blkif_request(). */
-	if (info->rq && info->gd) {
-		blk_mq_stop_hw_queues(info->rq);
+	if (info->gd)
 		blk_mark_disk_dead(info->gd);
-	}
 
 	for_each_rinfo(info, rinfo, i) {
 		/* No more gnttab callback work. */
-- 
2.53.0



