Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AC537204A;
	Sat, 12 Sep 2026 07:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197267; cv=none; b=rdT8vcTzzWK6/dJwVd+ksCMts3s5gGilSOo6R37SaUSidQACykI881MO1Ti5UMDxMnS4O6XtNorv9mu3j+v5+YvR2zSnN6UAOJOOeK0+Hovd2AP0rYXSxpyWtWEBV6cCKpBWvB8R7tYDEhTV6hmIkRiZ1Yyu58llZmrexKvpCRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197267; c=relaxed/simple;
	bh=zfk4iLkXeUQYdeJY2B6hQIs9w98IGbpOPzkS55RPEKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjmJb220omvmD7gDe/olSVPiuav+b4rNn91oYxLj6k5XEFtIDEWucgb9KJqEs5yHztyG7gtrZ1Hngp8PPs4dttNGTTQdXY33C3BF3Gwg7Drc5HybjE+Z4jiY2RqhADihYps6w7LaS8TS3xIBKjp3QgnxM+0qhJ4sr/TqUAyjbpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eiGCscV8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eiGCscV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6AF1F000FF;
	Sat, 12 Sep 2026 07:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197266;
	bh=laDLqYPtN8iEdpIHIEN+528UD0h0IZPtmOsXV3VK21w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eiGCscV8phNRmcHue3SYk7/J78wTH1O5t7rRpBoXO33snCZC/z3gz6vKuVm7m0jbK
	 1z0xoCymKavKyW8jg92PlREs15KoF7iegmLO7yJWx4d0j22w2a+a6vy0szbQKl0oSA
	 tVWqUc94U4U+cth+mEIxs2nFnkVGxWajjKo0qcuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0096/1815] arm64: dts: imx8mp-ab2: Enable MU2 for DSP communication
Date: Sat, 12 Sep 2026 08:30:46 +0200
Message-ID: <20260912065651.263663009@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit b1b6c1c4d3c63d8097c933009bdb618d1be18305 ]

Enable the MU2 (Message Unit 2) node on the i.MX8MP Audio Board v2.
MU2 is required for inter-processor communication between the
application CPU and the HiFi4 DSP, allowing DSP firmware to exchange
control and status messages with the Linux host.

Without this change, the DSP driver cannot establish the message
channel and DSP audio processing is non-functional.

Fixes: bf68c18150efc ("arm64: dts: imx8mp-ab2: add support for NXP i.MX8MP audio board (version 2)")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-ab2.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-ab2.dts b/arch/arm64/boot/dts/freescale/imx8mp-ab2.dts
index 443e4fd5b9bfc..285bf79864ebd 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-ab2.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-ab2.dts
@@ -775,6 +775,10 @@ &micfil {
 	status = "okay";
 };
 
+&mu2 {
+	status = "okay";
+};
+
 &pwm1 {
 	pinctrl-0 = <&pinctrl_pwm1>;
 	pinctrl-names = "default";
-- 
2.53.0



