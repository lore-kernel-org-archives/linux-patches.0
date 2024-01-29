Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723AF6FDE1;
	Mon, 29 Jan 2024 17:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548488; cv=none; b=gDk6tHwoVpe2F2S9FQ4Vgsa3TLJfkiumaK3i6F0NEMFJF6COrmH+OJgqyNrXL7K1JopNIoIx+127zHFbHXGmDfgS+RcrlAYIrtlp535XA1escf0JGYx4bJQ4mmFNa4aZfHcbzw6WmrAjRN6ImQW0FPcUt/dOcHeecdzPsRyicAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548488; c=relaxed/simple;
	bh=JFnhE8cQTn+HCtyCYO6/cG4GYc7LOZgCcWN3/bZdLV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2gQzT6MVGbILx9XgOs9hAhiUMfm3TlWDVkQEjnhxZYwDHzAOiQReBCCem4ShjP3fb6OiDZsTMrMQ4bPTKhN4AGOnZbIQyLx1Qg/2P4MxYcEKO+EFmu2N0xg1xCdSr7TOM4fSMDxfEEDM30dKTr5p/AGEktC7X/vpT+6Z/J+GSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w8/159KG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w8/159KG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DE9C433F1;
	Mon, 29 Jan 2024 17:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548488;
	bh=JFnhE8cQTn+HCtyCYO6/cG4GYc7LOZgCcWN3/bZdLV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w8/159KGRTMZJaqeW54WIUi1a8ogPcZ2fGQ+ZAHvbTxTODnMlsQF1SsqsMIuCsZkb
	 H6ybsTlBQj/FBBusEkKbUWfz/Tf7/nEMn5tR/ZDjbwcyKrKmZPa/N6JEFGf5WKMVTy
	 NjwJioQKeE8Finbg6WuUPjEj+sDV06b3aJl37tWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Acayan <mailingradian@gmail.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 084/331] arm64: dts: qcom: sdm670: fix USB wakeup interrupt types
Date: Mon, 29 Jan 2024 09:02:28 -0800
Message-ID: <20240129170017.395245190@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


