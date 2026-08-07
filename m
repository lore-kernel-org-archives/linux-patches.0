Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007C1332EA2;
	Fri,  7 Aug 2026 14:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113970; cv=none; b=nw7dQOfhHQe9nKXYxHNmekOSG661lTVd+52o1QTLXNju89Soqs0sebxwdlzwZObswShhLcpfHmnsSEaB7LK//hh2yicMeF8y8cCcAh2RznPcWmNSACCTxsMAL+9U1pEwJfndTLuJ9B4VoMOhkhlQ65s8A6QFo/8qUv6JUNHwids=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113970; c=relaxed/simple;
	bh=ADprrnPzR7Hyl2EsfTREpJlvtQrIztmPCVuU7QeFoE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edjmqUL1bniZvNgFOQtlMPwObICqgW24w8sBOVBxRcK0Ogi4+DS0uILSIU9Cxhph9wg+SB9XQyE3rgvxf+ig5x+4jRmgEJSF00SVQfrz60TSbJV6+hSigoYROf+CoB/3S2Txubhe1s1ekq7QhAvrPr7ll84ek8txAhZ8OGuqKuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCmTe+WP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCmTe+WP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D69B1F000E9;
	Fri,  7 Aug 2026 14:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113968;
	bh=tKuHEbgELxx5Zof2ZfafwPomtIQj5PIAK1K/RLWDitY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gCmTe+WP0SCMXRkm6BvO/mO2LSmFo6Qs9upHr/vGG+PH9qOvsCJQXqzC6lR+E4RPX
	 A4Gs6icQoRyK1Gcc+xUeHCBAUpMIQdYk4Eg2lGmReG2GQWi2BLUlIT/o5ChCennvSr
	 HMMugTXae+xhuBUxuX5/m7RRtCCuGZ4TXxb8g+m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/337] Bluetooth: ISO: fix timeout vs sync_timeout typo in check_bcast_qos
Date: Fri,  7 Aug 2026 16:35:01 +0200
Message-ID: <20260807143420.665346029@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit e9cb51813d79fc9aae4a2098aab3ab6ebd7fb6c8 ]

In iso.c check_bcast_qos(), missing bcast.timeout is not set to its
default value, and appears typoed as bcast.sync_timeout.

Fix the typo.

Fixes: b37cab587aa3 ("Bluetooth: ISO: Don't reject BT_ISO_QOS if parameters are unset")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 1d3e4616ee700..c54e42ab6947b 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1636,7 +1636,7 @@ static bool check_bcast_qos(struct bt_iso_qos *qos)
 		return false;
 
 	if (!qos->bcast.timeout)
-		qos->bcast.sync_timeout = BT_ISO_SYNC_TIMEOUT;
+		qos->bcast.timeout = BT_ISO_SYNC_TIMEOUT;
 
 	if (qos->bcast.timeout < 0x000a || qos->bcast.timeout > 0x4000)
 		return false;
-- 
2.53.0



