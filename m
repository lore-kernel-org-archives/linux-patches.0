Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFD636C9E9
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302332; cv=none; b=TPspsk9bDG18uvVv3wnLYKFdjXejbnlgg2ZUsFpFH/VFvnsmUi9/64dqzvT07NHYVNV3Niyt6IdY0mxnM9kAMQFqBhjR7lwggB7YoLdMaEWcy8Wh3UMV8uUI6XhzHjiodgIcSfcar7Mftl3mZROhPv0vp8WgejHG1nyQakF5xxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302332; c=relaxed/simple;
	bh=s6ubrWwR4ASLIolP0nEvF62wVFL4hF6epcwhVmbXPjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+FcznBI1Q8LLFcTN8xXsyO8t2Ih4y0XdP4GnmTMm241JJX1NKydKldBA+7H4bClAOMFaPk23BLFlKNCSC5aFbYyjky/tULiKjMiP7Q4HLqkewgAIuslrip+o6r8KACpxcz+eGaFvdtnv+U1RMIfodrTl6VzGwEjo55lWdgd5j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=boYTP86L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="boYTP86L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F73C116D0;
	Sat, 28 Feb 2026 18:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302332;
	bh=s6ubrWwR4ASLIolP0nEvF62wVFL4hF6epcwhVmbXPjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=boYTP86LecYaDfnZlgwkRg2yHU2v7qWZAVH8csT9Vu6uD0S1c+7IORfNgdnSPue8f
	 nywJtGrsVUa195QaKsR9ZpyTpXuml5L1mp56gkCaV1GDuPWj4MKgwUE+pnSZPuj715
	 vwPTjiDu7myjgvmekzF1vRqDVIfFBR5kxfeiUbPnM4OOMprZ1kV4/gTHhBeswnYpFV
	 XjZYPGWIXmfc0yeR8s3Ci/MDPoJc09e3XsxJrkBIauqPt1uq+zicRlwzk3yRwOR3zO
	 GPVd917ei3eLma/jQPqlIg6OFfX4eb/Is+QblI/RYmLusX6pc8Lv6zwFD4ZPs8efU6
	 B7LA9I+Cblj3w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/232] arm64: dts: tqma8mpql-mba8mpxl: Fix HDMI CEC pad control settings
Date: Sat, 28 Feb 2026 13:08:26 -0500
Message-ID: <20260228181127.1592657-53-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 8401527abb5e3a00c867b6597b8e1b29c80c9824 ]

As per datasheet of the HDMI protection IC the CEC_IC pin has been
configured as open-drain.

Fixes: 418d1d840e42 ("arm64: dts: freescale: add initial device tree for TQMa8MPQL with i.MX8MP")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
index 7bf6f81e87b47..4a75edb73dabe 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
@@ -628,7 +628,7 @@ pinctrl_hdmi: hdmigrp {
 		fsl,pins = <MX8MP_IOMUXC_HDMI_DDC_SCL__HDMIMIX_HDMI_SCL	0x400001c2>,
 			   <MX8MP_IOMUXC_HDMI_DDC_SDA__HDMIMIX_HDMI_SDA	0x400001c2>,
 			   <MX8MP_IOMUXC_HDMI_HPD__HDMIMIX_HDMI_HPD	0x40000010>,
-			   <MX8MP_IOMUXC_HDMI_CEC__HDMIMIX_HDMI_CEC	0x40000010>;
+			   <MX8MP_IOMUXC_HDMI_CEC__HDMIMIX_HDMI_CEC	0x40000030>;
 	};
 
 	pinctrl_hoggpio2: hoggpio2grp {
-- 
2.51.0

