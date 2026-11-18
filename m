Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023980;
	b=OiVOZr56poQOAZeM81sLWdPL2zyL0RjtKeEWikkT9QdSHaclFdVHp/IdJRIXtD50XXJA
	 DtyHyRXUBBOR9GpUWjw/c/gxuT31QLUfCkkpdMY7WtH9wQMGgXDCbjrWoTwuYUTMTRXzn
	 dh+3BKC+UHXmuf/DFBBw+HxQCyhROWFhVHwdQh2JoF4akqaRPaj9wp3NiFjDjSBGzJr38
	 0xyyNTfYKOZq6XMrj8/XyKt76JpywPFr8QPPYtlTLJbVKLtuZeSGodqXr0bJ0iNmR8QDc
	 Glm3Zm9D/hXUqAFRdoEIPmSktMwi+O42HO+70xiTp7f/sWkV/dRI1i6qw7LEI4uMwbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ecmZJgedudFjPafXQ56q/Iq+H1Xxjv0MqisjG1t5Qlo=;
	b=q7+ju4LEGyyVf7KNoaW7mZqqw47XdxyJ5zff178VQs3ks0Ou6BXu9nWbpzKraTNp0ZJ4
	 nmOSKAiTvZ3ciwob8eZB2Q+4jXDT2DZca8RrZREnUocQFrle3Xpn1Ms3n3hyHDDM23Lyb
	 19134uGtc/6SugyIs0588zp0JN/l0YVUZKqlZR2GEA3OGJcHLxaYxYqtPZUywiHbqjkKE
	 YYC96hRxDWegn69JfggjNnFhWrHmN4/1fc/fFDe3Bfgt5ygMaxEG2Beiqzn8h1ijjU5oG
	 l13SABoXwly40+AnhEnvqa1Kmf77ghCu8FqVrV6fnjv7tH+qj2YZ4gA8wGvwl1AFc6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qFuVKn4x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645E1606A32A;
	Wed, 18 Nov 2026 17:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qFuVKn4x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C951F000C5;
	Wed, 18 Nov 2026 17:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023980;
	bh=ecmZJgedudFjPafXQ56q/Iq+H1Xxjv0MqisjG1t5Qlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qFuVKn4xGY8opYUvxFczAnxzWYrRJ9wTv3JStWMMBsrtDXD4Mx3VbZn3SoM1IPbUl
	 rG6Ml2TPADmuHr5T1CgO61YTamP8XB/ldM7IAPQ2Rn4WltG4rsRb4Rdws0jfD7jSGI
	 iXkqC4ixiLIQjA2TihR7l+FpC5BOUtKJDZZtT42k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0521/2151] interconnect: exynos: Remove the PM QoS request on unbind
Date: Wed, 18 Nov 2026 15:37:36 +0100
Message-ID: <20261118150141.023157072@linuxfoundation.org>
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



