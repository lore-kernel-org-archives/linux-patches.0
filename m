Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1490932ED31;
	Wed,  3 Dec 2025 16:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780565; cv=none; b=faNn3W4PBVbP9+KbphC7a2NYz/nOVpCnXhVJWUMFmDKRu+6MqmojyxKYu3dvMDTeqRVwkPul8Mullgjh8wKgfwneAtK5dGKRrAhmebbkbGBNX9VNyBuoOxxk5IL1bhiqJQPIfBDOmL9bw0qcsjpJ9TImSHWLuCMZPnfSwUchUa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780565; c=relaxed/simple;
	bh=XGFuerGFAykOzRSaVVJ1paw0EZBNsWgrLPPTI/P0vX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXHP2IYcpet2EgHKMnSoaejNuQLlP0DSkadv6O0ixTy84ctm4E6QM7VAVZGUH1lQueMMbo+ErhI3Qdu+juqOCYvpJ4TcO69PX7wTrl70qwqHYxWefia4Aiu+POqSIeOZPjEsdGoYxibUmVzSNOYBWaTwg06khbvuR+uMPyIOKa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7phpftN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7phpftN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14572C4CEF5;
	Wed,  3 Dec 2025 16:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780564;
	bh=XGFuerGFAykOzRSaVVJ1paw0EZBNsWgrLPPTI/P0vX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7phpftNWGPBIDRUU5mjovAIr/8DOWd9s6BsbLAoMutlwOjRvE83YHG7i9h0teK3q
	 Fo9+h4kEtcG+MHIrW7yxzGOxz47TV4SAG7ascNW4ML3b78IjOuW5M3zGG/OVObJ4X3
	 3rk8Tt2rIMU3aASgUcdZ5P79k+rlMNpdHSyOn02g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slark Xiao <slark_xiao@163.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/132] net: wwan: mhi: Keep modem name match with Foxconn T99W640
Date: Wed,  3 Dec 2025 16:28:22 +0100
Message-ID: <20251203152344.158452645@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

From: Slark Xiao <slark_xiao@163.com>

[ Upstream commit 4fcb8ab4a09b1855dbfd7062605dd13abd64c086 ]

Correct it since M.2 device T99W640 has updated from T99W515.
We need to align it with MHI side otherwise this modem can't
get the network.

Fixes: ae5a34264354 ("bus: mhi: host: pci_generic: Fix the modem name of Foxconn T99W640")
Signed-off-by: Slark Xiao <slark_xiao@163.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20251125070900.33324-1-slark_xiao@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/mhi_wwan_mbim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/mhi_wwan_mbim.c b/drivers/net/wwan/mhi_wwan_mbim.c
index c814fbd756a1e..f8bc9a39bfa30 100644
--- a/drivers/net/wwan/mhi_wwan_mbim.c
+++ b/drivers/net/wwan/mhi_wwan_mbim.c
@@ -98,7 +98,7 @@ static struct mhi_mbim_link *mhi_mbim_get_link_rcu(struct mhi_mbim_context *mbim
 static int mhi_mbim_get_link_mux_id(struct mhi_controller *cntrl)
 {
 	if (strcmp(cntrl->name, "foxconn-dw5934e") == 0 ||
-	    strcmp(cntrl->name, "foxconn-t99w515") == 0)
+	    strcmp(cntrl->name, "foxconn-t99w640") == 0)
 		return WDS_BIND_MUX_DATA_PORT_MUX_ID;
 
 	return 0;
-- 
2.51.0



