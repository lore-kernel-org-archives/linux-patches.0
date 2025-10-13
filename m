Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AD02741DF;
	Mon, 13 Oct 2025 14:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367046; cv=none; b=LjD8B/f/YoWbcYfoBtdyZTO1j+hmWR5ettlZQx51c6tFGzzPumVAIZcSWj6+oYFawOpeCmLLf3JsYQ/pkuvgHx6alErOutRdFA2KFHtQgwMmxFbQBFXJjt8mAaRyliviCcBfLnxNiU9AxOVaztNAi3neU2u23EILVjk5hxTNoHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367046; c=relaxed/simple;
	bh=Nx01DCgUKZCK4JIuudxbrRHQotOegdsllWKtX3xHTgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pbf7LbdjLt45u8Bk4jY45iGfHTAFvVC4NI+qoLGIr5JXW1sx53jbZFXBqx70fpnEYv2oHetbMNlAj6bqq2sw5TYSmapB2IU9rAgi3KXVKO2ooywG7k7WjBm7Hwpi25j4VZ1IcC899A9CiyeYedVQGutLnwjZhYQJBZDOoX/pVVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3clDanA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3clDanA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E61C4CEE7;
	Mon, 13 Oct 2025 14:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367046;
	bh=Nx01DCgUKZCK4JIuudxbrRHQotOegdsllWKtX3xHTgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3clDanA3nNPGcG9DDCQ8nZbpsta6J1v7JA+zdhOF2r2A9JRJN4SAVwTKwrxUAux+
	 5HBENkYEil89PiKjJ6jFAOtS7y7WZvu0e2uYpertYp2zmVGR20lKG8MZ2gnD6UGKfG
	 USmVGpN1KEWwrQYuRr/3mAq9+5sYt6XV12yWF3/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/196] firmware: firmware: meson-sm: fix compile-test default
Date: Mon, 13 Oct 2025 16:44:06 +0200
Message-ID: <20251013144317.218042137@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



