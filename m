Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AB71A682B;
	Tue, 16 Jun 2026 15:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623621; cv=none; b=a2olpkRSAwIT20C6xbo2XGeYInfAvWKaHn4VZ5IPjVd9VkvR1mjeve1bV570cpeYSPF3rrSx3GQLA1tF0KhC8+lYiU/+Naw6bC8VM69OZfRoCdudOYFPBwqPnfyBGBYna2qQCB0dJoIJ0ziG7B/hgB8DwxYpnY8YAiY4Z45rXNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623621; c=relaxed/simple;
	bh=Lbzm4sGjsFhgXmB7c4jjuuQ6+DL29hQOQ99VVSplUDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIfhmo6Aod748B9v24Y3P30xyUrWCh7x4Iv0HjOKA++5Cb1iN+ZSrn2CkhI2nrIupt5+wQjURP9BlYR4k8l4DG9gFrd0HjTmk8xbKS5PXrB/DQtRxCIuYXBjX1k+/1BHr0qSlVrsSWFt+7trep4x+tEOoA0u1IuKvy2CuOngllM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osVU/F6t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osVU/F6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1A01F000E9;
	Tue, 16 Jun 2026 15:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623620;
	bh=tHCCVQbEtHzVUWqGUnfDuf/mEW//3/5rCANHw0UKTSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=osVU/F6td3m0YTfzWqXM5LM6SX18hfsFE4WaPExdcQJbOIPyLVuvoVhfl6zx4T+NY
	 +QQTADUYEwI58UCbTfBp3/U+dWufklHQWzj67SrchJxXYNL5+ss0NUjb+wnAiLy79W
	 NFrOH9ZPmkfRXE0OxO9fwHvV+muIg55v0+4nwn3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 150/378] net: txgbe: initialize module info buffer
Date: Tue, 16 Jun 2026 20:26:21 +0530
Message-ID: <20260616145118.149106506@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit 0487cfca46517ff6699c72dc1a8872b0af3c31a9 ]

The module info buffer should be initialized to 0 before the firmware
returns information. Otherwise, there is a risk that the buffer field
not filled by the firmware is random value.

Fixes: 343929799ace ("net: txgbe: Support to handle GPIO IRQs for AML devices")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/20260608070842.36504-2-jiawenwu@trustnetic.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
index f0514251d4f342..a7e81f9e1be148 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
@@ -335,7 +335,7 @@ static int txgbe_qsfp_to_linkmodes(struct wx *wx, struct txgbe_sff_id *id)
 
 int txgbe_identify_module(struct wx *wx)
 {
-	struct txgbe_hic_get_module_info buffer;
+	struct txgbe_hic_get_module_info buffer = { 0 };
 	struct txgbe_sff_id *id;
 	int err = 0;
 	u32 mod_abs;
-- 
2.53.0



