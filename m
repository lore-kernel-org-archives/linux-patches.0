Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591037;
	b=4xva8hU4/NjTWZ1xueOooQsBCYwaN7S9+ppPc1zajXE67LVODAagzl6W+L84xqsNUvkw
	 fm5vF59XITNT+nnkyOBu1xDXfVb1n3gnLReDJb2E0M1uk80rJoQtLTIj4u2UaV6kzzPHD
	 gKK6B+Ao9ichrbGEDOJyo/DFzdKRw77vQiZGllIliofzTx836CE01p/h4zLaekw6q3kX9
	 +cpzrCy64+E1Pl/RpDFWiyUO2g02YOD6dcRAPMBKzqhZ2dkWJp0l9lPSTPC7ROI8g48yC
	 7IIEdWjvJWu1pS91qJQZ5S14Zzn7VXyPHt1yrDVby5E4HldE6T+U5KKSJ0Hkyc7dkGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=quhIjbY2KVig9KuRGxKCWJv8jJGqxaJ5A7/lXQb+R5A=;
	b=ALVnzg+bFXSTpneNmxwLaMI4bvMR8f7i03Vzl9dzKlcqenGUApGb+CzaZcScE9jmFEmA
	 L7cOvxAn8Jl6jjQbLZgQXxNMN9Y7k6FjEYeWuUSNjHC0gRRjt4AAyXwxD1erryaXhKRzh
	 I9VHDKzs9eZ0pgC1E4x7pq94mx1vmQeewZOAApNl4LrXN7f04Fyuz0gTrjZgp1tdVZe09
	 MoaYVhhnTo7yuvHm2VLilwR7thua9D/4Sn7vvMgDCkNRPikcEsS34QmvexeWntGRtd5hy
	 kw0TdtFFIhOnNZm4z9BsbB/RHZVUoSVslKTiYsNz7TtklP0ggNgoePUSfn19QQ4uTuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RdUO6WN0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B048606B804;
	Fri, 13 Nov 2026 17:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RdUO6WN0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5AB21F000C4;
	Fri, 13 Nov 2026 17:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591037;
	bh=quhIjbY2KVig9KuRGxKCWJv8jJGqxaJ5A7/lXQb+R5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RdUO6WN0FYFilHS6F8FG5lrBgPz2ahvYQUR4oAK3PSs3719KhTHWK1gKIGU78920d
	 uTsRsWUOY8ezyGWEzG0cUfRh2KDGrpAJJgwcQg1hNtUv2QZQEYpvxBhF7ouHKXVWKI
	 3nWAHAzTNvCAGj0Ef+u9WB4O70cgSeatr5E1QY+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masafumi Suzuki <shengshilingmu97@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 203/670] sctp: account for chunk padding in sctp_init_cause()
Date: Fri, 13 Nov 2026 10:46:07 -0500
Message-ID: <20261113153818.838423535@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masafumi Suzuki <shengshilingmu97@gmail.com>

[ Upstream commit ed6c53b27be492643da2017c6f8e2732be5edf1a ]

sctp_init_cause() accepts a chunk when skb_tailroom() can hold the
cause header and the payload. sctp_addto_chunk() then writes 0-3
bytes of padding before that header so the chunk stays 4-byte
aligned. The check does not include the padding, and the following
skb_put() calls skb_over_panic() from softirq.

Count the padding sctp_addto_chunk() is about to write. The cause
length on the wire stays the header plus the payload.

Found by LLM inspection, triggered and tested the fix.

Fixes: 8914f4bace3f ("sctp: add sctp_make_op_error_limited and reuse inner functions")
Cc: stable@vger.kernel.org
Signed-off-by: Masafumi Suzuki <shengshilingmu97@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20261027082405.1297-1-shengshilingmu97@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_make_chunk.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 1bbc041c06440..6d0df43e08a86 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -145,6 +145,7 @@ int sctp_init_cause(struct sctp_chunk *chunk, __be16 cause_code,
 		    size_t paylen)
 {
 	struct sctp_errhdr err;
+	int chunklen, padlen;
 	__u16 len;
 
 	/* Cause code constants are now defined in network order.  */
@@ -152,7 +153,13 @@ int sctp_init_cause(struct sctp_chunk *chunk, __be16 cause_code,
 	len = sizeof(err) + paylen;
 	err.length = htons(len);
 
-	if (skb_tailroom(chunk->skb) < len)
+	/* sctp_addto_chunk() pads the chunk up to a 4-byte boundary before
+	 * appending the cause, so account for that padding here as well.
+	 */
+	chunklen = ntohs(chunk->chunk_hdr->length);
+	padlen = SCTP_PAD4(chunklen) - chunklen;
+
+	if (skb_tailroom(chunk->skb) < padlen + len)
 		return -ENOSPC;
 
 	chunk->subh.err_hdr = sctp_addto_chunk(chunk, sizeof(err), &err);
-- 
2.53.0



