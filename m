Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7324D3BD65D;
	Mon, 17 Aug 2026 14:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976052; cv=none; b=sdzc/IJqGkmSpZrpSBepqMhc5kdMbuxJRMMxzOC2K8IQu5t0bd7i5kJk1PAnao+SG3rk/i/QrLcqd51AHDANlXDm5Z5h/cXBUSX4mFv2jSTs0pKV8pjhU69EUlFW2P5i4/cinJqio/oR13uEkn5+5ubdXkUEogyFpXHgrKWEK2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976052; c=relaxed/simple;
	bh=NxbHkeZCzv5P470Ot8dv+pYVP+t7GABdnUt/5Xy4SbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+H6Uf+AFBg4rbGDcBxXPtTlZGsRXmB7+oCNYRsJDn4YHH8TEu/2xNQK7jlj/QBdyyrwp90HOwyX5gFxdMdcFxAz0U7q00DdnnqCuwbNpUyMYP0YkIukvwEEk8ECMHKUGTAkaWtLjcsC/g8Iz7NvYiub2p7VCnhF2YCY3msNSWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VKwUa2+H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VKwUa2+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3D21F000E9;
	Mon, 17 Aug 2026 14:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976051;
	bh=3EWcjiLIouGGDBLgfTw14bIUYHQ9qzgsErBY6QDGsHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VKwUa2+HzBI2tJNiq0gmhxrO8c8eBONE7M4P7qHsSY1GNGhITCj+pgd9h76Jgcivn
	 OAubv0Y321mnBnR79HG4eQ3j+sIjzFY3l8VdDgUOJ4WaofCY9tknXgkH067pWWl0bK
	 cZB3eJO9+5u2nEINYZPn678Bg+rS3RiBEbWUwK00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 201/389] net: qrtr: ns: Raise node count limit to 512
Date: Mon, 17 Aug 2026 15:30:40 +0200
Message-ID: <20260817132547.042839866@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>

[ Upstream commit ff194cffd586cbd4cc49eccb002c65f2a902a277 ]

The current node limit of 64 breaks the functionality for a number of AI200
deployments that have up to 384 nodes. Raise the limit to 512.

Also, the backport of commit 27d5e84e810b ("net: qrtr: ns: Limit the total
number of nodes") to 5.10, 5.15 and 6.1 dropped the node_count-- hunk in
ctrl_cmd_bye(). Add it back.

Fixes: 27d5e84e810b ("net: qrtr: ns: Limit the total number of nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Link: https://patch.msgid.link/20260713145901.212396-1-youssef.abdulrahman@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/ns.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index 440e68601e251..3ebb5d39e153f 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -75,11 +75,11 @@ struct qrtr_node {
  * requirements. If the requirement changes in the future, these values can be
  * increased.
  */
-#define QRTR_NS_MAX_NODES   64
+#define QRTR_NS_MAX_NODES   512
 #define QRTR_NS_MAX_SERVERS 256
 #define QRTR_NS_MAX_LOOKUPS 64
 
-static u8 node_count;
+static u16 node_count;
 
 static struct qrtr_node *node_get(unsigned int node_id)
 {
@@ -412,6 +412,7 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
 delete_node:
 	xa_erase(&nodes, from->sq_node);
 	kfree(node);
+	node_count--;
 
 	return ret;
 }
-- 
2.53.0



