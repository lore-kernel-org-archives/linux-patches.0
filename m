Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705301;
	b=Hx2SVvXpBtIdQpq5rsdIE5MO65jJzFzCULIQFiHKvgc7sL8dL6UOFekTKgszk9ESWuH5
	 NYZxZzOuoIdOIi93OkyxPnatDeqT/0H9DTYCS50vjrRMbYWkxsnzTv+QX0voJ4ZBUJA3L
	 LOmw2BBiNaUJdIShaMlaAeaGncQ6BaOCpWrjjO1In8HP35gjIwmGAIUw3OvABo/UNeIvD
	 pB1o+g4+NexuQSmsxsLW5+IdO53ps7nD5HTwyZr+y/C84vtPHTrxSlxdmn9h351ppnw0F
	 tZGNPG2mwAbS3HsbZyB8U4qeEaIP9QUfRNNhjnLfuVs31w8kx7HQ3vUeQT/2xIgTSXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vb874s1gOnmhCDwoqS0PSO8RNUJuWr3OHDeniIF/xTs=;
	b=SjrZ32FNh+b6BH3YXZDhhLJJrBXRDQDBBUYNWbSbdHZzM8sMb73uFWd4ml7w6hWjBB+N
	 8fa0DyKMtJwd64rxI7KeAG73lITlU0IvbfSLXCTc7J6g00cOfEy8gL34fFnNPDA3Aw+Dd
	 8u4XaWd922ucdmlZLZYlEmHTQwQPHwbwlU3qbB1gpJ6lBH4VdO2CtQXBprwY4IEHPqCab
	 7AeAAoUw8WJNIl6RCOp0iohykmnFdMj8S2xVwASjbQRBq8IVnezJfJcT1VxgnTwwQbYqz
	 NPYOOypUQC3R2JMjTBvA7rm1xP2IFIjDUIk3vDn+KM3ZKmIBagiQRoAAm8F/WD5UaDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JFu0x8Kf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA1F606A31C;
	Thu, 26 Nov 2026 15:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JFu0x8Kf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83321F000C0;
	Thu, 26 Nov 2026 15:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705301;
	bh=Vb874s1gOnmhCDwoqS0PSO8RNUJuWr3OHDeniIF/xTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JFu0x8KfXlGxwjeLAazNvyX1FL80TpD8VpOXj4YjIc/BP8TjRGLPNppVoyZTUfyg/
	 HkkvNxr9LLbYTS1PBxemxpP1pP8oGbAmVaRgnmVo2cWCppuebuHfyll32bq+wKw6xW
	 2b4P0rurt3maP9ZbmnCv+38d/yvPjtUtiPXNPUtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Pepper <cochcoder@proton.me>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/319] Bluetooth: reject invalid LE supervision timeout relationships
Date: Thu, 26 Nov 2026 15:38:13 +0100
Message-ID: <20261126144009.565318834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
index bb5c8fdd9d335..8656ce27eb330 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1685,8 +1685,6 @@ static inline struct smp_irk *hci_get_irk(struct hci_dev *hdev,
 static inline int hci_check_conn_params(u16 min, u16 max, u16 latency,
 					u16 to_multiplier)
 {
-	u16 max_latency;
-
 	if (min > max) {
 		BT_WARN("min %d > max %d", min, max);
 		return -EINVAL;
@@ -1712,19 +1710,14 @@ static inline int hci_check_conn_params(u16 min, u16 max, u16 latency,
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



