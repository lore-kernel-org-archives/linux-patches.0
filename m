Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A74179C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B75AC433C1;
	Wed, 30 Nov 2022 18:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833562;
	bh=gF8aaP9WpcIBEagXhF9SJqQyp67+oR/CbMheHWlgdik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rVgGuqvxSuNOTzqlCTt3r7H4vMi4232/sOB71osRIshfeCAl0RtM9F+EY6/JWdi8Y
	 RVssL2WZDhW5GDDV/LTsvdXzE58mUjDh9fcC4+PuB4aPmMDNQl3VXTa5gE7alAMcfa
	 KI0HzdaFKLAgUQ2WYdNlByHY0rPpw8n3yXGOaIF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/206] regulator: twl6030: re-add TWL6032_SUBCLASS
Date: Wed, 30 Nov 2022 19:22:46 +0100
Message-Id: <20221130180535.944068022@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit 3d6c982b26db94cc21bc9f7784f63e8286b7be62 ]

In former times, info->feature was populated via the parent driver
by pdata/regulator_init_data->driver_data for all regulators when
USB_PRODUCT_ID_LSB indicates a TWL6032.
Today, the information is not set, so re-add it at the regulator
definitions.

Fixes: 25d82337705e2 ("regulator: twl: make driver DT only")
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://lore.kernel.org/r/20221120221208.3093727-2-andreas@kemnade.info
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/twl6030-regulator.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/twl6030-regulator.c b/drivers/regulator/twl6030-regulator.c
index 430265c404d6..7c7e3648ea4b 100644
--- a/drivers/regulator/twl6030-regulator.c
+++ b/drivers/regulator/twl6030-regulator.c
@@ -530,6 +530,7 @@ static const struct twlreg_info TWL6030_INFO_##label = { \
 #define TWL6032_ADJUSTABLE_LDO(label, offset) \
 static const struct twlreg_info TWL6032_INFO_##label = { \
 	.base = offset, \
+	.features = TWL6032_SUBCLASS, \
 	.desc = { \
 		.name = #label, \
 		.id = TWL6032_REG_##label, \
@@ -562,6 +563,7 @@ static const struct twlreg_info TWLFIXED_INFO_##label = { \
 #define TWL6032_ADJUSTABLE_SMPS(label, offset) \
 static const struct twlreg_info TWLSMPS_INFO_##label = { \
 	.base = offset, \
+	.features = TWL6032_SUBCLASS, \
 	.desc = { \
 		.name = #label, \
 		.id = TWL6032_REG_##label, \
-- 
2.35.1



