Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064524;
	b=4bXpesiaacW3JTW48vt8fFog743Ld5bXxsI4rnUOZSJPioZNMDIVbDCvtPmyzRFdu6fO
	 yWF5ubDGWiJzzCJUqxbPkifxt3idBhjnZcJTKZHvGqC+1YZ5WDkoKl5eFAN8T+PNyoBq3
	 mm2vH7Z8Y23x+fk3JngRPY8VWIp+BTH8sUsTSqui0wJk4uNEaNsb/B6oKWuhpTsX6sFNi
	 LcfMegzGRB/DXMC6mToMqhpAGwCbzIGfvbuFAbM0OMK+qbw6iUMcIAEf/oIiI5xO+DJCe
	 j3WDeen7hLUC2l2EUxNhcpMt1qAAAMeEPf7zixm+V0NQaCAzPGY70svwj2revJf0wYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/go96+gT5BG+cnPZxbnSUGfXM/tzstIb2G1CPJl2FmI=;
	b=js6p+QAixuwrrdTTVdLuhX08eAPa6pwOtxNB98Su9qrzAMsFRVW/RJ6W72rvOArB7kDU
	 cKs9sVSss0nuV47sCDNk3/Mg92qq4aG9x5QyziwcuA1gB+BIvon3uPgIpxzHWs5oLsvV8
	 iE/FM17ikZLV+p6g3JB1Ui+wvR7iki2/5UET5+H9jawEVOMN6Tyux7AHaxyDa0Am50gxY
	 iwGNWfzl5zFPW9U7nNuDlcw/WzNxzvPNIdCl5f/0I0IV/WrCPFJT5PSCfzK6M40YTl+/Y
	 Zi2sERKZIAHrs/prLI2KcqmbO3oOF7pK0UiggA4poV1sS0xSJE2rQT1U+l4e0OthY5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q7eLhNM6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCC5606B8A2;
	Sat,  7 Nov 2026 15:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q7eLhNM6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E111F0089F;
	Sat,  7 Nov 2026 15:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064524;
	bh=/go96+gT5BG+cnPZxbnSUGfXM/tzstIb2G1CPJl2FmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q7eLhNM6jAsdVBjrrtXZGxJ0YGVXySxDObm8K8eD96AnpgW/E6BjUKdSH7uU6XIfV
	 zsMMTs17rxw3QLTY23tD3rXytiLuX9dTMaHtFMkLsnGsSSvo2q820fL3f8mrEoZtkF
	 9bMLuhcOY2Q8I/1qEk3yNT75xPFqv2qYTMimKIkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0555/1257] crypto: algif_skcipher - rewind rounded output bytes
Date: Sat,  7 Nov 2026 08:47:31 -0500
Message-ID: <20261107134954.711707504@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit 2f90facc7b94934653eb7ebfadcc25d503b89196 ]

af_alg_get_rsgl() advances the receive iterator by the unrounded RX
scatterlist length.  For a continuing skcipher request,
_skcipher_recvmsg() then rounds its local length down to a whole chunksize
without restoring the iterator.

A later chunk starts after bytes which the provider never wrote, while the
syscall returns only the processed length.  When copy_splice_read()
supplies non-zeroed pages and publishes that return as a dense prefix, the
gap exposes stale bytes from a previous page lifetime.

With unprivileged xts(aes), a 31-byte MSG_MORE request followed by one
final byte advances a 47-byte destination while returning 32 bytes.  A
hardened v7.2-rc5 image retained all 15 seeded stale bytes in 4,829 of
4,829 records.  With init_on_alloc enabled, all 72,345 gap bytes observed
were zero.

Rewind the iterator by the tail excluded during rounding, before rejecting
a zero processed length.  The crypto request uses only the rounded length;
af_alg_free_resources() releases the entire RX list before another receive
iteration.

The fixed target-like kernel returned byte-identical dense 48-byte output
in 4,771 of 4,771 rounds.  The unmodified kernel returned the vulnerable
32-byte short record in 2,409 of 2,409 rounds.

Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/algif_skcipher.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 1e61fe6e24b99..291dbd6989325 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -135,12 +135,16 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	 * full block size buffers.
 	 */
 	if (ctx->more || len < ctx->used) {
-		if (len < bs) {
+		size_t excess = len % bs;
+
+		len -= excess;
+		iov_iter_revert(&msg->msg_iter, excess);
+
+		if (!len) {
 			err = -EINVAL;
 			goto free;
 		}
 
-		len -= len % bs;
 		cflags |= CRYPTO_SKCIPHER_REQ_NOTFINAL;
 	}
 
-- 
2.53.0



