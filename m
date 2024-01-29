Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B361A158D9E;
	Mon, 29 Jan 2024 17:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548069; cv=none; b=a2ANi+F3hoM9fCSkMTVgasw3rrAv1U2vYyB7WSqGlR1rqhn5JQqQgwaqiuPAXXsmdOBa/gcFaCqaOXNp7+g5UDtMSbE15NGRzcG5PLg7AssN2WpvXi8MiSaudqvyKTL3OLHEG0um6xA9RqA3QDF0AaQLoLTsOkEeudfWv+vrh8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548069; c=relaxed/simple;
	bh=Zi1Q1Ju/XhNXpH0WSqwkSpLQAu3vW0hdUFECHSb6p7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWlHfdbxmzfHGrIaJ3VtpTOhBFEPlTZiUftxLSg4ojHalIRewCZiQ9DpCUQsRuljr6WoO5dRAK1pDBxztj6b7tW5CPLPFTcCT/dqxHT9zKgyiEKz0vYBEyWh92nrcdkj37f4yZP5cmkl807HpDrvS26WSAqd+lbINWiy5SwG4+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sMlzSVXJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sMlzSVXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7145CC43394;
	Mon, 29 Jan 2024 17:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548069;
	bh=Zi1Q1Ju/XhNXpH0WSqwkSpLQAu3vW0hdUFECHSb6p7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMlzSVXJ4iumt/YBWTh+JijCEbJAcp0laOkb6A4ujZQdCQ7T5U5adb3kW08IrzF+j
	 s/IoNVgb4lKUih9+juEMzPA1IWT9d2H8J00Kytt16GuujFxcaBbq0U4zkNhm8sK+V+
	 EhwR4MdFstqI0zz84E2fPdNOylTVVFdtsg4Y7bVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Acayan <mailingradian@gmail.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.7 077/346] arm64: dts: qcom: sdm670: fix USB wakeup interrupt types
Date: Mon, 29 Jan 2024 09:01:48 -0800
Message-ID: <20240129170018.651267132@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit de3b3de30999106549da4df88a7963d0ac02b91e upstream.

The DP/DM wakeup interrupts are edge triggered and which edge to trigger
on depends on use-case and whether a Low speed or Full/High speed device
is connected.

Fixes: 07c8ded6e373 ("arm64: dts: qcom: add sdm670 and pixel 3a device trees")
Cc: stable@vger.kernel.org      # 6.2
Cc: Richard Acayan <mailingradian@gmail.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Acked-by: Richard Acayan <mailingradian@gmail.com>
Link: https://lore.kernel.org/r/20231120164331.8116-8-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sdm670.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sdm670.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm670.dtsi
@@ -1297,8 +1297,8 @@
 
 			interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 486 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 488 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 489 IRQ_TYPE_LEVEL_HIGH>;
+				     <GIC_SPI 488 IRQ_TYPE_EDGE_BOTH>,
+				     <GIC_SPI 489 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 


