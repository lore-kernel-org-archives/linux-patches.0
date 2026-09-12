Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CCA47C106;
	Sat, 12 Sep 2026 16:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229637; cv=none; b=FrDu17QXu83y4Ck5SSxFfB8kAKlKD8YCaPLFz12cvk+FTGICsdn/4kEKHAgEM3KS47TvpHCi344mNp5KDqkvW7CXsSoQ2xQ+Q8VuGoOtOWnoWttIQDnMWHFwU+Fq303t5BaNoU4HuGpj7NqevI3VIt50HRA2dY3DPbRdGsQTiVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229637; c=relaxed/simple;
	bh=7nD79cSGVxp8bqe6jcv3CTyyzjj0WJiwoTwqUUqaH5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOeekuQJMxxy1LhlV0jQMZuNsqwfZJ7F2YanYGuQAOdr1dEZEXMdowYeN/D+QV/F9sfCirMR5rc4pzR6t8gmMTkoNwO/QwRH4zHLJx552msFkbrE5H3lOzLAZhSEsswtIDmHbitv50KpF+MRnpma8HLkWEsuKHZNXvY8Na1rUiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYDpkMdN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYDpkMdN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E871F000FF;
	Sat, 12 Sep 2026 16:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229634;
	bh=6RswpqmOW/CL4D+BJ4FIkI6S9huCYG5VCz6D5aBVTfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UYDpkMdN0wghFsfs+5sNLCedLhfai08X3wnPCKNASaEtHIQ0Vbzp6lVAy6oHGDUbm
	 ajpkQ8yaajXebEvtznMuXyFBHWpaxlUAYCjbKzRzhwDkTl1fQ+FxlZ4vyqNJBlIFHy
	 WHXv2Tfdn14c8ai2H/ohBzbxu9q4wCNgVwsP5Piw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0629/1191] wifi: iwlwifi: mei: pass correct argument to function
Date: Sat, 12 Sep 2026 08:55:57 +0200
Message-ID: <20260912065602.381678964@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 56d4b16ad4888..6719a1f892717 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/mei/main.c
@@ -446,7 +446,7 @@ static int iwl_mei_send_sap_msg_payload(struct mei_cl_device *cldev,
 	notif_q = &dir->q_ctrl_blk[SAP_QUEUE_IDX_NOTIF];
 	q_head = mei->shared_mem.q_head[SAP_DIRECTION_HOST_TO_ME][SAP_QUEUE_IDX_NOTIF];
 	q_sz = mei->shared_mem.q_size[SAP_DIRECTION_HOST_TO_ME][SAP_QUEUE_IDX_NOTIF];
-	ret = iwl_mei_write_cyclic_buf(q_head, notif_q, q_head, hdr, q_sz);
+	ret = iwl_mei_write_cyclic_buf(cldev, notif_q, q_head, hdr, q_sz);
 
 	if (ret < 0)
 		return ret;
-- 
2.53.0



