Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053076;
	b=KMXBcHsLhgWFT6gcRiHK5BLTJRui7OoAX02aQdpC/96V0p/yotQWK86hAAPNflnyXIuV
	 BDEvTTVJ3anEHnZfk+y/bU/3BcBtOH+Fc6/eDbqv3M8rt/cZSnXcK//CXFzRqfpCMeQ5d
	 X4TvpHya29ZuHX7IwdWZERb3Idb1rUIBnmWIXy7iOpFunvCZCG4sKRpfHhp/FZpIHZ6Yr
	 j47iXJyutzr27bziSjU9ApKkiGPTPPAEH4ccpQfc+hP8CFBGFpG8M2uoAf8Oj+pJT9tCs
	 ifCDGVVEKhV6r9nwN7fKuM6mpUBFMgfYJWybQLczDy3ro5Fw6OD71yFuepPTmU2+Gjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tYCf+E8lzREyNy5yk3gAglvciEPT01bngkEtrpbVr1E=;
	b=DrgRZf8jH4r0x2Se7RXKiOnZkcwEGUY6I6YDxuc8V+Af6+sPzXMqt9AskBUTjxE4f4Y0
	 4GvOAlxGPaxedGBVXfT7NG+QfjW+/LgnjxG73Zj+nB5iQw5YeKu10q3B/GP69gPBMqPZd
	 hElKccd4vUq3LV/BfnjiHw4kpiG7gCo+xcBCb+LcLpR0w4lgk1qbhsJc3J1vIh2LaK9eW
	 D6TpTc/xiPwTopTLEFJtluPZv56oFSO5VeUmGQz8RCY7fyxvG975YN4AlbbzikiI307RZ
	 hpcOSnuYb+vfTUR64wGGRt6KiWUn7IDu3IfbraCgtJlltOSg5thbdRDGUQVSu928iIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x2kweuJ3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93740606A325;
	Thu, 19 Nov 2026 01:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x2kweuJ3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77631F000C4;
	Thu, 19 Nov 2026 01:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053076;
	bh=tYCf+E8lzREyNy5yk3gAglvciEPT01bngkEtrpbVr1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x2kweuJ30iZODRZwWmLBzhx3DKoEUKCEpqH7DeREou/lJ7gq+aMNyS3r9CZ6BIXlo
	 AkrEbC05jBDExpLctphcuw0D2b5BZt/HiIYiVO44cKruhXIScszY6mDH9IkvG7bxcR
	 Zc8OQozIHz3LT9S+mZRF6duwHmHf7+sWgONCmJoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0741/2214] nvmet-fc: Tear down the association when the admin queue allocation fails
Date: Wed, 18 Nov 2026 15:40:17 +0100
Message-ID: <20261118150041.465771293@linuxfoundation.org>
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 11db8ab55e1a7533e9cfe57687ab142ba67d3c84 ]

When the initial admin queue allocation fails after a new association
was created, nvmet_fc_ls_create_association() only drops the
association reference, which frees the association.  By then the
association is already on the target port's assoc_list, though, and
removal from that list only happens in nvmet_fc_delete_target_assoc(),
which this error path never calls.  The freed association stays on the
list, where later lookups and the port teardown can access it, and the
target port reference taken at allocation time leaks.

A remote host can trigger this reliably with a Create Association LS
requesting a queue too large to allocate.

Schedule the regular association teardown instead of dropping the
reference directly.  The teardown removes the association from the
list and releases the target port reference before the final reference
drop frees it.

Fixes: 0cab4404874f ("nvme-fc: fix a missing queue put in nvmet_fc_ls_create_association")
Cc: stable@vger.kernel.org
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index adb6a207cf2d6..28ad8de903ff0 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1681,7 +1681,7 @@ nvmet_fc_ls_create_association(struct nvmet_fc_tgtport *tgtport,
 					be16_to_cpu(rqst->assoc_cmd.sqsize));
 			if (!queue) {
 				ret = VERR_QUEUE_ALLOC_FAIL;
-				nvmet_fc_tgt_a_put(iod->assoc);
+				nvmet_fc_schedule_delete_assoc(iod->assoc);
 			}
 		}
 	}
-- 
2.53.0



