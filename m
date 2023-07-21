Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D03D20F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0A7C433C8;
	Fri, 21 Jul 2023 18:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965822;
	bh=56f1In5tbzygGHl5qDvchEX5W2hG6dnIKV1N39LOWoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RC3OoGIGIhhdMtjzu9nkpY3HKeZ5HDCIv93VWfWxz9ZGYMCH1hsGAYkjbQb1idKZ4
	 mZ+L2Ifd23BnSQ6S3e5IzVnv2R8E0j1b69OAZTSVkxkPH/gprhRCIBqKKVROs0dNOE
	 A8hvjoxuIR1J0be8sNX2+7JL9sPrjifoegFEk+eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	"H. Nikolaus Schaller" <hns@goldelico.com>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 126/532] ARM: dts: gta04: Move model property out of pinctrl node
Date: Fri, 21 Jul 2023 18:00:30 +0200
Message-ID: <20230721160621.302240639@linuxfoundation.org>
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

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 4ffec92e70ac5097b9f67ec154065305b16a3b46 ]

The model property should be at the top level, let's move it out
of the pinctrl node.

Fixes: d2eaf949d2c3 ("ARM: dts: omap3-gta04a5one: define GTA04A5 variant with OneNAND")
Cc: Andreas Kemnade <andreas@kemnade.info>
Cc: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap3-gta04a5one.dts | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap3-gta04a5one.dts b/arch/arm/boot/dts/omap3-gta04a5one.dts
index 9db9fe67cd63b..95df45cc70c09 100644
--- a/arch/arm/boot/dts/omap3-gta04a5one.dts
+++ b/arch/arm/boot/dts/omap3-gta04a5one.dts
@@ -5,9 +5,11 @@
 
 #include "omap3-gta04a5.dts"
 
-&omap3_pmx_core {
+/ {
 	model = "Goldelico GTA04A5/Letux 2804 with OneNAND";
+};
 
+&omap3_pmx_core {
 	gpmc_pins: pinmux_gpmc_pins {
 		pinctrl-single,pins = <
 
-- 
2.39.2



