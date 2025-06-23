Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF59A24679C;
	Mon, 23 Jun 2025 13:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685536; cv=none; b=OmAp5RCRJFqourNtN3Y8zc7pizvHggcNK9NfXhZDA9wVYNF99V1tTzkYfZlzp4GV4XTadI3rQXQcAtjep5nDnFvFqPOdYQdMnk+O39TOm67JiNKR26F1c1StmaP8+H8zA6JKciPsQ2kuucLgV5jlWHUQ4XQ1wKUzBSJV9Fz4124=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685536; c=relaxed/simple;
	bh=Nlnx6uZRQvfT8EstEWKHI04g+smHBjdZB2hlXaBKJDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uobw63piBdlDfUdN83LKhIsEKt2zLJxQ8m2iDiOhbIK+KWOY/+Coy0fJLCxUfdazUviaLqMKqORTx832F0m6JwHVhijcR7D1Xyhsb2kmeHOas7emUJ9SzHvgKN7kY925QlVuiM4eOz32pNeh+fSJhxUo5d8KxNYIOrlF7MTPd+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OAJ+eto+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OAJ+eto+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D6BC4CEEA;
	Mon, 23 Jun 2025 13:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685536;
	bh=Nlnx6uZRQvfT8EstEWKHI04g+smHBjdZB2hlXaBKJDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OAJ+eto+mFHZAc0qRh63WilGk5xP6fdEEXo3//XVJJ6uRCIGye1+KqCU6Zq4g7pD3
	 07tGvfM0qWECJBFWDoCTdRmvYZVglYVYfWqYHP2ioFBKJZVGSLAwxwONRh1pjTS5f9
	 YRspPPiAcuG3VgdOZeUb+HrxlVqTDzILmpipZWHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 235/592] drm/bridge: select DRM_KMS_HELPER for AUX_BRIDGE
Date: Mon, 23 Jun 2025 15:03:13 +0200
Message-ID: <20250623130705.879802284@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit b12fa5e76e1463fc5a196f2717040e4564e184b6 ]

The aux bridge uses devm_drm_of_get_bridge() from the panel bridge (and
correctly selects DRM_PANEL_BRIDGE). However panel bridge is not a
separate module, it is compiled into the drm_kms_helper.o. Select
DRM_KMS_HELPER too to express this dependency.

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250411-aux-select-kms-v1-1-c4276f905a56@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index 09a1be234f717..b9e0ca85226a6 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -16,6 +16,7 @@ config DRM_AUX_BRIDGE
 	tristate
 	depends on DRM_BRIDGE && OF
 	select AUXILIARY_BUS
+	select DRM_KMS_HELPER
 	select DRM_PANEL_BRIDGE
 	help
 	  Simple transparent bridge that is used by several non-DRM drivers to
-- 
2.39.5



