Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026582;
	b=2gkEF5tc0vVpgtpjHCy0nBLIaPGMoua4QzLZG1Qk88DbwJSD9k5jZlxkS1y7w+whDRxV
	 EZFho5vg69E28zwB31m2ip2Q0MyP6e1CTBVDEikc3txZhRPuqEBsg2lUN3hessEIaMRyY
	 vCEPuQz7s4D//+CGMMFv9tg/RZjRA3oIb2h4ENw6D+2XS3bgkgdHGsvBFdQACbUaFIICH
	 KQChEZMp+jM3rIBpFHWaziGrbC8JbdYkWkKU4I0XAcoarC1wZa2FjoIQ55UsebX6GhNaF
	 KykFWKj3YGeTqp/gclJVNzmXPHXPy1ovFUWFRwSt0FZ4Q0m5WYV273cX9mK3ULadB/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a7QAN9LCG2qZ1mx+AGqwozRz40C17DHwBaZVE+hdvqE=;
	b=a8l3fEz19rgVz1gJFH0fzdHAh1UXHxVHdpI4bYKadYK7/i3XLXbjlm/5UIY3dmHRux36
	 7vClSelRKvVNhQeMnbAWkg0okFb1Nj7nojxzrWB/1qZLK+EtCFXjMhm4wgYFmsZnXkn5K
	 XrvRzIQcMoqDsvXOe9ypkNfEnbetbF47lOet26xYgFE85SOU/fmelJl0j60pEq1N0hSNJ
	 9aiVGmPJC+EW+FvQ+e+GE8yACssDgNOn+izp9BdDLw8Hdo4IZttBLJB98rln62a0RSazc
	 dbNDX4VN2UEvr3R0/GwSB3I6Zni05w1aAbIJujNIlksf6u4QZgfv0IkSf7FKfYHu6Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="P0W0t6/i";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB19F606A31C;
	Wed, 18 Nov 2026 18:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P0W0t6/i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E4F1F000C4;
	Wed, 18 Nov 2026 18:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026582;
	bh=a7QAN9LCG2qZ1mx+AGqwozRz40C17DHwBaZVE+hdvqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P0W0t6/iBKQVeDgiv+H0R5yQ575GIjWhz7/N4SxDCO2M2Kvh79emrA+Z33zVkMQam
	 U+cm2iU+9TtmuiMM0QjLzgAOkEf/q6upkS6tZdOm1AuZJNvWP2/Nn4BLGo4gy/+ZQd
	 CZPer79yiZ20gHyneP+GmJQYLg7YuPh54VGPam/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1487/2151] thermal: ti-soc-thermal: Fix the return value in ti_bandgap_get_sensor_data() kernel-doc
Date: Wed, 18 Nov 2026 15:53:42 +0100
Message-ID: <20261118150216.048814401@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 82bb005cd9cf5a9df4cfe4a52db90346ac5fd17a ]

ti_bandgap_get_sensor_data() returns an ERR_PTR() if the bandgap
instance or sensor ID is invalid. Otherwise it returns the stored sensor
data, which can be NULL if no data has been set or the stored value has
been cleared.

This mismatch was already present in omap_bandgap_get_sensor_data() when
the driver was introduced in staging.

Document the validation errors while retaining NULL as a possible stored
value.

Fixes: 8feaf0ce1a04 ("staging: OMAP4+: thermal: introduce bandgap temperature sensor")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260912062252.42762-1-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/ti-soc-thermal/ti-bandgap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
index 507fe67eaffae..815ca0786c545 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -576,7 +576,8 @@ int ti_bandgap_set_sensor_data(struct ti_bandgap *bgp, int id, void *data)
  * @bgp: pointer to bandgap instance
  * @id: sensor id
  *
- * Return: data stored by set function with sensor id on success or NULL
+ * Return: the stored sensor data, which may be %NULL, or an ERR_PTR()
+ * if @bgp or @id is invalid.
  */
 void *ti_bandgap_get_sensor_data(struct ti_bandgap *bgp, int id)
 {
-- 
2.53.0



