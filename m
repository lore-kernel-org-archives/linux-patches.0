Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051530;
	b=Cf4N7Nk0qNoYSCPRGBlWxv2EvveQkpl0G/EOLbl/DafDL8c1iXVbv5049o3EF7WgcTp1
	 9AYW7/xDYhFE1O9wltZ0+/tIBT0cVJzDaV1MSB0LB3Mvg1DV5gScQFwYQIkWy9XoRulKI
	 8srQYQNd1mo6rFj6IZbkCNr78bCslbFkNbQYBDtW9MD4gZjo5M1m6UBk260mWdoYmDYQR
	 WKnqeySPk+wH5QUGYU7mho63mqlCZaow5pKkwNZBIGCcj4o4uKweHQc70vrgPzkYLSY8I
	 9q5FXwP/AM9YMNk8SeaP0c4t+XE9sVIS8HzMX17bJwZqnMEPTEwupgGlffwzq/mFHgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G9qHG5cmTq10AWj5Rvo14HAhf1p/62/kb3bVfJdEsIc=;
	b=4s2Mmz8URfRfiJzvKpu3MOhQTztaBcKxIBcBYqP6YkaUHwGcNHRRgEGKdnq7o35MpOcj
	 cJ+F92ad0Mq8FIXdqrC9OQjlng0fS1qjutpbFjy2dMSVHt57qk9QnNL/d8u+gNM7H6QGH
	 FvW8NgT9sbSooAOvIU92chfkl/4cbgKoD6FtWZmYPtIn0hsfzvMWpbMbbp542BYyos51P
	 H+B8/SO/ZYvDeePygYuBrM3+Xm/M1WPHgOnjBE+mxKNq5NEr1dvgja2vG//G8LlE7GHMl
	 UV59/4dFnrYu+HTg5Z8gRtq35ScO3eonoEkZnlExL8VhpS0U1/3wHEpf73x/Tu3ryFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pTiUyxxM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF518606A31C;
	Thu, 19 Nov 2026 01:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pTiUyxxM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E101F000C5;
	Thu, 19 Nov 2026 01:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051530;
	bh=G9qHG5cmTq10AWj5Rvo14HAhf1p/62/kb3bVfJdEsIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pTiUyxxMkmuMY0d9+lsal0xPOAlCs/3uYPY6zIsEdP1ax3RJpgY9qXy0PrJ8MGOvV
	 96RPiUu5ngQqtl4b8G4pVt6e8XWJhk/Utp8BGbbp2rvkqwW9+G9O5Hr2ZeSj9Z50Bn
	 l/R/KucqtvyobJ5lVL9pN6wKFjQx1KIAerIngzOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0240/2214] nvme-fc: do not warn on controller removal race
Date: Wed, 18 Nov 2026 15:31:56 +0100
Message-ID: <20261118150019.786991872@linuxfoundation.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 62b70e6c87121ae5b79ca20c3a5b005590336ec5 ]

In nvme_fc_reconnect_or_delete(), the system attempts to remove
the controller when reconnect limits are reached by calling
nvme_delete_ctrl(). This call is currently wrapped in a WARN_ON().

If a user concurrently deletes the controller via sysfs, the
controller's state may have already transitioned out of the
CONNECTING state. When this happens, nvme_delete_ctrl() correctly
rejects the operation and returns -EBUSY. Because of the WARN_ON()
wrapper, this race condition triggers an unnecessary kernel warning
stack trace.

Remove the WARN_ON() macro around nvme_delete_ctrl();
this allows the system to safely ignore the -EBUSY return value
if the controller is already being deleted.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 0336f971543b7..10d45906c5ee5 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3326,7 +3326,7 @@ nvme_fc_reconnect_or_delete(struct nvme_fc_ctrl *ctrl, int status)
 				ctrl->cnum, min_t(int, portptr->dev_loss_tmo,
 					(ctrl->ctrl.opts->max_reconnects *
 					 ctrl->ctrl.opts->reconnect_delay)));
-		WARN_ON(nvme_delete_ctrl(&ctrl->ctrl));
+		nvme_delete_ctrl(&ctrl->ctrl);
 	}
 }
 
-- 
2.53.0



