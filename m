Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340D2168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9074C433EF;
	Mon,  8 May 2023 10:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541656;
	bh=gq2WjvZrCRTLHkAf17YogQc9bKTAC7ierVRLqekK1uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDUSEwIo1s2OorXF0Fp7jjAGS0qAxJdDqUnZfxjF8dpEUzrUrBCWxjWuTXvTqH2dX
	 zh2X+0wMRF3pcxGURqt1nAZer/YHc/7t9tk1OHRvTz2sl3defU3Fzx1oS//E98KAUp
	 6QnINUT1BOBgK+6QiJRNpt21kWchTg6BWG0qGwqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 185/663] arm64: dts: ti: k3-am62a7: Correct L2 cache size to 512KB
Date: Mon,  8 May 2023 11:40:11 +0200
Message-Id: <20230508094434.434379557@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit 438b8dc949bf45979c32553e96086ff1c6e2504e ]

Per AM62Ax SoC datasheet[0] L2 cache is 512KB.

[0] https://www.ti.com/lit/gpn/am62a7 Page 1.

Fixes: 5fc6b1b62639 ("arm64: dts: ti: Introduce AM62A7 family of SoCs")
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20230320044935.2512288-2-vigneshr@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a7.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a7.dtsi b/arch/arm64/boot/dts/ti/k3-am62a7.dtsi
index 331d89fda29d0..f1ebaec404fbc 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a7.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62a7.dtsi
@@ -96,7 +96,7 @@
 	L2_0: l2-cache0 {
 		compatible = "cache";
 		cache-level = <2>;
-		cache-size = <0x40000>;
+		cache-size = <0x80000>;
 		cache-line-size = <64>;
 		cache-sets = <512>;
 	};
-- 
2.39.2



