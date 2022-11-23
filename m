Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE801C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA5DC433D7;
	Wed, 23 Nov 2022 09:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194819;
	bh=dPYviG2x1KuTLEznEqp0BpXt7OOMBWQoC0Si/zlHnRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1n4nyNz461X88+f/78diTpg6/RZfDqpVpWSFEUoY1/BeJyewelo/elKHZWoQDURz
	 PCQQ17o7HpzDOKGE6yBIngzmJz8Kgm1OgvAYGjvqFv7B+/+JIIko8oH+Tg38bpvzVI
	 /8/kCqkPZXeoMotYoBxekr9xGc3DH8ZjyJHj9O5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siarhei Volkau <lis8215@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/156] ASoC: codecs: jz4725b: fix reported volume for Master ctl
Date: Wed, 23 Nov 2022 09:50:27 +0100
Message-Id: <20221123084600.491577640@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Siarhei Volkau <lis8215@gmail.com>

[ Upstream commit 088777bf65b98cfa4b5378119d0a7d49a58ece44 ]

DAC volume control is the Master Playback Volume at the moment
and it reports wrong levels in alsamixer and other alsa apps.

The patch fixes that, as stated in manual on the jz4725b SoC
(16.6.3.4 Programmable attenuation: GOD) the ctl range varies
from -22.5dB to 0dB with 1.5dB step.

Signed-off-by: Siarhei Volkau <lis8215@gmail.com>
Link: https://lore.kernel.org/r/20221016132648.3011729-3-lis8215@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/jz4725b.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/jz4725b.c b/sound/soc/codecs/jz4725b.c
index a04b8d5d1ded..1f7a234266b9 100644
--- a/sound/soc/codecs/jz4725b.c
+++ b/sound/soc/codecs/jz4725b.c
@@ -142,8 +142,8 @@ struct jz_icdc {
 	struct clk *clk;
 };
 
-static const SNDRV_CTL_TLVD_DECLARE_DB_LINEAR(jz4725b_dac_tlv, -2250, 0);
 static const SNDRV_CTL_TLVD_DECLARE_DB_LINEAR(jz4725b_line_tlv, -1500, 600);
+static const SNDRV_CTL_TLVD_DECLARE_DB_SCALE(jz4725b_dac_tlv, -2250, 150, 0);
 
 static const struct snd_kcontrol_new jz4725b_codec_controls[] = {
 	SOC_DOUBLE_TLV("Master Playback Volume",
-- 
2.35.1



