Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABC92D8396;
	Wed, 25 Feb 2026 06:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002688; cv=none; b=Z9sPYldgyMJi7V6NvbhYuQ/dIdTVgWvcbq4CIP9ZOESpyVHGhV1qQDD4VpOBYiILqSO2gzsA/x41U/olf9VKIdp4KWIF3+uRkJIWeTj9wTNxYN+kNu8igKc4iCSvihT0y2VfLRRKMo9QXvXsa2B8Hc5TPGVwD5gK0TAzGjYFp3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002688; c=relaxed/simple;
	bh=O51LVO7Ao123ElWKxPRKxJF69/lI5uqlghtmFUmZQtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szzA0TqkhwETpodvRrPD97qW/03CEAuHjzsMEGpruzrZYRFAcVALJ2k7ECs8jLr6NIuU0CjD5sFWWNa9fsPxlA/zfdsoJjVHKJFcJUJIMDQ3vEJjNE+vjaQUmCHLhYEkR9LbrmGt8Zx6bYe08Xbj2Rs0HelgR4/CjRuId5iTPxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7sGr6JP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7sGr6JP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53828C116D0;
	Wed, 25 Feb 2026 06:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002688;
	bh=O51LVO7Ao123ElWKxPRKxJF69/lI5uqlghtmFUmZQtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7sGr6JP8ojW0f8Blg5yT9dIA3ekfh/DHBmtuYWsHnWYiTd8j+JevKPwTSa3aOfaD
	 gfQcFTVu+JpxxlnV6fOLwL9r2kKaTtzTKFoLZNRB11LVVGLbFITm4cfoDzKUPR/o1z
	 DBnEVYAm/+7sFwYD9fbTuIjrMhmOnjZjQ+HOIymQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 481/641] nvmem: an8855: drop an unused Kconfig symbol
Date: Tue, 24 Feb 2026 17:23:27 -0800
Message-ID: <20260225012400.172906925@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 4796eaafd6a170db012395a40385d2baf4f4d118 ]

MFD_AIROHA_AN8855 is referenced here but never defined, so drop it
from the Kconfig file.

Fixes: e2258cfd9b98 ("nvmem: an8855: Add support for Airoha AN8855 Switch EFUSE")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260116170846.733558-4-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvmem/Kconfig b/drivers/nvmem/Kconfig
index e0d88d3199c11..11b098705ec62 100644
--- a/drivers/nvmem/Kconfig
+++ b/drivers/nvmem/Kconfig
@@ -30,7 +30,7 @@ source "drivers/nvmem/layouts/Kconfig"
 
 config NVMEM_AN8855_EFUSE
 	tristate "Airoha AN8855 eFuse support"
-	depends on MFD_AIROHA_AN8855 || COMPILE_TEST
+	depends on COMPILE_TEST
 	help
 	  Say y here to enable support for reading eFuses on Airoha AN8855
 	  Switch. These are e.g. used to store factory programmed
-- 
2.51.0



