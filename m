Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76FA44238B;
	Mon, 17 Aug 2026 14:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977189; cv=none; b=Se3MHngXWDgwaXLbzIIv5NHxYEIo4voqC3VLRuAl170DVML4BXd1r2KxzXJ3Kl1NHVo/1Nev50w3g4xds/RBHYryqfZDmaD72FvBlqIlZCU8Iq50srgbItPmXtkaH8DXKeeh6jOFVQkzeTYhiY0N2n6JXlFoSG1uRCwF4VnWMgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977189; c=relaxed/simple;
	bh=V2kJW3cWeTQML50NDCEZOInuabUes1Dptwmf7FSzwYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBvvws1BC9QD6I122qMp4sSto575cMDmnpiJ5NG3agP3etPb9FHYrTA02itOf5symzrc2bjvYPPvfJi+l0lFHAdd5yU4u53y1XeO+YmNwb5wGIwzqiV46pjnlm44goQTRKiQH2EmKLXqzLBEJrB5Op4no2vGvGJUyaoU4vMdfCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4Gevz5y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4Gevz5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B68E1F000E9;
	Mon, 17 Aug 2026 14:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977188;
	bh=ug+JvxljT3mfACeR4RKEHJC8zQ5x/LmslnhVKxCWWPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4Gevz5y73ZXM11OP3wV85f8Gnq0ZahZCs8D7NhuWpLqaTNCbZwBANVB1A4eWacF1
	 kyPrRjvx1bWyb+52oobRiU+X1sUoshZajiUxWW3Ezewqx+64DIkaCLsvTatQ6R4ozg
	 XPgVHJPBIgz+2UJZ2IAQKjQlHqEzbM6/NWMSdjx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 244/456] net: qrtr: ns: Raise node count limit to 512
Date: Mon, 17 Aug 2026 15:30:34 +0200
Message-ID: <20260817132549.628244551@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 91e43b0fd5669..5220529a4c62d 100644
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



