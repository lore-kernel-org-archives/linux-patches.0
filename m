Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031663;
	b=O1k6RW6ap031GA0SRy/xSJ62epEGprlSrMkmffEJ6A2NrlcNyeXya4K0sn5A2DzYF8QT
	 ZNYpjWWgrQKOjhHMSe+KmJtW/RnlENZW7NaRnKcYlHjW9vYCTZ9iTkOsZ/7xJ9e6hNLPK
	 wUtKLoKbEmTYVeHAjYF1QQSpSh2J10deCFKTpL9nohyexxYhYNfMn6sZjLSmFy2OcwdgQ
	 Kg6lCFzRHeS3kJuE2EEHfbSoAXyK98xGn42qA05ep/TfTHgt0fn1g/6zws0GuydlSW98Q
	 k+W74SEVLDeeL1MNKz7GU8kV7ztKW/2wsv4BbG2eH6dYfQIuPXaXUZphfm1cNbjsI9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lD4UyVrqAHUDC0O9qFSO4SEs+ibG/j7uKcxpP7U36tw=;
	b=ZpUMiAlxYrxzR4r5TSpofU/y8lOWfPJnPUoCdg4sq/1EWm9pYJZk+qNgCU1hTxB0oU8u
	 KPfAnVwx1M4Q6ehc5MG3pC4M+kcVFefy+KMlvTTG+TULR/QOtzyZV5wLeLPyyGrTFbrly
	 y0xH6U+HyF4CAELKvuk6lUvfZfLvatv+OC0CEdZONEYr2N5uhBWrtDdb/Tq1jNBImu9z9
	 REQ5ixeKoWU/4MAHFyIGFhJH008r8IBm+xc1QsriIncuo3vJaX2Om0PWThQtzuOHFgRo6
	 aZKz9hzjRxHFE4rLCvQdTT4Gs2YEawtH/s9fpFIwUFHcRWJHYKczlBKkp21egwZbK3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rcihqwEk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF47606A325;
	Wed, 18 Nov 2026 19:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rcihqwEk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE471F000C4;
	Wed, 18 Nov 2026 19:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031663;
	bh=lD4UyVrqAHUDC0O9qFSO4SEs+ibG/j7uKcxpP7U36tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rcihqwEkhGY1XxYNgUyWsDK9L6qh4imsV8f0PKYcv1zxoZFKGEU21pnrOxIUdbmKD
	 uA+5iIGULDvvhPSRpxtchH3qzHSJZO9PlCmuU9Hfnq3QoAf6hlpfusSMTj2sl9d0hD
	 NaReIk2RyiFiKaSCXwMWuid83BhLLooGn0ICnEUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1136/1756] clk: qcom: mmcc-msm8996: Fix FD AHB clock register offset
Date: Wed, 18 Nov 2026 15:54:23 +0100
Message-ID: <20261118150055.283630699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 7cb2d65286b817d8d7e26f454a9c374d65e87072 ]

The FD AHB clock branch register is at offset 0x3b74, not 0x3ba74.
The incorrect offset exceeds the regmap maximum of 0xb008, so regmap
rejects accesses to it and the clock cannot be enabled.

Correct both the enable and halt register offsets so the driver can
enable the branch and check its status.

Assisted-by: LLM
Fixes: c252659770db ("clk: qcom: Add MSM8996 Multimedia Clock Controller (MMCC) driver")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916-clk-qcom-mmcc-msm8996-fix-fd-ahb-offset-v1-1-a575e1b9112c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/mmcc-msm8996.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/mmcc-msm8996.c b/drivers/clk/qcom/mmcc-msm8996.c
index a742f848e4eeb..fd58768699c7b 100644
--- a/drivers/clk/qcom/mmcc-msm8996.c
+++ b/drivers/clk/qcom/mmcc-msm8996.c
@@ -3136,9 +3136,9 @@ static struct clk_branch fd_core_uar_clk = {
 };
 
 static struct clk_branch fd_ahb_clk = {
-	.halt_reg = 0x3ba74,
+	.halt_reg = 0x3b74,
 	.clkr = {
-		.enable_reg = 0x3ba74,
+		.enable_reg = 0x3b74,
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "fd_ahb_clk",
-- 
2.53.0



