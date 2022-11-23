Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFBE1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4A7C433C1;
	Wed, 23 Nov 2022 09:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196406;
	bh=GnFHhqJgy5Blx6aSCEt1Q21ZwsxFFTu/xTF3zjzbjCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E/5hgRoJLrmh4IYclkc8pByuOoHLikjPLNlFZ+rZwPK4RKdGlcS1TfHqkFL2Gf+PS
	 CdNdykFI2e0bAcpriZxAF47BfBcpTBdDGVBikD06KB4IgGW4BRQVSPchLjFPBjiWO8
	 A1N55hgj4UGcPnwr9BBOaKMw1Vg+jw72omU3xNK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 022/314] ASoC: rt1308-sdw: add the default value of some registers
Date: Wed, 23 Nov 2022 09:47:47 +0100
Message-Id: <20221123084626.512339686@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit 75d8b1662ca5c20cf8365575222abaef18ff1f50 ]

The driver missed the default value of register 0xc070/0xc360.
This patch adds that default value to avoid invalid register access
when the device doesn't be enumerated yet.
BugLink: https://github.com/thesofproject/linux/issues/3924

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://lore.kernel.org/r/20221019095715.31082-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1308-sdw.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/rt1308-sdw.h b/sound/soc/codecs/rt1308-sdw.h
index 6668e19d85d4..b5f231f708cb 100644
--- a/sound/soc/codecs/rt1308-sdw.h
+++ b/sound/soc/codecs/rt1308-sdw.h
@@ -139,10 +139,12 @@ static const struct reg_default rt1308_reg_defaults[] = {
 	{ 0x3005, 0x23 },
 	{ 0x3008, 0x02 },
 	{ 0x300a, 0x00 },
+	{ 0xc000 | (RT1308_DATA_PATH << 4), 0x00 },
 	{ 0xc003 | (RT1308_DAC_SET << 4), 0x00 },
 	{ 0xc000 | (RT1308_POWER << 4), 0x00 },
 	{ 0xc001 | (RT1308_POWER << 4), 0x00 },
 	{ 0xc002 | (RT1308_POWER << 4), 0x00 },
+	{ 0xc000 | (RT1308_POWER_STATUS << 4), 0x00 },
 };
 
 #define RT1308_SDW_OFFSET 0xc000
-- 
2.35.1



