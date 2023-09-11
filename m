Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52AD11715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58DB4C433C8;
	Mon, 11 Sep 2023 15:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445153;
	bh=7q9vkQ0N4NgdtAXEbYEoAgi/5ERczHGZER5bm/BScXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVyWpPXSElComLH9Sh9CpnlBAcmmJbNqrJHXJSjJ5nhscC56K4ryrjFoYJMwab/Eo
	 IeHeKPm8glS0zq1+LNhGdQRvAAoXxT6XTZXMbUgn4igpwdsvKR4gZiuyKxcRr2jEQS
	 1AGkbt83emy/ou1fHUBJCDjwA6nisWz5MzEc+EhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 245/600] ARM: dts: stm32: YAML validation fails for Odyssey Boards
Date: Mon, 11 Sep 2023 15:44:38 +0200
Message-ID: <20230911134640.828519577@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>

[ Upstream commit 84a34e1862aae43e4dcdfb743a7dd3ade1fe4a3c ]

"make dtbs_check" gives following output :
stm32mp157c-odyssey.dt.yaml: gpu@59000000: 'contiguous-area' does not match
any of the regexes: 'pinctrl-[0-9]+'
>From schema: Documentation/devicetree/bindings/gpu/vivante,gc.yaml

Signed-off-by: Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Stable-dep-of: 966f04a89d77 ("ARM: dts: stm32: Add missing detach mailbox for Odyssey SoM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi b/arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi
index 2d9461006810c..e22871dc580c8 100644
--- a/arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi
@@ -62,11 +62,6 @@ retram: retram@38000000 {
 			reg = <0x38000000 0x10000>;
 			no-map;
 		};
-
-		gpu_reserved: gpu@d4000000 {
-			reg = <0xd4000000 0x4000000>;
-			no-map;
-		};
 	};
 
 	led {
@@ -80,11 +75,6 @@ led-blue {
 	};
 };
 
-&gpu {
-	contiguous-area = <&gpu_reserved>;
-	status = "okay";
-};
-
 &i2c2 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c2_pins_a>;
-- 
2.40.1



