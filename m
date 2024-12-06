Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF7B13D516;
	Fri,  6 Dec 2024 14:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496517; cv=none; b=lH4gr0RmK78o+wTeV1Fm6WRyrDuLx5URPz2MEL/bRxJZb8elXMgaNr20IDKgLlRQNeIDtKQYwxcNKF1E7AyVf21suDhbUegw9/51l2LhxMHyiFO2AbBgjIK3bgFMZQJLUnJzoo+vzVL0MgPrVFLVjPNbtWg1Li2hiTKFudg6tTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496517; c=relaxed/simple;
	bh=CcnLsepwttLFFuAGpOMughmnor9DL0/xcM/IDKKNX74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpFIbGHlpaavOGTTaW45DgK0e0Rs+AArCNy7hjos/vQHjLHd/nCKqTrYJDFO1sYQzrSyR7kZtTkFvHulkNYhjjpDr9EAfX70lpGin0D0F052f8yYzl2MibECAi81arqhsD9C9Vnppd9Mu7ggrCxAfy4tj2HckIbfE5QUUwFLLtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=voY9u9mo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="voY9u9mo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D62DC4CED1;
	Fri,  6 Dec 2024 14:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496516;
	bh=CcnLsepwttLFFuAGpOMughmnor9DL0/xcM/IDKKNX74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=voY9u9mof/fVGgFnXl5VvtMBylHn/4AJ/oasXH4LEnsRqtteqYY5sVWDOZ6JbfvJh
	 IsrCGOrD+4QHrhZK5lcyC5Q26mmBd/D9EV6bpS/apHO+NnXKNAgCfnFbSf9s/MpYqH
	 bvqodobOQF8vflJZXyjEtMVTw+ujco0yNREMxUvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/676] drm: panel-orientation-quirks: Make Lenovo Yoga Tab 3 X90F DMI match less strict
Date: Fri,  6 Dec 2024 15:27:26 +0100
Message-ID: <20241206143654.418302915@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 052ef642bd6c108a24f375f9ad174b97b425a50b ]

There are 2G and 4G RAM versions of the Lenovo Yoga Tab 3 X90F and it
turns out that the 2G version has a DMI product name of
"CHERRYVIEW D1 PLATFORM" where as the 4G version has
"CHERRYVIEW C0 PLATFORM". The sys-vendor + product-version check are
unique enough that the product-name check is not necessary.

Drop the product-name check so that the existing DMI match for the 4G
RAM version also matches the 2G RAM version.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240825132131.6643-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 5b2506c65e952..259a0c765bafb 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -403,7 +403,6 @@ static const struct dmi_system_id orientation_data[] = {
 	}, {	/* Lenovo Yoga Tab 3 X90F */
 		.matches = {
 		 DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
-		 DMI_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
 		 DMI_MATCH(DMI_PRODUCT_VERSION, "Blade3-10A-001"),
 		},
 		.driver_data = (void *)&lcd1600x2560_rightside_up,
-- 
2.43.0



