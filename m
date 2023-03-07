Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5609BA4C
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC32C433EF;
	Tue,  7 Mar 2023 18:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214681;
	bh=x/w9rxm6JtvWRRGQKFwIPj4SNPlJVWM5Kqi+aKqHfkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lNXV3PoTabxFqhFHQP6ra8vuoKKbKKVE4LgNCP/032L3bqj8N6JffoIZ8Ri3FEgvU
	 qG8a4i9KHQ+d5SvaAh4LySdStUECfXQXeRCgBY5/zSMvFT3pYfU8wDpfo0DOMzU5wB
	 tGuWZO5Sq+sncFQyArkDNoadB3CYxddFpRk/UM9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vyacheslav Bocharov <adeep@lexina.in>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/567] arm64: dts: meson-gx: Fix Ethernet MAC address unit name
Date: Tue,  7 Mar 2023 17:55:51 +0100
Message-Id: <20230307165906.495738081@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 8ed5310356bfa47cc6bb4221ae6b21258c52e3d1 ]

Unit names should use hyphens instead of underscores to not cause
warnings.

Fixes: bfe59f92d306 ("ARM64: dts: amlogic: gxbb: Enable NVMEM")
Suggested-by: Vyacheslav Bocharov <adeep@lexina.in>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230111211350.1461860-5-martin.blumenstingl@googlemail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
index ee623ead972e5..f8d46588e582f 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
@@ -232,7 +232,7 @@ sn: sn@14 {
 			reg = <0x14 0x10>;
 		};
 
-		eth_mac: eth_mac@34 {
+		eth_mac: eth-mac@34 {
 			reg = <0x34 0x10>;
 		};
 
-- 
2.39.2



