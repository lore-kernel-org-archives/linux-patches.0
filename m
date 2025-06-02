Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2B7231858;
	Mon,  2 Jun 2025 14:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875540; cv=none; b=Vzj4QDA3NEwzD7+5P3wramLLSj5vq+pVSqm4laA+8kSfIt5uVACFyp+WOPanLi09zmB4tJZ9McLpgs6uRnJnONBAqp/Is8WMQpKq71pDWm/K2V5RELrZP9A3hNw4tCHFiGpEExhoEmb/QpnjP8aAc7MN6c/x08bKM+k7cHV0smo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875540; c=relaxed/simple;
	bh=BjDFVmvaNNIgW1S7FsaeJ0McC/LkxMar2Uue7tq8smE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1xe5+XxpXh/StoavvE+DjQbh1ckMxHPZ29tEPFR8AfWAFzybU1wWr0Yyd0xvKTKHxTgojdHgu/kPnXj/qE0bE6ky/XYV5tqS+cZeDc3n3F4e7kgDk82lKWPkFBfNAZ98apTmXq9zGGbxK5sJKRAyuNYs1qJJMU/odDHmO+B1q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOmeu9Sf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOmeu9Sf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C75EC4CEEE;
	Mon,  2 Jun 2025 14:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875540;
	bh=BjDFVmvaNNIgW1S7FsaeJ0McC/LkxMar2Uue7tq8smE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOmeu9Sfsvyc6dciS0e8BXoI/vfq/l0i/9gXmFIxAl0E4HHDOjuWfefptO+3lZvFs
	 HdVZCxGTUHheMTGfrHnlo8qul2ZIJ+3mHEl2m4U76DaLpd1X4uXTqUFjg30CPDP6TA
	 mjrV5Vn/8+irYrVRHfBgpGdLVY4T+ZDoGIKlca30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 159/270] ARM: tegra: Switch DSI-B clock parent to PLLD on Tegra114
Date: Mon,  2 Jun 2025 15:47:24 +0200
Message-ID: <20250602134313.712574814@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit 2b3db788f2f614b875b257cdb079adadedc060f3 ]

PLLD is usually used as parent clock for internal video devices, like
DSI for example, while PLLD2 is used as parent for HDMI.

Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Link: https://lore.kernel.org/r/20250226105615.61087-3-clamor95@gmail.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/tegra114.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index fb99b3e971c3b..c00097794dab1 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -126,7 +126,7 @@ dsi@54400000 {
 			reg = <0x54400000 0x00040000>;
 			clocks = <&tegra_car TEGRA114_CLK_DSIB>,
 				 <&tegra_car TEGRA114_CLK_DSIBLP>,
-				 <&tegra_car TEGRA114_CLK_PLL_D2_OUT0>;
+				 <&tegra_car TEGRA114_CLK_PLL_D_OUT0>;
 			clock-names = "dsi", "lp", "parent";
 			resets = <&tegra_car 82>;
 			reset-names = "dsi";
-- 
2.39.5



