Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D12188012;
	Tue, 30 Jul 2024 16:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355547; cv=none; b=VYW8GF9YSqOw45YMiTKDkfG6R/xkeAK1NMsP2wgkmuSrfeUlpbzw+zQHQ9ihMXbRZYDdh5E/KBJ++V580pheXXslzEKkiYjbnhUlYPkN9zvfnhdKFfNqWfHkRhX5gGAYifLobm+obBvkuKje+jBrnDotvPprfVvlfFYi0EB5spM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355547; c=relaxed/simple;
	bh=nzjIvm6KsK4zoaw2SQAF5PADYwznnAoeC/BPoggyT5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPYneuR5P9cKAWtJ3nJDlBE2Oe9jiO8BpJzAnyAA8Es8XpoI7BZ3sp23nyXwZZ1dk0APRbkRAsl2Qu7EfDAqDb4+AHDn803DJiXZ+/vWmcmXUZJenHY/pNGwLknqqzxYNsSEtvt4mSEnTwm42Blocq0oKk6itCLkvZZp/h+kpTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=px7bEJiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="px7bEJiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61238C32782;
	Tue, 30 Jul 2024 16:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355547;
	bh=nzjIvm6KsK4zoaw2SQAF5PADYwznnAoeC/BPoggyT5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=px7bEJivlVEtdu9VH7pt5oziVU6GQdP30cvqgfIzEgXWTDA9AZv+PBsrTUu1Ot6fq
	 YGlEcRHA20Em8gqz0UlWETfgBV+SfjcjyZbvHIUVjgJvxrYKhhXFVHUO7MrEd6jrqZ
	 Gb1zjjKGz3+kDxWh6JuRZ7XkyoLf72PnuJWD8TCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagar Cheluvegowda <quic_scheluve@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 065/809] arm64: dts: qcom: sa8775p: mark ethernet devices as DMA-coherent
Date: Tue, 30 Jul 2024 17:39:01 +0200
Message-ID: <20240730151727.210857507@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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
index 1b3dc0ece54de..490e0369f5299 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
@@ -2504,6 +2504,7 @@ ethernet1: ethernet@23000000 {
 			phy-names = "serdes";
 
 			iommus = <&apps_smmu 0x140 0xf>;
+			dma-coherent;
 
 			snps,tso;
 			snps,pbl = <32>;
@@ -2538,6 +2539,7 @@ ethernet0: ethernet@23040000 {
 			phy-names = "serdes";
 
 			iommus = <&apps_smmu 0x120 0xf>;
+			dma-coherent;
 
 			snps,tso;
 			snps,pbl = <32>;
-- 
2.43.0



