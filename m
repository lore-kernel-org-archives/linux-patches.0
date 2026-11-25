Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618846;
	b=EsHOnvH6vZozKowr7ej1rKkTEP/9UjfRfjT33QwS2Jp0AjnvjFPmrAmv+27w4aJLYxAj
	 xIK6ZiwxmBE+isc4sPbj+BRAZTwrmwouLONlI4F0ReeaebYfa9yBpjvhQWIFQ1sFRIAyd
	 BzyTnpUX0nHppf7NBNKiDk7IlRK60KB0l1zLRDScAlq34iw3P17IlsfkqkULiDPDD6s+U
	 pwt+/wbXvVHnvbwkpvep7nW8BG+u96ZbB0HL7AzCqsJZ3cAzQmTBqpjMFO7r3NUzGDGlr
	 mfzOnweyTiWitt1i2VBKt+pqD3ZoEzfQN254x4scNQXDXCRhk+O55f90pnbYCUpyZkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lynWKf7Ur/EOgEB3oK4PpH2ZL2ZPpgaFF8IfPoOEk54=;
	b=OckA7VGISfZ06zeELrQrvZLscM4k8fcpmtbWoBE84K+7E0ieDw8M27cOfUDe/sKlffHF
	 h3fSgr9PxfG83qUte4OzN7dQP/hLWcUuJI6cYF5xT1R4oC9Wqo8WluHISOwYwI8F00KQi
	 1mTtUAK/mghRD9YLhGXuymuHi8ClMieA6oHAk9ZZSXQ8hElScKDUcT+fVxWxFmSUySXEY
	 HWs8mvwL7613N6KY/4yvupvoXvwv+Xx3oLaHOLpHPtQt4XRuesyFu+z0amJpWWdbJLKer
	 1HHiXWBuwvRZn0s/Omv2ezxHrwrtRyWYggg0XNion+eIWZwQkOZ+55GRbP8+dLQFDaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dvizMhxR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB380606A321;
	Wed, 25 Nov 2026 15:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dvizMhxR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936BF1F000D0;
	Wed, 25 Nov 2026 15:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618846;
	bh=lynWKf7Ur/EOgEB3oK4PpH2ZL2ZPpgaFF8IfPoOEk54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dvizMhxRmLr5qV6Rr3IbgZRfbJYyvufNn9bHgPoSPWnEEdWxdi4duRsogaWKWFVwj
	 pSWb+19sEjTxLiR63DWl/88w+VrafRgnfscB4asMar88w0UcdlSD8uJVc8IYjMOJbP
	 CoGqBrf5QYt8xfSJs1/gT0IFQgMYpayZfEfEYkjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Pepper <cochcoder@proton.me>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0362/1005] Bluetooth: reject invalid LE supervision timeout relationships
Date: Wed, 25 Nov 2026 15:28:20 +0100
Message-ID: <20261125143830.212700261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Kyle Pepper <cochcoder@proton.me>

[ Upstream commit c1d50a71cdee90a0c68b7a67221d8aae96d14a0c ]

The LE parameter validator calculates an unsigned maximum latency by
subtracting one from a truncated quotient. If the quotient is zero,
this wraps and accepts invalid parameters. Exact quotient boundaries
also accept equality where the supervision timeout must be greater.

Compare the products directly after checking the field bounds. The
validated interval and latency limits keep the products within int.
This enforces the strict timeout relationship without division or
unsigned subtraction.

Sashiko identified the underflow while reviewing the soft interval
preference RFC. The bug is already present in its unpatched base; keep
this common-validator fix independent of that preference policy.

Fixes: 8757825b128e ("Bluetooth: hci_check_conn_params() check proper range")
Assisted-by: LLM
Signed-off-by: Kyle Pepper <cochcoder@proton.me>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index cac282584c616..3a1169e19eb80 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -2320,8 +2320,6 @@ static inline struct smp_irk *hci_get_irk(struct hci_dev *hdev,
 static inline int hci_check_conn_params(u16 min, u16 max, u16 latency,
 					u16 to_multiplier)
 {
-	u16 max_latency;
-
 	if (min > max) {
 		BT_WARN("min %d > max %d", min, max);
 		return -EINVAL;
@@ -2347,19 +2345,14 @@ static inline int hci_check_conn_params(u16 min, u16 max, u16 latency,
 		return -EINVAL;
 	}
 
-	if (max >= to_multiplier * 8) {
-		BT_WARN("max %d >= to_multiplier %d * 8", max, to_multiplier);
-		return -EINVAL;
-	}
-
-	max_latency = (to_multiplier * 4 / max) - 1;
 	if (latency > 499) {
 		BT_WARN("latency %d > 499", latency);
 		return -EINVAL;
 	}
 
-	if (latency > max_latency) {
-		BT_WARN("latency %d > max_latency %d", latency, max_latency);
+	if ((latency + 1) * max >= to_multiplier * 4) {
+		BT_WARN("latency %d, max %d and timeout %d are incompatible",
+			latency, max, to_multiplier);
 		return -EINVAL;
 	}
 
-- 
2.53.0



