Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045213;
	b=GgM8QL/goh/M3B52kgYSEcEXQHRC4z1vZ8kcMOiRPkP8PM8gKDv2EuL/8fSvNo7orWDP
	 f04j1ZZPT94uQi3glXpxAoQ7dumqnVTpZmWPC3x+a4Ho7Bj3nlH1y+K27HZY4re4gRIeQ
	 hTo3HEps50BgOjmoDNJgXocMVrqbE02DUYH4vkNMPsMCwLMeKs5wwaKz0DXDN4kRjjr/1
	 WEX33WD2UBOv69oCg1Rl/PIicY5RDpTWjOYe0h6ece184yaT6gb80HuU0AoUsUbYa3PBn
	 gHx25BgqmrX6O2FG3AKuck3gshgy1p0WLSoM7EDrqRYy7KTFIZVgvN/4quDcrdlxCqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GFITs5RF+70Jqsou389YxmsB1qaSflXpLWdP8uq/YEQ=;
	b=JdfKmLbxgjwv8YbGZFht4+UKuj+53oDP5VMWuQIIdgZ7JZVawIMbQ1o1fr3YNXdQ4TTD
	 o+damUp2JscjRlOFNgqCZoraAj9z392qgjViIT6drLws+TayD2zKQ40e6ZcUAOpKh6+0i
	 eSYYAbA4CMTmym2dL1+hugYMbHS59CIHEY2+z74pY2SCZKWxujr0Pp5OIUquWAWKfHguy
	 dxgyBR2cPHGESfdA52ZoSdCjtfieYG6lbvBu10T7mb4zg/cPMrM1+SZg86Hy2gDtz7D0B
	 O2BFaDhgeOIJFxW3MHLIb7lUDTCOmB1tufT6++te14rIOb0z421KqJB9EIAxrJPtOsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KiGXq9IW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AF2606A339;
	Wed, 18 Nov 2026 23:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KiGXq9IW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47221F000C6;
	Wed, 18 Nov 2026 23:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045213;
	bh=GFITs5RF+70Jqsou389YxmsB1qaSflXpLWdP8uq/YEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KiGXq9IWKPm9dNCE3EqyQ6BQMHYDZAZ0FmMGRYdCk3a5bnnBgdhqEg8ojTEX536aa
	 2UmF/MFIqmVGU1RQqxB1exGwOxpg6iYsTHgwvIu6slOgpTCoP04vpSes0RrT8zAzyW
	 cyTU4Ha5NAB90rHv32fm2ubKJvL9bfrLdiYw+KKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Martin Wilck <mwilck@suse.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0782/2857] md/raid5: validate payload size before calculating payload_len
Date: Wed, 18 Nov 2026 15:30:16 +0100
Message-ID: <20261118150229.724453785@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index df1b64c81ebc5..cf3191cc40373 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2011,27 +2011,36 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
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
@@ -2045,6 +2054,9 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
 				    payload->checksum[1]) < 0)
 				goto mismatch;
 		} else if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_FLUSH) {
+			if (mb_offset + sizeof(struct r5l_payload_flush)
+			    > le32_to_cpu(mb->meta_size))
+				goto mismatch;
 			payload_len = sizeof(struct r5l_payload_flush) +
 				(sector_t)le32_to_cpu(payload_flush->size);
 			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
@@ -2106,7 +2118,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 	mb_offset = sizeof(struct r5l_meta_block);
 	log_offset = r5l_ring_add(log, ctx->pos, BLOCK_SECTORS);
 
-	while (mb_offset < le32_to_cpu(mb->meta_size)) {
+	while (mb_offset + sizeof(struct r5l_payload_header) < le32_to_cpu(mb->meta_size)) {
 		sector_t payload_len;
 		int dd;
 
@@ -2116,6 +2128,9 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_FLUSH) {
 			int i, count;
 
+			if (mb_offset + sizeof(struct r5l_payload_flush) >
+			    le32_to_cpu(mb->meta_size))
+				return -EINVAL;
 			payload_len = sizeof(struct r5l_payload_flush) +
 				(sector_t)le32_to_cpu(payload_flush->size);
 			if (mb_offset + payload_len >
@@ -2140,6 +2155,9 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
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



