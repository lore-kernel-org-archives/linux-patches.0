Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3331515CB2
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2C3C433D6;
	Tue,  8 Nov 2022 14:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916956;
	bh=3GbL4dcmGlWKmU83u3q3YZQkedmXKpi+Ui/bhZ57wR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=irj6gSrpunGTTcDV9yJc42+3cjG24aZhAqJ5/UMRC+2mauQsy3yFlOBLFdS/rF4DJ
	 1NGIQB/Dgw3VTJbcvSzzRnWSoCZCuwGZOe/ls9Ps0RHtbZ7HXzc7qj8Pi+ucm3hHtt
	 +qLbpG1h3RfvvQHtFdmX/FAJv8bijHsZ5IJ9Q5Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	petrben@gmail.com,
	Petr Benes <petr.benes@ysoft.com>,
	=?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.0 155/197] ARM: dts: imx6dl-yapp4: Do not allow PM to switch PU regulator off on Q/QP
Date: Tue,  8 Nov 2022 14:39:53 +0100
Message-Id: <20221108133401.992825285@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Petr Benes <petr.benes@ysoft.com>

commit 5e67d47d0b010f0704aca469d6d27637b1dcb2ce upstream.

Fix our design flaw in supply voltage distribution on the Quad and QuadPlus
based boards.

The problem is that we supply the SoC cache (VDD_CACHE_CAP) from VDD_PU
instead of VDD_SOC. The VDD_PU internal regulator can be disabled by PM
if VPU or GPU is not used. If that happens the system freezes. To prevent
that configure the reg_pu regulator to be always on.

Fixes: 0de4ab81ab26 ("ARM: dts: imx6dl-yapp4: Add Y Soft IOTA Crux/Crux+ board")
Cc: petrben@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Petr Benes <petr.benes@ysoft.com>
Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/imx6q-yapp4-crux.dts       | 4 ++++
 arch/arm/boot/dts/imx6qp-yapp4-crux-plus.dts | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/imx6q-yapp4-crux.dts b/arch/arm/boot/dts/imx6q-yapp4-crux.dts
index 15f4824a5142..bddf3822ebf7 100644
--- a/arch/arm/boot/dts/imx6q-yapp4-crux.dts
+++ b/arch/arm/boot/dts/imx6q-yapp4-crux.dts
@@ -33,6 +33,10 @@ &oled_1309 {
 	status = "okay";
 };
 
+&reg_pu {
+	regulator-always-on;
+};
+
 &reg_usb_h1_vbus {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/imx6qp-yapp4-crux-plus.dts b/arch/arm/boot/dts/imx6qp-yapp4-crux-plus.dts
index cea165f2161a..afaf4a6759d4 100644
--- a/arch/arm/boot/dts/imx6qp-yapp4-crux-plus.dts
+++ b/arch/arm/boot/dts/imx6qp-yapp4-crux-plus.dts
@@ -33,6 +33,10 @@ &oled_1309 {
 	status = "okay";
 };
 
+&reg_pu {
+	regulator-always-on;
+};
+
 &reg_usb_h1_vbus {
 	status = "okay";
 };
-- 
2.38.1



