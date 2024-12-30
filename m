Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643FD2E414;
	Mon, 30 Dec 2024 15:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574178; cv=none; b=unFQ89+VpE+y8AQgLoIyy9e8Nh8QnKYnOcFsAIZzJu5seJl7xlGEri/xQ5lnK0fEWWDzrtT/TvnzHtD4ABj61iyif0JuzWgm4OqjqIr08K9dNgbnLIZwlPYij3EzwBVre7dPVTMNYcG42lhuPqT2KikgriM8i2CvcqR6EqcJ3xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574178; c=relaxed/simple;
	bh=D54Wc06N2qQ9fzLcwvQNm0IIlmjZie4u1tY6biOq7/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKBLPEXdAiqVUGghpGQaiKmM4gv1209MYOrhelUvwnr+2Xaf5dcIzgzmXtyABTwAS0e0kNBPbMsdgPMpO7VrFnYy18wzEsO0y3r8lFEoHztoG9zkxzxH4AAnInqkSaOBIE1wXQw6V5iVKrpNvonU9AXvWRCjPX/o4Xccf9FFBaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7QUL/TN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7QUL/TN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B0FC4CED0;
	Mon, 30 Dec 2024 15:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574178;
	bh=D54Wc06N2qQ9fzLcwvQNm0IIlmjZie4u1tY6biOq7/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7QUL/TNOp5rb9uLg4vEEqVxwv1CQrZnG/VoFoDTAi09lhEMqJgmwaaqh7eQixfab
	 XTxmaze3WJS6Br/mIfNPGzcj2zlKSrSugp8w5h8HTY4pOvGaFOzkvsNlArLkDuXXEE
	 hDWBQFSYa7W4JMkdQrJpB+6rsAeaIYW/ztpgFTvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/114] regmap: Use correct format specifier for logging range errors
Date: Mon, 30 Dec 2024 16:42:57 +0100
Message-ID: <20241230154220.402503540@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 3f1aa0c533d9dd8a835caf9a6824449c463ee7e2 ]

The register addresses are unsigned ints so we should use %u not %d to
log them.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20241127-regmap-test-high-addr-v1-1-74a48a9e0dc5@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index e3e2afc2c83c..5962ea1230a1 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1063,13 +1063,13 @@ struct regmap *__regmap_init(struct device *dev,
 
 		/* Sanity check */
 		if (range_cfg->range_max < range_cfg->range_min) {
-			dev_err(map->dev, "Invalid range %d: %d < %d\n", i,
+			dev_err(map->dev, "Invalid range %d: %u < %u\n", i,
 				range_cfg->range_max, range_cfg->range_min);
 			goto err_range;
 		}
 
 		if (range_cfg->range_max > map->max_register) {
-			dev_err(map->dev, "Invalid range %d: %d > %d\n", i,
+			dev_err(map->dev, "Invalid range %d: %u > %u\n", i,
 				range_cfg->range_max, map->max_register);
 			goto err_range;
 		}
-- 
2.39.5



