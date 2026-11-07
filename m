Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064009;
	b=IEfwf8SbRQ5OivDzg3/m+23te+b1ZqEkhsD1XzEE+4Dg/NwHrBvAfzPgxm7Fa8cxpTHR
	 tfXG2PBJDYDvCzgUiG9QgMERFuSobOGOsKfAw8ryqDS3r30//oanBS8rqy8YW0ciymgWL
	 sJxUaEA3t0+HTJBJlJZigYXdCn+ZTowHk10qXoAbr2KB+Igd0wOeGsmHTxLa55amz9za3
	 lcaRZjo1QzvfymeK6cI3Ue9JyET2XB//BNsoGJ2UteXAP79/FIxDHXAfORRnvR3TfiM7E
	 qA3xdXRcE4E5lxSK4RlLAnYieFc5G5y3sZCkPrP9WnH13oh3JItsDWc42zVu28U6vxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mGdPk/eKYqvPwkJZxJPn0oPlQ//826QUvkYk16ygjd0=;
	b=GreRd7+QjwPv3fGuEw06qWnRczw2DCqxU85nAFa2OTZBcA7Et4YMKAlX5m8PJNi+hCqa
	 cACSbQEDpK5tJF5itHznyRerzEn7ufe3l8BnKe0tvKvcuTKuK56J3Gin/MJNPcAt8f6jd
	 2nLhwGwDxlBsDcMLcIkEh4yyqfmJS0ME6S5Fw8LRT3wn0gg9aAfcXlFGw7a5HIPuvEDEV
	 fEL7+1DO7Luv8YePEf40wWIVcJOO5P3cOeKc6LYwIL2D3pRTkCVTt2R9P5pXW8wrRG1VW
	 0YZXlt6V7YbfgX7CQDT7Dthv9ePyU7QuW2ip83bEEVLH4aM12boi7sSfCpv5BtRhdCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0FHAAvkc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682B0606D834;
	Sat,  7 Nov 2026 15:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0FHAAvkc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173A51F0089F;
	Sat,  7 Nov 2026 15:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064009;
	bh=mGdPk/eKYqvPwkJZxJPn0oPlQ//826QUvkYk16ygjd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0FHAAvkc9K0LSmlFb4sNpqWlRoUaZCi2i2ROkR/IYWAqLtCqtV6JWbJVKlGdbaDCM
	 zt+HA0/yC/1g91UUErZfXhclZRhu5Vi0U0sS1ZPvsFe8p1Z2zfSXSFeerGYqp2G/AC
	 CwNAEtFVzHtPCkGJeUlNFg8tIZTiV7z1W9zUxZdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Martin Wilck <mwilck@suse.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0188/1257] md/raid5: validate payload size before calculating payload_len
Date: Sat,  7 Nov 2026 08:41:24 -0500
Message-ID: <20261107134944.649459731@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 7b7546bfa21fb..62460e231f025 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2001,27 +2001,36 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
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
@@ -2035,6 +2044,9 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
 				    payload->checksum[1]) < 0)
 				goto mismatch;
 		} else if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_FLUSH) {
+			if (mb_offset + sizeof(struct r5l_payload_flush)
+			    > le32_to_cpu(mb->meta_size))
+				goto mismatch;
 			payload_len = sizeof(struct r5l_payload_flush) +
 				(sector_t)le32_to_cpu(payload_flush->size);
 			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
@@ -2096,7 +2108,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 	mb_offset = sizeof(struct r5l_meta_block);
 	log_offset = r5l_ring_add(log, ctx->pos, BLOCK_SECTORS);
 
-	while (mb_offset < le32_to_cpu(mb->meta_size)) {
+	while (mb_offset + sizeof(struct r5l_payload_header) < le32_to_cpu(mb->meta_size)) {
 		sector_t payload_len;
 		int dd;
 
@@ -2106,6 +2118,9 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_FLUSH) {
 			int i, count;
 
+			if (mb_offset + sizeof(struct r5l_payload_flush) >
+			    le32_to_cpu(mb->meta_size))
+				return -EINVAL;
 			payload_len = sizeof(struct r5l_payload_flush) +
 				(sector_t)le32_to_cpu(payload_flush->size);
 			if (mb_offset + payload_len >
@@ -2130,6 +2145,9 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
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



