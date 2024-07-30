Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801D618E03C;
	Tue, 30 Jul 2024 16:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355853; cv=none; b=klCM/nhUp4DD2pyFuqinT37+xUnkjmkZVXgbdB1e9/yg+9jMNTK6L86mOzTcYD6ADVKxjMtQiJPkgsOAhzPZic5YBPU5AhujRQWBiLObw2Ug9rX5GpeN3Vzx7pRMhcUia4mICb/vkZBt8A4LadWC1dVQ1+FuiOSJCvxglkL5HZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355853; c=relaxed/simple;
	bh=R3k1l+tsUV4WmNYRcXSpYI/tE2uHmJczTCgSqXAqp4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWm3KhJZtg4UVUGHDkh6JZDCdAQB3HtbNVVn0yi51iCfuvg6EkEXG3Xp8jDR34lhyaxfOq+hjmdXbT3TwUFk/9CcmdDU78YLAX+J5CrcPamDDuz/YXeTrrblbmLiaONaOZGlvZUgIBlbs6fBJejOZlp9ZCkDTla+cpQxfp7BKS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7VbWuEP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7VbWuEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00132C32782;
	Tue, 30 Jul 2024 16:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355853;
	bh=R3k1l+tsUV4WmNYRcXSpYI/tE2uHmJczTCgSqXAqp4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7VbWuEPGe5wRavH8q9asPYgIdVqUg0BG6W3Kzb/El0s8DVw9rhtybkypnoXDip/l
	 cCYOJQGcu1Gw0SlI1aCL9/EHbp44b53LlT4k2QHOewjjJi6pNrLV0iGV56aLIKwsI0
	 IQ9Vo5RliM1AY5KMb6lReSKpfqxqxBRXVwipNiKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 076/809] arm64: dts: ti: k3-am62a-main: Fix the reg-range for main_pktdma
Date: Tue, 30 Jul 2024 17:39:12 +0200
Message-ID: <20240730151727.641230513@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jayesh Choudhary <j-choudhary@ti.com>

[ Upstream commit d007a883a61f55b9b195c4c18bbe29de5b802822 ]

For main_pktdma node, the TX Channel Realtime Register region 'tchanrt'
is 128KB and Ring Realtime Register region 'ringrt' is 2MB as shown in
memory map in the TRM[0] (Table 2-1).
So fix ranges for those register regions.

[0]: <https://www.ti.com/lit/pdf/spruj16>

Fixes: 3dad70def7ff ("arm64: dts: ti: k3-am62a-main: Add more peripheral nodes")
Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Link: https://lore.kernel.org/r/20240430105253.203750-3-j-choudhary@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a-main.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi b/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi
index bf9c2d9c6439a..ce4a2f1056300 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi
@@ -120,8 +120,8 @@ main_pktdma: dma-controller@485c0000 {
 			compatible = "ti,am64-dmss-pktdma";
 			reg = <0x00 0x485c0000 0x00 0x100>,
 			      <0x00 0x4a800000 0x00 0x20000>,
-			      <0x00 0x4aa00000 0x00 0x40000>,
-			      <0x00 0x4b800000 0x00 0x400000>,
+			      <0x00 0x4aa00000 0x00 0x20000>,
+			      <0x00 0x4b800000 0x00 0x200000>,
 			      <0x00 0x485e0000 0x00 0x10000>,
 			      <0x00 0x484a0000 0x00 0x2000>,
 			      <0x00 0x484c0000 0x00 0x2000>,
-- 
2.43.0



