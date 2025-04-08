Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F30C1B87CF;
	Tue,  8 Apr 2025 12:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115258; cv=none; b=kbJLk+vE0Ht0UYWNWwVm7RjCnwu72rsoZBxah1i7LejUU2pW+kePDg14Nj5fTyzQIO9EyzIQDZNPyv5NdsQfvJtR7/OoHKYlBpy0tJqk1rZ+tq6qyGOXCPl55+JA075lRNGew0KGmT9DqTJALn18yQk3fmtsqdj52fae2YQGS/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115258; c=relaxed/simple;
	bh=hOn5JnodkuscjfraVje2YmdAQT5D42Nh1u/8bXCjxWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFJmhdph1saWKB7oxxh9FN7EjX2UcAFFGGvTxIh1FutV6eEPqtYUHbje00vfC0llkuoFh3z09AtC4DHIeP9L8UMjkeYL9t3w7zjx0d7mz7nTgJo7TkhWiRHCtdVX6dQdsxAVYar5Zl1xMxudHF4rpRuCG6cCoC+/6wDdGCTD7mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xs4PUjgs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xs4PUjgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C0EC4CEE5;
	Tue,  8 Apr 2025 12:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115257;
	bh=hOn5JnodkuscjfraVje2YmdAQT5D42Nh1u/8bXCjxWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xs4PUjgs1ms1vCzI16kl4mMxsOkodb8Tycf7JfqeW2+BnBXDbO6QbUO/WPZGRrkKe
	 TxvwP8136/3KSSNSoYBMWbYR5EAns89XwNmI4QoHStPWkGIlTF1Pctb+Y8Q7KiDtQN
	 B9eQVdjDF4eUT6mCuPnDnpWPKWkUntseJQHYMd2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 407/499] drm/xe: Fix unmet direct dependencies warning
Date: Tue,  8 Apr 2025 12:50:19 +0200
Message-ID: <20250408104901.377317440@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yue Haibing <yuehaibing@huawei.com>

[ Upstream commit 5e66cf6edddb5f6237e3afb07475ace57ecb56bc ]

WARNING: unmet direct dependencies detected for FB_IOMEM_HELPERS
  Depends on [n]: HAS_IOMEM [=y] && FB_CORE [=n]
  Selected by [m]:
  - DRM_XE_DISPLAY [=y] && HAS_IOMEM [=y] && DRM [=m] && DRM_XE [=m] && DRM_XE [=m]=m [=m] && HAS_IOPORT [=y]

DRM_XE_DISPLAY requires FB_IOMEM_HELPERS, but the dependency FB_CORE is
missing, selecting FB_IOMEM_HELPERS if DRM_FBDEV_EMULATION is set as
other drm drivers.

Fixes: 44e694958b95 ("drm/xe/display: Implement display support")
Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250323114103.1960511-1-yuehaibing@huawei.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 689582882802cd64986c1eb584c9f5184d67f0cf)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/Kconfig b/drivers/gpu/drm/xe/Kconfig
index b51a2bde73e29..dcf6583a4c522 100644
--- a/drivers/gpu/drm/xe/Kconfig
+++ b/drivers/gpu/drm/xe/Kconfig
@@ -52,7 +52,7 @@ config DRM_XE
 config DRM_XE_DISPLAY
 	bool "Enable display support"
 	depends on DRM_XE && DRM_XE=m && HAS_IOPORT
-	select FB_IOMEM_HELPERS
+	select FB_IOMEM_HELPERS if DRM_FBDEV_EMULATION
 	select I2C
 	select I2C_ALGOBIT
 	default y
-- 
2.39.5



