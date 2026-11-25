Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621754;
	b=ywRoN2GOgWeNiFavP4OKCwFCn47UyF1lW0vA6yUsK0rlXal4KxRUr6xPMTAabxcSoB2i
	 cuYO427Tr8bk5BXQqGIJFdZKuUILFGrWMcCpEr0tydBNuG2AV9eMF43drnFJYaxCUvBFz
	 gh4/9NNiAM2zc3fhjmzxLi2HRGk3ZAx/yxr731u7NQzOhKgBmdsr4PhBbu9Dk3TRiRMEG
	 w39E1M8Mkqa9mRn9SoUv1FSXXce7eQhoew27xc3SHUch/yknp5t0ZhZ5i/dmw57zEeU1s
	 hiqR442jCcR25WPr7NVwAsg96HaZQlkSDs2ydzFLo+P/quNd4xwZXHXTktcqmHdzefQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qgjqbIfsToA6hgS/t8QULJbl200pjCC8Ks69SyaqJRo=;
	b=1vEOhzULbHY3mi+6PNDqdZasj2zWk5spdmKUTNH4o13/abr90fuDABghEQVTWIKRM6Xs
	 KshTgxzgV0GyRWuoSW+l39TwTjGBV4/wUM+XYvC3jzIGnZWwLlxxFOFpU15kO/1mnZcEH
	 0IE3L0SDB+KZiULtljpfUnoikGfOo7WMq5JvYF78HhpuGWXP0rJ+y1SP/XItunGc0fjlW
	 oTMeGGL4S/WU3LcLhKJH+jvCI1ksLXGuljFnExkHKQNMjQiSF9803dFycrTtjK+jiFTRn
	 oe9Fg5Fwl2BosE1jP3HERQ8TyPNUe3feo8UTgDfRDSLf8Mu400nu2sEcAcQeUcGslpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CUHYIS9K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981A4606A327;
	Wed, 25 Nov 2026 15:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CUHYIS9K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49181F000D2;
	Wed, 25 Nov 2026 15:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621754;
	bh=qgjqbIfsToA6hgS/t8QULJbl200pjCC8Ks69SyaqJRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CUHYIS9KZywZOTlcSU6iX9SSQ6M86t1LqLuP7dcwrkRzXp18YpXvQfXgY54YJBLNq
	 9i8uPOzkQTB665qrBIR59Z2wUseC+rW2Y2eW/qXfIo60ZDs74Tukg56Yt3NtlmnKp+
	 OEq8oAZv6IpQqP/ymeGaLWaHTCv9Yg0pZyapjoh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Pepper <cochcoder@proton.me>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 326/990] Bluetooth: reject invalid LE supervision timeout relationships
Date: Wed, 25 Nov 2026 15:28:13 +0100
Message-ID: <20261125143829.723143398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 37b3dc2b4c945..d244fd50345ec 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -2271,8 +2271,6 @@ static inline struct smp_irk *hci_get_irk(struct hci_dev *hdev,
 static inline int hci_check_conn_params(u16 min, u16 max, u16 latency,
 					u16 to_multiplier)
 {
-	u16 max_latency;
-
 	if (min > max) {
 		BT_WARN("min %d > max %d", min, max);
 		return -EINVAL;
@@ -2298,19 +2296,14 @@ static inline int hci_check_conn_params(u16 min, u16 max, u16 latency,
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



