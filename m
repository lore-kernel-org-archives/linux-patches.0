Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09379416139;
	Thu, 30 Jul 2026 14:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423095; cv=none; b=qAaGRR+HzLuGDJeSav+WOL6HOeQW/cFui/pwn8gSRxnbGk/Rikra6jJmo7dNbu1HAp2SaTewMrrPVzl+2h4iemBqwpLDbZXKmO/0Ehwc8rk4lks48td2V70ZN63E8eRCsV9+LL50N/Z3bByadNM0MXGRBSlKicFICUigwzGSQy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423095; c=relaxed/simple;
	bh=qmVPNsc0Fmsi+n7wCMdKnvcuyKyfBWM33SZjeEyltzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVzw0uDitEHAFDasoLel6T0p4WKVmRDcWkcklLoxuQyBVldnLr93Z0VcH9irAiLfSRFT9+w7ZXrbyQEvL2p8NuCcdEpCOHhcIiFpC40uvstOlii6sDRnmbg1LL9IrvgIFG9cscb3TmExUxrUNTo1lsvwQb6S373RHiVWUmtKp7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wd1XLdIX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wd1XLdIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516FE1F000E9;
	Thu, 30 Jul 2026 14:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423093;
	bh=4NIiTb02i2hv/4pyR9MdNFACd3Mdgo8Dyha4rP3FTwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wd1XLdIXFwuFi8AStb3RWGXT/ZyI9KXW5ms76laWeh7TExgYL/p8/E0WE+OoIa/46
	 68edesT1i61CA0ajz1wUqmvio+D72nzoZQ06Oew/IIC11/oranOYDhBT8MFZw80GYE
	 DAiKGCSjqzBXeLBOfnlWpG/+rXFNZy77I41V3OwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 665/744] net: qrtr: ns: Raise node count limit to 512
Date: Thu, 30 Jul 2026 16:15:38 +0200
Message-ID: <20260730141458.400908862@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>

commit ff194cffd586cbd4cc49eccb002c65f2a902a277 upstream.

The current node limit of 64 breaks the functionality for a number of AI200
deployments that have up to 384 nodes. Raise the limit to 512.

Fixes: 27d5e84e810b ("net: qrtr: ns: Limit the total number of nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Link: https://patch.msgid.link/20260713145901.212396-1-youssef.abdulrahman@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/ns.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -76,11 +76,11 @@ struct qrtr_node {
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


