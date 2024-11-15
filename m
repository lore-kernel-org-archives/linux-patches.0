Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F9F29A9;
	Fri, 15 Nov 2024 06:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653207; cv=none; b=aESFK5Z/5U6GFjV06MTapbnylevRnDEiQ1ovRT2do4yFonVIo8KpmCt3A+iN1kUF+lPrccKeR8ZsgrwPmDxh5pcP20P2huqvAYZ8n4XhSSZhlaL1EaeJ2ttU0jwI6OUX4PxKZUB8sO+Y52dsQ1PbDGVJFCFZCSo3gxYLGT23oSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653207; c=relaxed/simple;
	bh=7fakC3FhczB6VErpQPCGfCeKEf5ezGDcDjET/49HZNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IGCl6udNOd/Hr6XCRrM4VfndnWqmnMJTRsADZp/JDl5lyK+a/BZo/D9clzGSY3Nze2F47ZwVQDIwsLw9E6fhdTw3Hgzke4j1NTm0lAUtCCJfICQTg2eVLBb0hBt4XzhMXE2tUjiM8LtoX7xprh/eW79qx/ulyar033rIQFpKErU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijUCM0Sk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijUCM0Sk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E3EC4CECF;
	Fri, 15 Nov 2024 06:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653207;
	bh=7fakC3FhczB6VErpQPCGfCeKEf5ezGDcDjET/49HZNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijUCM0SkIhhjJGF47r0vdc4Hig5mDocI8D13eUQDGdzgXNd43+l8dlpW3zUidLO6u
	 o+xU+QkxO/i3a2b/QDm76jgwYfRTA8QnfH5xV8U9TU1pK+AuNuKD+RFo0TMyDOnXHf
	 PNvaNVbSPIyDc0OkrOBVn9jxXkbHAared+1VrjRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Klaus Kudielka <klaus.kudielka@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 18/63] crypto: marvell/cesa - Disable hash algorithms
Date: Fri, 15 Nov 2024 07:37:41 +0100
Message-ID: <20241115063726.577868737@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



