Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA9F11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83495C433C9;
	Mon, 28 Aug 2023 10:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693217778;
	bh=COeaAKJnbWLMVlB8TaZqwMfRStf11ANLet5Xi6Sy9Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MqoWHsHkYQEQ/UsUCD7a+wlUSOpmVEwafS+CqHO7W60Cv+rf+A9tXewzafJK+/8tB
	 rSSwqIe8VZJMM6H4imaa2tQ1jzFgKjIaKz0Be1xLWURbrOvAVEPtaIfv1cxPwurd2G
	 TLaHaNvHhxd30H/J64SWehs4Oq/IHAM2M0S/y8eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.14 36/57] ASoC: rt5665: add missed regulator_bulk_disable
Date: Mon, 28 Aug 2023 12:12:56 +0200
Message-ID: <20230828101145.598337219@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101144.231099710@linuxfoundation.org>
References: <20230828101144.231099710@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Shurong <zhang_shurong@foxmail.com>

commit c163108e706909570f8aa9aa5bcf6806e2b4c98c upstream.

The driver forgets to call regulator_bulk_disable()

Add the missed call to fix it.

Fixes: 33ada14a26c8 ("ASoC: add rt5665 codec driver")
Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
Link: https://lore.kernel.org/r/tencent_A560D01E3E0A00A85A12F137E4B5205B3508@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt5665.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/codecs/rt5665.c
+++ b/sound/soc/codecs/rt5665.c
@@ -4957,6 +4957,8 @@ static void rt5665_i2c_shutdown(struct i
 	struct rt5665_priv *rt5665 = i2c_get_clientdata(client);
 
 	regmap_write(rt5665->regmap, RT5665_RESET, 0);
+
+	regulator_bulk_disable(ARRAY_SIZE(rt5665->supplies), rt5665->supplies);
 }
 
 #ifdef CONFIG_OF


