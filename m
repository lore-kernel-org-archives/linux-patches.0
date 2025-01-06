Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5919D1DE4DE;
	Mon,  6 Jan 2025 16:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179292; cv=none; b=P8zFTMcsFm/ST83JvwjbIZZnDmYcODL6wEsWmNZm0CLk1X7qp1EOIJsfRhmui6DIErUM0okDvLydZ6lz1x1cpsMFAek31atWe0EBqcZz1VeejzxlmqWc86bfOFGZMnvwhLNCkk4Jp0w44WX149AZD5ZoUvnGYXSFkDgdPxTJSvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179292; c=relaxed/simple;
	bh=q7wHKestqKMe8/V360LJYfqNuA9RswOVEp3yGqQVgRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VuNw1ODeDRw15EBfDMukx2kydFcBG4t+jYnkrCAQiRbxuhoA7VNjrUBhj/LrKep56i3HonLEbKO8LTxzqpzIwNcl6FVAvc3Zjh4Ka4YeStC5hb73JtAcEclbI+ujmmqXMq2qBG/9oETbpXILGSpm3VbBPieZlEZ/xnKg6chp5gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJBt7SlY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJBt7SlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABFFC4CED2;
	Mon,  6 Jan 2025 16:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179291;
	bh=q7wHKestqKMe8/V360LJYfqNuA9RswOVEp3yGqQVgRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJBt7SlYTwsNSlsw6L0sttaa/ccaAwiItasiviuejAGp1bxactlVPWtKVX7Ukq+AK
	 R5g0BcS65+HdkZNgVeklnGYAoBYn2tVGT/9cNi2afSNCg8XMfQxkScklrkExMQ0QAM
	 tEl5LdbBMxh37nrwEFFyqRi17REf40FbeXI5UbP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 47/93] regmap: Use correct format specifier for logging range errors
Date: Mon,  6 Jan 2025 16:17:23 +0100
Message-ID: <20250106151130.478135991@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c83e3dcac6df..c453c24afeb8 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1075,13 +1075,13 @@ struct regmap *__regmap_init(struct device *dev,
 
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



