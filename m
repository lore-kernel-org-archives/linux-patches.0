Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A26E2C325E;
	Mon,  2 Jun 2025 15:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876978; cv=none; b=eKLZxqVTfmAoe4J2Eu+BMVqyjOSB6NDF0dFDh1E14uwJ98sDDDp4Q8EmIizOgqvB1rloEFsLxjrAQNdjHm/zLZBws/4W7091UE7b6ckoTycFAqAFR0MUf2c9Z61HuB7NbPacWfg7Oe0JI4VUD70/QuY/DNgsOYBBe7ZCOC/PPzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876978; c=relaxed/simple;
	bh=k04zewYxjHSyg0UhDOEM1ZHvj+QbPFpXQgIPYYX7m+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0MisBySReuNxnI7aP5A3HOFczd+HlMOFWU0mTS1gAE5iA7YH17G91xDxWdckHDR60MsUMCwvZ9IzRMs3fyRNZPM2kOuULGueZ6FpHPH/HT5q4jmze9gKt3WeO7nB21tve8Yq0zqAntptNorvGE6ar1uGxaBjqofC6xcTml1GDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9Ex0HKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9Ex0HKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02023C4CEEB;
	Mon,  2 Jun 2025 15:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876978;
	bh=k04zewYxjHSyg0UhDOEM1ZHvj+QbPFpXQgIPYYX7m+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h9Ex0HKSXryM0sFRsKVj5jiodoWtimHqp0WW4sC0fHI3NFQs8OyeGvj0k3OkIKx8p
	 a4Ge3+ClSmaklZu5fY2bn/HNgtfGcCFFxZgfSfQ8/T8EKGtgCHlaFAk4SnnNpmF7Bf
	 tGTWMBUVzYYU6fL2epC9RDQhw6j7nOGrRKSVe+oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/325] net: xgene-v2: remove incorrect ACPI_PTR annotation
Date: Mon,  2 Jun 2025 15:46:49 +0200
Message-ID: <20250602134325.208135064@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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
index 379d19d18dbed..5808e3c73a8f4 100644
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



