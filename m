Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212905;
	b=KEOLMkqpKUrCi0IAVswFwwk//QEvlpsNepyiU3sb7Bovw1mQqE069XDMUYccwh3ijoVM
	 XGk492iqX3a6Ue3XIcfbNiJThUahclg6cPWuIIuBY/LGLl2rDYtdzyw3BaU84Onca79Ut
	 O8ioSuLlzk6fPHPvTULxTKojkocGw9QzzRSHxYraEhRVNnHv8Va7jL4kEuhIajj5GCSwP
	 Ew742gIwvv3syNE1sPqW61DarAv7Cazua2zp5GRPoK5xXbyUOwTU00dg4knU48SqABBzu
	 CdnkT5ZttqrzBP1f9ltm2i+OdQNQwO3TlHxJHKkOFNY089kQn3BB+D/5D5G4SKJExMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Ht120cX5p6z8xTBICOrOsUcDNlNWTDcNiivEqiw+kQ=;
	b=5OC2jT+xdNeoLMeVpiKVKmEvMA3wXuRnEkrkDMY/8W9AjBz78VSyRoe4PE/FFNjJt+bS
	 vIJAjNyaOUlx/n9II4eDSTdyO5sGmsLLfhCTPqQiHsf2LO6RhIwd3dvUe30u6JYw8rJiN
	 6vIYmByPzbIi55vb8Hcwy0eveosRtPPKan+PbjE6lCJ2Z2rlZjHmjRJYSt53TX7Arrgmp
	 hHNMG32OM3uoUDFJOImW+GXAIBPwu5/nCkJCEQQmHw2kxsJCysC5j+5K34qxZFmK6eCeE
	 svMgeqlgzwIT7dB74Kqu3pHCZ0JmCqlfz0+qAJvmh9CJ1BfvOH8RWNoiyIDU+jsAMIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bam0dVS7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFDE606A335;
	Wed, 28 Oct 2026 18:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bam0dVS7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D371F01828;
	Wed, 28 Oct 2026 18:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212905;
	bh=7Ht120cX5p6z8xTBICOrOsUcDNlNWTDcNiivEqiw+kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bam0dVS7UJkOusACbBDCuxkyhkJvO48AsLGKnjAfB7MKoESlgcumBhkxahsOZQehs
	 IfIXS4bTqyLBlCNld3k9l9n6ZNpE5WsJDmgzUg/tnMQhs6rDJiq+8U1t6iqLBdT1vT
	 Td8Z0wQUI5RfjqBylhfSzzGhy/5pHZmqzSg2DGdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Yuqi Xu <xuyuqiabc@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 0318/1887] wifi: mac80211: handle empty FILS association request payload
Date: Wed, 28 Oct 2026 17:40:14 +0100
Message-ID: <20261028170506.463355523@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuqi Xu <xuyuqiabc@gmail.com>

commit 5bfd4b0b40b79781d900cb2f7da0685070f53c67 upstream.

fils_encrypt_assoc_req() accepts a (Re)Association Request frame whose
last element is the FILS Session element.  crypt_len is then zero and
aes_siv_encrypt() is called with an empty plaintext.

kmemdup() returns ZERO_SIZE_PTR for a zero-length allocation, so the
unconditional sg_init_one() puts an invalid page into the scatterlist.
With CONFIG_DEBUG_SG this triggers a kernel BUG in sg_set_buf();
without the debug check the bogus page is handed to the crypto backend.

AES-SIV is defined for empty plaintext and the S2V result is then the
complete output, so handle this case before the CTR step, which has
nothing to encrypt.

Fixes: 39404feee691 ("mac80211: FILS AEAD protection for station mode association frames")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Yuqi Xu <xuyuqiabc@gmail.com>
Reviewed-by: Ren Wei <weir@nebusec.ai>
Link: https://patch.msgid.link/325c048982d637a3af80d74ac5b36e9369b93f1e.1789751126.git.xuyuqiabc@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/fils_aead.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/mac80211/fils_aead.c
+++ b/net/mac80211/fils_aead.c
@@ -95,6 +95,14 @@ static int aes_siv_encrypt(const u8 *key
 	if (res)
 		return res;
 
+	/* With an empty plaintext there is no ciphertext to produce and
+	 * the S2V result is the complete output.
+	 */
+	if (!plain_len) {
+		memcpy(out, v, AES_BLOCK_SIZE);
+		return 0;
+	}
+
 	/* Use a temporary buffer of the plaintext to handle need for
 	 * overwriting this during AES-CTR.
 	 */


