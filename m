Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E303184551;
	Tue, 30 Jul 2024 16:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355327; cv=none; b=JhJGhRrPWq8EwbwwceqgvG9bTadqkehPCd0gq0sx1aLrJqaK60A6q1z58/jeIO8+50QKbRbDVIJUg7mnLVNmaRtKgqdVCDWNNF9sbLUJzPp5uK2dFFgClM5tf4p02aeHkiwGQ/FWJEaWRcCjjGWK1TVjF2PkbLAq+36XE50dnA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355327; c=relaxed/simple;
	bh=zFPjQIlTxEC9ZY6kXyrzK4IAaYOBsqsWZSTbl0oIn8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0OIxDsxbamZzc9cfiBrBLLx+lno1f7BIZGyjiCQQrO5V9+6gHKOnVS4WGqdFozhq+9oWD+vWUPYwZ6hIueN8rZxKUojLIAgbOBFWf/ZJqletotJhiPPGXzxMdJoKusvjA1qNolEpJcYqpeL+980eq8X9bMxaPh7pBCwNOx8w48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTNk4KrS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTNk4KrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B037C4AF0C;
	Tue, 30 Jul 2024 16:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355326;
	bh=zFPjQIlTxEC9ZY6kXyrzK4IAaYOBsqsWZSTbl0oIn8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iTNk4KrSmozNXhYGnM+H8T9uDKdwi8nR0sNJPhu1W0m/yT2hI23Z6+8/qDqBRmNDO
	 dTAPaK1pgHiFJVR0m4pMW5mrsivHbSaovaGn3kHKhmN+aRJ+eI6nJ7wqnWxOxlbmr6
	 t2r6PPO7z/i8p5DwjRTlIbn7jaWKkb/7eyGFVxOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagar Cheluvegowda <quic_scheluve@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/568] arm64: dts: qcom: sa8775p: mark ethernet devices as DMA-coherent
Date: Tue, 30 Jul 2024 17:42:35 +0200
Message-ID: <20240730151641.716345168@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Sagar Cheluvegowda <quic_scheluve@quicinc.com>

[ Upstream commit 49cc31f8ab44e60d8109da7e18c0983a917d4d74 ]

Ethernet devices are cache coherent, mark it as such in the dtsi.

Fixes: ff499a0fbb23 ("arm64: dts: qcom: sa8775p: add the first 1Gb ethernet interface")
Fixes: e952348a7cc7 ("arm64: dts: qcom: sa8775p: add a node for EMAC1")
Signed-off-by: Sagar Cheluvegowda <quic_scheluve@quicinc.com>
Link: https://lore.kernel.org/r/20240514-mark_ethernet_devices_dma_coherent-v4-1-04e1198858c5@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sa8775p.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p.dtsi b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
index 88ef3b5d374b3..44bea063aedba 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
@@ -2350,6 +2350,7 @@ ethernet1: ethernet@23000000 {
 			phy-names = "serdes";
 
 			iommus = <&apps_smmu 0x140 0xf>;
+			dma-coherent;
 
 			snps,tso;
 			snps,pbl = <32>;
@@ -2383,6 +2384,7 @@ ethernet0: ethernet@23040000 {
 			phy-names = "serdes";
 
 			iommus = <&apps_smmu 0x120 0xf>;
+			dma-coherent;
 
 			snps,tso;
 			snps,pbl = <32>;
-- 
2.43.0



