Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367B314A8F
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443D2C433C8;
	Mon, 26 Jun 2023 18:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804353;
	bh=9fIJSvdYO46TvjcA/sHiZ/D2LUpdxE9tD8HDBQEf/MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mP13LyCEGfNoed08dOlJvMBrKF7x5T8btvbKx7YDNyCRLwVCS736iUX2CF4IyR7iI
	 qeqQJ7vMZrLmRU8ac+fMi7w/OCUm1ONdCjQSOVEtUzwt+tfnMgUZaEGsgmfxDPkALk
	 EIJnxofnYSAfTZux/CpRWPN7Zg7PpCV7dgHe4Rwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Frattaroli <frattaroli.nicolas@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 127/170] arm64: dts: rockchip: Enable GPU on SOQuartz CM4
Date: Mon, 26 Jun 2023 20:11:36 +0200
Message-ID: <20230626180806.253568960@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicolas Frattaroli <frattaroli.nicolas@gmail.com>

[ Upstream commit e48824e8a03e5bc3666e9f5461f68d440d9acba0 ]

This enables the Mali-G52 GPU on the SOQuartz CM4 module.

Signed-off-by: Nicolas Frattaroli <frattaroli.nicolas@gmail.com>
Link: https://lore.kernel.org/r/20221112160404.70868-2-frattaroli.nicolas@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Stable-dep-of: cf9ae4a00774 ("arm64: dts: rockchip: fix nEXTRST on SOQuartz")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi b/arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi
index 4d494b53a71ab..4ceb9a979f6ad 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi
@@ -143,6 +143,11 @@
 	status = "disabled";
 };
 
+&gpu {
+	mali-supply = <&vdd_gpu>;
+	status = "okay";
+};
+
 &i2c0 {
 	status = "okay";
 
-- 
2.39.2



