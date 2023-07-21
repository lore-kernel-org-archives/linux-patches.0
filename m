Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DB4200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07730C433C8;
	Fri, 21 Jul 2023 18:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965904;
	bh=KzKq2My/U6f7nHF21bcVYK0vy+JrCDYjvnK0gfQVCxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HnKZqxJodHRG1FE3qyqbO04IZ8L1RIJrC/oU2kqQgXXR4HGltWqKDlxN4FLOpLf91
	 hPDqJ1DseWZZgrsWy0KXNoNhs7OAxOE0WtOY+Uhk9HYGWf0mE746AAjT9D6jdCXJSk
	 DkoUz/weaim6DB3rGmXl9suRd9GZvPspAlFj/yOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/532] arm64: dts: renesas: ulcb-kf: Remove flow control for SCIF1
Date: Fri, 21 Jul 2023 18:00:59 +0200
Message-ID: <20230721160622.831107676@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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
index 61bd4df09df0d..26cb5f14f9c7a 100644
--- a/arch/arm64/boot/dts/renesas/ulcb-kf.dtsi
+++ b/arch/arm64/boot/dts/renesas/ulcb-kf.dtsi
@@ -270,7 +270,7 @@ hscif0_pins: hscif0 {
 	};
 
 	scif1_pins: scif1 {
-		groups = "scif1_data_b", "scif1_ctrl";
+		groups = "scif1_data_b";
 		function = "scif1";
 	};
 
@@ -330,7 +330,6 @@ rsnd_for_pcm3168a_capture: endpoint {
 &scif1 {
 	pinctrl-0 = <&scif1_pins>;
 	pinctrl-names = "default";
-	uart-has-rtscts;
 
 	status = "okay";
 };
-- 
2.39.2



