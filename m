Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81F11171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E86AC433C7;
	Mon, 21 Aug 2023 20:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648564;
	bh=JoQBrU1dpDR8Ailph7uRwIdobolGQZcOg8MMoE7sTpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c2xe+uxmlXVDBdsa/sCSJEULLV6wWrRiSOEfY+xJSDPWfDcU3Xr+U+Im2+ttycKgd
	 b/3NvDEEBdbg2Q8t7XjumLoQy+HJxPeGnu0iRYVPWTDFU5uJxJi4zJXu4VvsrybXaA
	 t3kggNVQLPm9uQ+Tieol1sMtUSVpru1kRMIK3Uao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 191/234] ASoC: rt5665: add missed regulator_bulk_disable
Date: Mon, 21 Aug 2023 21:42:34 +0200
Message-ID: <20230821194137.272646849@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Shurong <zhang_shurong@foxmail.com>

[ Upstream commit c163108e706909570f8aa9aa5bcf6806e2b4c98c ]

The driver forgets to call regulator_bulk_disable()

Add the missed call to fix it.

Fixes: 33ada14a26c8 ("ASoC: add rt5665 codec driver")
Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
Link: https://lore.kernel.org/r/tencent_A560D01E3E0A00A85A12F137E4B5205B3508@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5665.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/rt5665.c b/sound/soc/codecs/rt5665.c
index 17afaef85c77a..382bdbcf7b59b 100644
--- a/sound/soc/codecs/rt5665.c
+++ b/sound/soc/codecs/rt5665.c
@@ -4472,6 +4472,8 @@ static void rt5665_remove(struct snd_soc_component *component)
 	struct rt5665_priv *rt5665 = snd_soc_component_get_drvdata(component);
 
 	regmap_write(rt5665->regmap, RT5665_RESET, 0);
+
+	regulator_bulk_disable(ARRAY_SIZE(rt5665->supplies), rt5665->supplies);
 }
 
 #ifdef CONFIG_PM
-- 
2.40.1



