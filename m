Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2453BF2E5;
	Thu, 15 Jan 2026 16:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496123; cv=none; b=pzYEqkEhauRJ+JgffjIcUQtL8SPXGtaawPnWeSfjq1fLRS1BefKO5nSr2XNo+0dc/liIRFyerTORqeSq6GhNSU5SRw57iXOEMmrOvIaJqJ9UcxE5tEnzETiOB3mjireHRU0H1AikOgKFXDUdu02DpUcQcjFM3PYsx8myrbNG96A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496123; c=relaxed/simple;
	bh=iHZSqvgMWtAob0urIcGxV4vfj1kZNxQXCa4rLryWQqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbbImHomB+5wuMILgofN2rWANrhoUrDYHShlbxWX6VN0rjgXyxi5KGm657PketJkNyXDji5b0aEiTg6lqyf79zp5P9P+KwWj2Zw3nJQQPdn8qLDojJlZCfzO16k3wM7y1KMuyxD8KBvP/AQuEF7fFqe2pA5b96HjTjw1vYtXqqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MDJ9TA1Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MDJ9TA1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB96C116D0;
	Thu, 15 Jan 2026 16:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496122;
	bh=iHZSqvgMWtAob0urIcGxV4vfj1kZNxQXCa4rLryWQqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MDJ9TA1Zuo+NBgEZ3x1RgYNbyu0gaygrNqmd5X8rE94LuMs/axECWnDOOrVM1qiWD
	 CaHx67iwVAjfamCQg0rHk580UQzDKOnviPMUzFYGOS82U/q+xDLdEneu3mFJepKRZO
	 eyQBwMmOpdM7V91x3uOd19qAYG6SnvCD1hlT8EIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 086/181] arm64: dts: mba8mx: Fix Ethernet PHY IRQ support
Date: Thu, 15 Jan 2026 17:47:03 +0100
Message-ID: <20260115164205.429445608@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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
index 79daba930ad64..3e41da4d6122b 100644
--- a/arch/arm64/boot/dts/freescale/mba8mx.dtsi
+++ b/arch/arm64/boot/dts/freescale/mba8mx.dtsi
@@ -185,7 +185,7 @@ ethphy0: ethernet-phy@e {
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



