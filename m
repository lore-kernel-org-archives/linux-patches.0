Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CBF4F85C5;
	Wed, 30 Sep 2026 15:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782499; cv=none; b=n/yO7Tzz4w2OUYeRQ/lK7qulE/TGc25KqwAQzs4UnmAJQZreQrBFLupZbIc+B7PxEwGcy/uaCnq7LM98v7JRX7fljPb+UBDfLSKhQH1Ij/RzMDVrwTAI29qMFYqbJdvJqVTG6UCPcq1Z5DaFza8cTCsmaGkmeNdUR7AfyTgYu7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782499; c=relaxed/simple;
	bh=zeHfdXxPvgejnzi7t/DXVwF9zo4c2XNVOh6EpWqguyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kULskgINN+0tQmkZACwnB6fzfCNVozWH6yNmwgTITDCZ/L3hz4FMUYIyuRWhKGaRESBWZcww5UThGDKMQAo8m1tILySvZoCeYvOFESqapTmPds89S7r9aqM2U0m1/qvQ/yQAuBoXpXkl450HsPxx8Pnq1m7aSyeqZEBZ51BMGZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPYS1Fkp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPYS1Fkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029B41F00899;
	Wed, 30 Sep 2026 15:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782490;
	bh=eyhKv5hkob3YrbNah8LkimQb0kr2KTfkVRu/WuqIis0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zPYS1Fkpi9DiHN+N824iBBDYfbKzssHIQfWiTakFTx109g64ls5AEoH3KxXWJ3dDH
	 WmcuaO06Ny+KcEFpwiJ7od/djcALmkW88/A7WQ9lXtQMMb5dk/6UBtPoirMzMcfAQB
	 vS+3XGqngDJZwvG8rDnpUDC+gf3KymdmErEZTafI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Jarkko Nikula <jarkko.nikula@bitmer.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/595] ASoC: ti: omap3pandora: update board check to use DT compatible
Date: Wed, 30 Sep 2026 17:18:33 +0200
Message-ID: <20260930152348.158062270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

[ Upstream commit 45efb8fbdae303539e7fb5562e147583d4ed63ad ]

The omap3pandora driver contains a check for the ARM machine ID via the
machine_is_omap3_pandora() macro. The board concerned now supports
only FDT booting, which does not use machine IDs, and therefore the
code should be updated to check the DT compatible property instead. The
legacy board file for this machine was removed in commit 7fcf7e061edd
("ARM: OMAP2+: Remove legacy booting support for Pandora").
The presence of this machine ID check prevents the removal of machine
IDs no longer used by the kernel from arch/arm/tools/mach-types,
because the machine_is_*() macros are generated from mach-types. To
resolve this issue, use of_machine_is_compatible() instead.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Acked-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/omap3pandora.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/ti/omap3pandora.c b/sound/soc/ti/omap3pandora.c
index a287e9747c2a1..3cec2eaafe62f 100644
--- a/sound/soc/ti/omap3pandora.c
+++ b/sound/soc/ti/omap3pandora.c
@@ -11,12 +11,12 @@
 #include <linux/delay.h>
 #include <linux/regulator/consumer.h>
 #include <linux/module.h>
+#include <linux/of.h>
 
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/soc.h>
 
-#include <asm/mach-types.h>
 #include <linux/platform_data/asoc-ti-mcbsp.h>
 
 #include "omap-mcbsp.h"
@@ -224,7 +224,8 @@ static int __init omap3pandora_soc_init(void)
 {
 	int ret;
 
-	if (!machine_is_omap3_pandora())
+	if (!of_machine_is_compatible("openpandora,omap3-pandora-600mhz") &&
+		!of_machine_is_compatible("openpandora,omap3-pandora-1ghz"))
 		return -ENODEV;
 
 	pr_info("OMAP3 Pandora SoC init\n");
-- 
2.53.0



