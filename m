Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA85F26FDB1;
	Tue,  8 Apr 2025 12:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115904; cv=none; b=OGvo+5V5o8IOP0KlrTsJq/PyqPnbfTgfWp7knRaTmRi+ZsRFydQ7yfJJSJAoyc9VlatP41DC76CnTbULIxSkUIsoV/Xp9QQO1rLMc5LJHMLWNvLnbhKQfze5mQXy5XYM6Z25OGE7a1OoQiHQCwXVFXcddwS5h3TZ3a5uY6qF+z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115904; c=relaxed/simple;
	bh=0PXDuKNZTCUPhLJphMAKFQswaaeKkYWOMeBR3CvtCzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0EGR74pqEGeFdnRkataLbyrwZvtNfQl+tKDV1FgqxOwoc4z86Dxsun1wCzmDBa5PGKLVQi1aWsX4eIuscotFV1oTwWNw+eM6OE1sY+pmdgh7AFFMW4kMQSQAnN3Xmvi2qI9Q1Ikk81mehjuaNzSDzVLKnCbZx99F+02clWIMgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBUtEb+p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBUtEb+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4497C4CEE5;
	Tue,  8 Apr 2025 12:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115903;
	bh=0PXDuKNZTCUPhLJphMAKFQswaaeKkYWOMeBR3CvtCzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OBUtEb+p9GVsgxA6ICoa7W3RkyaSpC3m0MQ045u7/hw3Sq5P4L0LaltlGQKo3zzC6
	 COSpgUzj0LTz/PfKLqussHwVMNX0kKY3sYF/T8seDFksohiVHhtUmgkJktYEWpxdLz
	 /189keN3dRyKpwdSoaxFbSWyL4Z6DvKx6z483LGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Roger Quadros <rogerq@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 146/204] memory: omap-gpmc: drop no compatible check
Date: Tue,  8 Apr 2025 12:51:16 +0200
Message-ID: <20250408104824.577998581@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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
index 2351f2708da23..f30b1c0093d3f 100644
--- a/drivers/memory/omap-gpmc.c
+++ b/drivers/memory/omap-gpmc.c
@@ -2154,26 +2154,6 @@ static int gpmc_probe_generic_child(struct platform_device *pdev,
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



