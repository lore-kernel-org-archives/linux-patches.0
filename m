Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB5F215076;
	Wed, 19 Mar 2025 14:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395064; cv=none; b=kJaN7jf0sC9PdeptOs81nVdQ6D1YDrRR7PDiEu99xUQkatb6UsJ1wj5MVxBf5EjsLg+lPtf5AQ9SglgNcSLVy12I4AMg2rlV+/eJJLNJQ622sBThMe/ZUuyk0O+lc1pXj+8mZA2PB3LNIz/oYMBxjS651T7TM0nA8MjYwsBAzjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395064; c=relaxed/simple;
	bh=0Sw1VnzyLiE14Ad6XA4jPs1DcObPR9AZtkTbW6Vp1EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcZlnOxZH9SdpsWrkkOhlVfg9OjQbI8GIzSzHyDIWJcHrZ+Od6mZkI0oEtfv8sbNWUgFXwBFt0cWxvInQGSIOQWJvw2Y6AOcIoAQEC7Dfp7cUDEcnN1GjdqSWN+rpPJc4DvwyfsSWUh/Ea2ZhsKHXfaL/w2Ns2ZgAxbVAZyV0ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GKhaB8xB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GKhaB8xB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0940C4CEE4;
	Wed, 19 Mar 2025 14:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395064;
	bh=0Sw1VnzyLiE14Ad6XA4jPs1DcObPR9AZtkTbW6Vp1EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GKhaB8xBlQSbFHTaar/G6Z5YzehPuawa38gO0ikhkZ7P8cRlpgtVxfvfPmjqx3Ylr
	 UrMwr7o0BAVfBR11iNk5ZxKUaSfMzZ8mxlU1x0ISk9tWKGVxOdw4M8m99aopTp94om
	 kn4esMhXm6okVjjcNDz7wmLpGCtCUUZemVDLkSuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/231] drm/tests: hdmi: Remove redundant assignments
Date: Wed, 19 Mar 2025 07:29:52 -0700
Message-ID: <20250319143029.286513087@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <mripard@kernel.org>

[ Upstream commit bb4f929a8875b4801db95b8cf3b2c527c1e475e0 ]

Some tests have the drm pointer assigned multiple times to the same
value. Drop the redundant assignments.

Reviewed-by: Simona Vetter <simona.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20250129-test-kunit-v2-2-fe59c43805d5@kernel.org
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c b/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
index cbd9584af3299..4e7369caa7369 100644
--- a/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
+++ b/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
@@ -450,7 +450,6 @@ static void drm_test_check_broadcast_rgb_auto_cea_mode_vic_1(struct kunit *test)
 	mode = drm_kunit_display_mode_from_cea_vic(test, drm, 1);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
-	drm = &priv->drm;
 	crtc = priv->crtc;
 	ret = light_up_connector(test, drm, crtc, conn, mode, ctx);
 	KUNIT_ASSERT_EQ(test, ret, 0);
@@ -564,7 +563,6 @@ static void drm_test_check_broadcast_rgb_full_cea_mode_vic_1(struct kunit *test)
 	mode = drm_kunit_display_mode_from_cea_vic(test, drm, 1);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
-	drm = &priv->drm;
 	crtc = priv->crtc;
 	ret = light_up_connector(test, drm, crtc, conn, mode, ctx);
 	KUNIT_ASSERT_EQ(test, ret, 0);
@@ -680,7 +678,6 @@ static void drm_test_check_broadcast_rgb_limited_cea_mode_vic_1(struct kunit *te
 	mode = drm_kunit_display_mode_from_cea_vic(test, drm, 1);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
-	drm = &priv->drm;
 	crtc = priv->crtc;
 	ret = light_up_connector(test, drm, crtc, conn, mode, ctx);
 	KUNIT_ASSERT_EQ(test, ret, 0);
@@ -1282,7 +1279,6 @@ static void drm_test_check_output_bpc_format_vic_1(struct kunit *test)
 	rate = mode->clock * 1500;
 	KUNIT_ASSERT_LT(test, rate, info->max_tmds_clock * 1000);
 
-	drm = &priv->drm;
 	crtc = priv->crtc;
 	ret = light_up_connector(test, drm, crtc, conn, mode, ctx);
 	KUNIT_EXPECT_EQ(test, ret, 0);
-- 
2.39.5



