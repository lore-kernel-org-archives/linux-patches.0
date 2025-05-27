Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F9B3C01;
	Tue, 27 May 2025 17:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367290; cv=none; b=WMxxMA/U/bECSmgEZLE2Z47P85KmC527dMTVFXW26hqvKS/wwqPyLZ2GFhKqVqdO41OdK/VXBNAV3gLHutdJs8d94s++xeyNLTNJWuM7xDjzNrGeUMV8XFuzP41fCh3FSi/uuMrZxenRW3RY76mcNaTAhxLyNwVxsaKOy9eZ1UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367290; c=relaxed/simple;
	bh=CvlA0+lX31ctVZsDff3YVyVATcCktTKwu1b7JOHxBP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCVsfyveXPMoyf2Fsbd9FT9Feu1uiLpB+tuGnMVT89EghcrKPEddXEjt63xvHOxK82ymlTll3nMqLJTEr2zNDhEtpJhkGNTtd8GtyeDhJrfRsaSE8jbviT+BPIaogZtwSbnw5k3Oo1yYyXvtdkkhu24AlElX9kjownt5k1ozOyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BAJ6CTaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BAJ6CTaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24697C4CEE9;
	Tue, 27 May 2025 17:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367289;
	bh=CvlA0+lX31ctVZsDff3YVyVATcCktTKwu1b7JOHxBP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BAJ6CTaHMeyUHozWCopmavzylT4x7Fzq93UJgFdcySanqHzuudOQf+86WDNAdMT/3
	 omtGqIKw4ghjlKMg9itONnRkbRpIcMpahpmIiV34estCYqmbRp4B3L752f6NJfpUxP
	 r3+X5ShtPv+Nfm6AUYbZjbP1Aw2NpocOHPEM3i8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 339/783] net: xgene-v2: remove incorrect ACPI_PTR annotation
Date: Tue, 27 May 2025 18:22:16 +0200
Message-ID: <20250527162526.871740307@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 01358e8fe922f716c05d7864ac2213b2440026e7 ]

Building with W=1 shows a warning about xge_acpi_match being unused when
CONFIG_ACPI is disabled:

drivers/net/ethernet/apm/xgene-v2/main.c:723:36: error: unused variable 'xge_acpi_match' [-Werror,-Wunused-const-variable]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20250225163341.4168238-2-arnd@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/apm/xgene-v2/main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
index 2a91c84aebdb0..d7ca847d44c7c 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -9,8 +9,6 @@
 
 #include "main.h"
 
-static const struct acpi_device_id xge_acpi_match[];
-
 static int xge_get_resources(struct xge_pdata *pdata)
 {
 	struct platform_device *pdev;
@@ -731,7 +729,7 @@ MODULE_DEVICE_TABLE(acpi, xge_acpi_match);
 static struct platform_driver xge_driver = {
 	.driver = {
 		   .name = "xgene-enet-v2",
-		   .acpi_match_table = ACPI_PTR(xge_acpi_match),
+		   .acpi_match_table = xge_acpi_match,
 	},
 	.probe = xge_probe,
 	.remove = xge_remove,
-- 
2.39.5



