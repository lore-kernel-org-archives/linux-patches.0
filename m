Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125E321E085;
	Thu, 12 Dec 2024 15:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018146; cv=none; b=Kw23qn1vcl1TeuCtWDf8iIdEaTmWID3cRUwBpKQ0yQxBTQkKINS5V6zlxxFVzPHniOz9gnAsJAuEG3HGjmGX4/2oVzUBRnmPBVpLvsV3ryLCyDy+5OW37IksiOhTPi9sinKsqe69JyDasaiQTaElZ9RODFEbsy4DsCwMp5x8m+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018146; c=relaxed/simple;
	bh=O/XHJIlVdj47wLwJJQRm9/KHC4IMYOBgv+ExBSo+Yu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pLaFBsYEvDE5Bm5/CwgGTDIWTCOjuUtprQ7QNF5azrIiU32IWVL6q5V5i1bSC2mVFQnCLGBDgcnxKfMRSLXzj16fvtPszgbK0Fu/0iojI/iU082oUblc/OhHS6BjYOWwlwzELsb96tZE0jLWyA6LVh8cpQYkmSZ7DYR3btnb2Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lt3Pu5e9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lt3Pu5e9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9C7C4CECE;
	Thu, 12 Dec 2024 15:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018145;
	bh=O/XHJIlVdj47wLwJJQRm9/KHC4IMYOBgv+ExBSo+Yu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lt3Pu5e96WE5WWOCDGTl2HXZBAX4sHSadeDve7DH/txKbQ6dXDFw7P8PFDq5Vb7GQ
	 PKyvDvfa6eKTLvGFpQ5WLq6jV2p3RuQa8MRxzPA02KKtcjwUCKBJ060zXucuEgOyjD
	 ZAYjijwnXtJ8Oz8xKmTYhQ2OMXx3yyknvb9Y/r2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Joaqu=C3=ADn=20Ignacio=20Aramend=C3=ADa?= <samsagax@gmail.com>,
	Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 210/356] drm: panel-orientation-quirks: Add quirk for AYA NEO GEEK
Date: Thu, 12 Dec 2024 15:58:49 +0100
Message-ID: <20241212144252.911608109@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Joaquín Ignacio Aramendía <samsagax@gmail.com>

[ Upstream commit 428656feb972ca99200fc127b5aecb574efd9d3d ]

Add quirk orientation for AYA NEO GEEK. The name appears without
spaces in DMI strings. The board name is completely different to
the previous models making it difficult to reuse their quirks
despite being the same resolution and using the same orientation.

Tested by the JELOS team that has been patching their own kernel for a
while now and confirmed by users in the AYA NEO and ChimeraOS discord
servers.

Signed-off-by: Joaquín Ignacio Aramendía <samsagax@gmail.com>
Signed-off-by: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/40350b0d63fe2b54e7cba1e14be50917203f0079.1726492131.git.tjakobi@math.uni-bielefeld.de
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 2ee14c6b6fd62..c00f6f16244c0 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -208,6 +208,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_MATCH(DMI_PRODUCT_NAME, "AYA NEO Founder"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
+	}, {	/* AYA NEO GEEK */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "AYANEO"),
+		  DMI_MATCH(DMI_PRODUCT_NAME, "GEEK"),
+		},
+		.driver_data = (void *)&lcd800x1280_rightside_up,
 	}, {	/* AYA NEO NEXT */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "AYANEO"),
-- 
2.43.0



