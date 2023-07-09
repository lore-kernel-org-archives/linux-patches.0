Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C246D522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B56C433C8;
	Sun,  9 Jul 2023 11:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902319;
	bh=MEjax2E3uwZ/Q7uTHGyL3toADYhbdwMSK5uHSBlQBd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZqtNoXxVJRPWkiDXsN6KM23ecCTHRYRpZTm6x8QW7OqDN8RkbAw1BK4pdCtOzr4F
	 YnemUJxupDlYdD7AIfY46D6WcvMq/Lo91EWpwTJg5rdFrtgoRGbNFs3mk1MhgnLQ4a
	 H0bFbCp1LDpLCArbKPMvKh5nOsRvY50fwpFo38dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 306/431] arm64: dts: ti: k3-am69-sk: Fix main_i2c0 alias
Date: Sun,  9 Jul 2023 13:14:14 +0200
Message-ID: <20230709111458.336815272@linuxfoundation.org>
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

From: Nishanth Menon <nm@ti.com>

[ Upstream commit b38c6ced4ec5b3f6260ff6cc2b71e8a3d8c897d7 ]

main_i2c0 is aliased as i2c0 which creates a problem for u-boot R5
SPL attempting to reuse the same definition in the common board
detection logic as it looks for the first i2c instance as the bus on
which to detect the eeprom to understand the board variant involved.
Switch main_i2c0 to i2c3 alias allowing us to introduce wkup_i2c0
and potentially space for mcu_i2c instances in the gap for follow on
patches.

Fixes: 635fb18ba008 ("arch: arm64: dts: Add support for AM69 Starter Kit")
Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Link: https://lore.kernel.org/r/20230602214937.2349545-5-nm@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am69-sk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am69-sk.dts b/arch/arm64/boot/dts/ti/k3-am69-sk.dts
index bc49ba534790e..f364b7803115d 100644
--- a/arch/arm64/boot/dts/ti/k3-am69-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am69-sk.dts
@@ -23,7 +23,7 @@ chosen {
 	aliases {
 		serial2 = &main_uart8;
 		mmc1 = &main_sdhci1;
-		i2c0 = &main_i2c0;
+		i2c3 = &main_i2c0;
 	};
 
 	memory@80000000 {
-- 
2.39.2



