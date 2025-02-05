Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1814613C8E2;
	Wed,  5 Feb 2025 14:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767593; cv=none; b=efEA8FRY+oXTEVcV1dgQ5u6YC5QLLjSYQtmbVkdDg5x0AE2k49IDIQ46rU4HREtcafrR910oUPac5J8Cms7o7uLhy/01G6P7GqToliW0rADI6hw6aFHkNR6kpj6fSF6tHLEEZ60vQmCZzqj+hxviJPGSlv12pZ/T+hjHzdOFiUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767593; c=relaxed/simple;
	bh=L6s2lrkHsQT8DdOHMDePAwj+H6SF4xAO8uEeXAeq0G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxyfDO6zHb2U08VZkTz9BzMg+qCEoZ8rRN58YzNwBk4I226FqdL5Dfc4JIwZrIHd5yiDVNSit+P5z6mSBkcpkc+Gtph2LJsTNv9VH8RjJ3hJFw2kcwyu355fGCpsmyymOGbxBmtWNpdk/N5veDkkhhZfjT/XgXcHG/FKPEOWakI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKpi5oH7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKpi5oH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11774C4CED1;
	Wed,  5 Feb 2025 14:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767592;
	bh=L6s2lrkHsQT8DdOHMDePAwj+H6SF4xAO8uEeXAeq0G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKpi5oH7bTqEou6h9YnwHM2RTLdFjS4EyWxtPV5mVTP5KxDTn0tpCe/Tzkkh9bAdn
	 uwltArW69p44QxBe6mt+ViMjxWzTPj9X6ro0Pwvb8TV09eknCLO5w5vH6nDqCcpc4v
	 9yRBJ9CHX8M8Om4Xlmg+TcaVFF3cjybZ/0i/iWWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 426/623] arm64: tegra: Fix DMA ID for SPI2
Date: Wed,  5 Feb 2025 14:42:48 +0100
Message-ID: <20250205134512.520507109@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil R <akhilrajeev@nvidia.com>

[ Upstream commit 346bf459db26325c09ed841fdfd6678de1b1cb3a ]

DMA ID for SPI2 is '16'. Update the incorrect value in the devicetree.

Fixes: bb9667d8187b ("arm64: tegra: Add SPI device tree nodes for Tegra234")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Link: https://lore.kernel.org/r/20241206105201.53596-1-akhilrajeev@nvidia.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index 984c85eab41af..570331baa09ee 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -3900,7 +3900,7 @@
 			assigned-clock-parents = <&bpmp TEGRA234_CLK_PLLP_OUT0>;
 			resets = <&bpmp TEGRA234_RESET_SPI2>;
 			reset-names = "spi";
-			dmas = <&gpcdma 19>, <&gpcdma 19>;
+			dmas = <&gpcdma 16>, <&gpcdma 16>;
 			dma-names = "rx", "tx";
 			dma-coherent;
 			status = "disabled";
-- 
2.39.5



