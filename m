Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7332C0261;
	Tue, 16 Jun 2026 18:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634919; cv=none; b=LPs/Qj/DXnGLNNvR/ckMIFyk9cK8nq5p28V573poK1IxMO6TxSMniFbvP/SeRkIOJFAKSw6sxrJ8AsUE4bIx424bXirCYyfvT3FErCBFArjT8Pb8ByrRmUEohb2izxF3gPdXLr8woLInUtuZ9Sdc2WwCJr07OZbeKwvs8g7fCZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634919; c=relaxed/simple;
	bh=WE5FM4u2axEfTdEkgiPiz0MC70ZiswyogAOBfPWqQkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RR1Lr+kkY2kiDII5IcPzlqMHMo8iYq5rwRTLZR39tynInQmVouM+9igM6J9kgXYU41/k/SHoKvTJonbIM/IXNB8YXv994CglCIMIAMdG7w7ADjxFiYS9MAMiedVDfX8GbqZGaRbBg/o+OOpb1oUKFz5nXrf7YuZXm6Z1w9XlW0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzdVDp8L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzdVDp8L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B771F000E9;
	Tue, 16 Jun 2026 18:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634918;
	bh=NMm3E32TMv91u4AzFlLCsCooaIRiDdD7E7i77HQ+kPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nzdVDp8LivuQKv9IqeAfXsHZyGeLH7RHxEbhVRIwU0WyIQIP37X3rVsfTlhpyaAbJ
	 sAgvmU94fM+VE9/zOpyieyCLUYuPS/gjEpnqaBVMEyGd86JcaxJqdS0qiJ9Dxr+AmK
	 ZT5rBdSlVgXG05geU6NLnhaOxmra61NjXgZ95aOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Goutham <sgoutham@marvell.com>,
	Linu Cherian <lcherian@marvell.com>,
	Geetha sowjanya <gakula@marvell.com>,
	hariprasad <hkelam@marvell.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	stable <stable@kernel.org>,
	Sam Daly <sam@samdaly.ie>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 356/411] octeontx2-af: CGX: add bounds check to cgx_speed_mbps index
Date: Tue, 16 Jun 2026 20:29:54 +0530
Message-ID: <20260616145120.244843673@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Daly <sam@samdaly.ie>

[ Upstream commit c0bf0a4f3f1f5f57aa83e1400ba4f56f0abfd542 ]

cgx_speed_mbps has 13 elements but RESP_LINKSTAT_SPEED can yield values
0-15. If it returns a value >= 13, this causes an out-of-bounds array
access. Add a bounds check and default to speed 0 if the index is out of
range.

Fixes: 61071a871ea6 ("octeontx2-af: Forward CGX link notifications to PFs")
Cc: Sunil Goutham <sgoutham@marvell.com>
Cc: Linu Cherian <lcherian@marvell.com>
Cc: Geetha sowjanya <gakula@marvell.com>
Cc: hariprasad <hkelam@marvell.com>
Cc: Subbaraya Sundeep <sbhatta@marvell.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Cc: stable <stable@kernel.org>
Signed-off-by: Sam Daly <sam@samdaly.ie>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026051352-refined-demise-e88d@gregkh
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -1096,10 +1096,13 @@ static inline void link_status_user_form
 					   struct cgx *cgx, u8 lmac_id)
 {
 	const char *lmac_string;
+	unsigned int speed;
 
 	linfo->link_up = FIELD_GET(RESP_LINKSTAT_UP, lstat);
 	linfo->full_duplex = FIELD_GET(RESP_LINKSTAT_FDUPLEX, lstat);
-	linfo->speed = cgx_speed_mbps[FIELD_GET(RESP_LINKSTAT_SPEED, lstat)];
+	speed = FIELD_GET(RESP_LINKSTAT_SPEED, lstat);
+	linfo->speed = speed < ARRAY_SIZE(cgx_speed_mbps) ?
+		       cgx_speed_mbps[speed] : 0;
 	linfo->an = FIELD_GET(RESP_LINKSTAT_AN, lstat);
 	linfo->fec = FIELD_GET(RESP_LINKSTAT_FEC, lstat);
 	linfo->lmac_type_id = cgx_get_lmac_type(cgx, lmac_id);


