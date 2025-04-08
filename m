Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4E4263C6D;
	Tue,  8 Apr 2025 11:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110600; cv=none; b=pY3WvL7BmC4uvPSI+29cYEIfHgnJHaUxYDaNgTbgyFUBk2nH7OeIqzcVP2Ve3tx3CD8fyWHD6QkU1iAhjiGthDAx8Y1BjVxKTTiIiMCUNBFoXmpen1kFZXxQVIf0/bG6qm2iG6RZdTqqbeLQWSXCJrdnu8EJgozNbND3aRYlO4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110600; c=relaxed/simple;
	bh=IeITd/t6QQ1zopeuvE+vnNNDLMvPTLZNT2se2+Ztplg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fld9HOp2SV+H5IX97DK4uxMgG/J3yZBM6ZCupgs1zAxKOLQWPAspfnsFuWoQm4vxnyEjwl/kcL2ROIs4ER0G5bNrPqTWSo3xcLo8nTYbargljQtfN0fgLC6m7XaBtADoJbx62x5DfRelgr0LHrxI3SwWFsnJLBpGIKMs4sRp7tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YEcldCZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YEcldCZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E60CC4CEE5;
	Tue,  8 Apr 2025 11:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110600;
	bh=IeITd/t6QQ1zopeuvE+vnNNDLMvPTLZNT2se2+Ztplg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YEcldCZAui4qrknhPYQ+w60hMZz5VezaPqCdBVZqulOrFbcncjhm+34eobjSh4Vtb
	 +qvhPEaDNSEFs3n8kqs826PAXSrVEhyjXR+kwcLk+iW2B9BTNdMMEU9CwshUBPoPz9
	 jJojfLod+TyZR1jhuSOL50MSfLf6l3uOQBkjaIsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 122/731] arm64: dts: imx8mp-skov: operate CPU at 850 mV by default
Date: Tue,  8 Apr 2025 12:40:19 +0200
Message-ID: <20250408104917.115342277@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit 3d8ffe5702b24a0bd9d97446c0740110325f379b ]

The Skov i.MX8MP boards are passively cooled and heatsink is specced for
continuous operation at 1.2 GHz only. Short bouts of 1.6 GHz are ok,
but these should be invoked intentionally, not as part of
suspend/resume cycles.

Therefore, configure RUN frequency as 850 mV and remove the higher
voltage operating points from those permissible for suspend.

Fixes: 6d382d51d979 ("arm64: dts: freescale: Add SKOV IMX8MP CPU revB board")
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/imx8mp-skov-reva.dtsi      | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-skov-reva.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-skov-reva.dtsi
index ae82166b5c266..7ae686d37ddac 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-skov-reva.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-skov-reva.dtsi
@@ -163,6 +163,19 @@
 	};
 };
 
+/*
+ * Board is passively cooled and heatsink is specced for continuous operation
+ * at 1.2 GHz only. Short bouts of 1.6 GHz are ok, but these should be done
+ * intentionally, not as part of suspend/resume cycles.
+ */
+&{/opp-table/opp-1600000000} {
+	/delete-property/ opp-suspend;
+};
+
+&{/opp-table/opp-1800000000} {
+	/delete-property/ opp-suspend;
+};
+
 &A53_0 {
 	cpu-supply = <&reg_vdd_arm>;
 };
@@ -253,7 +266,7 @@
 				regulator-boot-on;
 				regulator-always-on;
 				regulator-ramp-delay = <3125>;
-				nxp,dvs-run-voltage = <950000>;
+				nxp,dvs-run-voltage = <850000>;
 				nxp,dvs-standby-voltage = <850000>;
 			};
 
-- 
2.39.5



