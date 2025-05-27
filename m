Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BB218A6A5;
	Tue, 27 May 2025 17:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365239; cv=none; b=tLuIkEkZR3r5z0TVBFaPw6OY5mz1HBVS5XSj7CkVIYTjtSHNxfow7F+yE2/WFg+GinuDd1K/WEgmMXhrnCCvzEny5RL9ouc/JmCxqgS28En5VffcD+Zv7msHBbjptapdSJo2seGUw6M23D/mrYlqJpHzsXXBtKIGdSp/OADXoB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365239; c=relaxed/simple;
	bh=QcTIXFLoSWwaAmCo/fy1oCe78JcLt3wvXYjAOlhg4E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zf9DRc7pnpOYJ/TFT0O/NNeaxb4Rb2jCl98UAkQm2AihbDJTMlGhkmMrLt9HtUEzbykMkzalmG81cFLGfc7NUIBzVFxcdsb5roDu0haSnxO/cjXM88mSvVhuJ6cHzWyYFg2zt5lwVPzYjaLAlWBdM64NomgDMCIiLBTFYRF/Wuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qaSOyimJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qaSOyimJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95742C4CEE9;
	Tue, 27 May 2025 17:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365238;
	bh=QcTIXFLoSWwaAmCo/fy1oCe78JcLt3wvXYjAOlhg4E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qaSOyimJgM5V8e7Hb+QBDYlC9n9Zq0BQjQCQIbla/+gfVB65y8+86d6OpAmsG9xxg
	 9yAyCKoOkg4LTT6TDDI+X8KWoDZmuax+yZVeLzRerTZwLHd0n2hgidrFvUXIyVzfoj
	 7GYbuFv/B6Xqqv5kG3UQum9WNbrtwTNlZUv+ZHkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 280/626] net: xgene-v2: remove incorrect ACPI_PTR annotation
Date: Tue, 27 May 2025 18:22:53 +0200
Message-ID: <20250527162456.412876976@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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
index 9e90c23814910..68335935cea77 100644
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
 	.remove_new = xge_remove,
-- 
2.39.5



