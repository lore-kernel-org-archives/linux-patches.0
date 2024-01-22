Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F6756B70;
	Tue, 23 Jan 2024 01:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974046; cv=none; b=syk5WRDs+O/QAv9Y96CpcoOQjKSBwT7Z0z1TDfKLGMMLeRW6rQpxvJfVzSSBCVH+kPGozPyBYI5pMsklnyzXsCP3VbwUHO/aJCcAZbqzsyZEkZ4NL+62tavS8r3QMWVOuP6mwbZj8s+qkYjfeOPKVyCSq1fYXDEgAxTGa1ejZk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974046; c=relaxed/simple;
	bh=b9gN8bXLu2LJPTU8B/0M9NTPFSGnVHQXmfGLnJgmLL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ed4HrFwsRSzGWNS2LHYaTIpze514D+yFpFJ/5kabxWCenzp8a6hu8PKS0CAPmO9FYRPt92yGd293aGsYcsI0QxhAq1TMMl/43Deo/BRRnDqaVnRXpRI0kKWKstgx0ll1IJWymHukpho3MXnurkhyDDZnlX7Q7E4vOg3/1Vjw2bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6HqHi2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6HqHi2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91682C43390;
	Tue, 23 Jan 2024 01:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974045;
	bh=b9gN8bXLu2LJPTU8B/0M9NTPFSGnVHQXmfGLnJgmLL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6HqHi2h0M+x8JyH9Dhm9s90t53Gu8uRLda6XutKJqNElnd9eLXQYGs67j9z871JE
	 EZx9qDJfq8FOQssheYtGtvSYRzWTE50LPu2LtOdbe6waK3fW9oqR+AjBoNITL/jZ0T
	 eUUNFk8HhqjpwnDp6mjMSWKwksVzN2lmVqsfmZEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/374] arm64: dts: qcom: sc7280: fix usb_2 wakeup interrupt types
Date: Mon, 22 Jan 2024 15:56:35 -0800
Message-ID: <20240122235749.468652595@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 24f8aba9a7c77c7e9d814a5754798e8346c7dd28 ]

The DP/DM wakeup interrupts are edge triggered and which edge to trigger
on depends on use-case and whether a Low speed or Full/High speed device
is connected.

Note that only triggering on rising edges can be used to detect resume
events but not disconnect events.

Fixes: bb9efa59c665 ("arm64: dts: qcom: sc7280: Add USB related nodes")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231120164331.8116-6-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 9971b8763e08..e0c7f72773d6 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -1290,8 +1290,8 @@ usb_2: usb@8cf8800 {
 			assigned-clock-rates = <19200000>, <200000000>;
 
 			interrupts-extended = <&intc GIC_SPI 240 IRQ_TYPE_LEVEL_HIGH>,
-				     <&pdc 13 IRQ_TYPE_EDGE_RISING>,
-				     <&pdc 12 IRQ_TYPE_EDGE_RISING>;
+					      <&pdc 12 IRQ_TYPE_EDGE_BOTH>,
+					      <&pdc 13 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 
-- 
2.43.0



