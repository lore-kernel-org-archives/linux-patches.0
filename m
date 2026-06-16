Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545C23AE71F;
	Tue, 16 Jun 2026 17:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629942; cv=none; b=KzJZ8FbTyC2JuTJcNTyDNl8WwLrU83KOqfdROaZWM+ORiQRYaWFNxrpwK5LWyyOWyCZwbq549vW0I/0DUTxnQM7T+4Q7Wpp0vqAjVrG01tOFLUnHyN4kIm5PGyA4VEq32taW9Ix/BKb6g4KjKlC8n+1djqMWg39lFL/KosZSyXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629942; c=relaxed/simple;
	bh=NLLr70/uNjGphFmTiqABfGAimwCdVbFhiwGgdZqjoJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BxMFB+XZQ9IFXTDm5JY3HserwCaBB3YnPH1jlGlt+3w9vw6mXx9TeYhSnuhiZtk+EP4XzqnEkGwlj3KPiLRVTE0K/rm92VVxC+fCBhj4Hfyy91qW2RoaQM0pcMlkP2AUDVvKHwPMctzqZWxqBPOlbTsysekQVA9zijL6U0iMtvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3LPEEiR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3LPEEiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617F51F000E9;
	Tue, 16 Jun 2026 17:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629941;
	bh=7WAo3vrAYY/yg2C8EK1XjQf6engIT5O3zu8sUcGs28k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e3LPEEiRU/fIsI4HCvfOyG3+x+gRML8xXgxCV7FwcPt8rRW7dS795aCcn08dkOt9p
	 pbCsiomOphHkBMRJDZlGHpUI3xvwaN66SZ56FLtqffkmRFm+aB/Hd5zWzDpXQj4ji/
	 BJrr07mmyF3pgTjJ5zgwxe9jyWuwxN8NYrDPiZrc=
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
Subject: [PATCH 6.6 382/452] octeontx2-af: CGX: add bounds check to cgx_speed_mbps index
Date: Tue, 16 Jun 2026 20:30:09 +0530
Message-ID: <20260616145137.009392238@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -1286,13 +1286,18 @@ static inline void link_status_user_form
 					   struct cgx_link_user_info *linfo,
 					   struct cgx *cgx, u8 lmac_id)
 {
+	unsigned int speed;
+
 	linfo->link_up = FIELD_GET(RESP_LINKSTAT_UP, lstat);
 	linfo->full_duplex = FIELD_GET(RESP_LINKSTAT_FDUPLEX, lstat);
-	linfo->speed = cgx_speed_mbps[FIELD_GET(RESP_LINKSTAT_SPEED, lstat)];
 	linfo->an = FIELD_GET(RESP_LINKSTAT_AN, lstat);
 	linfo->fec = FIELD_GET(RESP_LINKSTAT_FEC, lstat);
 	linfo->lmac_type_id = FIELD_GET(RESP_LINKSTAT_LMAC_TYPE, lstat);
 
+	speed = FIELD_GET(RESP_LINKSTAT_SPEED, lstat);
+	linfo->speed = speed < ARRAY_SIZE(cgx_speed_mbps) ?
+		       cgx_speed_mbps[speed] : 0;
+
 	if (linfo->lmac_type_id >= LMAC_MODE_MAX) {
 		dev_err(&cgx->pdev->dev, "Unknown lmac_type_id %d reported by firmware on cgx port%d:%d",
 			linfo->lmac_type_id, cgx->cgx_id, lmac_id);


