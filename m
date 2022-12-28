Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2B41863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35428C433D2;
	Wed, 28 Dec 2022 15:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239962;
	bh=WA8MtBXPsmOfc4X9Y5fEGDSvQo1SK7z+JRzUXyIdYYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2e6zgXQWTnTPzTeydnAtT9P82BidnTQq9QOaZiQga5Q447mUEu5szQ7qKnxeRhTF
	 0dqc0GWZ1QMDas47JMekg8TlQ8pP5wFu/kREyKnrLWeTAHIng3g0+c0fkebKqIk4+l
	 ZeVlTZZPkI9MphMUC2expV6e+acjw8Z/vFLVN6wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0063/1146] arm64: dts: ti: k3-am65-main: Drop dma-coherent in crypto node
Date: Wed, 28 Dec 2022 15:26:42 +0100
Message-Id: <20221228144331.871872192@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jayesh Choudhary <j-choudhary@ti.com>

[ Upstream commit b86833ab3653dbb0dc453eec4eef8615e63de4e2 ]

crypto driver itself is not dma-coherent. So drop it.

Fixes: b366b2409c97 ("arm64: dts: ti: k3-am6: Add crypto accelarator node")
Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Manorit Chawdhry <m-chawdhry@ti.com>
Link: https://lore.kernel.org/r/20221031152520.355653-2-j-choudhary@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
index 4005a73cfea9..ebb1c5ce7aec 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -120,7 +120,6 @@ crypto: crypto@4e00000 {
 		dmas = <&main_udmap 0xc001>, <&main_udmap 0x4002>,
 				<&main_udmap 0x4003>;
 		dma-names = "tx", "rx1", "rx2";
-		dma-coherent;
 
 		rng: rng@4e10000 {
 			compatible = "inside-secure,safexcel-eip76";
-- 
2.35.1



