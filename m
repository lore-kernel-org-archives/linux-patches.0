Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211044;
	b=4dfRQzw0s8sOPPhkSM7gdBw0OmvtVtQKfpd4m87OePrgWTmhje32+V0Elx/C+PyqEHtX
	 cb7HHMlemFMiBUBr2QJVtid69Qnwh7ROdTdROQoEDXCLKPVtzKn4LmDOcr6vaVVjVwpxP
	 vsCf2iqzjkZdJ27HN3LTxqcDIlgq8jLhxcvhDeplrKc57v2mqPwjbUWOwl7PFZYf2TpuN
	 OFUZKxNg5orwCKbEm5bjHWQNaksbx+SNgyAOuegkNYqe6vgl7/TfC/MtnZPjXmZWxZyZB
	 tBC0+ewn4n9w7MejnBIAxyEPtxQ+fPw43jDHeLBwz9Wk6Bi+q5+K56BzWSRPa4n08JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hdQe9Tu06nzTxxzO4RsQ6RY3Hgo1B2S4KCRUCdqFOak=;
	b=LeMVkJ6Bi2/7DPSlCNPbcANbzqyRU0fACJPURDXoTRsBy/dYzJ8yxxW8Ncd70MJ30Bqf
	 +BMOau9Al3M31vlPf+JYdhSTGjNMN7WJcspLeUxBnI9DErEHHhSLkq30AYsB/4snDZX10
	 WQl9eK+ynCk1Q4OdDAdkYjQSTbWp8/sXVvG5GTu1toK2B6nVYMc9te1VAGDyJe9aaHKQj
	 C/LdrkaULKVM6U3fhn4yAYJUFRG0MQMMKZeOownXE5rW9xmuPpLxAZLukJeAB94stXEN5
	 pAojJfS5mzzU2knrsmHpx0yUI+uRZlB8X7rkcbsoI4eOSqzEUTid/gLpitiCXyCxVkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AqllA1fD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF8660A5BEA;
	Wed, 28 Oct 2026 18:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AqllA1fD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDAD1F01829;
	Wed, 28 Oct 2026 18:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211044;
	bh=hdQe9Tu06nzTxxzO4RsQ6RY3Hgo1B2S4KCRUCdqFOak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AqllA1fDatNzB5mfF3ft3fLRxGeflr2+pwh9q18Yey3YgLQFqLSGU7rghsinu99q1
	 NwzFeDrA1RqIvpt7gL7/uGHvrJFb0Up6muBX8L+9UDkpM3jd/ZY02Ul4LhXaqd+UTz
	 C6DOgLNhas1GHjYpqT/twj49kqZ7aoYVsQkbkGp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Yuqi Xu <xuyuqiabc@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 240/571] wifi: mac80211: handle empty FILS association request payload
Date: Wed, 28 Oct 2026 17:56:27 +0100
Message-ID: <20261028170013.700503993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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


