Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5236A22A7FF;
	Thu, 12 Dec 2024 16:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022208; cv=none; b=mTNHQUIjUeo01nD398JyYgu8AkuBRxLHIVXQ5lkzD+vbeQ25Sc6BTuqVOR7xmSmkszyE651vty/mPyyWPA8/TTYrSSsM7smu/0ymFHMpxc7M8grRfRTJv9kqz/LlFdbD4K4FJf9juaSf0JY2ydC6RiBRcTTNXUWDeE225IW+bWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022208; c=relaxed/simple;
	bh=z7138EPhM47uvTroh1fQx49Wvz2UYnF/hIFBDLcGzhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4PSO4M7Xx7Y1UvWukgrMrYt9+qntkPiA+RL1RFo3Y3Y7N03LmaZIg59iiQbwgTV/nu/6GCN611OSGXQCj0b5M7qUVekq4P7l7LIK1L8IQl5fGzVSR8jqMgw+UM5ZmvIRVHaSOPJlU8IKLSMGKTy4Nm7osNbW5d9HHDWii8xZ24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sg16NClA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sg16NClA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C84C4CECE;
	Thu, 12 Dec 2024 16:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022208;
	bh=z7138EPhM47uvTroh1fQx49Wvz2UYnF/hIFBDLcGzhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sg16NClAAGNC+ET4B0a5Bb24vAAsKxykTFLZpKbG9W+Jcrzmy+tMStGph6zzKrUMH
	 Afsl8dotmuQaq3SJHw9P38OOdmQI19UgALvQK0pAQZxOxTTwWdM7E9XBCdJ30yoLko
	 3ol1noOPKfWVg1svPsUkUxZjQwvfuhdK9z7F/qBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 177/565] octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_ethtool.c
Date: Thu, 12 Dec 2024 15:56:12 +0100
Message-ID: <20241212144318.467668778@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dipendra Khadka <kdipendra88@gmail.com>

[ Upstream commit e26f8eac6bb20b20fdb8f7dc695711ebce4c7c5c ]

Add error pointer check after calling otx2_mbox_get_rsp().

Fixes: 75f36270990c ("octeontx2-pf: Support to enable/disable pause frames via ethtool")
Fixes: d0cf9503e908 ("octeontx2-pf: ethtool fec mode support")
Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index fa4b2d833d77b..db4a9fc399f3f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -326,6 +326,11 @@ static void otx2_get_pauseparam(struct net_device *netdev,
 	if (!otx2_sync_mbox_msg(&pfvf->mbox)) {
 		rsp = (struct cgx_pause_frm_cfg *)
 		       otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+		if (IS_ERR(rsp)) {
+			mutex_unlock(&pfvf->mbox.lock);
+			return;
+		}
+
 		pause->rx_pause = rsp->rx_pause;
 		pause->tx_pause = rsp->tx_pause;
 	}
@@ -996,6 +1001,11 @@ static int otx2_set_fecparam(struct net_device *netdev,
 
 	rsp = (struct fec_mode *)otx2_mbox_get_rsp(&pfvf->mbox.mbox,
 						   0, &req->hdr);
+	if (IS_ERR(rsp)) {
+		err = PTR_ERR(rsp);
+		goto end;
+	}
+
 	if (rsp->fec >= 0)
 		pfvf->linfo.fec = rsp->fec;
 	else
-- 
2.43.0



