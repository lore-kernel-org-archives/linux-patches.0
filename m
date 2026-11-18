Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031795;
	b=Up7/6bBkIYqPH6CxxoxbxiZuXzgl3yP29tzDq4ZCXcqhfQI31GRZO2lHaAVOSJ0Xr26K
	 D5j1IvumgPO3AlfqkbA93R2v6PoTFBdx/XPIFfzDqBCON2V3SRyYTfBBH3izAOKn255nA
	 v0MtDv3+RwQAwhNFToSBCcxwlNHJihYpVSpPeqOJEYiY4MT3/0M4gQuI0l/DKxAlcACHn
	 8jtkjuzLTr1pKGOVQ/BDrkM+D4qpINtrKCZhDddQRLlJqeg1HkjOaF0nyjk/wag+WxZ2n
	 A2QEoalxGCMB9mjt+VB3gOlbVV07E4pMLkvZr9fjpcBVkIRWxMxm8v0Wxk+8uY2tqyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031795;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4b+XT/UDqm63T16uUnziC2F0wyo6ok5KIjsmk3e8p/U=;
	b=2bF7YX1ERoZS5o7fKcw4NKAuiyLsB8j4MqY172UxZFlxlZDhwmlSgfVT3ycmGYeyDNP6
	 XELGIPf5Su1RHb2Q8265lbzmmbCIm+MfNV2vW20A7FKFfyIGzo9Jj3vOeAH5pZM5rLhXi
	 jI4Y+IneNMIdBwX2Nh2Hl1qIgzOpPtM3B6Bzzx5R6SgyCBlLbBpf3DPjbUDWYoVljs/aV
	 G6b1KX4J7bpU7PIw8r6LQUBf0RfxafSINJyqUNqHWuQva8kLYU3lQdcRHkUAgCDUDIzXJ
	 Kv+XyU/GEMRC1P4dxLE1t32wt1O6Wj3QzT4HspBwHqfl+CDaMtaxxGtvNtRjxjkcAKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=auLUs4Mx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FD3606A31C;
	Wed, 18 Nov 2026 19:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=auLUs4Mx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2321F000C5;
	Wed, 18 Nov 2026 19:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031794;
	bh=4b+XT/UDqm63T16uUnziC2F0wyo6ok5KIjsmk3e8p/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=auLUs4MxMVBuBNxFCK+NcE5GabPRAuBpv3/HjxuCnTVkixyz2HNDsWC3Q8Uf/foQ7
	 MvySYAnFyDr82QwAhbcjSlqGeEwltljBab9iDRl4jvhEP2fCclW3FkNB+WlaU+p4y9
	 1YdchH1VIlcjJipQT6ggIaFnEgghtyh0fjzg3rB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1183/1756] thermal: ti-soc-thermal: Fix the return value in ti_bandgap_get_sensor_data() kernel-doc
Date: Wed, 18 Nov 2026 15:55:10 +0100
Message-ID: <20261118150057.004973570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index d722b5733336e..5054e1d259d66 100644
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



