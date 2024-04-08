Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959EE7350E;
	Mon,  8 Apr 2024 13:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582159; cv=none; b=AOim/g8hBK1ggXJfvZgwQvlDEoIsnxH6dLOMIy8VA5yaz3lTYcPrFnpLB/eJ0rPwKELViTH3yPNuer6hx2BRBgADLuYE6WAV//HS8FauBV+1R2Pshp946B1KylTOJ9jCecRRnF2maC1sFp11T8iB5NKR6Pqf22QH0jlOcjMpSRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582159; c=relaxed/simple;
	bh=vGhuM3PdE6BbHFd2gZ131slYvF6l/W0EwcnmGRSsCHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kv9hfSnDjDky+Xzi8TI0jhrUgcFjgDPgBUexpvmc7je0zRkVEouKZf6Ii0rtUK5Yv5ZKsPPsSTUHbCuL9I1/bjebh93dcYLcHoUoUbR4y2SPQ/G4lR+M3m88lf9SmsI+rr0RYdGlHfJDz/MB+Eh5rEhE3eJqvxgV0jAhoQIFPQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hc/d2Oc7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hc/d2Oc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8B6C433C7;
	Mon,  8 Apr 2024 13:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582159;
	bh=vGhuM3PdE6BbHFd2gZ131slYvF6l/W0EwcnmGRSsCHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hc/d2Oc7oHNHSQ/Vkht1LChIIIjAHKFsbc5OPwKz9vQsK6foiI1rHTufjKNLUA0YU
	 mjFvt+elRScuL+YSaEdE8iaXoXlPmsRxVDCTaUvIWC2cy/uRIqeY9Hmxq2dr4hhMgf
	 x4acx9t2lRAGX6PfQZdCUHzUXkyY4fZVwTBv2CEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 051/273] Octeontx2-af: fix pause frame configuration in GMP mode
Date: Mon,  8 Apr 2024 14:55:26 +0200
Message-ID: <20240408125310.878762107@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 40d4b4807cadd83fb3f46cc8cd67a945b5b25461 ]

The Octeontx2 MAC block (CGX) has separate data paths (SMU and GMP) for
different speeds, allowing for efficient data transfer.

The previous patch which added pause frame configuration has a bug due
to which pause frame feature is not working in GMP mode.

This patch fixes the issue by configurating appropriate registers.

Fixes: f7e086e754fe ("octeontx2-af: Pause frame configuration at cgx")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240326052720.4441-1-hkelam@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 3c0f55b3e48ea..b86f3224f0b78 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -808,6 +808,11 @@ static int cgx_lmac_enadis_pause_frm(void *cgxd, int lmac_id,
 	if (!is_lmac_valid(cgx, lmac_id))
 		return -ENODEV;
 
+	cfg = cgx_read(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL);
+	cfg &= ~CGX_GMP_GMI_RXX_FRM_CTL_CTL_BCK;
+	cfg |= rx_pause ? CGX_GMP_GMI_RXX_FRM_CTL_CTL_BCK : 0x0;
+	cgx_write(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL, cfg);
+
 	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
 	cfg &= ~CGX_SMUX_RX_FRM_CTL_CTL_BCK;
 	cfg |= rx_pause ? CGX_SMUX_RX_FRM_CTL_CTL_BCK : 0x0;
-- 
2.43.0



