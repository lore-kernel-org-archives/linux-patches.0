Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA661A6185;
	Tue, 30 Jul 2024 16:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356217; cv=none; b=puBW4pMsrVlg0x4yuxHqygQbPpGxHjqJdY9laXvPxbxTYp4Ze3mBhvvcMyMbx/yC6uUtCKNnzQ8maDTFCALJgur70ow7I6Bzf6vHXtnzNTJdBMQwHBSlV4Mzx8p9YXN4U7X5ULYPphNlPmKwx/OMhd0YRaRH9gvcjeMXCnhVHfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356217; c=relaxed/simple;
	bh=U/rC/4lXNAZDIvDifp0YyC7SMphll2XjdbheYgdpSAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=faiNvJ0RUX6cOiWWfiTIiCJUvEaMGvfNu/nOFZZmwgLT1kHy5KTVrBYSwPh/cIgnD779vuQSqMjeDu6cP/cik7xfbuHQv9g00hiGcHgSuSJSP00b5pfGGMSmHqj7ugKx8ntCS0oNCVKKEwkA6s+upD8poZ9YIPxnFxOOha25t1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nWVuefj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nWVuefj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B9DC32782;
	Tue, 30 Jul 2024 16:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356217;
	bh=U/rC/4lXNAZDIvDifp0YyC7SMphll2XjdbheYgdpSAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nWVuefj8Vr0tOmmVnPJrYHnh2ZaEsyzd94CMs76J/+KnK7dyNe61wQ9P5Q4LNX1fg
	 YA7c1uA3lvxyVCmjakqCLG7J5sFr02qauPOxYpHs+opabzviY4xqkDAS9dgYKIiDHN
	 awetcsrr886QIs1jRt+fZMEMjrwQ7pjsvUmlBOvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 130/809] arm64: dts: rockchip: Add missing power-domains for rk356x vop_mmu
Date: Tue, 30 Jul 2024 17:40:06 +0200
Message-ID: <20240730151729.750927964@linuxfoundation.org>
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 9d42c3ee3ce37cdad6f98c9e77bfbd0d791ac7da ]

The iommu@fe043e00 on RK356x SoC shares the VOP power domain, but the
power-domains property was not provided when the node has been added.

The consequence is that an attempt to reload the rockchipdrm module will
freeze the entire system.  That is because on probe time,
pm_runtime_get_suppliers() gets called for vop@fe040000, which blocks
when pm_runtime_get_sync() is being invoked for iommu@fe043e00.

Fix the issue by adding the missing property.

Fixes: 9d6c6d978f97 ("arm64: dts: rockchip: rk356x: Add VOP2 nodes")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20240702-rk356x-fix-vop-mmu-v1-1-a66d1a0c45ea@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk356x.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
index d8543b5557ee7..3e2a8bfcafeaa 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
@@ -790,6 +790,7 @@ vop_mmu: iommu@fe043e00 {
 		clocks = <&cru ACLK_VOP>, <&cru HCLK_VOP>;
 		clock-names = "aclk", "iface";
 		#iommu-cells = <0>;
+		power-domains = <&power RK3568_PD_VO>;
 		status = "disabled";
 	};
 
-- 
2.43.0



