Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F708F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B5DC433C8;
	Sun, 16 Jul 2023 20:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540124;
	bh=XyocUilrO7CofVsKrv3mYHz9JqTTG4tBbiYS3kNwYqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsQqcgVhzHgjoY5DJi/uvJ8RW9ahMqN5jLlwhqkbplMhMlQ3YX3QaaeLdIHEE2IHl
	 Pz1MnFa3JfsTiWAC3vuLtoye0pGsxIhCP8p3EDJ70MQs7R1sxKSTHaaNf1ivVl4gHS
	 4bKGrc0YprXerJ4nBa/paVkkfn81zvDgVfbJZHAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 224/591] arm64: dts: renesas: ulcb-kf: Remove flow control for SCIF1
Date: Sun, 16 Jul 2023 21:46:03 +0200
Message-ID: <20230716194929.668039555@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 1a2c4e5635177939a088d22fa35c6a7032725663 ]

The schematics are misleading, the flow control is for HSCIF1. We need
SCIF1 for GNSS/GPS which does not use flow control.

Fixes: c6c816e22bc8 ("arm64: dts: ulcb-kf: enable SCIF1")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230525084823.4195-2-wsa+renesas@sang-engineering.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/ulcb-kf.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/ulcb-kf.dtsi b/arch/arm64/boot/dts/renesas/ulcb-kf.dtsi
index 408871c2859d1..588b14b66b6fb 100644
--- a/arch/arm64/boot/dts/renesas/ulcb-kf.dtsi
+++ b/arch/arm64/boot/dts/renesas/ulcb-kf.dtsi
@@ -393,7 +393,7 @@ hscif0_pins: hscif0 {
 	};
 
 	scif1_pins: scif1 {
-		groups = "scif1_data_b", "scif1_ctrl";
+		groups = "scif1_data_b";
 		function = "scif1";
 	};
 
@@ -447,7 +447,6 @@ rsnd_for_pcm3168a_capture: endpoint {
 &scif1 {
 	pinctrl-0 = <&scif1_pins>;
 	pinctrl-names = "default";
-	uart-has-rtscts;
 
 	status = "okay";
 };
-- 
2.39.2



