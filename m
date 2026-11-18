Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048364;
	b=IxIdzO6lSfG0t3kBV4qa8Gwzp/952lvERUols0NwGKkQ918k2QwB7Jw6lwL/LipPKSJO
	 5F2dNrtc4RQOLbHfcfHYvR/3UlYmTaGr6398bKTHtFFezJb3+apbLs95HcsWHCozo+QWj
	 pcYoNDg2jLuvW5cUfb2RKRQpzZqiXKe1n9qcLTkay5TlvVuBaFdkVq57BMJCz5IKD7zE0
	 p8JrqTFjwizDqTIWxJIgAlk7eKKofxGM1iIDKFsKGOAW892IMMyqTiQebdVC8WEXVGVZz
	 stT5bFuSeCVn2ztVVLz0NW6ehQNE7sd6IuvzeIq6rUKcc702bz9v7oX4A0w+9YXBb2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qA++J3BICeTwYUdkY+40Eg0hss+7LafOdc4e6TmABP8=;
	b=pPfDepX3cODZzd0OU+PibeI5GBsNvz3slGMnJ2cdFJ1HfBG2HylJIEEkTeaX3aBYGhY9
	 tSvXRQk8VsTeLYvwrBMojl6phLRg11rHTbaTHMzXDMGJMMaj8MlBYQqNhWutKRJIgSGQ1
	 Q1jcv/ZfHMAQDqsjV/9hjjO7byV/OTw/GS5wE1a++Td9iX23a78HdSKQLWwbWxBhgK4qs
	 F4kDggWCXRQ+3fqTpxoQkfh56M9VZUlg1JADBooAKleL02X8ytaq1wYy55iJQX9cEZX5O
	 lF+MnW2YaIfAb9gcVVEpwyAmbWK2YC5oI4F1D1iP/3TmfiZHIswKSS8svsuHhGL5RGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lu63f89f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46DD606A320;
	Thu, 19 Nov 2026 00:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lu63f89f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C561F000C4;
	Thu, 19 Nov 2026 00:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048364;
	bh=qA++J3BICeTwYUdkY+40Eg0hss+7LafOdc4e6TmABP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lu63f89f5w6vYW5abhOcHrqSpeJ50eTaZtsQJ6HsKUEEhopC8S8SN3aVSt69kpkBX
	 kOuaHo6EdE/AhRIBUm1JSa4dni5kujec+2KiMorOWWmKMwf19gfoOhXD6zFG084Hns
	 9QgP7VatyqQ5gYWhiEySn7egIHT+ehzXNQGUKw6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1968/2857] interconnect: exynos: drop redundant link destroy
Date: Wed, 18 Nov 2026 15:50:02 +0100
Message-ID: <20261118150312.262786572@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 859ad5f177efa59f6b8a2fac20561ca5cb13c89f ]

There is no longer any need to explicitly destroy node links as this is
now done when the node is destroyed as part of icc_nodes_remove().

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230306075651.2449-17-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Stable-dep-of: 601a54f00723 ("interconnect: exynos: Remove the PM QoS request on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/samsung/exynos.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/interconnect/samsung/exynos.c b/drivers/interconnect/samsung/exynos.c
index 72e42603823b9..ebf09bbf725bd 100644
--- a/drivers/interconnect/samsung/exynos.c
+++ b/drivers/interconnect/samsung/exynos.c
@@ -96,14 +96,8 @@ static struct icc_node *exynos_generic_icc_xlate(struct of_phandle_args *spec,
 static int exynos_generic_icc_remove(struct platform_device *pdev)
 {
 	struct exynos_icc_priv *priv = platform_get_drvdata(pdev);
-	struct icc_node *parent_node, *node = priv->node;
 
 	icc_provider_deregister(&priv->provider);
-
-	parent_node = exynos_icc_get_parent(priv->dev->parent->of_node);
-	if (parent_node && !IS_ERR(parent_node))
-		icc_link_destroy(node, parent_node);
-
 	icc_nodes_remove(&priv->provider);
 
 	return 0;
-- 
2.53.0



