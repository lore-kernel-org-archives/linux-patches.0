Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A951549F
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBA8C433EF;
	Mon,  8 May 2023 10:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540012;
	bh=5Or5I+sf5+beT4hrwEZHob3aNtQiozivCqxqd9luJ3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wa37Gnc6yFYnJb1OBHFPi8Z11YNEQbkzZ2xfHHBnTmnlUhSrtSE/ejYJUJR1uOjMA
	 wlEwIC22AwJFNhJhXZg4zSHMjNqLFz7Un4iqJKSLGYmOnC37lVKwDLAeB42C+0K/j4
	 LNk2Z4tz8PMq/s51O1+ifSFX8gK73XqzuOQWi22o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 178/611] arm64: dts: ti: k3-am625: Correct L2 cache size to 512KB
Date: Mon,  8 May 2023 11:40:20 +0200
Message-Id: <20230508094428.154840505@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
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

[ Upstream commit 6974371cab1c488a53960945cb139b20ebb5f16b ]

Per AM62x SoC datasheet[0] L2 cache is 512KB.

[0] https://www.ti.com/lit/gpn/am625 Page 1.

Fixes: f1d17330a5be ("arm64: dts: ti: Introduce base support for AM62x SoC")
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20230320044935.2512288-1-vigneshr@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am625.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am625.dtsi b/arch/arm64/boot/dts/ti/k3-am625.dtsi
index 887f31c23fef6..31b37abbb8d5c 100644
--- a/arch/arm64/boot/dts/ti/k3-am625.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am625.dtsi
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



