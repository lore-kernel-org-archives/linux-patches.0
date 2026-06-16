Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0817615B998;
	Tue, 16 Jun 2026 15:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624931; cv=none; b=A0wLnWeUqKyX+Ks0XpFYqsIzDT7NPoef78sr8p9UEBQpArfIlR1JGu2xbqNhoOUph25bls1S4Io4aPEVqOf+ivYdYagm8DP92BqOUfih87Mt/b/GlK8PRFHQBN+g2ZWK+k12ZQPRPHl080U+Rfo42l692N5N1V7oVVnsMVhTZKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624931; c=relaxed/simple;
	bh=M5xDI1Ls+twH9h88sRGPoaKYWH08II9Yahv28Dz/omI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbcaGCo+WFQRwxUu+fhXtT+XdYYhLPIK+0WqR0lc0ozckxveh0Bq5n4MjCTSlojEbCo285IlyXY68K5WVt6JISMQjzH3BjXZytqw53lWT++xcQEFvByMS5ylqqrp380huTlqwzf3ASQm9W/r4K8FW5yCawdSuL8Mp6UVy2vmvxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/7cwS7A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/7cwS7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C971F000E9;
	Tue, 16 Jun 2026 15:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624929;
	bh=SyA2XjyWfOB5E5BF8G6eWBjikyXZKfgtTKaXSLPL89Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K/7cwS7AWrlEXqADbRV2KfAxr+mux1Uwk6C/fPGwa2Hiiu05FoUBEh3cpYthXRjcq
	 5l1Ft5D5ispicKiTWF6JhxLLam9Gx9PZBUX+ZOKX9/yNIqk5vMEfw0nYrcaumzrJp8
	 IBUDiTTe07nbzcPKUAjlX8OprXDwWzw/Gmou9i8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 053/325] octeontx2-pf: Fix NDC sync operation errors
Date: Tue, 16 Jun 2026 20:27:29 +0530
Message-ID: <20260616145100.342362285@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit a910fb8f7b9e4c566db363e6c2ec378dc7153995 ]

On system reboot "rvu_nicpf 0002:03:00.0: NDC sync operation failed"
error messages are shown, even if the operations is successful.
This is due to wrong if error check in ndc_syc() function.

Fixes: 42c45ac1419c ("octeontx2-af: Sync NIX and NPA contexts from NDC to LLC/DRAM")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/1780054677-17249-1-git-send-email-sbhatta@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index bbf25769f4994a..fa23d42d1318b4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -3481,7 +3481,7 @@ static void otx2_ndc_sync(struct otx2_nic *pf)
 	req->nix_lf_rx_sync = 1;
 	req->npa_lf_sync = 1;
 
-	if (!otx2_sync_mbox_msg(mbox))
+	if (otx2_sync_mbox_msg(mbox))
 		dev_err(pf->dev, "NDC sync operation failed\n");
 
 	mutex_unlock(&mbox->lock);
-- 
2.53.0



