Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F2233F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301164; cv=none; b=RjEbhQ7PZgSKLf9AMUH32/N0KXvOM9TD+t9GuoSh0NQMO/AjuWh1bXCglu59Wn+92A3gXUKm4CA0u7T6Dv2s0hzpi5ZzKIR/u9k7A4QMNCDjM7PO/ghuFFkNFMlwFE223UWh0OEs2wWNTEuVzHpcxKLPxGePb9TkSJuqNQaFQ0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301164; c=relaxed/simple;
	bh=4B9zfesSIGCETB9yT7zZ8o1RykvPoYvqKhAu5noR5P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MeZgSIBbDJXuAbLp9TAhjIAkp6RzAA5tSkY0ZJ14Js9+JxR64zz/YuU4kpMy+6Tq0taO46Gto2dkaqJUtlgbJbwLHChlFGQqtOhRLHYOYpmmDcTgDFY3h8xV5Ae7ol8PLQnlNFvdNZKho6kzGqAZBnrZohihYmkOi5MAhU3/Nw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bWkbKCNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bWkbKCNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730DCC116D0;
	Sat, 28 Feb 2026 17:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301164;
	bh=4B9zfesSIGCETB9yT7zZ8o1RykvPoYvqKhAu5noR5P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bWkbKCNC+wwTk/YCxSme5HQEwSOiwXKM3o8BoMU/tLwAXVt7tkz4tQFh2401Gi2oX
	 k2bY6JOqN25/jaEg46jbQCZnWHqOkEA7Pdz7gRXvHslSQDehGlr2Ium4Hd0LqbJzBH
	 u7u3LdppESbFOGoWb0kje+7Y6XADC3sLSO327zNgmMpZGcE1j7ihKo+Vkpw7a+I2aw
	 A0XiMS88m1yhUa3kQwgYz/ITrhl6fM6CaSodCFOumiJboB8pjUtXVDzlCbofqVXjJt
	 38tQROBlXW2EPA4TEW7pMpf/67SsWUdKLCvPzca/KmYS3b93bBdGIeZkZ9trbIEHe4
	 pp9+h4SSsnNtw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Romain Gantois <romain.gantois@bootlin.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 329/752] fpga: of-fpga-region: Fail if any bridge is missing
Date: Sat, 28 Feb 2026 12:40:40 -0500
Message-ID: <20260228174750.1542406-329-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Romain Gantois <romain.gantois@bootlin.com>

[ Upstream commit c141c8221bc5089de915d9f26044df892c343c7e ]

When parsing the region bridge list from the "fpga-bridges" device tree
property, the of-fpga-region driver will silently ignore bridges which fail
to be obtained, for example due to a missing bridge driver or invalid
phandle.

This can lead to hardware issues if a region bridge stays coupled when
partial programming is performed.

Fail if any of the bridges specified in "fpga-bridges" cannot be obtained.

Signed-off-by: Romain Gantois <romain.gantois@bootlin.com>
Link: https://lore.kernel.org/r/20251127-of-fpga-region-fail-if-bridges-not-found-v1-1-ca674f8d07eb@bootlin.com
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/of-fpga-region.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/fpga/of-fpga-region.c b/drivers/fpga/of-fpga-region.c
index 43db4bb77138a..caa091224dc54 100644
--- a/drivers/fpga/of-fpga-region.c
+++ b/drivers/fpga/of-fpga-region.c
@@ -83,7 +83,7 @@ static struct fpga_manager *of_fpga_region_get_mgr(struct device_node *np)
  * done with the bridges.
  *
  * Return: 0 for success (even if there are no bridges specified)
- * or -EBUSY if any of the bridges are in use.
+ * or an error code if any of the bridges are not available.
  */
 static int of_fpga_region_get_bridges(struct fpga_region *region)
 {
@@ -130,10 +130,10 @@ static int of_fpga_region_get_bridges(struct fpga_region *region)
 						 &region->bridge_list);
 		of_node_put(br);
 
-		/* If any of the bridges are in use, give up */
-		if (ret == -EBUSY) {
+		/* If any of the bridges are not available, give up */
+		if (ret) {
 			fpga_bridges_put(&region->bridge_list);
-			return -EBUSY;
+			return ret;
 		}
 	}
 
-- 
2.51.0

