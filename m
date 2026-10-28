Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209003;
	b=zbrpAQseqNSjPXMVhGXf/V4omjSezkLVrKR+IW+wuj46wb17QIECGeSjsG60nJ15gOo3
	 MsW09oiQsxYzo92pCOm6/VNi6CtvA/nVZSqubTJBojC2ko2xp6GdX3enFRbcp7Y0eTwGM
	 mpbk7g+yG/K8fucf9XCSEoLaQMefFryAtftJ7EapWQKHSqeCqikUedwURjIgPuMLFf8ry
	 bdb64auQxlrbemBoh+HQukWUbTXI4WBqnq11WXx9WR1KbBjbUsTmQKB4t8buQlrOZCF/u
	 JmDHKaLToJLoLiOdyqUwwJUqV4UenPoQ1u+xt/6YbCRzfwINp+Ok6fD8OjDyy+jyp4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=oOPf6/TxVl+fPY+8rt5ctIhFdT669BoPwEjXN2wl94s=;
	b=3UsfRmqLk8kMjyu+3P2g9HNOAGXZLI3WCRzhsmaAQ8ZSbBO/oBBggP6y2cjFsOHQTpXs
	 6OC7q5wZBGer0QreDuLMlT2QRFtdqxiUNUvG40RFHLroBwZxTdka4KwBQALWumtpsHjK8
	 kWJ4XCb9TISGJ6O/QixqZMFrpCmjESe5hZBelqmE/fcaOcHFYEHmsOWGS940p0CIIQQXy
	 WGo5V3LkY80fAhDHMzXlqgNgjzfEeQO7065fYWOYnc44sz9Xn4iBAaDP4/cGXzqinpBqI
	 ciGsosV9mnE3ZA8nN+OPhAbtnTx+NH0aEfVhQtVusE0jo1a1+S7Gq8dgf8t42RuBQAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vx/OhO2G";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD78F606A31A;
	Wed, 28 Oct 2026 17:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vx/OhO2G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF9E1F01825;
	Wed, 28 Oct 2026 17:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209002;
	bh=oOPf6/TxVl+fPY+8rt5ctIhFdT669BoPwEjXN2wl94s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vx/OhO2GfX18H9pe0K6mb6Mc3E3aApY6gFTfGQGiTW5j7KminSmhkm80CEcoSbVHU
	 4ufmtAbelE1WrkdKtWbrn8MXA0hcOO0Aei33Gr15I8hv/uIL5n54v65qDNyvpT5+dl
	 6tclLoK37dn/gJZZQc/RFpmBQTO+78j5BqOeMvKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 317/516] wireguard: noise: reject response consumption after intermediate initiation
Date: Wed, 28 Oct 2026 17:57:49 +0100
Message-ID: <20261028170010.999856638@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


