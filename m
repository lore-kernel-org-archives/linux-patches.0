Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A5729C338;
	Thu, 15 Jan 2026 17:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496566; cv=none; b=VUZYMk3afbmMD2deXFqo0C2tiZo/8YT2rAdJ336Wm2P5iE4oUOSn0XDIpptvJmBN1NXFpmLT/smRzUVLIR5Fn6XUS3EnfV+JXHNpr6AXJmHAW21Iht9BQYff2exZjHj+TXGm1UoVQ1bC2DOJMMN72+mPwPUBmj/itMqNhEoxWr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496566; c=relaxed/simple;
	bh=/X2tYseuO9h4qnaAZsp8EjYRMBHNaDryGDVoxJje/74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTDWV0Z04ykLHNpgoOVakW1bx+lbYgvP0n/zpaI7TXvK9oWd84/a+nROXUIZ9kaAI7uncSzAxowtk4X/8m8BxRrowF7DCBs1PZT9ahBfXXzPjSMU6rQx1MVddsXSC342APR1LuKGMY3B5HBLU2dxLlksCM2JGe/v3AXV6WAlFBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFdEVEHI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFdEVEHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03AAFC116D0;
	Thu, 15 Jan 2026 17:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496566;
	bh=/X2tYseuO9h4qnaAZsp8EjYRMBHNaDryGDVoxJje/74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RFdEVEHI9RfcdB/Y79eYfBwCT1F2jepSL6eh4iZJoKpl91BFyruNRCPlLuMqb7cjk
	 F+4uBvsZGsXMxH05skFbgZJn3e+wA6CBigoKtu8TeUlBRA93OPA4Crj6/Vefwol9sR
	 w8IUaiy/KbMLysQn2k3Rjy9YGvmfN624RObDaBdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/119] arm64: dts: mba8mx: Fix Ethernet PHY IRQ support
Date: Thu, 15 Jan 2026 17:47:52 +0100
Message-ID: <20260115164154.016502921@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 89e87d0dc87eb3654c9ae01afc4a18c1c6d1e523 ]

Ethernet PHY interrupt mode is level triggered. Adjust the mode
accordingly.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Fixes: 70cf622bb16e ("arm64: dts: mba8mx: Add Ethernet PHY IRQ support")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/mba8mx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/mba8mx.dtsi b/arch/arm64/boot/dts/freescale/mba8mx.dtsi
index c60c7a9e54aff..66f927198fe94 100644
--- a/arch/arm64/boot/dts/freescale/mba8mx.dtsi
+++ b/arch/arm64/boot/dts/freescale/mba8mx.dtsi
@@ -186,7 +186,7 @@ ethphy0: ethernet-phy@e {
 			reset-assert-us = <500000>;
 			reset-deassert-us = <500>;
 			interrupt-parent = <&expander2>;
-			interrupts = <6 IRQ_TYPE_EDGE_FALLING>;
+			interrupts = <6 IRQ_TYPE_LEVEL_LOW>;
 		};
 	};
 };
-- 
2.51.0



