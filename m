Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B010435201E;
	Wed, 20 May 2026 16:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295627; cv=none; b=T5jn3eQoseVCqw3FZ36mQ/CPpmpqoDGFoKZmQsSgAwxYlhdPP20mcH2Y7314ILo3jUD2Wr02pU4xcMBFkboD0Ey0IsxfIhY3QzzMf3F39fpWDDPSAoX3Ky51E8X2LUOKzafSnrvV3JYn8nCv321F5XrnEhuRaaBhG+5h+TCLP6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295627; c=relaxed/simple;
	bh=3ggeqoe907+oLVBaF4vGEa7tm3q8OoMhZiQMNE64uJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAbjap9oShcQirGfNLVVfhIDnieBrJ/FdfLm3VESv8yV2iIzkKqY+mi9/dbrvO+uChaO2DrZDtqkIXKnn4iq5uiiGPGMRXU/SR1YUIDebE3upxmuO2E2LI7axkBdPgDs3oRF3qtuskBu1UTiMkYmD0vUW+9g1kRfDtUCZbA7EKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uro6yK7s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uro6yK7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204381F000E9;
	Wed, 20 May 2026 16:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295626;
	bh=cdUXRehwTyguR/tVJsvm/ljzW3iwT4sOBU2gf09SiwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uro6yK7s3uezKBrSoGW6fG9itg7wOLRvlZ7SLEzrr53vd4IBYyWgGBewsfLeQkW52
	 ZfaZAeLSdNKIMGSSrLuggrmgMCVZkyh2n1E4hpmON+ZGeXCmQlrGWxXm2tZ905MMmP
	 glrWN0o5M8LZFwIGuJ3gAzEOzZESis17v0ZUEliI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0491/1146] arm64: dts: imx8mp-hummingboard-pulse: fix mini-hdmi dsi port reference
Date: Wed, 20 May 2026 18:12:21 +0200
Message-ID: <20260520162159.304225854@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josua Mayer <josua@solid-run.com>

[ Upstream commit 1d1d14d4253e6f373c247e67f3716768910be81e ]

imx8mp.dtsi includes a default port@1 node with an empty placeholder
endpoint intended for linking to a dsi bridge or panel.

HummingBoard Pulse mini-hdmi dtsi described a new endpoint node with a
different label attached.

This duplicate label causes confusion and is suspected to also cause
errors during dsi_attach.

Remove the duplicate node and link to the one defined in soc dtsi.
Further remove the unnecessary attach-bridge property.

Fixes: 2a222aa2bee9 ("arm64: dts: add description for solidrun imx8mp hummingboard variants")
Signed-off-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../imx8mp-hummingboard-pulse-mini-hdmi.dtsi          | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-hummingboard-pulse-mini-hdmi.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-hummingboard-pulse-mini-hdmi.dtsi
index 46916ddc05335..0e5f4607c7c1b 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-hummingboard-pulse-mini-hdmi.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-hummingboard-pulse-mini-hdmi.dtsi
@@ -41,7 +41,7 @@ port@0 {
 				reg = <0>;
 
 				adv7535_from_dsim: endpoint {
-					remote-endpoint = <&dsim_to_adv7535>;
+					remote-endpoint = <&mipi_dsi_out>;
 				};
 			};
 
@@ -71,11 +71,8 @@ &lcdif1 {
 &mipi_dsi {
 	samsung,esc-clock-frequency = <10000000>;
 	status = "okay";
+};
 
-	port@1 {
-		dsim_to_adv7535: endpoint {
-			remote-endpoint = <&adv7535_from_dsim>;
-			attach-bridge;
-		};
-	};
+&mipi_dsi_out {
+	remote-endpoint = <&adv7535_from_dsim>;
 };
-- 
2.53.0



