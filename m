Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213354;
	b=mzJI/d/x/AqJcxXDHWD4MgVKdjOkPeonj2iort2GRoHvqXBaP74OW+U0/b5BvOdXIvnL
	 Uc1dBie2NnLYhkehODE+Z034PJpm9J75YZ07JObiwxqcuFmUYNrYnWYTXqYIXPAB37bCi
	 B3ebOfYY5S3vc+heGrzTtfPOv1veWH1LTm4yvAl0jUROF85wPGNZjRAH8E0y8abwviu3p
	 tWObYnQwETCN5DUOaqWyhA8xb8kvv2IQUsV7P8sDw1r5ySedYE76xewM/A5Vwl+rw/KK0
	 Xm/tWDF33RayXFWZfQe4Jr4oHvRseIiizElLqOI+fp9IvbYdEiWck3KzYzXQrjSwkKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=KNTR6T5K2GiC+ot2fhf3bUl1Mm3FM1bdFcrvO7juM4E=;
	b=ztd9WfB3tfL+i5q1XwoFNPLwMbQHEANSbJ/LEZD2RsVRYKl2GgfXJhG9NbGV8xIvgL6U
	 3juGK0DLCpupdWdPMLjgv/k1dtvbbc3cysJ9XgDwOiOmX2v5wTkBw6OAE3PEC7nhX3eF1
	 1a6+0Z29kmytzJ0VaYYY7C25AsTj23l02RZyY6vZoK3I7d8unNPkbS+J6Kk5KNDZiJQth
	 /CusLGFudoqPO75e+OPpYqTvm/zBv26q1OwoALvlTDBFEXEqPFGmBkxQBSvB101TcvGMa
	 yfX/G1afwML8lcekbVxdQnVEUx5ZOy4ORTMg/XWGjaGw6uH5Dbefl9oOMFw2yMR9fGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pk7pLZlR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599E6606A31A;
	Wed, 28 Oct 2026 18:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pk7pLZlR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723A91F01825;
	Wed, 28 Oct 2026 18:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213354;
	bh=KNTR6T5K2GiC+ot2fhf3bUl1Mm3FM1bdFcrvO7juM4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pk7pLZlRY8Bsn5nwe9BiIzHiAyqAe82wyHHSexb8b+e7TSDGxY7JPoBbw2S+S7/JB
	 kyuJsV10FDnNCYqIpgtwEOFZR4+02fh19wi3D9+5xJn1/gT7/6oxlfPS9mjIqahdRC
	 f5wRzCNxPQ+N8zmAlppJAIqd8DVmveLQavbbM18g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0439/1887] wireguard: noise: reject response consumption after intermediate initiation
Date: Wed, 28 Oct 2026 17:42:15 +0100
Message-ID: <20261028170509.221503977@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit d0305f8d90029556260c6824b61c493c424eba9e upstream.

Two threads begin processing the identical response message, received
twice. The first thread, A, runs. While it's running, the second one,
B, gets partway through, and during that slow calculation, or even while
blocking on down_write(), A completes and then also a handshake
initiation that's already been queued up runs in thread C, which itself
takes that same down_write(). The handshake initiation creation
succeeds, and sets the state back to waiting-for-response, and calls
up_write(), at which point thread B resumes, because either its finished
its calculations or was finally allowed to acquire down_write(). Thread
B then copies the state back to the peer, and begins a new session,
using that state, which is the same session as the one made in thread A.

Thread A			Thread B			Thread C

down_read()
 sA = handshake->state
 memcpy(cA, handshake->crypto)
up_read()
if (sA != 1)
 goto fail
slow_crypto(cA)
				down_read()
				 sB = handshake->state
				 memcpy(cB, handshake->crypto)
				up_read()
				if (sB != 1)
				 goto fail
				slow_crypto(cB)
down_write()
 if (sA != handshake->state)
  goto fail
 memcpy(handshake->crypto, cA)
 handshake->state = 2
up_write()
down_write()
 if (handshake->state != 2)
  goto fail
 derive_session(handshake->crypto)
up_write()
								down_write()
								 slow_crypto(handshake->crypto)
								 handshake->state = 1
								up_write()
				down_write()
				 if (sB != handshake->state)
				   goto fail
				 memcpy(handshake->crypto, cB)
				 handshake->state = 2
				up_write()
				down_write()
				 if (handshake->state != 2)
				  goto fail
				 derive_session(handshake->crypto)
				up_write()

This seems basically impossible to hit in a meaningful way in practice,
but ensure that it absolutely cannot happen by comparing the ephemeral
private key that's on the stack with the latest one that the peer's
handshake state has.

Cc: stable@vger.kernel.org
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Reported-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://patch.msgid.link/20261008130124.724119-4-Jason@zx2c4.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/noise.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/wireguard/noise.c
+++ b/drivers/net/wireguard/noise.c
@@ -784,10 +784,11 @@ wg_noise_handshake_consume_response(stru
 
 	/* Success! Copy everything to peer */
 	down_write(&handshake->lock);
-	/* It's important to check that the state is still the same, while we
-	 * have an exclusive lock.
+	/* Check that the state is the same and that this is still the
+	 * initiation we started with, while we have an exclusive lock.
 	 */
-	if (handshake->state != state) {
+	if (handshake->state != state ||
+	    crypto_memneq(handshake->ephemeral_private, ephemeral_private, NOISE_PUBLIC_KEY_LEN)) {
 		up_write(&handshake->lock);
 		goto fail;
 	}


