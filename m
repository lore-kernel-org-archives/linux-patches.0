Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC0B168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C667AC433D2;
	Mon,  8 May 2023 10:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541653;
	bh=AP++7PdnSpfvOIuIV7P6kQ9eLUcDL9xu6UCnqt0PVSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mbU34gncgynZ0ZCIRrnraLFEp76cBp/TL34xyFGG4d+8P54cX+ha4V/anBUS54h3P
	 tu0E6AlPbt4pi5BiTNqNMurw1CLFMo/9cSubquxi8EMGKXl6Of2hWek8ecOcn7cJYY
	 3otsn4a1m2oE5yHDedKH9mapJ4eWDtqL3OBZ9rH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 184/663] arm64: dts: ti: k3-am625: Correct L2 cache size to 512KB
Date: Mon,  8 May 2023 11:40:10 +0200
Message-Id: <20230508094434.405530399@linuxfoundation.org>
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
index cea2cc7de5dd3..26d78562ceba7 100644
--- a/arch/arm64/boot/dts/ti/k3-am625.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am625.dtsi
@@ -147,7 +147,7 @@
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



