Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993CA5275BB;
	Wed, 23 Sep 2026 14:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175346; cv=none; b=C5FV0bn6KLvwzgQfrLOCR02oq74jjU6N3qXaTsRv7JuHGPyFfAHEwJ+qkpIXzdEo7nWkfSSzRzf5g36+fyX5sFw0IHb5L+xlRvHtuORX3dxSBFrQ66lyCm8Z1f6CHjnzwL9vKYNKogNdyCzILYBi6o7sVkvhDmHvuwt4ycJuqnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175346; c=relaxed/simple;
	bh=JNQJh5DhuMu0HUtM1fF762mkXRKrWuhOpt2HsBWLsoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4JHwfmhyYKxdyfBo/iLiVIeS6qMebBsq5dK51lCrXBCkI/MOM8Gy5870cgKUV+Ax064gpi4N9VTRj7e7qINSOI4jlrOZaMQcd+tGtJcr5YBdoey7W0hSHnj2sruVuSGGqVBFf0WEpuFFTe1Lh08FT6yAZrpHlhyuOizEq2c2pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jsRWCYTS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jsRWCYTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EA71F000FF;
	Wed, 23 Sep 2026 14:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175345;
	bh=zK0ev+/Hp2owG90yq8Q3ZHEPRRcUbzN+RGZ0bUprH40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jsRWCYTS3b2d033vVYkwkRRNgS3ab53Ex+2eGR0B+K1HxrLpLEqwZcThXIqDopxLk
	 KJsCKv+/fHSANb5fefLf+Pu+o7r3a3z8Te8rb59uWEl7FRcwNXbvFil+SmaMnEceGu
	 pVQTUeohk559qKLGpQ7Zy3OdqDQrE0TYqFwiOa6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 387/398] wifi: ipw2x00: Rename michael_mic() to libipw_michael_mic()
Date: Wed, 23 Sep 2026 16:07:41 +0200
Message-ID: <20260923140653.498718026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit ea06baf59bd4b83c2cb13698411909e5e6be001e ]

Rename the driver-local michael_mic() function to libipw_michael_mic()
to prevent a name conflict with the common michael_mic() function.

Note that this code will be superseded later when libipw starts using
the common michael_mic().  This commit just prevents a bisection hazard.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Link: https://patch.msgid.link/20260408030651.80336-2-ebiggers@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 06f42accaf3c ("wifi: libipw: reject TKIP frames without a full MIC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/ipw2x00/libipw_crypto_tkip.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/intel/ipw2x00/libipw_crypto_tkip.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_crypto_tkip.c
@@ -464,7 +464,7 @@ static int libipw_tkip_decrypt(struct sk
 	return keyidx;
 }
 
-static int michael_mic(struct crypto_shash *tfm_michael, u8 *key, u8 *hdr,
+static int libipw_michael_mic(struct crypto_shash *tfm_michael, u8 *key, u8 *hdr,
 		       u8 *data, size_t data_len, u8 *mic)
 {
 	SHASH_DESC_ON_STACK(desc, tfm_michael);
@@ -546,7 +546,7 @@ static int libipw_michael_mic_add(struct
 
 	michael_mic_hdr(skb, tkey->tx_hdr);
 	pos = skb_put(skb, 8);
-	if (michael_mic(tkey->tx_tfm_michael, &tkey->key[16], tkey->tx_hdr,
+	if (libipw_michael_mic(tkey->tx_tfm_michael, &tkey->key[16], tkey->tx_hdr,
 			skb->data + hdr_len, skb->len - 8 - hdr_len, pos))
 		return -1;
 
@@ -584,7 +584,7 @@ static int libipw_michael_mic_verify(str
 		return -1;
 
 	michael_mic_hdr(skb, tkey->rx_hdr);
-	if (michael_mic(tkey->rx_tfm_michael, &tkey->key[24], tkey->rx_hdr,
+	if (libipw_michael_mic(tkey->rx_tfm_michael, &tkey->key[24], tkey->rx_hdr,
 			skb->data + hdr_len, skb->len - 8 - hdr_len, mic))
 		return -1;
 	if (memcmp(mic, skb->data + skb->len - 8, 8) != 0) {


