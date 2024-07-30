Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC371A305E;
	Tue, 30 Jul 2024 16:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355847; cv=none; b=Xp/5Ws4cD6Uz8LhNLHX+x7ELIMz6IR8G9H8OQLLdoonjV5tQoRfcpjgrdmsNe7uAlcJbR/qutwezeRBVmgJvDHdHZTfwjzuGvraa3oLW15fBQ3HJGbZTBw3mSwbPzt3KYQ7n709BpXl+mTPW5DOIPYFGEVkglhrGyCcdK8u7K5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355847; c=relaxed/simple;
	bh=M5r9S0CAUqCayyDBsNroeaEMn31LDDP5dSs0NQ2HoQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rc9l7I5I6NWrKpFMZAFv8cVKYDL1tzYQcAy+uXrs47E383Qp8/JOAaM4hJ0kowiiNbv5XoXSZeumGlDv/rVrZoErWC44s15fYt0eSe9h5M2D9DWqesd99XK4o82sROKLg2Tf57SyOtV/SFcD8QsdyoEsaIaDWx8xnStnIfbQPVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZSDHtVk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZSDHtVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4790FC4AF0E;
	Tue, 30 Jul 2024 16:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355846;
	bh=M5r9S0CAUqCayyDBsNroeaEMn31LDDP5dSs0NQ2HoQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZSDHtVk+y/t03SocS604OX5zo9Vue/UyNCyQY9Jj9czPPVW9q76G2Ubyl+PRonb2
	 +1sDPiMaxxu/ZfabFfIotLj+OsRgAQ/CuAJR1NbwCKPA2JcFMQp17CnxW4lZ0xs0rP
	 YslaUnDX3MbBqBY98Rx6ISmhfs9oy/Ps/Oa4ZILI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/568] arm64: dts: rockchip: Add missing power-domains for rk356x vop_mmu
Date: Tue, 30 Jul 2024 17:43:22 +0200
Message-ID: <20240730151643.589779583@linuxfoundation.org>
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
index 820c98dbccc0a..2f885bc3665b5 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
@@ -749,6 +749,7 @@ vop_mmu: iommu@fe043e00 {
 		clocks = <&cru ACLK_VOP>, <&cru HCLK_VOP>;
 		clock-names = "aclk", "iface";
 		#iommu-cells = <0>;
+		power-domains = <&power RK3568_PD_VO>;
 		status = "disabled";
 	};
 
-- 
2.43.0



