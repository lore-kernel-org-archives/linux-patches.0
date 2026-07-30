Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C9343FD01;
	Thu, 30 Jul 2026 14:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423507; cv=none; b=P33zmcXrUcAmq2rI179QBuGQHcYE+Gn6fnl4jKwJVTKGmd090NJrot7EBUbIOpZYn8omGuEzyzkNps2pS07LU5BL9vaQQhBJHZIgNh2Dui6BtraltQFLT3ejF7/5nX2PYVXnmDawqvqbc2U87o+a23Z3BaubXGO3Y1GxA3JyWSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423507; c=relaxed/simple;
	bh=1Q7pNxVNq2wR9nyM5jFs8hi3IG0V+94AeLjDgY9SHnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDGPSuRa5+PGhRFzrg3H2xZk8o40LH7V+4ntCpIfPxoSJ3h7FIhlsOVlxgSkVLdCSGKJEoIqXk4gvnCSLI823NFLCdl4Hlrbe1SLp+lDy7Zby0nQ0QGO13eyRykLUq4ku4yVJUvy0egGMq0bU6x7ZB0KTkxvmfrLeOdjOzbmZso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHWyS4dZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHWyS4dZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094731F000E9;
	Thu, 30 Jul 2026 14:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423506;
	bh=eXRIzbI1TL7ZQv+bhugKzw+6S0wjKoIZ+gzAiLD6tII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WHWyS4dZnjzPaqfR8m6MAjmDsqybOq0xQILlbRtXLrZihi1kB5ZZuBv7OyYqpvqwS
	 ouPSgv2EM1D2MrIM6JpG+oiU1+nLt9ne6lWxfzQ1VdK62EXa1vWYzBruYaQqPPsGJ1
	 7NLvpnmBveN7eiY0gwCeX8r6j+/lGO4WeND3mMJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 031/675] arm64: tegra: Remove fallback compatible for GPCDMA
Date: Thu, 30 Jul 2026 16:06:01 +0200
Message-ID: <20260730141445.781712179@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil R <akhilrajeev@nvidia.com>

[ Upstream commit ee7863e43228a3143398dc5bbb943c9a735a8fca ]

Remove the fallback compatible string "nvidia,tegra186-gpcdma" for GPCDMA
in Tegra264. Tegra186 compatible cannot work on Tegra264 because of the
register offset changes and absence of the reset property.

Fixes: 65ef237e4810 ("arm64: tegra: Add Tegra264 support")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra264.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra264.dtsi b/arch/arm64/boot/dts/nvidia/tegra264.dtsi
index 872a69553e3c82..b16d380209a50a 100644
--- a/arch/arm64/boot/dts/nvidia/tegra264.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra264.dtsi
@@ -50,7 +50,7 @@ timer@8000000 {
 		};
 
 		gpcdma: dma-controller@8400000 {
-			compatible = "nvidia,tegra264-gpcdma", "nvidia,tegra186-gpcdma";
+			compatible = "nvidia,tegra264-gpcdma";
 			reg = <0x0 0x08400000 0x0 0x210000>;
 			interrupts = <GIC_SPI 584 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 585 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.53.0



