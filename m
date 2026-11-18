Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043231;
	b=sU6nn6KMmtu0+p/hf96YM5uTsIMftT8L6406r3bybIjOROTsKip0TxCE16qp+LKsuLaR
	 JREqIUPwtDBHdcPMJYo+rcGO/uPHn9Y8unMnZTPIxQVVIl4/xNLqR+pd4nmIuv7AQF0pD
	 GbR2QaHsyXMahOlpQQDtTi03X/6aPAjjReb1F798cP+yFK2yyxQPmHaG+0RkowzfOwA9J
	 HhvBS5U3GavsoOkCy6m3TjXZl2L/HvlPP/7YHInnH3mTN4qYdmHbceF5ZRumv0iGZ++0M
	 0EQweyyIkMPKPWhGASQWLJ+XuawLgMK2WKfc7PxrWc4YDIVbhok6D4QLQSN0A1Wtgpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043231;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NTKiDpuKGfuxQd35oMA/3Klrf/QnwAxHHVXSbb7zIug=;
	b=WiKHnR8fK8WB6wAQVcweC4B9ZVgLkDX0oi5SAdjSKl3de6t6Q8bhqr2PGJweSWO9EXbB
	 UHEc0UNsUDyN+5MDF1mVbKMseBMmGqSX0XpnRCX406NVio8xgS177H1BPrL6/0g5qye28
	 YXyxy07493g6hwwxdCteST53UeJnN/nfUGbQxKawbc9I4Sf08qYntcvv/HhiuROzSQlKq
	 AIpq+IrpU1NoiGux1ZjaWz/guVSjSqPDOyyWB6M0M70xNljv4XnD28WNKKo6MrdpHEdLz
	 2TnDbrU60F0m024cx21qrsOdEjejMJRgYW0s+RyC9yi/C9xz8GeGVWzmokwS6yUfv3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1yCQWyPr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A63606A31C;
	Wed, 18 Nov 2026 23:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1yCQWyPr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE43D1F000C4;
	Wed, 18 Nov 2026 23:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043231;
	bh=NTKiDpuKGfuxQd35oMA/3Klrf/QnwAxHHVXSbb7zIug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1yCQWyPr8dYrlBguUbPomq82ptMdVRAbXzQOFZqiFcH7K0UL05Yq97E3SJrpHuUUx
	 1EDXBG4v77fvgT9TYirWy9HPBBUMI9eW54klt9w0/OWd97FEcw6pxWKTMaiNU3Nj2z
	 jRPf2aftFIUC3VTpvwnvnTdEu//aCXUaGLfeFjMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Yuyang Huang <yuyanghuang@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0136/2857] net: prestera: ignore duplicate RIF destruction events
Date: Wed, 18 Nov 2026 15:19:30 +0100
Message-ID: <20261118150206.251136013@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuyang Huang <yuyanghuang@google.com>

[ Upstream commit 3cbbc9fa33382d03f2813118e672eb318eba9cde ]

During address teardown, the inetaddr notifier may be called multiple
times for the same interface. Ignore NETDEV_DOWN events if the RIF has
already been destroyed, rather than returning -EEXIST, which aborts the
notifier chain.

Cc: Ido Schimmel <idosch@nvidia.com>
Cc: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Yuyang Huang <yuyanghuang@google.com>
Link: https://patch.msgid.link/20260711005405.2861680-2-yuyanghuang@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/prestera/prestera_router.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index de317179a7dcc..e36d023fe9c30 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -1302,10 +1302,8 @@ static int __prestera_inetaddr_port_event(struct net_device *port_dev,
 		dev_hold(port_dev);
 		break;
 	case NETDEV_DOWN:
-		if (!re) {
-			NL_SET_ERR_MSG_MOD(extack, "Can't find RIF");
-			return -EEXIST;
-		}
+		if (!re)
+			return 0;
 		prestera_rif_entry_destroy(port->sw, re);
 		dev_put(port_dev);
 		break;
-- 
2.53.0



