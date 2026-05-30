Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D75134389F;
	Sat, 30 May 2026 17:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162922; cv=none; b=BwgpNjuRw+zvNI9LpnbxZN//0B3Bz+ze/KBkiLrjc6si9Q1qzjeOCr7FZ0Yw2aOkJM1NBDXC1XbWrNPFSu8ufEm9ukHELhZTt9DP8b8MJg1A38EcCwBe2Tjh9PPnmPdYA/5HHe6U4l+qSIJWS46f3dQ8d/tmik4BnCfPnoDvwhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162922; c=relaxed/simple;
	bh=6BvbUm92uDXycRlqbClq1OP7LjeJyCeHnTkFk9QslF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVn9vcTjBwF6NycrbTwKEXdbsOMAHhW9Kv/euJbNajXBrgn0ORIOzNkLrgv+bOEWAeEb2Tuc08Tezdm9/kUTGW3175CbuW3G8rQky1kRi417YERfm5hToCacyrM27aBAxjeYTXIfmMrrANz6xz7yB0ElOWyUrfFD/Puz/Ag00d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iHrD01u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iHrD01u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93DA1F00893;
	Sat, 30 May 2026 17:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162921;
	bh=ushEMhPImyrtWT/n4d+MNVgbrTx/DZA5JHRMfIWy11U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2iHrD01uVu7L/K/4TvGnfa2S3wCTE6qF0JLDl/sDECTvYfqZ4z/dR6JEiBVKJ8on/
	 w4nNKfNd74dK1En94ZLBEtsKJ8g2kvagVWUg7+sdPDmVu2alzEwmpHhDO45m4LxVbG
	 /3Iju3ti/RIBjLsYD+BRWCEnceU2jMgSBqW42q1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Martin Kepplinger <martin.kepplinger@puri.sm>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/776] arm64: dts: imx8mq-librem5: Bump BUCK1 suspend voltage to 0.81V
Date: Sat, 30 May 2026 17:56:56 +0200
Message-ID: <20260530160242.979000720@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

[ Upstream commit 94b91e3ca6688fafd6a5dd70bd89fe9d3aee88da ]

0.8V is outside of the operating voltage specified for imx8mq, see
chapter 3.1.4 "Operating ranges" of the IMX8MDQLQCEC document.

Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: 511f76bf1dce ("arm64: dts: imx8mq-librem5: Bump BUCK1 suspend voltage up to 0.85V")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
@@ -706,7 +706,7 @@
 				regulator-ramp-delay = <1250>;
 				rohm,dvs-run-voltage = <880000>;
 				rohm,dvs-idle-voltage = <820000>;
-				rohm,dvs-suspend-voltage = <800000>;
+				rohm,dvs-suspend-voltage = <810000>;
 				regulator-always-on;
 			};
 


