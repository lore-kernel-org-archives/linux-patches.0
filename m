Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A116D153800;
	Fri, 15 Nov 2024 06:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653404; cv=none; b=NNTQZa/eK8q6AosRlCMRtW5Xy9a/lOKGZkfXr75Y45hfPO/BQjIWCPzcet2e556H+vHkLfnXvYHSTN2H5AjrmYyJUF/1J65MA1bpUCWZ8XrYn+50kH690+fczQE9+YANen2J9AE+k7e4CbnrKQLpvCDWbuvlM+K6S8oYwaKScWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653404; c=relaxed/simple;
	bh=Q58FeUfBgSK88AN8DbRgIU+74xr6vCaQEbb4RdJdd+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HP9EXvN2aKBbnOT1PKf1xO7qSvJzQW21VX1GYFbwN8XlfWl/SjvW/g9qJiM9hAicsLcH68e0Pm15xIe69W/9/9toJO4kBzH5BodSNF8cfTPe+JV6djkWZ8P5wkmXdLq8P9rKw7pLYT/8yTDo5xhIlzYEUTQVItnUutLjK67W9Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YinPIMzL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YinPIMzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3CBC4CECF;
	Fri, 15 Nov 2024 06:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653404;
	bh=Q58FeUfBgSK88AN8DbRgIU+74xr6vCaQEbb4RdJdd+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YinPIMzLeJVdphnPoHpmkSnFy61DVr7/m2tzgWCQg886Z4TINX8xCg3uYrRRa7MV6
	 Al7UI6v2QgoIITdOS+4Jtl28cIwGD1m8Xh+8rX/sk0wMHw4Q1rWGLvu/JdFP8n24T0
	 gWn/Uk//Wh8AiztZGDVCOdbq5U467wLI86a0tw8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Klaus Kudielka <klaus.kudielka@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 13/48] crypto: marvell/cesa - Disable hash algorithms
Date: Fri, 15 Nov 2024 07:38:02 +0100
Message-ID: <20241115063723.444056147@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit e845d2399a00f866f287e0cefbd4fc7d8ef0d2f7 ]

Disable cesa hash algorithms by lowering the priority because they
appear to be broken when invoked in parallel.  This allows them to
still be tested for debugging purposes.

Reported-by: Klaus Kudielka <klaus.kudielka@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/cesa/hash.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index 8d84ad45571c7..f150861ceaf69 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -947,7 +947,7 @@ struct ahash_alg mv_md5_alg = {
 		.base = {
 			.cra_name = "md5",
 			.cra_driver_name = "mv-md5",
-			.cra_priority = 300,
+			.cra_priority = 0,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
@@ -1018,7 +1018,7 @@ struct ahash_alg mv_sha1_alg = {
 		.base = {
 			.cra_name = "sha1",
 			.cra_driver_name = "mv-sha1",
-			.cra_priority = 300,
+			.cra_priority = 0,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
@@ -1092,7 +1092,7 @@ struct ahash_alg mv_sha256_alg = {
 		.base = {
 			.cra_name = "sha256",
 			.cra_driver_name = "mv-sha256",
-			.cra_priority = 300,
+			.cra_priority = 0,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
@@ -1302,7 +1302,7 @@ struct ahash_alg mv_ahmac_md5_alg = {
 		.base = {
 			.cra_name = "hmac(md5)",
 			.cra_driver_name = "mv-hmac-md5",
-			.cra_priority = 300,
+			.cra_priority = 0,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
@@ -1373,7 +1373,7 @@ struct ahash_alg mv_ahmac_sha1_alg = {
 		.base = {
 			.cra_name = "hmac(sha1)",
 			.cra_driver_name = "mv-hmac-sha1",
-			.cra_priority = 300,
+			.cra_priority = 0,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
@@ -1444,7 +1444,7 @@ struct ahash_alg mv_ahmac_sha256_alg = {
 		.base = {
 			.cra_name = "hmac(sha256)",
 			.cra_driver_name = "mv-hmac-sha256",
-			.cra_priority = 300,
+			.cra_priority = 0,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
-- 
2.43.0



