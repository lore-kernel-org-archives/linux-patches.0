Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12360379EDF
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301702; cv=none; b=Kp0L8gJcYoLhpQlzGAJhzZFaHcmvI9vFN6NTkumB0Cq2XOB51iuqmFRPPzUwa5L68R8xiRHFBFhkVDgTp2rtniI9uRxD770hIQF0l7MC4LQ6REKPZJvDPFXYIR24aiJfg+YTRRS4NB5WgteC4rKoO2SYS99m+M9D0mFMCTHXZmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301702; c=relaxed/simple;
	bh=InrNIeZDzFrizGuVIFvkSjwn0LndcsglZ9B3IB+3Adk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/C5zByF+/jorA/uX25sV+2OxjizU4BlGN+d9fqJMQSCAFxw7vajdyL39SSUir4+F+hfWXH5/vSXKMl4MIoGnqrfNrPUMf7wSTbLns+yjRg8MGFR7qocK5JUnRNs1liW1arlKLxsqrSv88T5KHp01NWek+C3lIPrZF3VUU+DheY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uoUU1uen; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uoUU1uen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7667FC116D0;
	Sat, 28 Feb 2026 18:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301702;
	bh=InrNIeZDzFrizGuVIFvkSjwn0LndcsglZ9B3IB+3Adk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uoUU1uenSlZWCdLUbSXqxY22ymdhSoHUAsFTGJGtUk4npBAHtsJNn78ZK2Yuxn1B+
	 xKtVcPQ8uU32pm0cjx2FavG6O2JZmy1/7QMDHcnq/a8zslELQCFUB1yYKj0yZVHThs
	 vt+xHUCHyueiaSZOwmL52RIk6HH6hlSHX4wHF2xx2uxLSu9F1sA1PEgG2T7JltQWfB
	 b7R7y5m/lDPhadLQLI76q9/pJGyzXoKoMRpNkay1qcefabVFYFU7M8BTdlOSgNLGmP
	 3nmU8IoUJzR5rGGpEYbTlxdlLv75/e7kAiykNXT9LU4x/krrMyHvDdWdANPd4UZCjW
	 ixJYzawnePkcQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/385] arm64: dts: tqma8mpql-mba8mpxl: Fix HDMI CEC pad control settings
Date: Sat, 28 Feb 2026 12:55:17 -0500
Message-ID: <20260228180011.1568201-95-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index e7c16a7ee6c26..773282002e6c6 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
@@ -859,7 +859,7 @@ pinctrl_hdmi: hdmigrp {
 		fsl,pins = <MX8MP_IOMUXC_HDMI_DDC_SCL__HDMIMIX_HDMI_SCL	0x400001c2>,
 			   <MX8MP_IOMUXC_HDMI_DDC_SDA__HDMIMIX_HDMI_SDA	0x400001c2>,
 			   <MX8MP_IOMUXC_HDMI_HPD__HDMIMIX_HDMI_HPD	0x40000010>,
-			   <MX8MP_IOMUXC_HDMI_CEC__HDMIMIX_HDMI_CEC	0x40000010>;
+			   <MX8MP_IOMUXC_HDMI_CEC__HDMIMIX_HDMI_CEC	0x40000030>;
 	};
 
 	pinctrl_hoggpio2: hoggpio2grp {
-- 
2.51.0

