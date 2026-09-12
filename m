Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5449530D40D;
	Sat, 12 Sep 2026 14:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223401; cv=none; b=r1b3WTmKOVWlnGdOBCFpTvgtYLS224aK8yULNCGnWnBgKWSZxSHe0pTerexGIwknQJrEWXQKj1hnO5gl3v+09yYWhUSkrhUdBBhTLDVpRFz4FQNzGf8ZvGlfEA8rpkJitNxxGnW/HMzVbnPm4WffSi+RTCE04mMuf/on71mfRBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223401; c=relaxed/simple;
	bh=cAw1Q2qR2w276lhgcSlf5yNdXdcru7NHsslaB4YjTnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhLG0DGKo5IG0OOw4r2lzsW52RPtsEvl+HWxbJFInp/ZITSGfYx659fcMZpRiE+EAjS0zkIY9sGShmvSo9cOOkp2245zxSX+BObk9FE46eT0MVGfPMePfwIeMCri3OgHULV0H480iOAjH6wJWq6OcUeYsyT6B4NLHMcWC5YlfBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJNJwhrG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJNJwhrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B8A1F00893;
	Sat, 12 Sep 2026 14:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223399;
	bh=YulIWXFUe1mo7uZn+p93lSxny68rgHye/pVfwvWufMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rJNJwhrGcQEZjBth3x+C16M8il0b7OqKsCJRqnm02eY6KX0m/HpGPmau0lDvKn+kn
	 hBmzFQKjqKCva0vI+JdkB5MAe2ET7SKufBy+6COKwrbeeejWA9eoWv3K74tOry5J1K
	 WxnOjPzAD892mTx9YHvV08ur5wlO6u0zddeSPY0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0783/1424] wifi: iwlwifi: mei: pass correct argument to function
Date: Sat, 12 Sep 2026 08:53:35 +0200
Message-ID: <20260912065624.832977747@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



