Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6211422D9EE;
	Mon,  2 Jun 2025 14:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875581; cv=none; b=IAmAC2gBDU0BelFDWLIG/VlP8OCM3mMPcb6kGU1op4WhLRp9/Pl0K92aPRdgTjwsI5tN1u2AF0/QLWDhp6ZlyWDVCuBpwc/5Tb8ab5dwSW3xvKzeUo+sw+fROw7vdGMxoGacFUcKqyYqMvO2Dfi63LApIuXuD2/lf5ofS47G1BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875581; c=relaxed/simple;
	bh=5kMQI6DrKY4Z3tjRL5inrrF1/xLQtBiHybtfgQO2Hwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M735Rzua3kcxIZFZOesiaFDw9sJQUqIEibrJ6HNraOF9pRn2KafekBYeY41AQvgRzQq7TqFTBVOyMaYT+z0aq6cbh1MTBzay6bL8ObXTzRDy0Tg6mQxxrwk5CuB6HIxA4ws6uC/iurGOX+WaMEQg9mNqHqdKY5qQw9ISvV3cjzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2pxrOagN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2pxrOagN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CEF0C4CEF0;
	Mon,  2 Jun 2025 14:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875580;
	bh=5kMQI6DrKY4Z3tjRL5inrrF1/xLQtBiHybtfgQO2Hwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2pxrOagNYueaX9h/+J5R4P8knpopiS80bAsvExgWrC5PwniPjk19lRhCUgg3SjZn1
	 kMfTt9PjdD7QgceBUwERIJZPfHFlOl1ShLFOpYEvyGt+Xuokyql8XzgFNdrXj5LJvF
	 whahOSGLC8RCKB5NQnzq+F8p3h7Hjefm4xvZ25ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 178/270] net: xgene-v2: remove incorrect ACPI_PTR annotation
Date: Mon,  2 Jun 2025 15:47:43 +0200
Message-ID: <20250602134314.491027008@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 80399c8980bd3..627f860141002 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -9,8 +9,6 @@
 
 #include "main.h"
 
-static const struct acpi_device_id xge_acpi_match[];
-
 static int xge_get_resources(struct xge_pdata *pdata)
 {
 	struct platform_device *pdev;
@@ -733,7 +731,7 @@ MODULE_DEVICE_TABLE(acpi, xge_acpi_match);
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



