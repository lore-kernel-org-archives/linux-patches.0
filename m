Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABE3157A72;
	Tue,  9 Jul 2024 11:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523564; cv=none; b=utHrrUa/LZ7IxK/jmUXMr940MCPSops0Q5NV0/0EkRKpIsEJXiRBwnElHgwGhH4/h4kAh5fbiDOqPnU1YBo4fxyJbLlPSZktHTTY4gQ+x2Ja/WoF6Vw4R8NQmjFPxqvA9WjctAZXrnYBeGF1FSl78tcYtivbiTS/i8INDppMXMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523564; c=relaxed/simple;
	bh=5UjDANeqIxIL/f3V91p3zFYRhiWY7Rq/KL0KDOP9pjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuHU0MV6E+T4+8/o5iHZ0oJTHg6h5QZgrdsYZn14pNjV5W3Z7Hr8ntUknQ2eaXxvWXN15RWET7tpyAdrOFtf7R5R4fVksLxOElmx327Ywgi5k7LBfO1z/yVOnCKK/dvN1yI+BP36c14uH3OB2ymCG+yP5ILWv/fYn6Cp61yF/g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ja/usSt7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ja/usSt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B460BC3277B;
	Tue,  9 Jul 2024 11:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523564;
	bh=5UjDANeqIxIL/f3V91p3zFYRhiWY7Rq/KL0KDOP9pjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ja/usSt7UcZr28XmQD3+mfuD2TxqqrRdcvUtWM1Px1HiR21fcgRPvxft7XVExpiHS
	 hgl2KMbztUHUUCQIFFai88+Y1cBG+GbF97YWpIFRfOnCGvS2CtxPFomHtW7cWy8RiL
	 bKf41tarfr29tQbLLk7y2sfYknxc60Yi1CnPqtLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julien Panis <jpanis@baylibre.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/139] thermal/drivers/mediatek/lvts_thermal: Check NULL ptr on lvts_data
Date: Tue,  9 Jul 2024 13:08:54 +0200
Message-ID: <20240709110659.482652772@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julien Panis <jpanis@baylibre.com>

[ Upstream commit a1191a77351e25ddf091bb1a231cae12ee598b5d ]

Verify that lvts_data is not NULL before using it.

Signed-off-by: Julien Panis <jpanis@baylibre.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20240502-mtk-thermal-lvts-data-v1-1-65f1b0bfad37@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/mediatek/lvts_thermal.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/thermal/mediatek/lvts_thermal.c b/drivers/thermal/mediatek/lvts_thermal.c
index 666f440b66631..8d0ccf494ba22 100644
--- a/drivers/thermal/mediatek/lvts_thermal.c
+++ b/drivers/thermal/mediatek/lvts_thermal.c
@@ -1208,6 +1208,8 @@ static int lvts_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	lvts_data = of_device_get_match_data(dev);
+	if (!lvts_data)
+		return -ENODEV;
 
 	lvts_td->clk = devm_clk_get_enabled(dev, NULL);
 	if (IS_ERR(lvts_td->clk))
-- 
2.43.0



