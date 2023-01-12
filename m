Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CECF746A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E46C433EF;
	Thu, 12 Jan 2023 14:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532001;
	bh=+9N/8MwmrzXV21ox5oD2bn67//1PDpAsghUnHesXyBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SCtN0bSgZBfUUK2bB7bIS8PKGlyXWaNsOkyRnhAiBw6Jd1+fzg7ANAcPnOEKmG4k3
	 FJ74FYFlJJEqQD39i19MweMWRGvx4HrxVnttYZxo9dZIAl+Q/HPVDe+1DLuCf2Gmxv
	 q1QXT5KC0jociW3TalH9Qbza/2wpt01LHQ8AAVJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/783] arm64: dts: ti: k3-am65-main: Drop dma-coherent in crypto node
Date: Thu, 12 Jan 2023 14:45:37 +0100
Message-Id: <20230112135525.147148146@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index d04189771c77..4265f627ca16 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -127,7 +127,6 @@ crypto: crypto@4e00000 {
 		dmas = <&main_udmap 0xc000>, <&main_udmap 0x4000>,
 				<&main_udmap 0x4001>;
 		dma-names = "tx", "rx1", "rx2";
-		dma-coherent;
 
 		rng: rng@4e10000 {
 			compatible = "inside-secure,safexcel-eip76";
-- 
2.35.1



