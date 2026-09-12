Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5703624A5;
	Sat, 12 Sep 2026 10:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207496; cv=none; b=TQITU+vWn8+FnG3shsl1DmzwShdRwNq40LktHRkoqmFskC440RyvdXym3ggYQW5SaPnW6olSZ+92sXLUzWrf6FLz9pNfsTLwd56W9o1lGSbA1vedsO8zdZvwD65K4nTHdyp6r7aWOAU2qTAK4f7B4f4kdIyYhBbksxJhrQ1TPEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207496; c=relaxed/simple;
	bh=fy7OiuiFCSzCerQPijhOMq7x2NsWubWetK+gh4Kz5pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meid9pWejbmxicaeUOV05wwBeSks9KyTV7l9u6XQ3eQvyNFRA+d6X6iu5ZnlJqgduLiAixM1soOrLOq+q3ix/S+Nah5pMZ93Vu9L2V7FQwQCHAvl3D6NMvYDG7HUvN5wB80XaG9RaRgPZqZSsbdre7NS+yiEg6o+Y5KuUcghZrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f//LhTZJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f//LhTZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A841F000FF;
	Sat, 12 Sep 2026 10:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207494;
	bh=aub6dNXxo6/NMRvJDNaoUCugEGcLz/l7pFZb1adCano=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f//LhTZJJpW0SOPWdgHckLoh7yOKqvHWnJKbvUN46yd4CAYfQtnPbhjj1pZhW6VG4
	 zptsA364LNOBlfQjICvmgQLK/oNKmXruSR2sUabZdSNBigW7iVZD+xUZv62L+xEqQs
	 ZXO1HQz5moQ/xopnmwYDFMmQo58JBTrc6c2Blxdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0425/1518] wifi: iwlwifi: mei: pass correct argument to function
Date: Sat, 12 Sep 2026 08:43:14 +0200
Message-ID: <20260912065633.064004483@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 905f57aefde4f4092a411c8a55856182fb1c7598 ]

The first argument to iwl_mei_write_cyclic_buf() should be the cldev
but the q_head pointer is passed instead. Fix it.

Fixes: 652291601459 ("iwlwifi: mei: don't rely on the size from the shared area")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715220243.24cea60c6428.I42301010c31487b1458faa967b22c8320b0cfd23@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mei/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mei/main.c b/drivers/net/wireless/intel/iwlwifi/mei/main.c
index c083af5240593..1486702d37e75 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/mei/main.c
@@ -458,7 +458,7 @@ static int iwl_mei_send_sap_msg_payload(struct mei_cl_device *cldev,
 	notif_q = &dir->q_ctrl_blk[SAP_QUEUE_IDX_NOTIF];
 	q_head = mei->shared_mem.q_head[SAP_DIRECTION_HOST_TO_ME][SAP_QUEUE_IDX_NOTIF];
 	q_sz = mei->shared_mem.q_size[SAP_DIRECTION_HOST_TO_ME][SAP_QUEUE_IDX_NOTIF];
-	ret = iwl_mei_write_cyclic_buf(q_head, notif_q, q_head, hdr, q_sz);
+	ret = iwl_mei_write_cyclic_buf(cldev, notif_q, q_head, hdr, q_sz);
 
 	if (ret < 0)
 		return ret;
-- 
2.53.0



