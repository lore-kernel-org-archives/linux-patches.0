Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01741A681E;
	Fri,  7 Aug 2026 15:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115848; cv=none; b=Wej3RjCtk5Qy7mAYDKGI1mmOkW4fWOYYVyUBNiY+cMfVtp+P3dhHlABIrQl1tAnX2gnFSx4fKK8oI746Ti+C+HZlnz1D7/G3DVTqESIcx4QKomSXYa6k5+8/etfQafxWedz5oku2teeAb+ae/bFgKMic4bPBxfizquw6I52pGXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115848; c=relaxed/simple;
	bh=SiESuvLqdiYwdBLX4TplaI8/7pNu0rTpXgNh29xKzBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gs2hjLZ8ecHNhs1w5FyPn2Bbknp5+PbHpnMCM1p0WzBPB+Tq1sdEOszh69FciyJLMPKvqYkctgd9+zuYgFWcNH2Q9SP/RaWnZfYFBV3GxtFvvEB13sk/T4vJ2WBFw5HspukBdRBUavi+W8qp9mUCH0uCMJX8tsC2ocJKrJsKNIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BuRbJkWG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BuRbJkWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411711F000E9;
	Fri,  7 Aug 2026 15:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115846;
	bh=f99z7/KeX27DyurFzC9O97id27/qlvEzWW65gvg8oeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BuRbJkWGTncBlwFp59G67XJAT7DABvyh0akzN6cstP79uW72ujhq6Dc3LzCqqc4wu
	 6kQ//qn+/8BH+FIBZVCX+WkoejKzJlwI3ozLsem5yY1YvyiV+Xlkwac7SZzKvAiSX0
	 KLldcOajZ0xmRfebdKzfy4HxvtqbSCNEWP/QQkJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/261] soc: qcom: ice: Allow explicit votes on iface clock for ICE
Date: Fri,  7 Aug 2026 16:36:05 +0200
Message-ID: <20260807143415.545370036@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Harshal Dev <harshal.dev@oss.qualcomm.com>

[ Upstream commit 0d5dc5818191b55e4364d04b1b898a14a2ccac38 ]

Since Qualcomm inline-crypto engine (ICE) is now a dedicated driver
de-coupled from the QCOM UFS driver, it explicitly votes for its required
clocks during probe. For scenarios where the 'clk_ignore_unused' flag is
not passed on the kernel command line, to avoid potential unclocked ICE
hardware register access during probe the ICE driver should additionally
vote on the 'iface' clock.
Also update the suspend and resume callbacks to handle un-voting and voting
on the 'iface' clock.

Fixes: 2afbf43a4aec6 ("soc: qcom: Make the Qualcomm UFS/SDCC ICE a dedicated driver")
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260416-qcom_ice_power_and_clk_vote-v5-2-5ccf5d7e2846@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/ice.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index 94e91835062b2..b20214027fc26 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -48,6 +48,7 @@ struct qcom_ice {
 	struct device_link *link;
 
 	struct clk *core_clk;
+	struct clk *iface_clk;
 };
 
 static DEFINE_XARRAY(ice_handles);
@@ -149,8 +150,13 @@ int qcom_ice_resume(struct qcom_ice *ice)
 
 	err = clk_prepare_enable(ice->core_clk);
 	if (err) {
-		dev_err(dev, "failed to enable core clock (%d)\n",
-			err);
+		dev_err(dev, "Failed to enable core clock: %d\n", err);
+		return err;
+	}
+
+	err = clk_prepare_enable(ice->iface_clk);
+	if (err) {
+		dev_err(dev, "Failed to enable iface clock: %d\n", err);
 		return err;
 	}
 
@@ -160,6 +166,7 @@ EXPORT_SYMBOL_GPL(qcom_ice_resume);
 
 int qcom_ice_suspend(struct qcom_ice *ice)
 {
+	clk_disable_unprepare(ice->iface_clk);
 	clk_disable_unprepare(ice->core_clk);
 
 	return 0;
@@ -240,11 +247,17 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
 	engine->core_clk = devm_clk_get_optional_enabled(dev, "ice_core_clk");
 	if (!engine->core_clk)
 		engine->core_clk = devm_clk_get_optional_enabled(dev, "ice");
+	if (!engine->core_clk)
+		engine->core_clk = devm_clk_get_optional_enabled(dev, "core");
 	if (!engine->core_clk)
 		engine->core_clk = devm_clk_get_enabled(dev, NULL);
 	if (IS_ERR(engine->core_clk))
 		return ERR_CAST(engine->core_clk);
 
+	engine->iface_clk = devm_clk_get_optional_enabled(dev, "iface");
+	if (IS_ERR(engine->iface_clk))
+		return ERR_CAST(engine->iface_clk);
+
 	if (!qcom_ice_check_supported(engine))
 		return ERR_PTR(-EOPNOTSUPP);
 
-- 
2.53.0



