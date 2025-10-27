Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A131032B9A2;
	Mon, 27 Oct 2025 18:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590988; cv=none; b=rNpt3Ara19FxXLxCW+zb5qcc//wEIJM77Pl8AY6JEYrTLqvnr7noYhUa3l4zHa0kpbQKKBYW14TdvS2Fem3De9TjxNXKCsHkeVeRnXobdhAfKEKbDUMnqO1prOwM4mOOcVEY/itIan35NAr0q0yGrtLdOkJiZIhQu6ZNmTBG5X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590988; c=relaxed/simple;
	bh=qyNl+ksqDFP+SKwiDAe8KDkG335YHhfJ8EpcyZf9kA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtlTOw2Tcay97EExJxKQhPhZXn1RedxdfSfEU6A86nE+r6NjLTS0GFyxyI0FBGi4XK+CjQtQfn/P5qSj/iv7jNsEL5262kQMbdb75/DGAh+wOOP3lFuaavUuvIBf9EOm6NCxCVpLc7FKnkGfHD504iwXgRFCHL9nkKSf5IGW4fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xr7FE4dw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xr7FE4dw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A25C4CEF1;
	Mon, 27 Oct 2025 18:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590987;
	bh=qyNl+ksqDFP+SKwiDAe8KDkG335YHhfJ8EpcyZf9kA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xr7FE4dwHMA5cSTr/xFf+TnoWsTwGx/gqkDVCMnPZxW3SCYPK2wXpPPlDf39oWioD
	 EP9Ez6Yjtf4FINYTiDuQ0u46fVLCes3nnvoj8lOcG2BdFKgabfBZ9hEiz8dIOeFVEB
	 oZWyRI2GHK17w+Gb5pDbVcfb7ohpcerZSUmTAJ88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/332] regmap: Remove superfluous check for !config in __regmap_init()
Date: Mon, 27 Oct 2025 19:31:17 +0100
Message-ID: <20251027183525.257527284@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fb463d19a70a0..02c21fce457c1 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -853,7 +853,7 @@ struct regmap *__regmap_init(struct device *dev,
 		map->read_flag_mask = bus->read_flag_mask;
 	}
 
-	if (config && config->read && config->write) {
+	if (config->read && config->write) {
 		map->reg_read  = _regmap_bus_read;
 
 		/* Bulk read/write */
-- 
2.51.0



