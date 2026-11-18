Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052269;
	b=qzIJ0qfoWGD5TYu8yX5Qzfn2wBchwdJii/jHSf18nLIrmpwMWVUA9NyEhU+k8LRMVJwV
	 1ppG9+PtqPYxqBnB+1MYGASU0ZERBthkGHXcUnLv56++GB7fiHx/HLdTJQVbERqyzjdOS
	 A45k7MG2JNaMICY5NYvtcQYNks33zKeYwIiY3z06Pog5ebvHoEimBHu5yzHYFSBe+fJ+r
	 Pdzc1naoULyNUjtfC140n+76MrZ9R0eWox13wDz7zzYUIoLCjPNSGJV6SEBaWX3SI1p8x
	 anl1ISszslf+9XsX3FeuIWJdWjNmQbgobENm2SOjlgPV14dTJbmHd26sQ07GBmluANw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZTZdTgMSJ8zxDodfCWE6LDnaG6Z3TRCajil9CauGr4g=;
	b=X1B5YdSUAsswsgJ+sMFoQUxnzfctAr/Z4qbWuXGbM5U+d/FLOweZQuB/VYkA/8FuzUTC
	 VmSK8kfjjQOVJBakX8QITDgJm5WhP1mxZdeezaJ19ACe9isn6VPoDSqfs4PByVi+5Yycv
	 oR5mCyVL3NthJTDVJT2LMqwR4eJWDpIEi+s26vxDQf3vXJoH1oaKs4pifQbd2qP8Sx6UC
	 3wtjmJ3sVYtnNQRMmeONDCDKWwBY/FY6oeZEqXlLCGlIHTHl2uZL23+RESKdsSM/Feine
	 ktc38weww4rBB6yyLszQw7hDAxXctTUvKuF8brI2uPkjp/3GId+Y/FnpGTNsIglF/IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pWOZfRZe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AF7606A31C;
	Thu, 19 Nov 2026 01:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pWOZfRZe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36BE1F000C4;
	Thu, 19 Nov 2026 01:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052269;
	bh=ZTZdTgMSJ8zxDodfCWE6LDnaG6Z3TRCajil9CauGr4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pWOZfRZeFg7eu+CRbRciuXhZYG3AYfoqmfs4/5knE+lyH47P9GzWr37Da1v2ogzAH
	 0687aRZK+3wvkGPF/8fjB3QJp+G0B0X4xRUCNF14vSkbGO49S8wD/zydCQmskG71oC
	 OdjM5o22KJtPrizNt9/1avU0RcgdzHMBoO6T7WdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Martin Wilck <mwilck@suse.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0502/2214] md/raid5: validate payload size before calculating payload_len
Date: Wed, 18 Nov 2026 15:36:18 +0100
Message-ID: <20261118150031.237090716@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Wilck <martin.wilck@suse.com>

[ Upstream commit 38c795105992bbaa3418dd39cbff7348ad17537c ]

Commit b0cc3ae97e89 ("md/raid5: validate payload size before accessing
journal metadata") introduced a bounds check to verify that a given payload
fits into the current metadata block. In order to calculate the payload
size, it has to access the members payload->header.type and payload->size,
the offset of which may already be past the end of the metadata block,
because the loop condition only checks that the first byte of the payload
is inside, and the payload entries have variable sizes. Later on,
payload->checksum[0] and payload->checksum[1] are accessed without
verifying that payload->size is large enough.

Add another check to make sure that payload->size can be safely
accessed, and make sure that the checksum fields are accessible.

This issue has been found by AI (gemma4, Gemini) during a backport
review.

Cc: Junrui Luo <moonafterrain@outlook.com>
Cc: stable@vger.kernel.org
Fixes: b0cc3ae97e89 ("md/raid5: validate payload size before accessing journal metadata")
Signed-off-by: Martin Wilck <mwilck@suse.com>
Link: https://patch.msgid.link/20260907155103.2325511-1-mwilck@suse.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5-cache.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index cac91c3bcfa66..86679d34232ce 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2016,27 +2016,36 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
 	if (!page)
 		return -ENOMEM;
 
-	while (mb_offset < le32_to_cpu(mb->meta_size)) {
+	while (mb_offset + sizeof(struct r5l_payload_header) <= le32_to_cpu(mb->meta_size)) {
+		u32 payload_size;
 		sector_t payload_len;
 
 		payload = (void *)mb + mb_offset;
 		payload_flush = (void *)mb + mb_offset;
 
 		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_DATA) {
+			if (mb_offset + sizeof(struct r5l_payload_data_parity)
+			    > le32_to_cpu(mb->meta_size))
+				goto mismatch;
+			payload_size = le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9);
 			payload_len = sizeof(struct r5l_payload_data_parity) +
-				(sector_t)sizeof(__le32) *
-				(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
-			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
+					(sector_t)sizeof(__le32) * payload_size;
+			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size) ||
+			    payload_size < 1)
 				goto mismatch;
 			if (r5l_recovery_verify_data_checksum(
 				    log, ctx, page, log_offset,
 				    payload->checksum[0]) < 0)
 				goto mismatch;
 		} else if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_PARITY) {
+			if (mb_offset + sizeof(struct r5l_payload_data_parity)
+			    > le32_to_cpu(mb->meta_size))
+				goto mismatch;
+			payload_size = le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9);
 			payload_len = sizeof(struct r5l_payload_data_parity) +
-				(sector_t)sizeof(__le32) *
-				(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
-			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
+					(sector_t)sizeof(__le32) * payload_size;
+			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size) ||
+			    payload_size < conf->max_degraded)
 				goto mismatch;
 			if (r5l_recovery_verify_data_checksum(
 				    log, ctx, page, log_offset,
@@ -2050,6 +2059,9 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
 				    payload->checksum[1]) < 0)
 				goto mismatch;
 		} else if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_FLUSH) {
+			if (mb_offset + sizeof(struct r5l_payload_flush)
+			    > le32_to_cpu(mb->meta_size))
+				goto mismatch;
 			payload_len = sizeof(struct r5l_payload_flush) +
 				(sector_t)le32_to_cpu(payload_flush->size);
 			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
@@ -2111,7 +2123,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 	mb_offset = sizeof(struct r5l_meta_block);
 	log_offset = r5l_ring_add(log, ctx->pos, BLOCK_SECTORS);
 
-	while (mb_offset < le32_to_cpu(mb->meta_size)) {
+	while (mb_offset + sizeof(struct r5l_payload_header) < le32_to_cpu(mb->meta_size)) {
 		sector_t payload_len;
 		int dd;
 
@@ -2121,6 +2133,9 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_FLUSH) {
 			int i, count;
 
+			if (mb_offset + sizeof(struct r5l_payload_flush) >
+			    le32_to_cpu(mb->meta_size))
+				return -EINVAL;
 			payload_len = sizeof(struct r5l_payload_flush) +
 				(sector_t)le32_to_cpu(payload_flush->size);
 			if (mb_offset + payload_len >
@@ -2145,6 +2160,9 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 		}
 
 		/* DATA or PARITY payload */
+		if (mb_offset + sizeof(struct r5l_payload_data_parity) >
+		    le32_to_cpu(mb->meta_size))
+			return -EINVAL;
 		payload_len = sizeof(struct r5l_payload_data_parity) +
 			(sector_t)sizeof(__le32) *
 			(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
-- 
2.53.0



