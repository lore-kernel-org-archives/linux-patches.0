Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737F311715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87EBC433C7;
	Mon, 11 Sep 2023 15:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445145;
	bh=PO2ffL1Z53w8zCXZ9bX9ktfK3HkUQbhBVIdktQX692M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZ31aSh8AfYaQr8HR9eVp120nzR4cU44/G/LHTCbNBbwUN+y1gTtpdHHBsrORwbn/
	 9gFCnhE8gbHenJjRiiaW5tqpqLwfOdXVrSXQq0fJEgNqyblGjsi9u2VSUi8wDRW/um
	 mFkgT5WPcmf+O5Oc34ksTtI7XsMftC6XLJjKiHNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 242/600] ARM: dts: stm32: YAML validation fails for Argon Boards
Date: Mon, 11 Sep 2023 15:44:35 +0200
Message-ID: <20230911134640.742211032@linuxfoundation.org>
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

[ Upstream commit fc8d2b21bc5d5d7a6eadaa8c2a5d2e6856689480 ]

"make dtbs_check" gives following output :
stm32mp157c-emstamp-argon.dtb: gpu@59000000: 'contiguous-area' does not match
any of the regexes: 'pinctrl-[0-9]+'
>From schema: Documentation/devicetree/bindings/gpu/vivante,gc.yaml

Signed-off-by: Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Stable-dep-of: 0ee0ef38aa9f ("ARM: dts: stm32: Add missing detach mailbox for emtrion emSBC-Argon")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp157c-emstamp-argon.dtsi | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp157c-emstamp-argon.dtsi b/arch/arm/boot/dts/stm32mp157c-emstamp-argon.dtsi
index 7d11c50b9e408..b01470a9a3d53 100644
--- a/arch/arm/boot/dts/stm32mp157c-emstamp-argon.dtsi
+++ b/arch/arm/boot/dts/stm32mp157c-emstamp-argon.dtsi
@@ -68,11 +68,6 @@ retram: retram@38000000 {
 			reg = <0x38000000 0x10000>;
 			no-map;
 		};
-
-		gpu_reserved: gpu@dc000000 {
-			reg = <0xdc000000 0x4000000>;
-			no-map;
-		};
 	};
 
 	led: gpio_leds {
@@ -183,10 +178,6 @@ phy0: ethernet-phy@0 {
 	};
 };
 
-&gpu {
-	contiguous-area = <&gpu_reserved>;
-};
-
 &hash1 {
 	status = "okay";
 };
-- 
2.40.1



