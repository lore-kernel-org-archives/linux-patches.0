Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7C3223336;
	Thu, 12 Dec 2024 16:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019384; cv=none; b=c7VzWrlLkfbH3emGXtGsoh2H4y8iKr9/arVXz3zEvib9BaNl6HXvcBW1/D2OJCTRN+qmeJ4Gci0DKyxBdklnCx05eDcj6okaC/vSqckHQCRmoCjyWH5Lv0AiEv21Wtz8wN4km/eQbxF2zM1vSMF/X5Z1R1XRdbkvGfjJSFVJc6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019384; c=relaxed/simple;
	bh=XGNKLJRb8s/cxpxGshfF9VVc13yCaiT6XFMfIiglE5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVpZpTx9P2l/ADHqk14NEAC6HfZxCo3wOgUGZowauGbF58HiqsNrBm0lPFwkH3ikaQenzNtQ3PgbIVnIvJ6qQjKWE6J7w8ujDk2T39BgVwS3obcw2ZAYPfxU/DGOU8VzCKnwJ1paN8ft+asd8GAyID8LTz6K923+LCgCB3/2rcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cAY+dviI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cAY+dviI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F6CC4CECE;
	Thu, 12 Dec 2024 16:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019384;
	bh=XGNKLJRb8s/cxpxGshfF9VVc13yCaiT6XFMfIiglE5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cAY+dviIJ83tXuxs87B05VTGHD1k1XykJDjLctP/mfHRAkIgubQHhO2vUWhDqwsTl
	 16vEA38YeLgLu442q4phJRrWGnUhiuj9+SJ3XNhXnk7JqUkLjmbNsydBEmhl1dEL7F
	 f+hyXxbxhITyhyTTFu9ul2nMBDB59H2LlSUZC38A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 163/772] octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_dcbnl.c
Date: Thu, 12 Dec 2024 15:51:48 +0100
Message-ID: <20241212144356.674849437@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dipendra Khadka <kdipendra88@gmail.com>

[ Upstream commit 69297b0d3369488af259e3a7cf53d69157938ea1 ]

Add error pointer check after calling otx2_mbox_get_rsp().

Fixes: 8e67558177f8 ("octeontx2-pf: PFC config support with DCBx")
Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
index 28fb643d2917f..1a13f003f3dbd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
@@ -311,6 +311,11 @@ int otx2_config_priority_flow_ctrl(struct otx2_nic *pfvf)
 	if (!otx2_sync_mbox_msg(&pfvf->mbox)) {
 		rsp = (struct cgx_pfc_rsp *)
 		       otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+		if (IS_ERR(rsp)) {
+			err = PTR_ERR(rsp);
+			goto unlock;
+		}
+
 		if (req->rx_pause != rsp->rx_pause || req->tx_pause != rsp->tx_pause) {
 			dev_warn(pfvf->dev,
 				 "Failed to config PFC\n");
-- 
2.43.0



