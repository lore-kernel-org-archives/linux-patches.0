Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624672;
	b=qlEY4j/3vkcfdnjMpfyxssblV7v8ZqD6dH/UHZZb5QLZV0sbqkdwhSMtSK1ROtjmOG02
	 Dosam/gIryXb7NNlAZ5yG6Qof81SNso6jTu1eU3Mkf6XLAie/JBlVHFjoAmJShFudfnqU
	 8kbiXspm33fS3CQp2Ztg5AinBbE3jnEJkerGDx3UgJdQtSc4xD7KVrQp9K7n8BQyZRngV
	 RwUMC0PMOav/sBSLPV2pk3MgG++iTWgwza+SD8G3NmpNF9y/pK3I0RGNZtVX5LOa5V0hF
	 GzqWVTZb5JbxGcqzz8e3lw4a6XR61SK0jqzf6+wT6183yVEji01F5CBcuIgsdgZcwrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KLBdABLttaNvz0XPLvMaWNkmn5gltMWVnghJsh4XjR8=;
	b=V9CCy3RvV113Stey7ldVVaxGNaV41jEY+D5LU4HwOD90VvWE2vPW1Ro7vAeyESBdnBZd
	 sgr5cnMtWl86F1uboxGVDU4ay1dZZFVunccWGSGmx6HyAfu78lYU5lkVvqrQVnuzYQKY9
	 2SRzgoGbPTIAoyAJZZM85700FQd9dlULbu1xFZUnsA9Bjzg8jKc57i7RR9otiblfIb+s5
	 03nPUQL11+hrEXJ7rtDYwqyDMPJCYVJBdIY0uJyUpqjh1ujEnf4rym9wZtLhVz7z0G3sw
	 bbAz1Fi/rI48mDUxJtuJpIr5qdYcxx76Zw74SrLAJqp7mYQgFkeb0MJMO8eNclchwQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oo01GKob;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3902E606A33A;
	Wed, 25 Nov 2026 16:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oo01GKob
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0661F000C4;
	Wed, 25 Nov 2026 16:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624672;
	bh=KLBdABLttaNvz0XPLvMaWNkmn5gltMWVnghJsh4XjR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oo01GKobQDgZjTS0UB+UelSq7ImnRlh79eRSPBFI3GRTKVaedKWUxoQY+YiTg30kc
	 2Aaa8evH7G3KxczJ3sHaXUuYyV0pRbsQ6tk/IA60lMRmmNUJsmsansHxhHEOLTXE8k
	 y0SQY+qklvwoxArZ/Fwk6KXBOuAO5Q0Mfo2s6Ngg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Pepper <cochcoder@proton.me>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 267/816] Bluetooth: reject invalid LE supervision timeout relationships
Date: Wed, 25 Nov 2026 15:30:15 +0100
Message-ID: <20261125143855.390151495@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index b023f0870efaa..d247e088ebd01 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -2233,8 +2233,6 @@ static inline struct smp_irk *hci_get_irk(struct hci_dev *hdev,
 static inline int hci_check_conn_params(u16 min, u16 max, u16 latency,
 					u16 to_multiplier)
 {
-	u16 max_latency;
-
 	if (min > max) {
 		BT_WARN("min %d > max %d", min, max);
 		return -EINVAL;
@@ -2260,19 +2258,14 @@ static inline int hci_check_conn_params(u16 min, u16 max, u16 latency,
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



