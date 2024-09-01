Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F8118454E;
	Sun,  1 Sep 2024 16:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208475; cv=none; b=COW4hoopaPw9Zm6v4ccnv8Ne88wiANgMtHzG+jV54u0N4zLtB1qHWj/FmHAJXlaRw8es2Z6v3PSG8dd1hDNnraPs3MJAOYnhHatDxYX3ruLOdGk3Mn0F/AXvh9dre1htAecRVCkjIekbjgOvSHtTC1+pZke/IvFSRb2Q/fJB1+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208475; c=relaxed/simple;
	bh=hPDySGdS+fepgmQEoVwDYqYpIXRsUzGcH06ck73sfZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtptoM5AISlZF/F64gplZ5WBw3tmbeQuPgZkX+rjj1fC37erzVfeezhLwTIonTCK9QkbzZ1H8z4LMpoPpeDFAofJV8V0QY4q6vjKGdglIsEQgzaKmoM0jJmySPDdNVKGrTC696meEsNZE6NI4+lgkzHRDiOKPH6bWfQI9yBH+Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5zY2pnW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5zY2pnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD536C4CED0;
	Sun,  1 Sep 2024 16:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208475;
	bh=hPDySGdS+fepgmQEoVwDYqYpIXRsUzGcH06ck73sfZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y5zY2pnWTdkVMauCgDAF8/IVBtt5kabEFBqrr5jLNur7OeXp3fQalovJbLatxjb8v
	 wfFmGMlPDWsUJjoSkmGk/cGQf7BnNuOL/lNvH1/01uURgA0LjQuEQSHNFKox8nxXxZ
	 ZfjpV0Gm8C1vNU8+sT6jO9AjQJgt1XbUWQaTiOG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <quic_kdybcio@quicinc.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 062/149] pinctrl: qcom: x1e80100: Fix special pin offsets
Date: Sun,  1 Sep 2024 18:16:13 +0200
Message-ID: <20240901160819.799864199@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <quic_kdybcio@quicinc.com>

[ Upstream commit d3692d95cc4d88114b070ee63cffc976f00f207f ]

Remove the erroneus 0x100000 offset to prevent the boards from crashing
on pin state setting, as well as for the intended state changes to take
effect.

Fixes: 05e4941d97ef ("pinctrl: qcom: Add X1E80100 pinctrl driver")
Signed-off-by: Konrad Dybcio <quic_kdybcio@quicinc.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/20240809-topic-h_sdc-v1-1-bb421532c531@quicinc.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-x1e80100.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-x1e80100.c b/drivers/pinctrl/qcom/pinctrl-x1e80100.c
index 6cd4d10e6fd6f..65ed933f05ce1 100644
--- a/drivers/pinctrl/qcom/pinctrl-x1e80100.c
+++ b/drivers/pinctrl/qcom/pinctrl-x1e80100.c
@@ -1805,10 +1805,10 @@ static const struct msm_pingroup x1e80100_groups[] = {
 	[235] = PINGROUP(235, aon_cci, qdss_gpio, _, _, _, _, _, _, _),
 	[236] = PINGROUP(236, aon_cci, qdss_gpio, _, _, _, _, _, _, _),
 	[237] = PINGROUP(237, _, _, _, _, _, _, _, _, _),
-	[238] = UFS_RESET(ufs_reset, 0x1f9000),
-	[239] = SDC_QDSD_PINGROUP(sdc2_clk, 0x1f2000, 14, 6),
-	[240] = SDC_QDSD_PINGROUP(sdc2_cmd, 0x1f2000, 11, 3),
-	[241] = SDC_QDSD_PINGROUP(sdc2_data, 0x1f2000, 9, 0),
+	[238] = UFS_RESET(ufs_reset, 0xf9000),
+	[239] = SDC_QDSD_PINGROUP(sdc2_clk, 0xf2000, 14, 6),
+	[240] = SDC_QDSD_PINGROUP(sdc2_cmd, 0xf2000, 11, 3),
+	[241] = SDC_QDSD_PINGROUP(sdc2_data, 0xf2000, 9, 0),
 };
 
 static const struct msm_gpio_wakeirq_map x1e80100_pdc_map[] = {
-- 
2.43.0



