Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D32630F7E4;
	Mon, 13 Oct 2025 15:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368861; cv=none; b=bOWiiIntu6ErXJvnSMK6BuFLbz5KCCRr9iiM7pcz4jIlnAK5e9nQvpWj7832vObtl4jkeQHmKFCEFj+Cs5PY14B9Hpj4j8kqvKJ5Jv0bzhNWgTQBnpQIOsWvntHZTyuUwRUNBWqYXJcfo6OnR2fUDOW2hKHCDkBqM0yR4BkRQ3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368861; c=relaxed/simple;
	bh=e+eceK+a/Sgx52nypJviumHp4m+YouhSmRVLWU94Txw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCo4dYm6HrBP37/3FcJfOBtB6BaYRJL6ZzzGEDngt05LzeWlnj0MFNWSCn99vpeNo80k+UcyxV/9p2Qp3dtCQaDRYp/3m0yuLowIkM+W3VQZnPfeYN3bez1Lo14LPA072hpY2ck+pw+q9rPePlOsG303gPP6Xo76dQPWRNX9x24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vMCrveQO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vMCrveQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5019C4CEE7;
	Mon, 13 Oct 2025 15:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368861;
	bh=e+eceK+a/Sgx52nypJviumHp4m+YouhSmRVLWU94Txw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vMCrveQOxu0qasF8vCfLjIzwIMVLRM0N3YXmleJLx3LwNAG3+duKnpUXoThtkygQF
	 TiXijAWqWmOWVbn7IawEusswI8BdQLKQVY1NZC9JFn4A0Io6NXWUsMsFFkC2uwr2T1
	 O86FYEcHEpW24u7tKSMYoda+MFft4FEFz3OlD6fE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 044/563] regmap: Remove superfluous check for !config in __regmap_init()
Date: Mon, 13 Oct 2025 16:38:25 +0200
Message-ID: <20251013144412.889373021@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 1f3f782a04ba2..6883e1a43fe5d 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -827,7 +827,7 @@ struct regmap *__regmap_init(struct device *dev,
 		map->read_flag_mask = bus->read_flag_mask;
 	}
 
-	if (config && config->read && config->write) {
+	if (config->read && config->write) {
 		map->reg_read  = _regmap_bus_read;
 		if (config->reg_update_bits)
 			map->reg_update_bits = config->reg_update_bits;
-- 
2.51.0



