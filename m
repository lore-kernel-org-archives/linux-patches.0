Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CF0223DD6;
	Tue, 30 Sep 2025 15:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245197; cv=none; b=o5qJJwYDI2q7iUAeQ9QVrYRP05Gvvn+reokBwPL8xYXOE+EJqrfRpK5boXkx6P5dKHDZ6fHxnqk9Qr+k+8ZJf6nDUJiFpC8eP0nLg93b64uVb182wewL1pz1qwP2TbkUiErb0oTxhliqyc8Yxqpmb8DGxKvmT85G4CdFbzcU1c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245197; c=relaxed/simple;
	bh=zoty6v551NW4OImh+Qv75Pu9lPJJUJyT/Ho62B91glg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4FEuTRLVfPnl5tN34AQjwXj1ZtJesiqe3IaRWT9TK0KuM+WVqgt1gsQSMLFrKZCmrItwhcPMd7YqgxtEB6QxAnNkrvXMDiZzfhOXHIl9uhhk9qAfs3tG2AWyJydWa7EJdeo2r6h7VL3pSQEilo7ztchAoTxqf7F3/LU84q0HZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RT/O7qEy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RT/O7qEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FCFC4CEF0;
	Tue, 30 Sep 2025 15:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245195;
	bh=zoty6v551NW4OImh+Qv75Pu9lPJJUJyT/Ho62B91glg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RT/O7qEyj8+T7UGphzLZryXXZlBC8NKRXpNaak6IKupXR+FQDOeSgs/wMOja94mj5
	 yfU9DKSClyscx4x/6Jnmm3tQcJKQmwJlj3C4zv9eUbGCsDpu+4aB0Bkq8ZmsqL8mQ8
	 75Q1icJqiP+/cQZzJ4O24aCXPTMt/3neir6pXAxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/151] phy: broadcom: ns-usb3: fix Wvoid-pointer-to-enum-cast warning
Date: Tue, 30 Sep 2025 16:47:05 +0200
Message-ID: <20250930143831.379909315@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit bd6e74a2f0a0c76dda8e44d26f9b91a797586c3b ]

'family' is an enum, thus cast of pointer on 64-bit compile test with
W=1 causes:

  drivers/phy/broadcom/phy-bcm-ns-usb3.c:209:17: error: cast to smaller integer type 'enum bcm_ns_family' from 'const void *' [-Werror,-Wvoid-pointer-to-enum-cast]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230810111958.205705-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 64961557efa1 ("phy: ti: omap-usb2: fix device leak at unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/broadcom/phy-bcm-ns-usb3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/broadcom/phy-bcm-ns-usb3.c
+++ b/drivers/phy/broadcom/phy-bcm-ns-usb3.c
@@ -206,7 +206,7 @@ static int bcm_ns_usb3_mdio_probe(struct
 	of_id = of_match_device(bcm_ns_usb3_id_table, dev);
 	if (!of_id)
 		return -EINVAL;
-	usb3->family = (enum bcm_ns_family)of_id->data;
+	usb3->family = (uintptr_t)of_id->data;
 
 	syscon_np = of_parse_phandle(dev->of_node, "usb3-dmp-syscon", 0);
 	err = of_address_to_resource(syscon_np, 0, &res);


