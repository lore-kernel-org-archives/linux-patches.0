Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC9911C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111E3C433C8;
	Mon, 28 Aug 2023 10:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218374;
	bh=1/quXGO+wRoSqTLQeavstAgJTp9mQ5VtKi+F/uVSWoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxOWUXkSzlY2AQOQ8RPkF00Zi9mX1Qb2j5Gjgv+iBeiKrMQ3ZZMdVRdQTBcPapWKU
	 xCSd2cqFP+jXk6ho7N6phDkS8EKArf8dqzPI64Wm6ZLTEk31OSMVUW46oJx0mAiNfy
	 IiC47hRW5rogGMJmfn5bUqUEQdpxptnCKMDnHAP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 065/129] ASoC: rt5665: add missed regulator_bulk_disable
Date: Mon, 28 Aug 2023 12:12:39 +0200
Message-ID: <20230828101155.701873594@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 6ba99f5ed3f42..a7ed2a19c3ec2 100644
--- a/sound/soc/codecs/rt5665.c
+++ b/sound/soc/codecs/rt5665.c
@@ -4475,6 +4475,8 @@ static void rt5665_remove(struct snd_soc_component *component)
 	struct rt5665_priv *rt5665 = snd_soc_component_get_drvdata(component);
 
 	regmap_write(rt5665->regmap, RT5665_RESET, 0);
+
+	regulator_bulk_disable(ARRAY_SIZE(rt5665->supplies), rt5665->supplies);
 }
 
 #ifdef CONFIG_PM
-- 
2.40.1



