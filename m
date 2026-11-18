Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053241;
	b=a2mSa0Jg/+8FCqZSCX1tDdaYW2xDZvuYzbCoU5MFBdg3+ST52ve0adUkiwDZBGEVA+i3
	 KCAbFw903iJRdrS+Z6Lt1SCYTALNeipl5a+JcXExOn6aGRG9upimaOnSqMf63kxNy2oNY
	 DSCE41X6LKndt43sPaJ0hAWqTFAB31kpphm6/Httf4CsnwnTqgF/A/54Mp2A6idsV8hgM
	 5wGHknEII7oOxDzchZw0cFkihHxsmXwSZNcO3BY1a+ml1PnOQ27qz7U3Wu45T2ln63Gtp
	 wtxMNZpBY2hSAtdWgnTTpokXr52KEJ+UFCgSMFJW4S8pCgXjel3MCGmcPi5hCSa6qFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AsXriFnLR5LlzreW6G/cBpHIy+U7XPjR5XB1H83KOKM=;
	b=EtKEJZhZSfxSpoEah68iNuOFClPDhxtRNQ8KrM4wUYVYBAY6FA0f/DYUxtNndnLhkiEf
	 p6dVHd76WCaLy4JolyaJIS4lxKLz8zddUILfx1JX8JW2wu4qECzPtsDDjge2QqS+GwJTf
	 l4uDe4B7br74in8CN8NnKhSS+qPQ+ntpBvJ/OA3Pzw18UfVBSQYX75gIlV87oMh0YejHJ
	 zJcUMvcKMrhopFvUBwKDdw6cejno6oOLU1CSxN9u7Re9m85Xq95PZBiU43BbL+O8L2k23
	 3N4KlXNPl3/kBPJL+y0c2R7k8LqVrVDvmXb9DbDIX1nvWlO6S6QH18+STnexzcwFyRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=10ttbC87;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F05C60A2600;
	Thu, 19 Nov 2026 01:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=10ttbC87
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125191F000C4;
	Thu, 19 Nov 2026 01:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053240;
	bh=AsXriFnLR5LlzreW6G/cBpHIy+U7XPjR5XB1H83KOKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=10ttbC87Ic8t1zsw7H0O/S3dyd/GRbQsATxXFjH7oEbxzLfPHuClgm/d+si1AE6cs
	 hlsA+qpvpNyrT5c3J1Wu4pOycza/rAJoGHfpe0rypw3OpRCgXZCfDYmKji6+yCx237
	 6RXgz75gd0PsM5JuLchSKXqwzrX7C0WD3nlFmEDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masafumi Suzuki <shengshilingmu97@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0850/2214] sctp: account for chunk padding in sctp_init_cause()
Date: Wed, 18 Nov 2026 15:42:06 +0100
Message-ID: <20261118150046.167892204@linuxfoundation.org>
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
index 649384ff0e547..cedf3006ee823 100644
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



