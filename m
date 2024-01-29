Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1797159560;
	Mon, 29 Jan 2024 17:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548070; cv=none; b=f4W2T4wMAiMvbrhBdUGaQkvLzOMNR2+YwF3PV3KoTrh8rmxw+alXWQj1wYWo3c9tJFhO66LdXj68FmKuqgT+T5Lo+eqGlM7GqtZrU5iStB8aEugZBKkeLsdzoPjwpCDgIpyHypTGmFptidIEUbumY7vebERPlwVeNkvL10fsVVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548070; c=relaxed/simple;
	bh=9atlvx09hGKsUZLdA/eA/23xcV3UNP7hwj6hMGVWDLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfYyI/g1dff9Dpfi93LDdtFdqnWEybX1tFZwjLy47ppAffiPZ0j0SnghG6CetsOh786g02OIPiXEt3NzR8TrdKMkRTBfxPb6IGRTpHukgoDdYgm+au3Bi3SXB2bwsHIEQVkzaDXwU4htzpSmDaJS6X46lSgc42/x7DMMgemlalM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bgd4f6zh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bgd4f6zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A73FC43394;
	Mon, 29 Jan 2024 17:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548070;
	bh=9atlvx09hGKsUZLdA/eA/23xcV3UNP7hwj6hMGVWDLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bgd4f6zhxDvkVP47BiJfW+ACHoZDplvdamCOiNunUspX7uXIYKeKgE/TpXlTw8YBH
	 fJ64ID895gsoumigfXqzuJE19MsFd0Cb4nDh6LgHKYSkLz+wwBtxvwB4z19Lw3zSVt
	 EHGhJCAJZqjIeCFL3A7a3e4VzDnDcFv3TYgmAgtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Jack Pham <quic_jackp@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.7 078/346] arm64: dts: qcom: sm8150: fix USB wakeup interrupt types
Date: Mon, 29 Jan 2024 09:01:49 -0800
Message-ID: <20240129170018.679521767@linuxfoundation.org>
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

commit 54524b6987d1fffe64cbf3dded1b2fa6b903edf9 upstream.

The DP/DM wakeup interrupts are edge triggered and which edge to trigger
on depends on use-case and whether a Low speed or Full/High speed device
is connected.

Fixes: 0c9dde0d2015 ("arm64: dts: qcom: sm8150: Add secondary USB and PHY nodes")
Fixes: b33d2868e8d3 ("arm64: dts: qcom: sm8150: Add USB and PHY device nodes")
Cc: stable@vger.kernel.org      # 5.10
Cc: Jonathan Marek <jonathan@marek.ca>
Cc: Jack Pham <quic_jackp@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Jack Pham <quic_jackp@quicinc.com>
Link: https://lore.kernel.org/r/20231120164331.8116-11-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3567,8 +3567,8 @@
 
 			interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 486 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 488 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 489 IRQ_TYPE_LEVEL_HIGH>;
+				     <GIC_SPI 488 IRQ_TYPE_EDGE_BOTH>,
+				     <GIC_SPI 489 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 
@@ -3620,8 +3620,8 @@
 
 			interrupts = <GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 487 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 490 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 491 IRQ_TYPE_LEVEL_HIGH>;
+				     <GIC_SPI 490 IRQ_TYPE_EDGE_BOTH>,
+				     <GIC_SPI 491 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 


