Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704383;
	b=dkOd/78CDkUyFDwNbosLDL4QjASh7LLClwOZyGcFoNjVGCGhSTFKnjrbbDmMCK2P1jt8
	 6LzLLZNhO9VupbtKm7k8MvGhrMTk5RM8o72n3HqzQtXITY9IjrItyNqXF571CvUZcaehS
	 A06ZDA7sD+DsYtGHuih9KZISBkSnQHPx6iX3K+zeJ3sVfM3P/DZXrDtGYfjm01IIjuWbU
	 PmzNPSui2FlXrhSfwIIFGCnqeBekyE3KdEUpSqY8EcRJb5GYjpE2a+sJtTpDYdANK+sgS
	 oUWbXl6+IrTb2Wxw1v/eY8/fn2rpXKXXt8dXn63f0jiHk6UW0i+5NG4lmlWlKH/UXQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AeLWwbrRlCuPFLlA5Su9GZO1Z4ej73DHlBnwULvfmXE=;
	b=s5SxsuF/TCoMGzfYH4tQOQrsWLdQezs+euRl9l6o1WfEmyZMsAmFYQYsxxnZq/GHs+vt
	 0cQkSiWJOdRYkWRJSlzN7vH1VEzeVAEaSxFFcAXciUeyW6G6dGM6mhU0f+z7xOK52GLuE
	 FKmf/LFlL7xxFCNk6AtnGNudR20Y0XhjojM/wFYbfufmk4X/PrdUGgYJfF7UtHOjZGMXO
	 Z52S2jGcpBtrtv+QWkrc5cAbUOyMcM8LBG+zJKwIP7vZHUF8+fFeaQDDdnZ2w8CUsBCsv
	 hvyrZhJTDlXIp7kESRvtoovuVPceKBTNDeGU04ipF3wHsqOPPzj/fY9iX2VsjWrj4Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S6p+D+Ef;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884E6606A32C;
	Thu, 26 Nov 2026 14:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S6p+D+Ef
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CE21F000D1;
	Thu, 26 Nov 2026 14:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704383;
	bh=AeLWwbrRlCuPFLlA5Su9GZO1Z4ej73DHlBnwULvfmXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S6p+D+Ef3c62cE40RffSJlBLF1jEwMjabv/p7v6iBC4YbS+m7n5+xbmYliMYaAtnp
	 9X2WSwSQCYpvAXOf+YUsA0JIkvgM4g2KHFRY4C0DqTDNbmfQwpEOgAiMpz9KPY7Zlc
	 qyMPVtTfUAjPEgVbZmlh1aByWVlT//d4kgVPho5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Pepper <cochcoder@proton.me>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/265] Bluetooth: reject invalid LE supervision timeout relationships
Date: Thu, 26 Nov 2026 15:37:16 +0100
Message-ID: <20261126143612.439017193@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c76ac9a036e98..67828f941ba5b 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1620,8 +1620,6 @@ static inline struct smp_irk *hci_get_irk(struct hci_dev *hdev,
 static inline int hci_check_conn_params(u16 min, u16 max, u16 latency,
 					u16 to_multiplier)
 {
-	u16 max_latency;
-
 	if (min > max) {
 		BT_WARN("min %d > max %d", min, max);
 		return -EINVAL;
@@ -1647,19 +1645,14 @@ static inline int hci_check_conn_params(u16 min, u16 max, u16 latency,
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



