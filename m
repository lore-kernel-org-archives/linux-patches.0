Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9EC1581F4;
	Tue, 23 Jul 2024 18:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759968; cv=none; b=CvyYihOLOu8WNxpYzkB3R9s364X1XoguAl8+D6czvOTyInysf+w235D77qtKGLQgvL86SqCGRjAxS5J+HX2JBxa49QMhpc1CSbffydXRX5LGbNqkGdCem6IMONHPeYIHuFhqSLmPEoRGfux0HjALVZ6lOfsACjrNQhLtkdL5I88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759968; c=relaxed/simple;
	bh=C9MfPwGaFsn8T1lWUqC3cnKpd9Kk3T3/MmPnifMJnM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3w9Kik/lgIGUV8iXUQwSQAIKFsObCN43SXHAOiH2fAIE6Pcrw67SKU/wgs4Miv7MfcRooCCn9M25wiG7CAvFQqxL+c9ZmXUUBELOrqb/brCAD+kjl+41o+hgD0jDBX+VVuq5bVEckPe4tdwbx0ICN9UOSqfBqoAbYXuGTAZfDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9m8Z+6M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9m8Z+6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3F1C4AF0A;
	Tue, 23 Jul 2024 18:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759968;
	bh=C9MfPwGaFsn8T1lWUqC3cnKpd9Kk3T3/MmPnifMJnM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l9m8Z+6MPDo9DnnsP2kFE7bPpaf3hlrY0S77wuZrut3yJnLaa8bha75rG4s5JCcAG
	 x8U9uBZNFZCbJVZLdOq5NOkI8wcSxi4D24URI0z3XDWT+VAY+q9jBDroU83XY/Ho4o
	 dRkX86FZhy3aYOhDcH26UI7UZvRh74SyIINIvAfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 058/163] drm/exynos: dp: drop driver owner initialization
Date: Tue, 23 Jul 2024 20:23:07 +0200
Message-ID: <20240723180145.716171367@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index f48c4343f4690..3e6d4c6aa877e 100644
--- a/drivers/gpu/drm/exynos/exynos_dp.c
+++ b/drivers/gpu/drm/exynos/exynos_dp.c
@@ -285,7 +285,6 @@ struct platform_driver dp_driver = {
 	.remove_new	= exynos_dp_remove,
 	.driver		= {
 		.name	= "exynos-dp",
-		.owner	= THIS_MODULE,
 		.pm	= pm_ptr(&exynos_dp_pm_ops),
 		.of_match_table = exynos_dp_match,
 	},
-- 
2.43.0



