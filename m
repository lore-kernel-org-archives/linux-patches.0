Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EFC79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB74C433EF;
	Thu, 12 Jan 2023 14:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533626;
	bh=l1wuZT8MGIVYYTFKEkjyAeCihuBJ63AUnrtE5WvRH04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQ4taH0O2vLSTxZlxaNLeN+5HcLMxun71um5BK0l6pLnUaewcQcFIQuZtguZR1S73
	 cv2Anoe8R3FfRoMdFGzXlTsSz5Kp37Ye7hZoX/2yQRnx/TC5eScrqdx6f0yr9AOXgS
	 cnroXQ+1iVj5aNWcK9/dwJB91nXZUFqtTRjSjtMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 500/783] ASoC: codecs: rt298: Add quirk for KBL-R RVP platform
Date: Thu, 12 Jan 2023 14:53:36 +0100
Message-Id: <20230112135547.388978326@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index dc0273a5a11f..1ca06213e3a3 100644
--- a/sound/soc/codecs/rt298.c
+++ b/sound/soc/codecs/rt298.c
@@ -1168,6 +1168,13 @@ static const struct dmi_system_id force_combo_jack_table[] = {
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



