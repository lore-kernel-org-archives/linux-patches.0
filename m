Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082451A619E;
	Tue, 30 Jul 2024 16:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356796; cv=none; b=VdO6l7d4DH/EawNhluHShyK63qIOujP94fHdkzz5SwEfaG8kaBudz9ZoK3h6A9LSQJxA4BM3+rvcM36b8sitv3vOs3qCfRD97ELKbI7NKdt2bpQ0AqY8NSx5f1ctVUksQ3K3PfdcQDlLBwrGBvbppidISlvPSNDp6IlYYUIf+Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356796; c=relaxed/simple;
	bh=lhvQUzqZ5BzNqlh380b6sHnJF7RodgmnGE6NvQTKAb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UO+tC7GUEo1HWG1H8VnvvdXCeklBQBX4RE4DYtkMwU8O4RfVy/sV0VMtbudhBxa5Lpn+rjOwj7PlI4lV19lHJrIzxhalB/iZ9UUmqMWeX4sqkRDX3MqjU3i4yGv7uxxheJEfpFUFpfpnEEfUZeiH3MM9EQ8OJWtrNWiqVbzKLCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pHojuoxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pHojuoxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819AAC32782;
	Tue, 30 Jul 2024 16:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356795;
	bh=lhvQUzqZ5BzNqlh380b6sHnJF7RodgmnGE6NvQTKAb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pHojuoxA+DxvOwhhHNV1uhvbRf3b0lK6OIeRJPy18Hh5dEKvjZ90uKR4bB6xSmv3p
	 4dH/KjrmDi4rPNcGZhrwHZ08ALrpcZl9JrejJCJkVOT7Px1Vk2ihFnwKKc5+CvaodV
	 4TbppCYZHI67msUT23/9okYicLVqpE4MGLYU+HQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 185/568] drm/panel: boe-tv101wum-nl6: If prepare fails, disable GPIO before regulators
Date: Tue, 30 Jul 2024 17:44:52 +0200
Message-ID: <20240730151647.110076947@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 587c48f622374e5d47b1d515c6006a4df4dee882 ]

The enable GPIO should clearly be set low before turning off
regulators. That matches both the inverse order that things were
enabled and also the order in unprepare().

Fixes: a869b9db7adf ("drm/panel: support for boe tv101wum-nl6 wuxga dsi video mode panel")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20240517143643.2.Ieac346cd0f1606948ba39ceea06b55359fe972b6@changeid
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240517143643.2.Ieac346cd0f1606948ba39ceea06b55359fe972b6@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
index 7990c519a56b1..688efb2253a16 100644
--- a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
+++ b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
@@ -1868,13 +1868,13 @@ static int boe_panel_prepare(struct drm_panel *panel)
 	return 0;
 
 poweroff:
+	gpiod_set_value(boe->enable_gpio, 0);
 	regulator_disable(boe->avee);
 poweroffavdd:
 	regulator_disable(boe->avdd);
 poweroff1v8:
 	usleep_range(5000, 7000);
 	regulator_disable(boe->pp1800);
-	gpiod_set_value(boe->enable_gpio, 0);
 
 	return ret;
 }
-- 
2.43.0



