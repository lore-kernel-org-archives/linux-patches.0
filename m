Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE9B28383
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BhoR+cnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B84C433C8;
	Wed, 15 Nov 2023 19:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077440;
	bh=qaAjU3tlNlVi7J5tZqIgk9oTfkDzu2Q58eJGEML/Y0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BhoR+cnt7OiDJ6L5HylIKWnw1g5l0fBlYt0xlfPQGZR1+vg1JIPFi2QN45YmiRcYw
	 KEgqXbeA21S/SwzR9ZfJUl4rLVp9qI9CHlYQ7iEF5IyC4bPrs91S4zRrHoxAtIH+Lj
	 axA/u/NYomk1/ECNYbm41RmDo0jAcVyNBiEnmHNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh+dt@kernel.org>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 305/603] arm64: dts: ti: k3-j721s2-evm-gesi: Specify base dtb for overlay file
Date: Wed, 15 Nov 2023 14:14:10 -0500
Message-ID: <20231115191634.514331440@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit 35be6ac964450687ab39b846d65ee1cb2a352280 ]

Specify the base dtb file k3-j721s2-common-proc-board.dtb on which the
k3-j721s2-evm-gesi-exp-board.dtbo overlay has to be applied. Name the
resulting dtb as k3-j721s2-evm.dtb.

Fixes: cac04e27f093 ("arm64: dts: ti: k3-j721s2: Add overlay to enable main CPSW2G with GESI")
Reported-by: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Link: https://lore.kernel.org/r/20230912043308.20629-1-s-vadapalli@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/Makefile b/arch/arm64/boot/dts/ti/Makefile
index e7b8e2e7f083d..51dab9499cd0b 100644
--- a/arch/arm64/boot/dts/ti/Makefile
+++ b/arch/arm64/boot/dts/ti/Makefile
@@ -66,6 +66,8 @@ dtb-$(CONFIG_ARCH_K3) += k3-j721e-sk.dtb
 dtb-$(CONFIG_ARCH_K3) += k3-am68-sk-base-board.dtb
 dtb-$(CONFIG_ARCH_K3) += k3-j721s2-common-proc-board.dtb
 dtb-$(CONFIG_ARCH_K3) += k3-j721s2-evm-gesi-exp-board.dtbo
+k3-j721s2-evm-dtbs := k3-j721s2-common-proc-board.dtb k3-j721s2-evm-gesi-exp-board.dtbo
+dtb-$(CONFIG_ARCH_K3) += k3-j721s2-evm.dtb
 
 # Boards with J784s4 SoC
 dtb-$(CONFIG_ARCH_K3) += k3-am69-sk.dtb
-- 
2.42.0



