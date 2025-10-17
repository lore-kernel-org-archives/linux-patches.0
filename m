Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F457330B29;
	Fri, 17 Oct 2025 15:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716101; cv=none; b=ZxBYCrpO2gp/weTklT2SOqfRjwPY4dhCbuQjoHMG42ULWKOTo1JVH9gWBSEVMya7px0f72hDy4xA7SqnlR3iDLcNZ/224Xo1pDWECkjoTwSjgr//hXDqSgfI4ysFBskq/uG8sBjM7lvVxu7jLBxNrC5eL91BUenFOzhEYm/I3QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716101; c=relaxed/simple;
	bh=mRL8vPyLg3Gx+GcuPbAXKjsiLkiYBEA8gyrGp4LGk7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHeTr0dFtOnisjXpBlsglHYft7/fsvyLf3E4VMyPryz5EtPe6iv5YM7yV3N4Fk/1SxLOySL9dSHHFmO5AOyh74zZShfSKo5mtUFHTizFYx9HIB4BVcX2y4EQGLyh7Wc29r3lAymDJo+crPclN1DJPj0duOFRFd/SbHin8rUR3Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oq1C+57G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oq1C+57G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D22C113D0;
	Fri, 17 Oct 2025 15:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716100;
	bh=mRL8vPyLg3Gx+GcuPbAXKjsiLkiYBEA8gyrGp4LGk7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oq1C+57G1F/lO7bT+/6Ax726DvlMPUCvegSf25mDEpyMfhgmLH/BhqkgG7Iboc6o1
	 qsX+eUX+uPwE3uw6O0UHqf/Vv+UDWU7M8CK5CPWm/YCLOs/rqPwD1lp3poP01PAi1t
	 9aM6DQ2fPGKUhQuE1LfJVChZTpUKubVd6cJ+nQUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/276] firmware: firmware: meson-sm: fix compile-test default
Date: Fri, 17 Oct 2025 16:52:13 +0200
Message-ID: <20251017145143.868493300@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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



