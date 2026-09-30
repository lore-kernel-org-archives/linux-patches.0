Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E51E51AFD5;
	Wed, 30 Sep 2026 17:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790088; cv=none; b=rbDGiz5WzdbFg32bfWAKOpDoQex3ylxafkgYS8C71d2D8nvKHFI761NIaWQdtWwAurMSQ5vpPcXGt/e5lYZMWzZ4wYmK2uUxbrg5KYxILMGJDvH2srz4yBlqmmqMBxTQNv6sPT41+MsYeZ7ddyujpxi4KCiToRQh+TiNx3Bi3X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790088; c=relaxed/simple;
	bh=2Ub7KT6ogWeIgjjDAL14Oo+xzHzIcVtCfJxRgLlwq/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CX1orqfP4ckSbFoWWImdgiVDcYhxyRPWRLa1YosF2D0yXO7ykn8FdYC6hzwKHcJfJo5MNYilTAL6dX+m+LXOQ6sgFpqLlbj4bpeTugafYGekGmCi54O9UbR8N/FuoL1RD+WeCt7BbhtJ0y9iffcDkw5fDKWycxnx7l2dPlXgQSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yKshzREl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yKshzREl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F061F000FF;
	Wed, 30 Sep 2026 17:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790087;
	bh=qrR+iNMrCZE5sJ6iCbpL73EckIrxaZBDWQAqWnH+AkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yKshzRElR67Z9GK6J6uF2EBM5YZoq+8G2A4vaPXrTfBZRFRVgbtf1TrD7C5hN1VRl
	 ghBMEixyJXC7VKGciitRxc+jNlyCKU1FrXBMbJ/cPHAPojgD7aA2UBe56HxNmyKgpN
	 cYVK8b8BGs9OxAR0ZyvUd2lExlTeU4fcf9MTJ4dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Thierry Reding <treding@nvidia.com>,
	Maxime Ripard <mripard@kernel.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 706/877] drm/sysfb: simpledrm: Improve framebuffer-size validation
Date: Wed, 30 Sep 2026 17:26:57 +0200
Message-ID: <20260930152429.919037862@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 03f1a3545b721fa7fdadd00080e237519a286a97 ]

Validate the framebuffer size from the firmware against the
limitations of struct drm_display_mode. The type only stores sizes
in 16-bit fields. Fail probing on errors.

v2:
- remove unused function simplefb_get_validated_int0() (Sashiko)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
Cc: <stable@vger.kernel.org> # v5.14+
Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
Link: https://patch.msgid.link/20260625094509.157581-2-tzimmermann@suse.de
[ adapted shared-validator changes to the existing simplefb_get_validated_int0() helper in drm/tiny/simpledrm.c. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tiny/simpledrm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/tiny/simpledrm.c
+++ b/drivers/gpu/drm/tiny/simpledrm.c
@@ -54,7 +54,7 @@ static int
 simplefb_get_validated_int0(struct drm_device *dev, const char *name,
 			    uint32_t value)
 {
-	if (!value) {
+	if (!value || value > U16_MAX) {
 		drm_err(dev, "simplefb: invalid framebuffer %s of %u\n",
 			name, value);
 		return -EINVAL;


