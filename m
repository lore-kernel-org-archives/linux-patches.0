Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738BD369990;
	Sat, 12 Sep 2026 08:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200629; cv=none; b=KO0UM48l7PVynPfh3O0LxDDnZVFTIhX0bCRhReOizLMmV1oPUmoM1G7hM+0trtkBTnB5QNgMNzfPOgL3lts9VVUH+//vML8NW6EmsRc/rQx2rGqnB8NuwuC2SxRVeS+eyUFnQI8qzHg4F4Zirs3G4vtO22qVGnDAcCDey7PstSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200629; c=relaxed/simple;
	bh=d7jZXS6W0YDPjmX7C+LF3MtWq2qgwXPCwI4ndprbQPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZslzYTJ3cdm2JGpw4cXn5snrW1QlQiDqZQFL0lxJkcCR9nwWsKBbHublaUq26gFZyZfGpOxNy5VyfS7FK4W6+hRnXMbpZ5+txZMELsySZjr9NiKgZTJznPl0Jd+y8odrgurILK3fYXJ3Qm8aoVUmYS5YBe2IBj7rB3ISKgGgHx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiFd7x1M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiFd7x1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0241F000FF;
	Sat, 12 Sep 2026 08:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200628;
	bh=tivfGA1nT2ZPp8xs2QzVEF7XJ+WKdZ2Xf1BZD8SQL6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UiFd7x1M7lR3UgRvsCWuSWDn0TmGw1rgHXCOYY31j0AYgx9lpZDgHJeDPabc7jbR+
	 TsW8yEzLiCi04VFc5eeYyu+dnZ8vTkvQ1nHgzlPAORYdyS8EWOoejNWE7pVVDuovLI
	 /ePxy5SVOHVc6nLTcjWsWJ5FFFh28I+JE+SrEqG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0830/1815] clk: qcom: dispcc-qcm2290: Enable runtime PM support
Date: Sat, 12 Sep 2026 08:43:00 +0200
Message-ID: <20260912065708.399935647@linuxfoundation.org>
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

From: Imran Shaik <imran.shaik@oss.qualcomm.com>

[ Upstream commit 11345cbf17cacc3828f7bcb021ecc07c687d04f2 ]

The QCM2290 DISPCC is now associated with a power domain (RPMPD_CX) to
propagate genpd performance state votes to the CX rail. Set use_rpm to
true so that a runtime PM reference is acquired and released around probe,
instead of leaving a permanent 'enable' vote on the power domain.

Fixes: cc517ea3333f ("clk: qcom: Add display clock controller driver for QCM2290")
Signed-off-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260718-shikra-dispcc-gpucc-v6-4-62703e05ef0f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-qcm2290.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/dispcc-qcm2290.c b/drivers/clk/qcom/dispcc-qcm2290.c
index 50a0705128a37..2350ce7f46d9f 100644
--- a/drivers/clk/qcom/dispcc-qcm2290.c
+++ b/drivers/clk/qcom/dispcc-qcm2290.c
@@ -515,6 +515,7 @@ static const struct qcom_cc_desc disp_cc_qcm2290_desc = {
 	.num_gdscs = ARRAY_SIZE(disp_cc_qcm2290_gdscs),
 	.resets = disp_cc_qcm2290_resets,
 	.num_resets = ARRAY_SIZE(disp_cc_qcm2290_resets),
+	.use_rpm = true,
 	.driver_data = &disp_cc_qcm2290_driver_data,
 };
 
-- 
2.53.0



