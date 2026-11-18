Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059003;
	b=m//DkktUfXWcw+L4PSoE/5ujNj9XkBDl0Ks5PP3n748xhG61z9GEcymoPgkWDJFRWLsc
	 tFWSZlNkNjRBN/QKjdUk3vgdqviOsXELB9MqD+tojBG1WM0a91VDbjsk7ZK0WX8YK484z
	 kYmxMwgS8tWCKO2MNPGWh5pR87MTjdD22Z8EnvIKU5cNoW2bLRzaaJmUkW0b+38VkzgQg
	 l2i2vADo1fGd/rTmBhgGWHtUOpT+g6Db8g/WJM07/qO9y5LUXQSrwNacbG9NVJOUKscIU
	 iUd8J11LSwcsvo3yVFLwFqkKjFBY5IbX5+OXT+akPoED1V0yVZDTn/kOml/UoVMuW1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FxEnPCB/SiT/MOxpD7yDuJBQigAs/fhuD/DC3hzTzdk=;
	b=msMjQcVZW2eDpwKKjIvtp+1OJxFeEZAx6j2h93wIUHIB69ZIfNN34zQ3PEyLFWAoqnAX
	 d+yf8Jemy1yky+d6rwm7DUcZaFpRXqrHgYbCL0v2Ns+icWFpauR5aMM0od/Mng7CFv1jG
	 wjV6DR7/scBxEVpoJvCa2fNroXmbNs0q9pi1wsWPEtR8k423YcKfVimXXxxuZ9xrJSocG
	 3+Ti8odjP3Xn7u3//wtAWx8VNVYORdV12xqwxkKyNuVEd50e8Q4RN04Dijqm/DeYiEgng
	 aS4xGVFhHO6BVWc2aELeJSNnoAUqBnz/OzgZpcu3y0rdZLm6241/eq9aaRt8V7uGiDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K2UK5+eT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6E8606A325;
	Thu, 19 Nov 2026 03:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K2UK5+eT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8B41F000C4;
	Thu, 19 Nov 2026 03:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059003;
	bh=FxEnPCB/SiT/MOxpD7yDuJBQigAs/fhuD/DC3hzTzdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2UK5+eTeAGnehLyam7TtOgQKVucztOy/b7VAx5ldq4tsYFQ9+1QV9P30EwnBOhtA
	 FWNGvh1/WtF2gagmEw5/E4pswnFcNJdP+tTCiVjh0zvomvLtPXRtxL9T7etbaThk1v
	 n8g2Z0dRxLMGs1amsoeAyDz0930ZDIK64rC66X1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masafumi Suzuki <shengshilingmu97@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0687/1848] sctp: account for chunk padding in sctp_init_cause()
Date: Wed, 18 Nov 2026 15:45:25 +0100
Message-ID: <20261118145944.709780336@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3425554931a37..362c314fd48e9 100644
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



