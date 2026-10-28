Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214479;
	b=srLkH6XJvN4KTG18O4FToeauHEteKO6OzuNXxM0qwz3MtYkEPcHe5/I2+Tv5I+6rtcU6
	 gVWBDXCTuUaBvgeYemfUpuXlVfkxt3m8QhjHeWmjDMqvR6705YrGXtrDvIRXY4beYDhuw
	 UzjHYyySjk/ilB0Kzl9awVYgLhpf6t1SZy0C3jWrqGpIybYhBvJx8TFoB4P0nXEOWDLZB
	 qOTzMaSNr7f3RddREI/ngQViRLpDbWoHQMJQsCrDncAzsGbLPLGjZXNEY/xkmakm+UuF4
	 HbKrM4sjdPHnvUFplzt+AsfomferVwGK+8BRm1Ji+r217rkm8P3DzJa7b7dRF9un11Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qNJ23x1Z8Pxc+l4gEwVt02gkqHyHfPXBxUcTWa7ciQg=;
	b=amZWxiShIphAQIH0bSu0Jj54SQ9E1R9/UrBxisoljNjCoZzyfSyBx28GHH8vMD7RPYQU
	 ljNvb16uanw7lvOm9CkeQ6X7iBVCDgT/LPpbRPlz3dWaT5RIwwNG448MKMKU2nT0IYHEx
	 DvcDKaEc++HgOdz2r+XT5d6v5LzFFdGwghsZlGAfQlo+8fQz2vMnB2t57iSYOlB9v8JeS
	 S14KUZLbZdpOQPBpnZsNnFq7J1+iwhmg+kbB3rfguaQjkqE2SqFsfHISuXy0RcbsBESVt
	 yqSFtTB9hDf0sPTVEOwEm7r2YfTQVf/EWxe37rThn8mR2CL3tiuuzbKugliJNhCTtcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sfV+JI9E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05876606B7DC;
	Wed, 28 Oct 2026 19:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sfV+JI9E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575C91F01828;
	Wed, 28 Oct 2026 19:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214478;
	bh=qNJ23x1Z8Pxc+l4gEwVt02gkqHyHfPXBxUcTWa7ciQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sfV+JI9EFhAVJNVPmIj9iuo76Q0HiuGnj5BU5cJBLn3X8cLBfT1xCjIWPQheqTZRh
	 VGllkuZudWe8JErpQWPNo7KGc2LvGapT0iznLSlfvNEnjXsZBe4WQvPu1dNXy0fPxr
	 qpt2d7xbPyQgEJ3o0iPHYBHZ+HePVEdGlm83meeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0873/1887] of: Move of_device_get_match_data() declaration
Date: Wed, 28 Oct 2026 17:49:29 +0100
Message-ID: <20261028170519.286214217@linuxfoundation.org>
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

From: Rob Herring <robh@kernel.org>

[ Upstream commit 82174a0a9c5cf36a3e421fc1d2c86998d8023f61 ]

of_device.h mostly defines functions for bus drivers whereas
of_device_get_match_data() is used by drivers. Let's move it to of.h.

Link: https://lore.kernel.org/r/20230329-dt-cpu-header-cleanups-v1-3-581e2605fe47@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Stable-dep-of: 0aead8197fc1 ("mailbox: zynqmp-ipi: Fix out-of-bounds access in mailbox cleanup loop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/of.h        | 6 ++++++
 include/linux/of_device.h | 7 -------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 2960e609ca05e..9ff3ce1719c0b 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -364,6 +364,7 @@ extern int of_n_addr_cells(struct device_node *np);
 extern int of_n_size_cells(struct device_node *np);
 extern const struct of_device_id *of_match_node(
 	const struct of_device_id *matches, const struct device_node *node);
+extern const void *of_device_get_match_data(const struct device *dev);
 extern int of_modalias_node(struct device_node *node, char *modalias, int len);
 extern void of_print_phandle_args(const char *msg, const struct of_phandle_args *args);
 extern int __of_parse_phandle_with_args(const struct device_node *np,
@@ -845,6 +846,11 @@ static inline phys_addr_t of_dma_get_max_cpu_address(struct device_node *np)
 	return PHYS_ADDR_MAX;
 }
 
+static inline const void *of_device_get_match_data(const struct device *dev)
+{
+	return NULL;
+}
+
 #define of_match_ptr(_ptr)	NULL
 #define of_match_node(_matches, _node)	NULL
 #endif /* CONFIG_OF */
diff --git a/include/linux/of_device.h b/include/linux/of_device.h
index 90dabbf1e0258..24b911d3c89a7 100644
--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -26,8 +26,6 @@ static inline int of_driver_match_device(struct device *dev,
 	return of_match_device(drv->of_match_table, dev) != NULL;
 }
 
-extern const void *of_device_get_match_data(const struct device *dev);
-
 extern ssize_t of_device_modalias(struct device *dev, char *str, ssize_t len);
 extern int of_device_request_module(struct device *dev);
 
@@ -63,11 +61,6 @@ static inline int of_driver_match_device(struct device *dev,
 static inline void of_device_uevent(struct device *dev,
 			struct kobj_uevent_env *env) { }
 
-static inline const void *of_device_get_match_data(const struct device *dev)
-{
-	return NULL;
-}
-
 static inline int of_device_modalias(struct device *dev,
 				     char *str, ssize_t len)
 {
-- 
2.53.0



