Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D97326928;
	Sat, 12 Sep 2026 07:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198865; cv=none; b=L2JarAtSWIgbjmncHlJRDD4lWVLw3N+bxjW4MPrIKWWvHXxNgO/yY/bALR8M18mvkJkuyxv5Kf7JiypSgHCzeHWM4hdQ8I+t44g99OHJhHxRzVqIGZ3Sws8HnuNXobzhOuROT9MV6YTVF4pJiWFiimHkbDTHpHiW/fLkj0io83Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198865; c=relaxed/simple;
	bh=YpcYeMytKl0ykXs8puehWGIe9ssI75Qk6s7akw7PjYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3lG899vRAjIoUxginSif92lsSTTO3qes6yCaGocd04jJcGRoALXZeQzfO6s0yEsapOn6diC9/TbVKgpFVnw2oAIcthGG/7JeQb11M7RDN90mWTqIdP5Z6f7DytHE+2PZK37byJLnewEBJqvJ1HRJsYvrlc5QcYT3ZSxzP1cA1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YcrWCuwZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YcrWCuwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A93D1F00893;
	Sat, 12 Sep 2026 07:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198859;
	bh=zJNHpyUTTyYLpwQUKl1sZK/lt9MTq3Tr5GkQpyUqVgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YcrWCuwZ8bGGl6wn5ZBkIWJZ2415eqtaks7xnKhFkuvrqM2hnNA8BJQ5LbSXuk7mX
	 JZ7FtE0Uz+UC0e2fc5l2K9o9XBLYxukGLKZVMaR+8e2+EYyAwA1LMf1OPQ0ivsZaiy
	 66wVsJ8i+HhQfDvfSv38achTgmuqbPhAm0nvJwWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0468/1815] wifi: iwlwifi: mei: pass correct argument to function
Date: Sat, 12 Sep 2026 08:36:58 +0200
Message-ID: <20260912065659.873795991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index c014358593498..b78ab75afc159 100644
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



