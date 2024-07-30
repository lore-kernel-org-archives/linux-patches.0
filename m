Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9607F1BD013;
	Tue, 30 Jul 2024 15:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355078; cv=none; b=OMpGNYRt5VRMtEsC+e6+GfTrmgxCeqAblUaZvBSnzyUfjC1BlBa3xR+1tXdX3yP80AhdUxTeHTnIVR9ycGb3lR7SKN1tKnMCfit7UfEAfiFLUzkG4mJfp8rHKK17KUnLf4QZpQO9l5iGf0i0g2qc1O62nwsnBkZFiEEPlt1DOko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355078; c=relaxed/simple;
	bh=fvx/cSr9OXkv/C397FCab8kYIgvvxmekgyJMhoTwwco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBQLoKcsPQwzvib6esSRMDRN48flucA9MDxdQtiLzXgaFNSvHApSPUxK9R9mGQr8xbeOe5m4iu5i6lvpZoATpUyOOPJkJZrmG0wwv9VzOafgmaaxKCSrYHzZ0+r6bDzuep+AI+xAywb9+znNW+J2toLe5+ZP0sYdSguVfntLiIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xl1u8OjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xl1u8OjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F03C32782;
	Tue, 30 Jul 2024 15:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355078;
	bh=fvx/cSr9OXkv/C397FCab8kYIgvvxmekgyJMhoTwwco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xl1u8OjWPjqxxtS4eKlOfULuqkgn8Cm3diwk4bMBsYgbfkDUGH9rId915yO06Q1Me
	 CaQTg93tat5fHDlISdoImXOk+NLztBALMeeVsBcidKzT14epI39iUbuju7LnFrgTT0
	 33HfFC2wxU2dgDop5Gvrk3ZcUfFszDYo1iDdnCMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/440] ARM: dts: imx6qdl-kontron-samx6i: fix PCIe reset polarity
Date: Tue, 30 Jul 2024 17:44:49 +0200
Message-ID: <20240730151617.955917891@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit df35c6e9027cf9affe699e632a48082ab1bbba4c ]

The PCIe reset line is active low. Fix it.

Fixes: 2a51f9dae13d ("ARM: dts: imx6qdl-kontron-samx6i: Add iMX6-based Kontron SMARC-sAMX6i module")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
index 78cbc2df279e6..668d33d1ff0c1 100644
--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -732,7 +732,7 @@ &pcie {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_pcie>;
 	wake-up-gpio = <&gpio6 18 GPIO_ACTIVE_HIGH>;
-	reset-gpio = <&gpio3 13 GPIO_ACTIVE_HIGH>;
+	reset-gpio = <&gpio3 13 GPIO_ACTIVE_LOW>;
 };
 
 /* LCD_BKLT_PWM */
-- 
2.43.0



