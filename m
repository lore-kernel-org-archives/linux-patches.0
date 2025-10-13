Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E433093C3;
	Mon, 13 Oct 2025 14:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367517; cv=none; b=WPml+NpxV+RIXrVgVRCLXODqLH3zr1gJxY0lwXAPGtGm0C8EN4VTNA51/LwdPSf6OJjUNuhhdBJtXLC2ZngS/yVJzzIuU9QnbL2SV2Llq2i//UvaAIo4LVFq2h25ymQtupcMsS2HtXzq+qWEfB2oSTLgnbrhTsZv101ezu6Sh1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367517; c=relaxed/simple;
	bh=J1kci3dy8oEoEKHm8wWXgu0kxfMDFkrO2/M2kUPpbOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ez4qEyqF/x74QzGSbwKa9Y+Ule9KjntbsAh3gOq8QStZeaUB0JVK9nY+jfFLA25nlrcvsO0VEeAIouhxLfbkBnSHed1JDEyeaI/qosWaa5gAl17DRs1reIamCkGGtxnYIneQkKqUYhX4ByevGuXT305gpeFU5r7qGNneUX1o7/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJMzKYZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJMzKYZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A09C4CEE7;
	Mon, 13 Oct 2025 14:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367517;
	bh=J1kci3dy8oEoEKHm8wWXgu0kxfMDFkrO2/M2kUPpbOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VJMzKYZgiqk662154F2gLr/uJMe5P0xgnZTK/r6337f+rO8aXyEnrCefoHAg3jqxs
	 S76sGScHRAHJEFXHiaGUZhfEQhLs9vx2w0KRblg7UlkdCVBwoTdc/ataJxCmny0xRw
	 gZxYaHIjHD4j/5KVuJJL40FF18uGsvLAqyYO5nes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/196] firmware: firmware: meson-sm: fix compile-test default
Date: Mon, 13 Oct 2025 16:43:51 +0200
Message-ID: <20251013144316.652131670@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



