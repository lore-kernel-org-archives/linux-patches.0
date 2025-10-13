Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEE721930A;
	Mon, 13 Oct 2025 14:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367089; cv=none; b=jXnlKogrVbxpmWNEW19oazutMHawDoQr15AB7mWTcDnVtwH4CP1RsqyDHcMX521t8lfoIk3l1omt3wsJSo4+N1hU69SzcFJdzwM7Jk5PMKa82FARrzB89my+aqBkwu7AbntF42AdIx515cI7vwJLkHlmFpazYqRwbXL15MrU0lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367089; c=relaxed/simple;
	bh=ovEkVSo0gb775omDXJUthTJwizrJsvIcwe25JGMekJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtaRlJ0tXJIT0VdGlv2/7eNgoWzPxon/9hAAgD83vxBAlw3nZLHvmXVqnNfyu5WvAXR+oIoBgTr8zbpOBWyES+OlNqyFA6iE0zD7nYBsvLlr+ESlrjvyjApyKx71J/pwgM313TmM0wDdSQY/NR60VU+ETNXhCMBGRwc8yw55934=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvfcfCxf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvfcfCxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52599C4CEE7;
	Mon, 13 Oct 2025 14:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367089;
	bh=ovEkVSo0gb775omDXJUthTJwizrJsvIcwe25JGMekJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvfcfCxfBN2wzIuHRkrA7PkdOYIws1bIv8J04zZFXKjle1+t0wtvXn16eaNa98Jmx
	 tp4taDqdslnVKtU9C600QYvpXhqEg24nltlkNLsCt/vVE0AqQ5cN3k7s3Lp+Dt1au0
	 4DHrnq9C2fRtBgvvQjGE1g6sCzUNLTj50psF1Xqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/196] regmap: Remove superfluous check for !config in __regmap_init()
Date: Mon, 13 Oct 2025 16:43:48 +0200
Message-ID: <20251013144316.574161831@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 5c36b86d2bf68fbcad16169983ef7ee8c537db59 ]

The first thing __regmap_init() do is check if config is non-NULL,
so there is no need to check for this again later.

Fixes: d77e745613680c54 ("regmap: Add bulk read/write callbacks into regmap_config")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/a154d9db0f290dda96b48bd817eb743773e846e1.1755090330.git.geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 168532931c86d..bdbde64e4b21d 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -880,7 +880,7 @@ struct regmap *__regmap_init(struct device *dev,
 		map->read_flag_mask = bus->read_flag_mask;
 	}
 
-	if (config && config->read && config->write) {
+	if (config->read && config->write) {
 		map->reg_read  = _regmap_bus_read;
 		if (config->reg_update_bits)
 			map->reg_update_bits = config->reg_update_bits;
-- 
2.51.0



