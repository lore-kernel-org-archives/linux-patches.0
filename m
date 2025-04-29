Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5240524113C;
	Tue, 29 Apr 2025 17:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947239; cv=none; b=FUK/9AQVLH8pne5g9HDX62c2gdultei7WyDrmphBiEruDFPweOjrPzftOw+K1wakx1HaNz0GY666/PArySoErUazBTkz5sX+8zgf/hWPEPLzqczVXKZDLAIRVLBkXuI6VzXZ3+AmVe/T+4TmBswZXAVBrtHQMOPEqdPBpwG+/1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947239; c=relaxed/simple;
	bh=GuhuKodNICHJfXiPjbq1adYIKgwmaCu3z0QX/yHggjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fn3sKxrzJE+jxfZnSNb2eFew5OdEzO8JPenN5YlWQldnKUtHSAjgmhvj0RM2NHoPLrrQqbVfLMTbe4rSPX2nZjl2U1yRBtnYaWHqx6wo/lj1a/mAK1g/lFNDNN/7ki5a+z0Rb6xPaaj0hP/06VXi3U5QTP4vWaWCSMHZRHbl4Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vzDUES4o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzDUES4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B82C4CEE3;
	Tue, 29 Apr 2025 17:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947239;
	bh=GuhuKodNICHJfXiPjbq1adYIKgwmaCu3z0QX/yHggjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vzDUES4oKbcMG8RUKlnw1z5359p60exiRKlTJnuD2DCcUp0dIVAt8rC0IMaOUODvf
	 0oFGWffJ9x/fWt8kjDleKyutuAVVAPkPQrF4CnNablhADjljL+rwraUqZrIV65WguX
	 MMFD4B9Fd7gK7XUx58E6XV32e1PJbH4iE6+nmIKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 216/286] soc: samsung: exynos-chipid: Add NULL pointer check in exynos_chipid_probe()
Date: Tue, 29 Apr 2025 18:42:00 +0200
Message-ID: <20250429161116.832819383@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a2d163a1b4e11..fb9e80b63b917 100644
--- a/drivers/soc/samsung/exynos-chipid.c
+++ b/drivers/soc/samsung/exynos-chipid.c
@@ -124,6 +124,8 @@ static int exynos_chipid_probe(struct platform_device *pdev)
 
 	soc_dev_attr->revision = devm_kasprintf(&pdev->dev, GFP_KERNEL,
 						"%x", soc_info.revision);
+	if (!soc_dev_attr->revision)
+		return -ENOMEM;
 	soc_dev_attr->soc_id = product_id_to_soc_id(soc_info.product_id);
 	if (!soc_dev_attr->soc_id) {
 		pr_err("Unknown SoC\n");
-- 
2.39.5



