Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D82F522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FABC433C8;
	Sun,  9 Jul 2023 11:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902165;
	bh=28IevJQjAk3Y8Tnlhqqa9ZUj1pLgEcoWDtW/kaCAI6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcdsq6diy6k+XRGTH7YY56iKggxmTm4FOIRk0dwrYeRZ+oEtrd+zr0yqphmOqPVrA
	 trQGwJ+OlO12rsTRr8TgtG5iojaH2gLx66KMAJedIMtNZHHzqvwM7JjucvXXTx6+T6
	 qeSRIe55rGK0SnI3P3so96+3wM93ghRqw9aprSZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 251/431] ARM: dts: stm32: Shorten the AV96 HDMI sound card name
Date: Sun,  9 Jul 2023 13:13:19 +0200
Message-ID: <20230709111457.041151529@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit 0cf765e598712addec34d0208cc1418c151fefb2 ]

Fix the following error in kernel log due to too long sound card name:
"
asoc-audio-graph-card sound: ASoC: driver name too long 'STM32MP1-AV96-HDMI' -> 'STM32MP1-AV96-H'
"

Fixes: e027da342772 ("ARM: dts: stm32: Add bindings for audio on AV96")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
index e67c0fa209cde..7d5d6d4360385 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
@@ -87,7 +87,7 @@ sd_switch: regulator-sd_switch {
 
 	sound {
 		compatible = "audio-graph-card";
-		label = "STM32MP1-AV96-HDMI";
+		label = "STM32-AV96-HDMI";
 		dais = <&sai2a_port>;
 		status = "okay";
 	};
-- 
2.39.2



