Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C478E2D595D;
	Tue, 31 Mar 2026 17:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976569; cv=none; b=gdSdhRweprswfx08OAJ0si3Ye3p/14pbaxcHRk9becn1To1E83j5KR09wJT5Ah+b10gnFZZyq0YNFn38yXgX8bOicRbMSdppVXF0CAUOzSGFJs8w8vsKv1gcW8sr+MVqPKdIudVTfY48YoSreA+hgSHp3Djzz91GvIYrqM6D7LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976569; c=relaxed/simple;
	bh=60sYr36zn564hFayDXiWckQG6W+wQTSaXdLdA4+bCX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbgnQzDCtFuKjbcTUuH6QBX9u8kSfVjN3qUUqkDIZOiPXR7FlzdQaN2HFhLm1HZY9EeaOZLNHE+WKy7aV/rGufNZePK8VB9GtPyth8IqULsM6pwtTgWe3Ki4skTGw1s8xtyQnIbL8TNTGyLj1iPY3XVZ8rBKg0IjzFL9f0uZEao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUvMiKzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUvMiKzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BB7C19424;
	Tue, 31 Mar 2026 17:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976569;
	bh=60sYr36zn564hFayDXiWckQG6W+wQTSaXdLdA4+bCX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUvMiKzCIMeft7+HgMbomN2u3a0dm3+xbjFVBFcD9Kl97GxicqrTfBTmpAqRmuSdG
	 R/Of254rAi1BR6bH6/LetSK1hSNyhmXYVYW59G7NQ2jDWyIfklcSqEo4nsgUsH6Hp9
	 NqOaJxJ/w0wSpXlW8pAMnItnyZN7Y3u7Iwru6ZPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Barrera <ivan.d.barrera@intel.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 144/309] RDMA/irdma: Clean up unnecessary dereference of event->cm_node
Date: Tue, 31 Mar 2026 18:20:47 +0200
Message-ID: <20260331161758.773322524@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Barrera <ivan.d.barrera@intel.com>

[ Upstream commit b415399c9a024d574b65479636f0d4eb625b9abd ]

The cm_node is available and the usage of cm_node and event->cm_node
seems arbitrary. Clean up unnecessary dereference of event->cm_node.

Fixes: 146b9756f14c ("RDMA/irdma: Add connection manager")
Signed-off-by: Ivan Barrera <ivan.d.barrera@intel.com>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/cm.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
index f4f4f92ba63ac..128cfcf27714d 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -4239,21 +4239,21 @@ static void irdma_cm_event_handler(struct work_struct *work)
 		irdma_cm_event_reset(event);
 		break;
 	case IRDMA_CM_EVENT_CONNECTED:
-		if (!event->cm_node->cm_id ||
-		    event->cm_node->state != IRDMA_CM_STATE_OFFLOADED)
+		if (!cm_node->cm_id ||
+		    cm_node->state != IRDMA_CM_STATE_OFFLOADED)
 			break;
 		irdma_cm_event_connected(event);
 		break;
 	case IRDMA_CM_EVENT_MPA_REJECT:
-		if (!event->cm_node->cm_id ||
+		if (!cm_node->cm_id ||
 		    cm_node->state == IRDMA_CM_STATE_OFFLOADED)
 			break;
 		irdma_send_cm_event(cm_node, cm_node->cm_id,
 				    IW_CM_EVENT_CONNECT_REPLY, -ECONNREFUSED);
 		break;
 	case IRDMA_CM_EVENT_ABORTED:
-		if (!event->cm_node->cm_id ||
-		    event->cm_node->state == IRDMA_CM_STATE_OFFLOADED)
+		if (!cm_node->cm_id ||
+		    cm_node->state == IRDMA_CM_STATE_OFFLOADED)
 			break;
 		irdma_event_connect_error(event);
 		break;
@@ -4263,7 +4263,7 @@ static void irdma_cm_event_handler(struct work_struct *work)
 		break;
 	}
 
-	irdma_rem_ref_cm_node(event->cm_node);
+	irdma_rem_ref_cm_node(cm_node);
 	kfree(event);
 }
 
-- 
2.53.0



