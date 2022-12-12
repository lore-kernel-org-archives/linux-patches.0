Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D07928ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C74C433F2;
	Mon, 12 Dec 2022 13:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852150;
	bh=PAxi6eeJkAJBPTiO6t6sK57HyXc9bdfpzD8eQdRXDQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NzPjuB+KO7F5SiNMGjFtJl835xtMXymSPew2m4v1TU3eOyFXu6raZinozCALwYcPb
	 283KK0G4vO/BnqjmC8gH0JYcx9O9UbSTo81iz9EZAtkOVQBE13fpEc96AUV9KJQUoc
	 juSm0MhmFNHTL1CdG9Z8plWYk15YeXmrKBd6unnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 021/157] ASoC: rt711-sdca: fix the latency time of clock stop prepare state machine transitions
Date: Mon, 12 Dec 2022 14:16:09 +0100
Message-Id: <20221212130935.357515012@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

[ Upstream commit c7d7d4e7bb1290cc473610b0bb96d9fa606d00e7 ]

Due to the hardware behavior, it takes some time for CBJ detection/impedance sensing/de-bounce.
The ClockStop_NotFinished flag will be raised until these functions are completed.
In ClockStopMode0 mode case, the SdW controller might check this flag from D3 to D0 when the
jack detection interrupt happened.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://lore.kernel.org/r/20221116090318.5017-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711-sdca-sdw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt711-sdca-sdw.c b/sound/soc/codecs/rt711-sdca-sdw.c
index a085b2f530aa..31e77d462ef3 100644
--- a/sound/soc/codecs/rt711-sdca-sdw.c
+++ b/sound/soc/codecs/rt711-sdca-sdw.c
@@ -230,7 +230,7 @@ static int rt711_sdca_read_prop(struct sdw_slave *slave)
 	}
 
 	/* set the timeout values */
-	prop->clk_stop_timeout = 20;
+	prop->clk_stop_timeout = 700;
 
 	/* wake-up event */
 	prop->wake_capable = 1;
-- 
2.35.1



