Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DFC41CB39;
	Sat, 12 Sep 2026 08:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202396; cv=none; b=h0uie7kly0EHGca/fXyz2iKUg3CgTT6pitMwuqXkQb9J2HaJllHnKuZ3Ca+fq9AKPHDKjoO+vXNzsBkjWt0mT7Qu/tKLIvtkKE2Dh/3ovRFm+tg3tWEdqwEtvOUTuMH5EzSc51+a/uR1/KR1nF8BXwMIKlYF4Z46GVx9CxZvbDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202396; c=relaxed/simple;
	bh=Qv5tpvYoiKXTfVqELpX9sIeVHDxYRDgBYGjLNwubWNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pV7zrgEm5b8kYys4jT9rpmtMWIxoW2ptINvY14nFmkfVcrKF5mm+xU9QBJEhNcC4U2jcRkiHZfM7P6J1q7iIH4BcKp7/cmIXuEnmYIL7JGUwANNAgUsrbXZj3omdNIzC1OyMaYmMiNfiPYJq5LH+0DBUKe/4Zj2QhXEGD1yyMqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IsasG/8B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IsasG/8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E34E1F000FF;
	Sat, 12 Sep 2026 08:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202395;
	bh=MtR4aAz3SIjCfYJLQrXz2zBMRHmz12JmbpY6iZKtHEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IsasG/8BvJzBxgcO3/0R7Kru/07rwCN9MsV3lNUA90T5eqTcJYy/etD2xGv73YoxA
	 bMK4ZWKZNhp5WMTSDQns8cBexsE6ChCcAl2FvqTLhLvHc3GuaJrjU2nqK3v2bVwvgQ
	 wDWHJbZbtYsKJ0pl2VCt2IX48NQJTyVi/ITJyDDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esteban Urrutia <esteuwu@proton.me>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1187/1815] phy: qcom: qmp-pcie: Add pcs_lane1 offset to V5 offsets
Date: Sat, 12 Sep 2026 08:48:57 +0200
Message-ID: <20260912065716.877852062@linuxfoundation.org>
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

From: Esteban Urrutia <esteuwu@proton.me>

[ Upstream commit f8b4493d5e7e19682abcf538a9faad012b5ef69e ]

Some SoCs such as SM8475 write data to registers using this offset,
specifically SW_CTRL2 and MX_CTRL2.
Add pcs_lane1 offset to V5 offsets to support this.

Signed-off-by: Esteban Urrutia <esteuwu@proton.me>
Fixes: 0fd0b31965b0 ("phy: qualcomm: qmp-pcie: add support for SAR2130P")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20260715-sm8475-bup-pcie-v2-2-48bd91a19abf@proton.me
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
index d3effad7a074b..3618812e84d5f 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
@@ -3554,6 +3554,7 @@ static const struct qmp_pcie_offsets qmp_pcie_offsets_v5 = {
 	.pcs_misc	= 0x0600,
 	.tx		= 0x0e00,
 	.rx		= 0x1000,
+	.pcs_lane1	= 0x1400,
 	.tx2		= 0x1600,
 	.rx2		= 0x1800,
 };
-- 
2.53.0



