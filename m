Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA54A250C0C;
	Tue, 29 Apr 2025 17:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949268; cv=none; b=B+iKtBoFwB9fG/BocpEg11CeTnp5r87BfbuZIqb3YlE9xTft4LEfLPxgSsJ7aD9f/JIO74yHEWbkr/NNF35W/UbwN5UUMF0afUryElCTc6uU9XbHgIQfVUzrGUUvXFZLYZIcg57f3NYvOxdtKglifXPqQyLRDSUzs9wLQTaex3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949268; c=relaxed/simple;
	bh=GCh565sKjbgCJoRzzrGsZWJPa8d2yEgptN5iBAbgp4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCrAzB46fcKkqg0YgpvADZ3aFwRv7xO7jMsIOzExAtAdOFZX+dUq8ODov+3Lo1KaCLUv5SfQrfr+02f+BBJNSwhjXi6DDCKTcH3Q3eukt3d+0shy3iBL8F1uQdPS+CLw9f1l7Tg/i+L9b9QOhaOcRhGfZvQYZIL4H4pNQOD2m9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6WseMqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6WseMqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A823C4CEE9;
	Tue, 29 Apr 2025 17:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949268;
	bh=GCh565sKjbgCJoRzzrGsZWJPa8d2yEgptN5iBAbgp4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l6WseMqyziIs9pBkF9MHGP+LaR3cKpOlGOGXJgn8a2t+42PX+5Quh9d+ovab/iV0U
	 B3uh069aWT7auFha50H+L4IkxPazDLoZ3z/tmsXiWfsZ1LyI/gjeo3bEKQtHMzu+Ct
	 hrPNu6x4qf7bnv2UUVYoibICJPDutbLXIyS/TVoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 265/373] soc: samsung: exynos-chipid: Add NULL pointer check in exynos_chipid_probe()
Date: Tue, 29 Apr 2025 18:42:22 +0200
Message-ID: <20250429161134.020576890@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit c8222ef6cf29dd7cad21643228f96535cc02b327 ]

soc_dev_attr->revision could be NULL, thus,
a pointer check is added to prevent potential NULL pointer dereference.
This is similar to the fix in commit 3027e7b15b02
("ice: Fix some null pointer dereference issues in ice_ptp.c").

This issue is found by our static analysis tool.

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Link: https://lore.kernel.org/r/20250212213518.69432-1-chenyuan0y@gmail.com
Fixes: 3253b7b7cd44 ("soc: samsung: Add exynos chipid driver support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/samsung/exynos-chipid.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soc/samsung/exynos-chipid.c b/drivers/soc/samsung/exynos-chipid.c
index 133654f21251f..edcae687cd2a2 100644
--- a/drivers/soc/samsung/exynos-chipid.c
+++ b/drivers/soc/samsung/exynos-chipid.c
@@ -125,6 +125,8 @@ static int exynos_chipid_probe(struct platform_device *pdev)
 
 	soc_dev_attr->revision = devm_kasprintf(&pdev->dev, GFP_KERNEL,
 						"%x", soc_info.revision);
+	if (!soc_dev_attr->revision)
+		return -ENOMEM;
 	soc_dev_attr->soc_id = product_id_to_soc_id(soc_info.product_id);
 	if (!soc_dev_attr->soc_id) {
 		pr_err("Unknown SoC\n");
-- 
2.39.5



