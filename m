Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3CA1F7547;
	Tue,  3 Dec 2024 15:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238465; cv=none; b=fRZYT+KSKz+3s4NXvNpNIzGBhSP5CMGu7tSKt7aKbpXMNXPfa0LuZIuHFf7iDcP9/R9hPhbHhDKphJBfn9zSs+tZ2uC1K4ec+RMOKhLMp9G59dvSUxdrPGKxFyFAQIxdiVmC+xs6TUTMU3RXmvJxnTI1A9AKJe+1R/F/TiZpkn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238465; c=relaxed/simple;
	bh=a11dov/IHx/T8FK8CUdK+ulG6wex4qFRvw1RgJvKoK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1WPp9pVh0AC1IePIh7SgJQatbN6DTvi9UqP/KH5iOxRCzK3KEwd423bZtNbCL57y3lL+vNjz1QBoRhKN3cQYvRJxH7KYAhH4HzGpydx9scvRRifGFUUNda9sasLkZobLNV8GMXfVUzjdkWDG/5VnFVBA8B2D3CJk8cnwfi5Sms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQQuRoiG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQQuRoiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC81C4CED6;
	Tue,  3 Dec 2024 15:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238465;
	bh=a11dov/IHx/T8FK8CUdK+ulG6wex4qFRvw1RgJvKoK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQQuRoiGDnIOTVPaGQulg5FQ3Q8AKLjQNWI0Tr/psmRZiShzU2m5zO1gGO52MMLv+
	 A0vBWOlwIBnuVPZ7SQEIS3GAHsKJzs7xe3esIl1hTTDHv0xl9BbtvccSqGjlMpJh4K
	 ql1UbvG+wzfy0JO9FYcGg6k45X47VMiZvtKlrPao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 287/817] octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_ethtool.c
Date: Tue,  3 Dec 2024 15:37:39 +0100
Message-ID: <20241203144007.012504679@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 0db62eb0dab3f..09317860e7382 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -343,6 +343,11 @@ static void otx2_get_pauseparam(struct net_device *netdev,
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
@@ -1074,6 +1079,11 @@ static int otx2_set_fecparam(struct net_device *netdev,
 
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



