Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A6028BAB3;
	Wed, 23 Apr 2025 15:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422572; cv=none; b=PDP0Ne6i0Z2/0hcaH3t9TeSlXALPM1Q8w6HbR13TkUnQE12fnpAmYz/A6jlO+gxpnWVgo9j7zwHRn0Ky8YDGCqqVQ/xVqRiNUu3W876Up6g9frXDlRhXxiH++Z1RyGaMDVU2+La/MUaleuk+rKswzf55y0A9khEZbuBHrre/Fy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422572; c=relaxed/simple;
	bh=tCNKIctYUwlpW/9EMJZcs3D0WhAI+bIhzuQJqPV58bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KVLwri10ZSC4f/OEJa3wKiydc60hqQiAiK+EEenC34fZV2tgMg27g3iM7XMSmG0z2rw9mG2gj3ot059F26xBjGBJq4H9KfUl4Gs4leMurvPhvLWOaFt+RNxqcwPEWxViTIoMtVTwWcSwiOT2HYl4NGjs7ZWH65VIr12BusvChhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XTQ3fTd8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XTQ3fTd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16928C4CEE2;
	Wed, 23 Apr 2025 15:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422572;
	bh=tCNKIctYUwlpW/9EMJZcs3D0WhAI+bIhzuQJqPV58bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTQ3fTd89E8nH7eYt/pqiInsq9D+AMnxQPKopReG40/3xsRxUUfGPEo8NIHwOPryC
	 p8mluEcrQu+OzIhrZxyvRPX0FZYF3XRLAs/MM+VCxgfiRTf5FNVOtXqCuvn/MDNqoa
	 bhBPoQjXOXHbQ0L9308EhsIelEiZrU9/1fdgiro4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Karolina Stolarek <karolina.stolarek@intel.com>
Subject: [PATCH 6.6 393/393] drm/tests: Build KMS helpers when DRM_KUNIT_TEST_HELPERS is enabled
Date: Wed, 23 Apr 2025 16:44:49 +0200
Message-ID: <20250423142659.548916252@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karolina Stolarek <karolina.stolarek@intel.com>

commit f1a785101d50f5844ed29341142e7224b87f705d upstream.

Commit 66671944e176 ("drm/tests: helpers: Add atomic helpers")
introduced a dependency on CRTC helpers in KUnit test helpers.
Select the former when building KUnit test helpers to avoid
linker errors.

Fixes: 66671944e176 ("drm/tests: helpers: Add atomic helpers")
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Karolina Stolarek <karolina.stolarek@intel.com>
Link: https://lore.kernel.org/r/20240313142142.1318718-1-karolina.stolarek@intel.com
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -69,6 +69,7 @@ config DRM_USE_DYNAMIC_DEBUG
 config DRM_KUNIT_TEST_HELPERS
 	tristate
 	depends on DRM && KUNIT
+	select DRM_KMS_HELPER
 	help
 	  KUnit Helpers for KMS drivers.
 
@@ -79,7 +80,6 @@ config DRM_KUNIT_TEST
 	select DRM_DISPLAY_DP_HELPER
 	select DRM_DISPLAY_HELPER
 	select DRM_LIB_RANDOM
-	select DRM_KMS_HELPER
 	select DRM_BUDDY
 	select DRM_EXPORT_FOR_TESTS if m
 	select DRM_KUNIT_TEST_HELPERS


