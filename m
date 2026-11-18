Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016558;
	b=qNSFVym+WxduoXA7xIOmcC1xX9WaHw8OVZJ48ZKlUkiDVWgkktZQNHOWRACc4y/J6sVb
	 E6x2MmXOcQV1RoRIhG6mEnCdPwAo3xbTWHggqFdXZPtNa8I7Cevbn9D+IwCkKvjO+jb/V
	 fNB10/2in8NGY96mNT9VegEhh+lcUprx+JNnja4BJBIgIPKC6yJNYMYWGJxaDjeJXFGCt
	 4piIMvkv7qL9F+p2eqPhWz1IOCyPvgSi3mRidYlulyw99cgJGo9Yb+68pT12QaejcyOnc
	 TF3diBu4y0Wj7oMaQzhtV1Smevc3NetP5FotE9tPSgcj74zgiMB0e5LRkNEw0yWnptA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A9wuOkWraYE8ubY/XSDmNqVYJAaAMmrPK3FnzVNFQUA=;
	b=nkXPgtL93RIq7Lr7ZZqO2GSro+mySPxt5UZq7obyTgAR09y0x/eLAaQFWNFnX33hd1oW
	 pBdZrTp/RyyYOyzJ7zhpZL8kUvnVlQ72BiUyZOY8hqIvHk1PXrQeyKUWp/AYyk/j+MxZR
	 XOowQd1guv2XCyUNqpuBADOXM371XIXoJtxMb62npXBQ/7MKs6sYfqMOPJjL2r8uI5APo
	 pVNui/RUTgWGsmk4gcaGXT5GN0JcAcqhI/WWsBI8BWKtfge6K83P1d4jG9sPjMr8Y/e2a
	 KPVLHKce9o6d8hIbvDZfweLYBOIbkwkECU60k1AIsj0hRI7TlOfazzyIqOYjcDp2TnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kPi7G54d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13D9606A330;
	Wed, 18 Nov 2026 15:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kPi7G54d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B32B1F000C4;
	Wed, 18 Nov 2026 15:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016558;
	bh=A9wuOkWraYE8ubY/XSDmNqVYJAaAMmrPK3FnzVNFQUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kPi7G54dnOoldSUV5Xm+6z40pn1UoPyeo4LbzxumyTku3RUIw9gHy6hRP5zn1BaKW
	 dP70LQ3qObAzR6xSTJIwwb8DDSmp2t2sDn++DqsvYVvixVBvvUiqavvGmnoy0hLWZB
	 msrG2I3JEIe4AFeVst0Bm39BMg+HKKOTzf2MPPlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0572/2651] interconnect: exynos: Remove the PM QoS request on unbind
Date: Wed, 18 Nov 2026 15:30:12 +0100
Message-ID: <20261118150308.326389049@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 601a54f00723b0b653d76caf26a2a78482d95f00 ]

The Exynos interconnect provider adds a minimum-frequency PM QoS request
to its parent devfreq device. The request is embedded in the provider's
device-managed private data.

The probe error path removes the request, but the remove callback does
not. Unbinding the provider while the parent device remains registered
therefore frees the private data with the request still on the parent's
QoS list. The child's device cleanup does not remove requests registered
against its parent.

Remove the request after deregistering the provider, before the private
data is released.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 2f95b9d5cf0b ("interconnect: Add generic interconnect driver for Exynos SoCs")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260911031750.8182-1-mhun512@gmail.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/samsung/exynos.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/samsung/exynos.c b/drivers/interconnect/samsung/exynos.c
index 8e8f56186a366..9a4789fadac2e 100644
--- a/drivers/interconnect/samsung/exynos.c
+++ b/drivers/interconnect/samsung/exynos.c
@@ -98,6 +98,7 @@ static void exynos_generic_icc_remove(struct platform_device *pdev)
 	struct exynos_icc_priv *priv = platform_get_drvdata(pdev);
 
 	icc_provider_deregister(&priv->provider);
+	dev_pm_qos_remove_request(&priv->qos_req);
 	icc_nodes_remove(&priv->provider);
 }
 
-- 
2.53.0



