Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733B215E8B;
	Mon, 30 Dec 2024 15:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573567; cv=none; b=nYMkVttHnEYIzFyGbsu4aWm0dGKN11w1IgsxsyHpA4Tr4qtJVSYnoAdGgp/og1eUuar2quhlTaNeBWN4ApvLv6brLAfhx89ufBVk72idrGeA6nZLFo9Y0eGnyQnqByoALkIxwzs8eC1P4x0TxUP/D7yoPQWjXF7GVmipihKvmb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573567; c=relaxed/simple;
	bh=pFhxoIbhklERn/yIEFdWsyfc1/xy0hHMGMb2IUxkYRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxRMCSzsRgs6yG6Oy6k0gSRPQBpfs0OiJlzbQV7CLqu25OXmcQtXfVTfMIjXZbLWZx98fvMvbNAAKKbFiqUn3S9ASvjcA/67GqIRb676ZtY6h7Q1f0wYV9F2Dk0Rf9oO0OSVG+K7Cafbiv4IKqUH1dO4HClFDTi2L3FMfjHFlFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Al3FZzUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Al3FZzUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901BFC4CED0;
	Mon, 30 Dec 2024 15:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573567;
	bh=pFhxoIbhklERn/yIEFdWsyfc1/xy0hHMGMb2IUxkYRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Al3FZzUT8o5Infkkbk3yh2owbMGkGpByV34Vbgl0NFPPRs0nZr97rZ+F5kS4D2Ltk
	 wuTziplZ0zilsxVtqqDeZw/kucHvS8khs8qJ5AcWQ6HUEfgIFjZTaPagK0CtfwJ54K
	 GqeqlGA23wMIopDDyr7ejSjuXS876RIRhmT/rmv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 32/60] regmap: Use correct format specifier for logging range errors
Date: Mon, 30 Dec 2024 16:42:42 +0100
Message-ID: <20241230154208.500926993@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c822af48d2c9..8748cea3bc38 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1155,13 +1155,13 @@ struct regmap *__regmap_init(struct device *dev,
 
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



