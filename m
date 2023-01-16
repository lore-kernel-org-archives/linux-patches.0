Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B7E46B8
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10779C433EF;
	Mon, 16 Jan 2023 16:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887889;
	bh=MAAF9cFBWVvZUUf8z3zc8SydFeMhTvgVuM+fYaPOVmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qwpv3bxqJ13zXrGJa16JPAGB++VES3LAPYWe37VoCDOTe2O3ABlgJejSTvAtBfMEL
	 g5N/vGr0HRqmhXTII2fPoSvlRxwo8ZZA6GUeyQAA8S0iRpbc9Vqt2Z58M7ZGHeEfTy
	 9c5aBoareulTB+kd59+cddsho0LjDGduDv2G56Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 320/521] ASoC: codecs: rt298: Add quirk for KBL-R RVP platform
Date: Mon, 16 Jan 2023 16:49:42 +0100
Message-Id: <20230116154901.461942302@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 953dbd1cef18ce9ac0d69c1bd735b929fe52a17e ]

KBL-R RVP platforms also use combojack, so we need to enable that
configuration for them.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20221010121955.718168-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt298.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/codecs/rt298.c b/sound/soc/codecs/rt298.c
index 06cdba4edfe2..3181b91a025b 100644
--- a/sound/soc/codecs/rt298.c
+++ b/sound/soc/codecs/rt298.c
@@ -1169,6 +1169,13 @@ static const struct dmi_system_id force_combo_jack_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Geminilake")
 		}
 	},
+	{
+		.ident = "Intel Kabylake R RVP",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Kabylake Client platform")
+		}
+	},
 	{ }
 };
 
-- 
2.35.1



