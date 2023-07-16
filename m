Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14168F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246F0C433C8;
	Sun, 16 Jul 2023 20:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538327;
	bh=Dn5O9FtzjDO3T1bXEQU9cHUp6OVsz+LhmVVkGMdlkdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eT5d+oQSBDESMwk8jNwbue6saAiU8JfptAdhjsjTae8Qck3VlztVKwfrjJ3Flciwd
	 NsukwnSS/vqR8R+PKgi1Pam+QMuA/RlC8zPBukzzTM157PSiImP45lyVrJeWUn16my
	 ko/oWiewmq58jO7TG8okA+EcJxxMKoYpdkUVIx3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 394/800] arm64: dts: ti: k3-j784s4-evm: Fix main_i2c0 alias
Date: Sun, 16 Jul 2023 21:44:07 +0200
Message-ID: <20230716194958.222499629@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nishanth Menon <nm@ti.com>

[ Upstream commit c10a9df30e3401bd5a5ee43f1afd6c2b2ca75ad7 ]

main_i2c0 is aliased as i2c0 which creates a problem for u-boot R5
SPL attempting to reuse the same definition in the common board
detection logic as it looks for the first i2c instance as the bus on
which to detect the eeprom to understand the board variant involved.
Switch main_i2c0 to i2c3 alias allowing us to introduce wkup_i2c0
and potentially space for mcu_i2c instances in the gap for follow on
patches.

Fixes: e20a06aca5c9 ("arm64: dts: ti: Add support for J784S4 EVM board")
Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Link: https://lore.kernel.org/r/20230602214937.2349545-2-nm@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j784s4-evm.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j784s4-evm.dts b/arch/arm64/boot/dts/ti/k3-j784s4-evm.dts
index f33815953e779..e8e007e4a7d4f 100644
--- a/arch/arm64/boot/dts/ti/k3-j784s4-evm.dts
+++ b/arch/arm64/boot/dts/ti/k3-j784s4-evm.dts
@@ -23,7 +23,7 @@ aliases {
 		serial2 = &main_uart8;
 		mmc0 = &main_sdhci0;
 		mmc1 = &main_sdhci1;
-		i2c0 = &main_i2c0;
+		i2c3 = &main_i2c0;
 	};
 
 	memory@80000000 {
-- 
2.39.2



