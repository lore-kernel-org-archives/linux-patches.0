Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA693093C9;
	Mon, 13 Oct 2025 15:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368133; cv=none; b=K4kGwAQp2AVQg+8mCBVq8Y7LDsFDIzDEyQnieykttGP0IpztLJks071Zpadc7O9Dp+XEZMBp7xhJnlt84VbqEiYHT+ilKGZhXJLC3cSwAno6mtSYHixyKzT5TlsUHv8eK+o9BFkTRrYBaym/maLfhT25xuNRbXS79K6d4BqYnzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368133; c=relaxed/simple;
	bh=XcnLqL92Z40LC1u1L4BPcZS9nc8H4jm3mpm8H3OEOJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VnD2UWXogsikmFre8P52n2QxdrvCwnJBWJMPQsjRxaB3KZjo8nXckyxdQ9PXkJP1NjzX2UbZgM90bqTmsE6yobtHz2GhLK+QmdyZmzXOJ7Oq98k6gzu5saVOnSgIMQeTx7KW2B6QUwymDH9YDoCT/rQujOrabv+6F8Q5GDLRjww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ha8qGzIu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ha8qGzIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50E3C4CEE7;
	Mon, 13 Oct 2025 15:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368133;
	bh=XcnLqL92Z40LC1u1L4BPcZS9nc8H4jm3mpm8H3OEOJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ha8qGzIu4Eu1D8LlZ/tx/OiV/Vfdu227cAzVObljooh6KWi9YEr5Haj16DQ676FqY
	 D4XskqTOmF+n9g15UqQIBdo5pU3EkOxQVdGbyja6h6ijTV2vxHRuCxJCTFdolPctV/
	 3ypDvP7nyuqFnQE4uz5WAanh/qp90lBf7B8jx5pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/262] firmware: firmware: meson-sm: fix compile-test default
Date: Mon, 13 Oct 2025 16:43:17 +0200
Message-ID: <20251013144328.110353116@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 0454346d1c5f7fccb3ef6e3103985de8ab3469f3 ]

Enabling compile testing should not enable every individual driver (we
have "allyesconfig" for that).

Fixes: 4a434abc40d2 ("firmware: meson-sm: enable build as module")
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20250725075429.10056-1-johan@kernel.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/meson/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/meson/Kconfig b/drivers/firmware/meson/Kconfig
index f2fdd37566482..179f5d46d8ddf 100644
--- a/drivers/firmware/meson/Kconfig
+++ b/drivers/firmware/meson/Kconfig
@@ -5,7 +5,7 @@
 config MESON_SM
 	tristate "Amlogic Secure Monitor driver"
 	depends on ARCH_MESON || COMPILE_TEST
-	default y
+	default ARCH_MESON
 	depends on ARM64_4K_PAGES
 	help
 	  Say y here to enable the Amlogic secure monitor driver
-- 
2.51.0



