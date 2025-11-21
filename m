Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD2C1F09AC;
	Fri, 21 Nov 2025 13:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731241; cv=none; b=AzOMcPCKdKWb1c56JMNBOFi29jPFbZLwYRw5EQmqD8r9h55RDRKLSkLlJh2zFelLXfkPvd/bkM53vEyryJSaESEntPqW9r0J1dGRmn/CSllhHALmvFmzjuNZ/6OD6pyxW+BxYbY76dV2+oST4/H89LkuxuibS1y+e5mkI3A1YOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731241; c=relaxed/simple;
	bh=ZUvF81NJjo6hUUC8kOuCYYAohQVV0nm9lzKbJ34E9N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=si5UVoovWvTuNWbgtPVNo1/4axMDHG6YAfOg7L4u6wiIKnr2ltYcRioX+0q2b38ltl7wK0ZQs/+z0uiAk49mEIAw3+dwpIYBcKM2UR7lNA3egqDG9vm+POoDQKzbDMg15yGi2UfBvPV+VwCPlLbF9JgtR9GfvboZAEAl8WuMTOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t3tN6DiX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t3tN6DiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F98DC4CEF1;
	Fri, 21 Nov 2025 13:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731241;
	bh=ZUvF81NJjo6hUUC8kOuCYYAohQVV0nm9lzKbJ34E9N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t3tN6DiXP7CPhseu4fbnpftv2hPSmhPeSgk9DPTcFQfNcmhTPnCRAy8+hj87ZTQrh
	 t8BvU6qn+T3e2gugWbp2MUmnLRuTMGZwhQ/YIaTqIz163bBfTSRuljzt7p5Tc7iEvU
	 BDK8JsR5J7DWdvbL+YOHbtpFhzuj4egsQbMBqfB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 139/247] ARM: dts: imx51-zii-rdu1: Fix audmux node names
Date: Fri, 21 Nov 2025 14:11:26 +0100
Message-ID: <20251121130159.715775086@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jihed Chaibi <jihed.chaibi.dev@gmail.com>

[ Upstream commit f31e261712a0d107f09fb1d3dc8f094806149c83 ]

Rename the 'ssi2' and 'aud3' nodes to 'mux-ssi2' and 'mux-aud3' in the
audmux configuration of imx51-zii-rdu1.dts to comply with the naming
convention in imx-audmux.yaml.

This fixes the following dt-schema warning:

  imx51-zii-rdu1.dtb: audmux@83fd0000 (fsl,imx51-audmux): 'aud3', 'ssi2'
  do not match any of the regexes: '^mux-[0-9a-z]*$', '^pinctrl-[0-9]+$'

Fixes: ceef0396f367f ("ARM: dts: imx: add ZII RDU1 board")
Signed-off-by: Jihed Chaibi <jihed.chaibi.dev@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx51-zii-rdu1.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx51-zii-rdu1.dts b/arch/arm/boot/dts/nxp/imx/imx51-zii-rdu1.dts
index 06545a6052f71..43ff5eafb2bb8 100644
--- a/arch/arm/boot/dts/nxp/imx/imx51-zii-rdu1.dts
+++ b/arch/arm/boot/dts/nxp/imx/imx51-zii-rdu1.dts
@@ -259,7 +259,7 @@
 	pinctrl-0 = <&pinctrl_audmux>;
 	status = "okay";
 
-	ssi2 {
+	mux-ssi2 {
 		fsl,audmux-port = <1>;
 		fsl,port-config = <
 			(IMX_AUDMUX_V2_PTCR_SYN |
@@ -271,7 +271,7 @@
 		>;
 	};
 
-	aud3 {
+	mux-aud3 {
 		fsl,audmux-port = <2>;
 		fsl,port-config = <
 			IMX_AUDMUX_V2_PTCR_SYN
-- 
2.51.0



