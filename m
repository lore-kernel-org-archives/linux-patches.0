Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922D13502A0;
	Fri, 21 Nov 2025 13:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733489; cv=none; b=DAOSPkvvk28OBk90clhsW3fUMXj30kRZ1l+o+uhnfKFegFahE3mgIFt3UqR3VIvv/DQ3uu3Pz2BScjdtBqQFIpDOZO8An0oWBtSNQI0AxNH1b/9KYY+k8Dsaddms5szD0xy34OmDVS633UcqObxk6eHU21mBuFI52FLQfzKQ6vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733489; c=relaxed/simple;
	bh=1rw38aQmcEfvrMWjzMjMYDXBwIrM962pfukkdI1/+No=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJBlz7SP+zg7RJUgH9DMmDsv6pbVeqof2UPBMvCmJEZplhSABOdh+/VfSOSKuXC/BZo9v0VlHg+GazFDBMU0Ch3eMAFxVpnuQKsFkKGPvblMP4D0mxYwcTjXiM9a6jw8zZjQ7J/fbkpi6WTE8iR/nQfvtzEM4elEwDjTFMOCni4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ji8Ey/lE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ji8Ey/lE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39E9C116C6;
	Fri, 21 Nov 2025 13:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733489;
	bh=1rw38aQmcEfvrMWjzMjMYDXBwIrM962pfukkdI1/+No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ji8Ey/lEsvfsNYu5hqpvfqHzbHnF7/fH3tyxYWc7pucQb31Xv1s5RgUAuMVfF0ai1
	 uHfZJhF1C9wQdRhD5mW2MQCBZtULm484tfwNXGIWNlGjtvx1Rjh7deVtnhGSvq0Gk8
	 0XZe2bWFDBcR4gsOS8BvRyEVr0KwQHD/ftvOseGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 458/529] ARM: dts: imx51-zii-rdu1: Fix audmux node names
Date: Fri, 21 Nov 2025 14:12:37 +0100
Message-ID: <20251121130247.307015857@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5d4b29d765853..6cc4c2f08b15d 100644
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



