Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA6C24169C;
	Thu, 13 Feb 2025 14:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458605; cv=none; b=ZNKjMMPOcUPjYkUiXSUiPFbGGQTU5Kk5HvfgLS53EygavroqPq0u7OgtPB6s/FEVRkUZ2SMnNmwd2wENF6w9UCgiDBP7c7yPQ6OyVFMGvDN0h3L+nGBB0Y0KRuQQDFHucWvA4c0uYWyY6GR4EauctI6KFb1JxVB7zBaVpjT98Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458605; c=relaxed/simple;
	bh=3AOQG8Tpu2rxguEIU8dLJmiiIOKRM4eRv1pvLQEBmQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0ZaSyIybDf48vInEdKOfY03KNRxFQ6ccwC1i/NEQ43sw6CRKvrxFP+nTv7ghx31nQ9mOBIU5fwBszdWe6oSPUtYKz/8z2syFeYC+zfyv7hugNKbZvBNTMvhxCA/TXD5WvJokSg7AOEkY74o/9NvlwgZAqEDIOGVcRztMXQ5Y30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y81tCXvi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y81tCXvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00062C4CEE4;
	Thu, 13 Feb 2025 14:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458605;
	bh=3AOQG8Tpu2rxguEIU8dLJmiiIOKRM4eRv1pvLQEBmQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y81tCXvivE1qrqpvkx/8ExCxq4s5+IbkSIB5C72b+yNXc/ETENMGHvWXk4Xno3nwp
	 WfHInkgGJVPR3PDbC+JTOheDQwzp4hlSgpufv1+Ql7pI5qpO3+DqgOKIFY2ggKC4RZ
	 VPZzYbsafRWuwcL8cMlfF+KQ+EXfQZtpMJhOvnpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 026/443] drm/tests: hdmi: handle empty modes in find_preferred_mode()
Date: Thu, 13 Feb 2025 15:23:11 +0100
Message-ID: <20250213142441.634221122@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit d3314efd6ebf335a3682b1d6b1b81cdab3d8254a ]

If the connector->modes list is empty, then list_first_entry() returns a
bogus entry. Change that to use list_first_entry_or_null().

Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241130-hdmi-mode-valid-v5-1-742644ec3b1f@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c b/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
index 294773342e710..1e77689af6549 100644
--- a/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
+++ b/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
@@ -46,7 +46,7 @@ static struct drm_display_mode *find_preferred_mode(struct drm_connector *connec
 	struct drm_display_mode *mode, *preferred;
 
 	mutex_lock(&drm->mode_config.mutex);
-	preferred = list_first_entry(&connector->modes, struct drm_display_mode, head);
+	preferred = list_first_entry_or_null(&connector->modes, struct drm_display_mode, head);
 	list_for_each_entry(mode, &connector->modes, head)
 		if (mode->type & DRM_MODE_TYPE_PREFERRED)
 			preferred = mode;
-- 
2.39.5



