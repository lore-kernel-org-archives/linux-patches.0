Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EE72686AA;
	Tue,  8 Apr 2025 12:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115095; cv=none; b=j6y4sq5LIeI/YMpUDOvPUTGXAh5xsXgUak1NVgYPwDFsDk3HLwzr71Fxmeu67xG9tEpx2dIwjXPAmc9Q0a1jqeL83mbkQCx8HrkrOwj7fQPjSv40Y77xYgwR2RcaZc80Qh4zZTAYZ2sDhBB0tDHglPS6oEUdc4SWqqI5joLxWFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115095; c=relaxed/simple;
	bh=dB8l8yxtH9IhEb/278Nr6V6OTtXmGQG5f0ZRm8qYy/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBHo1h4TKZWU41ob4SCJCXvnaMx0ZFppAEjtMaop015Pd4rKFWAdvLsn0jEGE73qMahFokpb9DZoGyJM2yR8Of5LiITeaIX5wNdGoZcx9t7tsJZHD0oLBCBwcSFTwExIdab9+oZCEuLqwiQb8F16sBYhHPjYLA8UkP4XL6r/3Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1xtqWxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1xtqWxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAB9C4CEE7;
	Tue,  8 Apr 2025 12:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115094;
	bh=dB8l8yxtH9IhEb/278Nr6V6OTtXmGQG5f0ZRm8qYy/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1xtqWxGTeZBGM3NckorxLd/LIeU5U/wUqCOe2gB7HsQ10qwHT7DJOjFPJBI+TsM8
	 IarO+4W5oU1q/1fQij3idE/SUQorxIcwVstfBYbjud43C64T+cdg7OptaQPLqBa06Z
	 hb7wrJrdt+EPpl4I8C/S/DSK9iVLXk5frOFugIcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Roger Quadros <rogerq@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 348/499] memory: omap-gpmc: drop no compatible check
Date: Tue,  8 Apr 2025 12:49:20 +0200
Message-ID: <20250408104859.904528964@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@kernel.org>

[ Upstream commit edcccc6892f65eff5fd3027a13976131dc7fd733 ]

We are no longer depending on legacy device trees so
drop the no compatible check for NAND and OneNAND
nodes.

Suggested-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Roger Quadros <rogerq@kernel.org>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Link: https://lore.kernel.org/r/20250114-omap-gpmc-drop-no-compatible-check-v1-1-262c8d549732@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/omap-gpmc.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/memory/omap-gpmc.c b/drivers/memory/omap-gpmc.c
index 50eb9f49512b4..368b0848b64df 100644
--- a/drivers/memory/omap-gpmc.c
+++ b/drivers/memory/omap-gpmc.c
@@ -2245,26 +2245,6 @@ static int gpmc_probe_generic_child(struct platform_device *pdev,
 		goto err;
 	}
 
-	if (of_node_name_eq(child, "nand")) {
-		/* Warn about older DT blobs with no compatible property */
-		if (!of_property_read_bool(child, "compatible")) {
-			dev_warn(&pdev->dev,
-				 "Incompatible NAND node: missing compatible");
-			ret = -EINVAL;
-			goto err;
-		}
-	}
-
-	if (of_node_name_eq(child, "onenand")) {
-		/* Warn about older DT blobs with no compatible property */
-		if (!of_property_read_bool(child, "compatible")) {
-			dev_warn(&pdev->dev,
-				 "Incompatible OneNAND node: missing compatible");
-			ret = -EINVAL;
-			goto err;
-		}
-	}
-
 	if (of_match_node(omap_nand_ids, child)) {
 		/* NAND specific setup */
 		val = 8;
-- 
2.39.5



