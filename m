Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359453735B
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 21:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA0FC433D2;
	Wed,  7 Jun 2023 21:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171807;
	bh=Yi3HRkWKEx0pw3Gf23P/WUj04QPLO9B60Jc+I9rnpsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bEH1s6Y6xQUMy2d7gDeuqRREO7+zVmIGcg48BoK8o2nMktNBAnQAJsp7DxFW4Q/3f
	 idzRW9YLDGsjrsiKDcwWA/toyJW1qHxHUMgbUZaaYZTQkeltzafM5emW6Pp+4vCIy2
	 FJcFvGp4uiED5w7O8nj6awGq7pZpnuJfS7hhyhRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.15 157/159] ARM: defconfig: drop CONFIG_DRM_RCAR_LVDS
Date: Wed,  7 Jun 2023 22:17:40 +0200
Message-ID: <20230607200908.794467368@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

commit 1441a15dd49616bd9dd4c25a018b0508cdada576 upstream.

This is now a hidden symbol, so just drop the defconfig line.

Fixes: 42d95d1b3a9c ("drm/rcar: stop using 'imply' for dependencies")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/configs/multi_v7_defconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -696,7 +696,6 @@ CONFIG_DRM_IMX_LDB=m
 CONFIG_DRM_IMX_HDMI=m
 CONFIG_DRM_ATMEL_HLCDC=m
 CONFIG_DRM_RCAR_DU=m
-CONFIG_DRM_RCAR_LVDS=y
 CONFIG_DRM_SUN4I=m
 CONFIG_DRM_MSM=m
 CONFIG_DRM_FSL_DCU=m


