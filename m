Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916061C39
	for <patches@lists.linux.dev>; Sat, 15 Jul 2023 11:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E462C433C7
	for <patches@lists.linux.dev>; Sat, 15 Jul 2023 11:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689421721;
	bh=/cnjqebX0qVyCoL+VPfKzCQNiobr8hPQWE3NlrjT6pQ=;
	h=Resent-From:Resent-Date:Resent-To:From:Date:References:
	 In-Reply-To:To:Subject:From;
	b=s2KfAfkQUZvSgdstq9CkXx651WIay0Sqsj12286MG+US82kfY2oaEXt21tDHqzO4p
	 ivnwNLnJM5IAiHK+4QfV+xIoejmyyGzEFFsv68wG/CQC3OvcugfT5kfaZX1+8ZuJt9
	 rLNGK+8fzXYyLxA+6ATZf+jxXF4pEm19WOTZrjfxu7j5nEGxCgPSDswWfOnLQaSCNp
	 6PDMpOCk8mtkJKJlw7/yoqACu6OJ5gyMu6EYJ51Rag+8SNGvA2Tb7ROpquv4WWuXhh
	 TEWTZDHxdiORCFvJ08f0/Kecz6rydr7tpvWsOc283M5er7k4b7OK5IIkrsdnjTe7dp
	 TBqIP4cwq39ow==
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Sat, 15 Jul 2023 12:48:37 +0100
Resent-Message-ID: <ZLKHlVN2tHcy0/Yr@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 12 Jul 2023 12:16:54 +0100
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <broonie@kernel.org>)
	id 1qJXpz-004s0N-PF
	for broonie@sirena.co.uk; Wed, 12 Jul 2023 12:16:54 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 0034761787
	for <broonie@sirena.co.uk>; Wed, 12 Jul 2023 11:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id C40E2C433C9; Wed, 12 Jul 2023 11:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809EDC433C8;
	Wed, 12 Jul 2023 11:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689160609;
	bh=/cnjqebX0qVyCoL+VPfKzCQNiobr8hPQWE3NlrjT6pQ=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=phFFx4XEx+i/dsVFJtu1TTZgpbuYJYgFitlrkoK3gzfXV0p4MJsuafuBAXjqs6/ZV
	 4eu0Bsfp5j6UDA3pwSi5HCE8TnBiDFplStYPJ4JjsWUD1aevqTjJrOiOFAJtTicFjc
	 NXh9HN10M5FZMmJTWl//T9YroaSNS0ykfcc1UrJ1706yomUevTn9YhLRhvSG3PgmLK
	 bs7y+4lWeMg7sAPoih85uO8H6YLTBG/pX0p9Qd8rYOy6cUFMUIhKUX2VG6cI5n9FRA
	 5woFMgfMLmCma6HADo6mFcpU3k2jxxMRugYjv9lmy71NuLJO4cvv1VqP/vjMdFFC4l
	 Vr5E+WBQ5ElNg==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 12 Jul 2023 12:16:39 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230712-regmap-max-transfer-v1-1-80e2aed22e83@kernel.org>
References: <20230712-regmap-max-transfer-v1-0-80e2aed22e83@kernel.org>
In-Reply-To: <20230712-regmap-max-transfer-v1-0-80e2aed22e83@kernel.org>
To: Ansuel Smith <ansuelsmth@gmail.com>, Jim Wylder <jwylder@google.com>, 
 Xu Yilun <yilun.xu@intel.com>, matthew.gerlach@linux.intel.com, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-099c9
X-Developer-Signature: v=1; a=openpgp-sha256; l=2498; i=broonie@kernel.org;
 h=from:subject:message-id; bh=/cnjqebX0qVyCoL+VPfKzCQNiobr8hPQWE3NlrjT6pQ=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkrouc2B/HieoYcsxXfOVYCjCgqAEG00QE+d8Pd
 h6YI+F0SxaJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZK6LnAAKCRAk1otyXVSH
 0Mg0B/9shayMF/FhafcYuA8n6iFfAotaiCBRqvAnTBdiGPN732mX7mN1Vy+ldcGitb3oQbg/tds
 IT3P7BSBJWfwSPPzXaL7/tPeuBhfRvrNGwk7yMRxp1COdiMub4XRMGlH2QzHsuNFOGahwuxFq7F
 hpVWp5Rb8SailjGMGs8Cz6sHSI5fgEJ9JdUz2TiMbUOKdDdK/I9Q3bdK/1Yz5VwckEet9pWTLym
 1LLpuoe9gHMm3Z62DMhxh5sdSdGw3Z6EqNg027tNM5Cy1vOJquNb+49oktKTpD2SLKFD1Ytl4UP
 aeW5l70jbo7KAi+SNDqaFUOQd/vucwCsVGnWIwoBoVkoQmu3
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: [PATCH 1/2] regmap: Drop initial version of maximum transfer
 length fixes
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: 7jFIrR3CRfBk

When problems were noticed with the register address not being taken
into account when limiting raw transfers with I2C devices we fixed this
in the core.  Unfortunately it has subsequently been realised that a lot
of buses were relying on the prior behaviour, partly due to unclear
documentation not making it obvious what was intended in the core.  This
is all more involved to fix than is sensible for a fix commit so let's
just drop the original fixes, a separate commit will fix the originally
observed problem in an I2C specific way

Fixes: 3981514180c9 ("regmap: Account for register length when chunking")
Fixes: c8e796895e23 ("regmap: spi-avmm: Fix regmap_bus max_raw_write")
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/base/regmap/regmap-spi-avmm.c | 2 +-
 drivers/base/regmap/regmap.c          | 6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/base/regmap/regmap-spi-avmm.c b/drivers/base/regmap/regmap-spi-avmm.c
index 6af692844c19..4c2b94b3e30b 100644
--- a/drivers/base/regmap/regmap-spi-avmm.c
+++ b/drivers/base/regmap/regmap-spi-avmm.c
@@ -660,7 +660,7 @@ static const struct regmap_bus regmap_spi_avmm_bus = {
 	.reg_format_endian_default = REGMAP_ENDIAN_NATIVE,
 	.val_format_endian_default = REGMAP_ENDIAN_NATIVE,
 	.max_raw_read = SPI_AVMM_VAL_SIZE * MAX_READ_CNT,
-	.max_raw_write = SPI_AVMM_REG_SIZE + SPI_AVMM_VAL_SIZE * MAX_WRITE_CNT,
+	.max_raw_write = SPI_AVMM_VAL_SIZE * MAX_WRITE_CNT,
 	.free_context = spi_avmm_bridge_ctx_free,
 };
 
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 89a7f1c459c1..1bfd1727b4da 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -2082,8 +2082,6 @@ int _regmap_raw_write(struct regmap *map, unsigned int reg,
 	size_t val_count = val_len / val_bytes;
 	size_t chunk_count, chunk_bytes;
 	size_t chunk_regs = val_count;
-	size_t max_data = map->max_raw_write - map->format.reg_bytes -
-			map->format.pad_bytes;
 	int ret, i;
 
 	if (!val_count)
@@ -2091,8 +2089,8 @@ int _regmap_raw_write(struct regmap *map, unsigned int reg,
 
 	if (map->use_single_write)
 		chunk_regs = 1;
-	else if (map->max_raw_write && val_len > max_data)
-		chunk_regs = max_data / val_bytes;
+	else if (map->max_raw_write && val_len > map->max_raw_write)
+		chunk_regs = map->max_raw_write / val_bytes;
 
 	chunk_count = val_count / chunk_regs;
 	chunk_bytes = chunk_regs * val_bytes;

-- 
2.39.2

