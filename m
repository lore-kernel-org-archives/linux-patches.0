Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DF133CC2;
	Tue, 14 May 2024 11:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684795; cv=none; b=U+u8k6vLuvm0GAii5AgDfaXd6/Wj+wTjCPcARZwyyqzj5m7DKCPqGaklbrOI3fP3z1AIv/p4ge1e5na8ikxmSqllQAsoeL+oT3+CMic8VD0+zw2J6PX1FE5WPAjDZakIgzxftUraNTC6a964h5wX32xDRRv7bBc0KFSavlfiLZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684795; c=relaxed/simple;
	bh=cyQKufcD25r4Ad2tJiYmXSvZ+PnjbS1/2luIe/hM54Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mn8XjUQyvqfrgjyOJTfE3yGLr4jt0DPE1yRUFpBYR7UzCpn1Ps4tYAQCgA92JtlA+ORZyJqFhRrvBDeTDzL5/9zwl46dj/zfsEkapppfJKTHIktRuAI/MBWSHCQHU1iVdDG3yQ99ldiBOHnK183U11Uq1J83Yrrrq7+GSmBW8gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xr6gjypT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xr6gjypT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B68BC32781;
	Tue, 14 May 2024 11:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684795;
	bh=cyQKufcD25r4Ad2tJiYmXSvZ+PnjbS1/2luIe/hM54Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xr6gjypT2+YLkBKl7f0+eRtSdH1nPm+GC1USciLgqlg+RlVGtzEOZ5iALGR/K1WwI
	 HZiXhMq/ngx9V0EPb+IB6l6QY841QxzSDYmBytf1N+/NKpsKNTGLidua3BgVSavhPI
	 hMIf0mSp+rKhSmOjya9UO+UVHN74ZU7bLvuxV8jA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Skladowski <a39.skl@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/301] clk: qcom: smd-rpm: Restore msm8976 num_clk
Date: Tue, 14 May 2024 12:16:00 +0200
Message-ID: <20240514101035.609209499@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Skladowski <a39.skl@gmail.com>

[ Upstream commit 0d4ce2458cd7d1d66a5ee2f3c036592fb663d5bc ]

During rework somehow msm8976 num_clk got removed, restore it.

Fixes: d6edc31f3a68 ("clk: qcom: smd-rpm: Separate out interconnect bus clocks")
Signed-off-by: Adam Skladowski <a39.skl@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240401171641.8979-1-a39.skl@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-smd-rpm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/clk-smd-rpm.c b/drivers/clk/qcom/clk-smd-rpm.c
index 0191fc0dd7dac..789903a1b3f2b 100644
--- a/drivers/clk/qcom/clk-smd-rpm.c
+++ b/drivers/clk/qcom/clk-smd-rpm.c
@@ -758,6 +758,7 @@ static struct clk_smd_rpm *msm8976_clks[] = {
 
 static const struct rpm_smd_clk_desc rpm_clk_msm8976 = {
 	.clks = msm8976_clks,
+	.num_clks = ARRAY_SIZE(msm8976_clks),
 	.icc_clks = bimc_pcnoc_snoc_smmnoc_icc_clks,
 	.num_icc_clks = ARRAY_SIZE(bimc_pcnoc_snoc_smmnoc_icc_clks),
 };
-- 
2.43.0



