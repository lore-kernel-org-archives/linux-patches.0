Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158091422B5;
	Thu, 13 Jun 2024 11:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278728; cv=none; b=mzZnHtThPo6YtG6X7ZVMlCGfDwYwpdSDxUOFBF18I7k40ZZMZ+y4MOzr++jbCG4T9SBe6RSvqAinUacpIBoWaKUDG9jmj2x/8IM0kQMPuM4sq3W4WNx00mFQYCLrVD5mugaymc6gcE4kFAtmpmJ3Ts1TatdLxCNgpWs6isFdK2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278728; c=relaxed/simple;
	bh=jiDIC7lZYwckByIcK8uMS8zQHUjTrahxAbi7PlwivTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=if5xFUJnztQ+KldActDPNNnlUaTCGZaFTni/4m+25SR4kDTgEzPCQdrlrWnD3yu+RrDrlVmXqwBXIXWv8x9lyZmd9Fb8wK2FfX1uLFTopmrjZpTm0nGWcNLtJzwgQhJMixbrMSInKTsHWViQdBLqVR4a4qrB7VTcxVV+zK2y740=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDrpsfJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDrpsfJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E57AC2BBFC;
	Thu, 13 Jun 2024 11:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278728;
	bh=jiDIC7lZYwckByIcK8uMS8zQHUjTrahxAbi7PlwivTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDrpsfJOnSDUrAEx5wX0QST60RWSscebtTeCf/Mjn21IPt7IDAQhMqRSbloHF/kw1
	 ChRDktDdbVe2OaDj7Cjhsq/SW4fHLVLWoAvplSMU1NrVPC17i6IpicPH0obXAmv9kG
	 uOnT6dA4vNUKd4LzCDYS0awKJ8CP2b+VWCJKxjmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <natechancellor@gmail.com>,
	Gary R Hook <gary.hook@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 019/213] crypto: ccp - Remove forward declaration
Date: Thu, 13 Jun 2024 13:31:07 +0200
Message-ID: <20240613113228.731203939@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 3512dcb4e6c64733871202c01f0ec6b5d84d32ac ]

Clang emits a warning about this construct:

drivers/crypto/ccp/sp-platform.c:36:36: warning: tentative array
definition assumed to have one element
static const struct acpi_device_id sp_acpi_match[];
                                   ^
1 warning generated.

Just remove the forward declarations and move the initializations up
so that they can be used in sp_get_of_version and sp_get_acpi_version.

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 42c2d7d02977 ("crypto: ccp - drop platform ifdef checks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sp-platform.c | 53 +++++++++++++++-----------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/ccp/sp-platform.c b/drivers/crypto/ccp/sp-platform.c
index 71734f254fd15..b75dc7db2d4a1 100644
--- a/drivers/crypto/ccp/sp-platform.c
+++ b/drivers/crypto/ccp/sp-platform.c
@@ -33,8 +33,31 @@ struct sp_platform {
 	unsigned int irq_count;
 };
 
-static const struct acpi_device_id sp_acpi_match[];
-static const struct of_device_id sp_of_match[];
+static const struct sp_dev_vdata dev_vdata[] = {
+	{
+		.bar = 0,
+#ifdef CONFIG_CRYPTO_DEV_SP_CCP
+		.ccp_vdata = &ccpv3_platform,
+#endif
+	},
+};
+
+#ifdef CONFIG_ACPI
+static const struct acpi_device_id sp_acpi_match[] = {
+	{ "AMDI0C00", (kernel_ulong_t)&dev_vdata[0] },
+	{ },
+};
+MODULE_DEVICE_TABLE(acpi, sp_acpi_match);
+#endif
+
+#ifdef CONFIG_OF
+static const struct of_device_id sp_of_match[] = {
+	{ .compatible = "amd,ccp-seattle-v1a",
+	  .data = (const void *)&dev_vdata[0] },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, sp_of_match);
+#endif
 
 static struct sp_dev_vdata *sp_get_of_version(struct platform_device *pdev)
 {
@@ -201,32 +224,6 @@ static int sp_platform_resume(struct platform_device *pdev)
 }
 #endif
 
-static const struct sp_dev_vdata dev_vdata[] = {
-	{
-		.bar = 0,
-#ifdef CONFIG_CRYPTO_DEV_SP_CCP
-		.ccp_vdata = &ccpv3_platform,
-#endif
-	},
-};
-
-#ifdef CONFIG_ACPI
-static const struct acpi_device_id sp_acpi_match[] = {
-	{ "AMDI0C00", (kernel_ulong_t)&dev_vdata[0] },
-	{ },
-};
-MODULE_DEVICE_TABLE(acpi, sp_acpi_match);
-#endif
-
-#ifdef CONFIG_OF
-static const struct of_device_id sp_of_match[] = {
-	{ .compatible = "amd,ccp-seattle-v1a",
-	  .data = (const void *)&dev_vdata[0] },
-	{ },
-};
-MODULE_DEVICE_TABLE(of, sp_of_match);
-#endif
-
 static struct platform_driver sp_platform_driver = {
 	.driver = {
 		.name = "ccp",
-- 
2.43.0



