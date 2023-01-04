Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B369AD49
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8CBC433EF;
	Wed,  4 Jan 2023 16:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848886;
	bh=v9iKPrZMYg/bgSJvbowIzC8kGWM8Eifz2LD6Akjp5tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zSBSvQxcd3pZ0s1r3cN2zmJ79h0LvuA5YyNNf1Zb6+6tehcthSvqUcUuLSfO8QZvy
	 lFxkxpfWFgONz2991sGotKYYFhFNftNh0m/5vj46GY2PUCHGYDB03lOVJKm+9zz4RD
	 xUqI9IjD5V8x4eRfjaBQmMcFh0TIg1XUuDTdkXgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	Miles Chen <miles.chen@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 6.1 099/207] arm64: dts: mediatek: mt8195-demo: fix the memory size of node secmon
Date: Wed,  4 Jan 2023 17:05:57 +0100
Message-Id: <20230104160515.055698699@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Macpaul Lin <macpaul.lin@mediatek.com>

commit e4a4175201014c0222f6bab1895a17b3d1b92f08 upstream.

The size of device tree node secmon (bl31_secmon_reserved) was
incorrect. It should be increased to 2MiB (0x200000).

The origin setting will cause some abnormal behavior due to
trusted-firmware-a and related firmware didn't load correctly.
The incorrect behavior may vary because of different software stacks.
For example, it will cause build error in some Yocto project because
it will check if there was enough memory to load trusted-firmware-a
to the reserved memory.

When mt8195-demo.dts sent to the upstream, at that time the size of
BL31 was small. Because supported functions and modules in BL31 are
basic sets when the board was under early development stage.

Now BL31 includes more firmwares of coprocessors and maturer functions
so the size has grown bigger in real applications. According to the value
reported by customers, we think reserved 2MiB for BL31 might be enough
for maybe the following 2 or 3 years.

Cc: stable@vger.kernel.org      # v5.19
Fixes: 6147314aeedc ("arm64: dts: mediatek: Add device-tree for MT8195 Demo board")
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Reviewed-by: Miles Chen <miles.chen@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221111095540.28881-1-macpaul.lin@mediatek.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8195-demo.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/mediatek/mt8195-demo.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8195-demo.dts
@@ -56,10 +56,10 @@
 		#size-cells = <2>;
 		ranges;
 
-		/* 192 KiB reserved for ARM Trusted Firmware (BL31) */
+		/* 2 MiB reserved for ARM Trusted Firmware (BL31) */
 		bl31_secmon_reserved: secmon@54600000 {
 			no-map;
-			reg = <0 0x54600000 0x0 0x30000>;
+			reg = <0 0x54600000 0x0 0x200000>;
 		};
 
 		/* 12 MiB reserved for OP-TEE (BL32)


