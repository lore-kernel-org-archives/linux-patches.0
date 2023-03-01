Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115E0847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEC1C433D2;
	Wed,  1 Mar 2023 18:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694279;
	bh=TcEvZYHrQCR/hfcOxedM7Vg4Fnq1Z6Qy069MGALnJCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2kX54FGVw2yGg2R4ImG2cQXhkVIBeys6HFxrX4g1XKBgoSree3D7cQh0XORyW51k
	 ya7vTViFrgA0deQMmmh0k5IQQ01crkv1VXkwy+XX88mIjheTXC8ebjge+sPeoj6Zf5
	 OwfYhvSu8n+SP7eVBCJU+dZxoI/j4nhhWHREZMEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Yu <jack.yu@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 08/22] ASoC: rt715-sdca: fix clock stop prepare timeout issue
Date: Wed,  1 Mar 2023 19:08:41 +0100
Message-Id: <20230301180652.989600676@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180652.658125575@linuxfoundation.org>
References: <20230301180652.658125575@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit 2036890282d56bcbf7f915ba9e04bf77967ab231 ]

Modify clock_stop_timeout value for rt715-sdca according to
the requirement of internal clock trimming.

Signed-off-by: Jack Yu <jack.yu@realtek.com>
Link: https://lore.kernel.org/r/574b6586267a458cac78c5ac4d5b10bd@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt715-sdca-sdw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt715-sdca-sdw.c b/sound/soc/codecs/rt715-sdca-sdw.c
index 0f4354eafef25..85abf8073c278 100644
--- a/sound/soc/codecs/rt715-sdca-sdw.c
+++ b/sound/soc/codecs/rt715-sdca-sdw.c
@@ -167,7 +167,7 @@ static int rt715_sdca_read_prop(struct sdw_slave *slave)
 	}
 
 	/* set the timeout values */
-	prop->clk_stop_timeout = 20;
+	prop->clk_stop_timeout = 200;
 
 	return 0;
 }
-- 
2.39.0



