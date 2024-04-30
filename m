Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DDF1E50A;
	Tue, 30 Apr 2024 11:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475762; cv=none; b=fJzhvmHqI6Fj2KitpYxHyB0Cg7NkRKAJCTwlRTfq07waOJp88KHvMUv/IECzArbelcnYZGKWUV9XRt5ydM0DmPLVHFHu+yYF04xgF0SLvNE/U585+C9fadu498w32stOkZz3bGwtvIS6aixFGCuMHwMo1ZGnLo16IrLY8XIVTFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475762; c=relaxed/simple;
	bh=GwXKrXLDCJ1ioIZRPXman09GoEJGD5ieR5lMVCu1pVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHx5xOjt/KNsViWhtIZE2WI+fbDa6b2ekHoREMB3Olyy/CTexOv2UVY4Nv1LgII7OKS3IVf8P/I5h/Wfvd4hlSWshb6pX8ZqQqcCbjttTqLl0MEWxBVoEqfcdo0GDdYQAqjhleBcfltLKNpantYOoDuA0INKHTCbumjcpKIo8pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xl6W+7c3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xl6W+7c3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92AD4C2BBFC;
	Tue, 30 Apr 2024 11:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475762;
	bh=GwXKrXLDCJ1ioIZRPXman09GoEJGD5ieR5lMVCu1pVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xl6W+7c3iSQRDa1CXS3tJbXwIiEQJH2JpYW3IuUFWS1uxN87r+esZvHbTkHhyEL1K
	 z9El/tzE7rhWqIxDcq3dnqLCMXjycZD94psWvg+gA9WsHbyPoQQzQoyfuDfSQcJl0h
	 2YJJYzM7bUIjEVPcJ+xFsmXDW6i5aurKyK2t1OTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 10/80] arm64: dts: mediatek: mt7622: add support for coherent DMA
Date: Tue, 30 Apr 2024 12:39:42 +0200
Message-ID: <20240430103043.714905546@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 3abd063019b6a01762f9fccc39505f29d029360a ]

It improves performance by eliminating the need for a cache flush on rx and tx

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 3ba5a6159434 ("arm64: dts: mediatek: mt7622: fix clock controllers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7622.dtsi | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
index a4c48b2abd209..8a332a3d3718a 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -357,7 +357,7 @@
 		};
 
 		cci_control2: slave-if@5000 {
-			compatible = "arm,cci-400-ctrl-if";
+			compatible = "arm,cci-400-ctrl-if", "syscon";
 			interface-type = "ace";
 			reg = <0x5000 0x1000>;
 		};
@@ -938,6 +938,8 @@
 		power-domains = <&scpsys MT7622_POWER_DOMAIN_ETHSYS>;
 		mediatek,ethsys = <&ethsys>;
 		mediatek,sgmiisys = <&sgmiisys>;
+		mediatek,cci-control = <&cci_control2>;
+		dma-coherent;
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
-- 
2.43.0



