Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFF4522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE28C433C8;
	Sun,  9 Jul 2023 11:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902305;
	bh=+nvfuXGaWBc5EfdQEZttQ/wkcL89p5cqfTmmq3UQDLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bGUW4DKgqq0FWkbO7IEbYXxpuZjIJoaXYgcaErmFV1RyOgfgcKr5er2lCUtjuyG/L
	 6GtOAtuXxnkrF/mFUMk79dSQxjI4SQlLHV36sUcZOgGcYwJrava68+64foM0ax2cfk
	 JEvgBskgAargnUqTy9eztg/eXXyCD8XqIj0/bA5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Romanov <avromanov@sberdevices.ru>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 328/431] drivers: meson: secure-pwrc: always enable DMA domain
Date: Sun,  9 Jul 2023 13:14:36 +0200
Message-ID: <20230709111458.866157312@linuxfoundation.org>
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

From: Alexey Romanov <avromanov@sberdevices.ru>

[ Upstream commit 0bb4644d583789c97e74d3e3047189f0c59c4742 ]

Starting from commit e45f243409db ("firmware: meson_sm:
populate platform devices from sm device tree data") pwrc
is probed successfully and disables unused pwr domains.
By A1 SoC family design, any TEE requires DMA pwr domain
always enabled.

Fixes: b3dde5013e13 ("soc: amlogic: Add support for Secure power domains controller")
Signed-off-by: Alexey Romanov <avromanov@sberdevices.ru>
Acked-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230610090414.90529-1-avromanov@sberdevices.ru
[narmstrong: added fixes tag]
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/amlogic/meson-secure-pwrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/amlogic/meson-secure-pwrc.c b/drivers/soc/amlogic/meson-secure-pwrc.c
index e935187635267..25b4b71df9b89 100644
--- a/drivers/soc/amlogic/meson-secure-pwrc.c
+++ b/drivers/soc/amlogic/meson-secure-pwrc.c
@@ -105,7 +105,7 @@ static struct meson_secure_pwrc_domain_desc a1_pwrc_domains[] = {
 	SEC_PD(ACODEC,	0),
 	SEC_PD(AUDIO,	0),
 	SEC_PD(OTP,	0),
-	SEC_PD(DMA,	0),
+	SEC_PD(DMA,	GENPD_FLAG_ALWAYS_ON | GENPD_FLAG_IRQ_SAFE),
 	SEC_PD(SD_EMMC,	0),
 	SEC_PD(RAMA,	0),
 	/* SRAMB is used as ATF runtime memory, and should be always on */
-- 
2.39.2



