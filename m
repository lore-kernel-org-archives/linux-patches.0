Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D368613D896;
	Tue, 23 Jul 2024 18:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759545; cv=none; b=tEVABIGAQQ0cEwjaTJVeu7u30ogtxPDb93QI3Y7haKMaiBNn1b0wgJrL9B4YeVrQbAUu81g/dAuPAr7WOat051R4OX3MGSXGkw7LVmNIT8ljg5XcOkFk5VbcjcgDe1bxh2pac57/GRAlcYxgXNCgXxswytsI5cG+/bz4FBucnos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759545; c=relaxed/simple;
	bh=Ux4nYVHthkQfirnP4ey/fO8LVx9dRaJaQzaiWJrfOmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1KlM2+GgTXkv+YS+y5UznvadvpblBRVdE2QoQijMg7pNWzkLFQDPTWUPgvnYDmu4UX0QzrlPYKukKi4QPmJmoR8yiv/fDQZtXM8GnXVj/mDjHGYobrOU5QDC9lUQGG5rVbtCguBe8iLa9hR+QjPc0Cwt5HHVmntV7McJdzoddw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNzwbBuj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNzwbBuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51401C4AF0A;
	Tue, 23 Jul 2024 18:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759545;
	bh=Ux4nYVHthkQfirnP4ey/fO8LVx9dRaJaQzaiWJrfOmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNzwbBujE94982sAEh2X/KNjet6IpbmhbBdR3r9Vn81AJdPnq+XHmMMs/GUYv68J2
	 KKx6ktLQ8rs4KflzAfn7P7Z5Gocc4IadazOzjLZSPP1dF0prQLTs5wAWxYtlOdXgJL
	 emiU++wrw3trBI+blhSHIChjeH1goqucoPmZ0W2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/129] drm/exynos: dp: drop driver owner initialization
Date: Tue, 23 Jul 2024 20:23:14 +0200
Message-ID: <20240723180406.567840358@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 1f3512cdf8299f9edaea9046d53ea324a7730bab ]

Core in platform_driver_register() already sets the .owner, so driver
does not need to.  Whatever is set here will be anyway overwritten by
main driver calling platform_driver_register().

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_dp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_dp.c b/drivers/gpu/drm/exynos/exynos_dp.c
index 3404ec1367fb9..71ee824c4140b 100644
--- a/drivers/gpu/drm/exynos/exynos_dp.c
+++ b/drivers/gpu/drm/exynos/exynos_dp.c
@@ -288,7 +288,6 @@ struct platform_driver dp_driver = {
 	.remove		= exynos_dp_remove,
 	.driver		= {
 		.name	= "exynos-dp",
-		.owner	= THIS_MODULE,
 		.pm	= pm_ptr(&exynos_dp_pm_ops),
 		.of_match_table = exynos_dp_match,
 	},
-- 
2.43.0



