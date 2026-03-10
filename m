Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11971352C4F;
	Tue, 10 Mar 2026 11:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141182; cv=none; b=Pk4t/aqrwt40lQiCLnD2VDjOzFSDyVRxMC3c+cmi5RmV/6LEiWwKdhejfhWvVwa1fQd4zELkIP4o6Wwb41nAXNbfWkZfNna+S/guojFsQWqPCLkLr2OB0GG9dP4fWkFLLpAKlQeT5bpvDmaLI44P28LFVA6pdeGJjEOsBa4a6cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141182; c=relaxed/simple;
	bh=kGfe69y9XNALAN3qt3ZmPh3zKRto5YLgrxCRNuw4RAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIN1g+1JkqI2EMHP2IhZ/x1QdzJY43tTbS7gTmvmtycqIapGsvdBfbKJqBs6x00b87AHiZ+2zZFvk9UvhprvsuHkrrxbolixxd7cLlTHL7Rq1LZT6q5aXKIxPBROIyGcYmTyFcAeuPGDYAHyfIEcamnzH6fODVBCuihxLOJHQzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G7dQkQaP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G7dQkQaP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48062C19423;
	Tue, 10 Mar 2026 11:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141182;
	bh=kGfe69y9XNALAN3qt3ZmPh3zKRto5YLgrxCRNuw4RAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7dQkQaPQCQZzOhRZQkMV6YVU3gsgwoSs/N6z7OQ8BTk5CBPJITXFDNvvCyneWi5o
	 tlUmDQ+zcP9RK5G48Rh8razz6/Z0togYQl4/oQDa2uLPHm+jTFvLxlapEfYrXtJPVf
	 /LW7L5/2zsDLEHU3yv2mg9HPkPhdEJPtyC5L3EAaNlR9dweJ5kjfGPr+g+6BoYep3q
	 HI74IHUx47bWW6KRwYRFTbH9yu1xuU5v19AhzJwYzKeg926tEcroyOx5vmliSa34Bo
	 CiM/5jTtd1vrba63IqIXebV4ZkrVGsSFteh56mM8NBZFNwjxfQKSEDblFyEC9yiuSb
	 Tx1Skjg17aTuA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maulik Shah <maulik.shah@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 183/311] pinctrl: qcom: qcs615: Add missing dual edge GPIO IRQ errata flag
Date: Tue, 10 Mar 2026 07:03:50 -0400
Message-ID: <ab6052261e6a3782f413c8483c9cd48c534223c3.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Maulik Shah <maulik.shah@oss.qualcomm.com>

[ Upstream commit 09a30b7a035f9f4ac918c8a9af89d70e43462152 ]

Wakeup capable GPIOs uses PDC as parent IRQ chip and PDC on qcs615 do not
support dual edge IRQs. Add missing wakeirq_dual_edge_errata configuration
to enable workaround for dual edge GPIO IRQs.

Fixes: b698f36a9d40 ("pinctrl: qcom: add the tlmm driver for QCS615 platform")
Signed-off-by: Maulik Shah <maulik.shah@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-qcs615.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-qcs615.c b/drivers/pinctrl/qcom/pinctrl-qcs615.c
index 4dfa820d4e77c..f1c827ddbfbfa 100644
--- a/drivers/pinctrl/qcom/pinctrl-qcs615.c
+++ b/drivers/pinctrl/qcom/pinctrl-qcs615.c
@@ -1067,6 +1067,7 @@ static const struct msm_pinctrl_soc_data qcs615_tlmm = {
 	.ntiles = ARRAY_SIZE(qcs615_tiles),
 	.wakeirq_map = qcs615_pdc_map,
 	.nwakeirq_map = ARRAY_SIZE(qcs615_pdc_map),
+	.wakeirq_dual_edge_errata = true,
 };
 
 static const struct of_device_id qcs615_tlmm_of_match[] = {
-- 
2.51.0

