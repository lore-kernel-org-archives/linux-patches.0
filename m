Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AD646C4BD;
	Tue, 21 Jul 2026 19:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663090; cv=none; b=OwhQG3hfNbT9p13tJga3s2BwSmj4b0VHDuSwMkznDnE12ziGzaIrho0IH+6UGfNMiPkd0kkqwOhFdhMZUV2M+3tiNl0iKqdtEOBK3vmKBeY1cS6QZOewXoNNNIYHiXyS2G3b2ZDG9dp9pES40ZSgATHxn8Qouq/Q1ANH78qDi1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663090; c=relaxed/simple;
	bh=ybar2vaLwoQPgvMrzKUFtUCGYQvugyGcEAxANWBjQlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhOttTUS2TCZOeNb6wfNg+uJIJ5R4AM6MLV0gjACEkY2vOZCvawsxV9BvVr8i07nS1pmkVuVxecP5myz06OQg38iQX3sZZALCZG5bVxEp4FBblAWcp1lA5W+BKAREm0sMPodylb2hKPrRwGfz0By2n79LbpTxpU0sukXB/Suuds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cV3QAxKa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cV3QAxKa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED211F000E9;
	Tue, 21 Jul 2026 19:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663088;
	bh=vWng85il1SInPRCaLufY+O5/Wv8NCY4eH9+YdCiBR/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cV3QAxKapflpI1kR5vtxzsaKvwwv6zkX5PRVkzR1dmCq1QjyGpYpkACkI+kf+B5O6
	 GZvVEB5SQSbNmOlSKOe5XPbhJF2GhuREjQgKkrujAv/LbKm719tRfw/h5pOpmgVZcP
	 w7S+mmmkHL/aK/z04G4dXTEt3bx0elXd4x8x5LU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0648/1276] NTB: epf: Make db_valid_mask cover only real doorbell bits
Date: Tue, 21 Jul 2026 17:18:11 +0200
Message-ID: <20260721152500.612274556@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 6eb7e28f1f24a28234add38755687a7ed8bc2654 ]

ndev->db_count includes an unused doorbell slot due to the legacy extra
offset in the peer doorbell path. db_valid_mask must cover only the real
doorbell bits and exclude the unused slot.

Set db_valid_mask to BIT_ULL(db_count - 1) - 1.

Fixes: 812ce2f8d14e ("NTB: Add support for EPF PCI Non-Transparent Bridge")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260513024923.451765-10-den@valinux.co.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/epf/ntb_hw_epf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/ntb/hw/epf/ntb_hw_epf.c b/drivers/ntb/hw/epf/ntb_hw_epf.c
index dac1520906a441..8b580e9687b7df 100644
--- a/drivers/ntb/hw/epf/ntb_hw_epf.c
+++ b/drivers/ntb/hw/epf/ntb_hw_epf.c
@@ -560,7 +560,11 @@ static int ntb_epf_init_dev(struct ntb_epf_dev *ndev)
 		return ret;
 	}
 
-	ndev->db_valid_mask = BIT_ULL(ndev->db_count) - 1;
+	/*
+	 * ndev->db_count includes an extra skipped slot due to the legacy
+	 * doorbell layout, hence -1.
+	 */
+	ndev->db_valid_mask = BIT_ULL(ndev->db_count - 1) - 1;
 	ndev->mw_count = readl(ndev->ctrl_reg + NTB_EPF_MW_COUNT);
 	ndev->spad_count = readl(ndev->ctrl_reg + NTB_EPF_SPAD_COUNT);
 
-- 
2.53.0



