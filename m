Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9757C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428B6C433D2;
	Mon, 24 Apr 2023 13:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342380;
	bh=9BcY4NpXlmM8SJTPBshNDG4fj8b+emeHCZaMQ2kVci8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVnbbutqkFv4+VKruki2BkJdDWmdune56i/w90EtmK1E2lZbeNlCc5YeTlcPhIh85
	 dgDLc3FmLDjvG2DYwpEAcmeuV50CuNJeasfqGIhW9zyksnyPZchI0HvrTGZBk9SITF
	 Wcl7qo+wUKMc8M92OtXSG1PJLfaM7nsrVSrkEnLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 07/73] regulator: fan53555: Fix wrong TCS_SLEW_MASK
Date: Mon, 24 Apr 2023 15:16:21 +0200
Message-Id: <20230424131129.322830569@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit c5d5b55b3c1a314137a251efc1001dfd435c6242 ]

The support for TCS4525 regulator has been introduced with a wrong
ramp-rate mask, which has been defined as a logical expression instead
of a bit shift operation.

For clarity, fix it using GENMASK() macro.

Fixes: 914df8faa7d6 ("regulator: fan53555: Add TCS4525 DCDC support")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20230406171806.948290-4-cristian.ciocaltea@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fan53555.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index df53464afe3a0..ecd5a50c61660 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -61,7 +61,7 @@
 #define TCS_VSEL1_MODE		(1 << 6)
 
 #define TCS_SLEW_SHIFT		3
-#define TCS_SLEW_MASK		(0x3 < 3)
+#define TCS_SLEW_MASK		GENMASK(4, 3)
 
 enum fan53555_vendor {
 	FAN53526_VENDOR_FAIRCHILD = 0,
-- 
2.39.2



