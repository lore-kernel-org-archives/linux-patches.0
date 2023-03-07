Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D87BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F68C433EF;
	Tue,  7 Mar 2023 18:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214616;
	bh=9lqFVp72P3qy6PTD6/0T9qxO/Z7XuPwaQc1AwYhUvSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpZJSnqt+6/21DO90GDDmK3wt5HN3FTk3aZvorSqQBGXkAD7NfbVxjbefIE898Pum
	 Zl1E2Px83vKSlhr7IOASGW4GnF5RnHxCrF+86jpiKjM6HegVDlybBI/7bZIJ44YcoA
	 9rpA3CNwOpnL5ORAS7omAeoiZC5FvWkUh9z23wAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Hawrylak <mark.hawrylak@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 880/885] drm/radeon: Fix eDP for single-display iMac11,2
Date: Tue,  7 Mar 2023 18:03:34 +0100
Message-Id: <20230307170040.027039644@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Hawrylak <mark.hawrylak@gmail.com>

commit 05eacc198c68cbb35a7281ce4011f8899ee1cfb8 upstream.

Apple iMac11,2 (mid 2010) also with Radeon HD-4670 that has the same
issue as iMac10,1 (late 2009) where the internal eDP panel stays dark on
driver load.  This patch treats iMac11,2 the same as iMac10,1,
so the eDP panel stays active.

Additional steps:
Kernel boot parameter radeon.nomodeset=0 required to keep the eDP
panel active.

This patch is an extension of
commit 564d8a2cf3ab ("drm/radeon: Fix eDP for single-display iMac10,1 (v2)")
Link: https://lore.kernel.org/all/lsq.1507553064.833262317@decadent.org.uk/
Signed-off-by: Mark Hawrylak <mark.hawrylak@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/atombios_encoders.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -2122,11 +2122,12 @@ int radeon_atom_pick_dig_encoder(struct
 
 	/*
 	 * On DCE32 any encoder can drive any block so usually just use crtc id,
-	 * but Apple thinks different at least on iMac10,1, so there use linkb,
+	 * but Apple thinks different at least on iMac10,1 and iMac11,2, so there use linkb,
 	 * otherwise the internal eDP panel will stay dark.
 	 */
 	if (ASIC_IS_DCE32(rdev)) {
-		if (dmi_match(DMI_PRODUCT_NAME, "iMac10,1"))
+		if (dmi_match(DMI_PRODUCT_NAME, "iMac10,1") ||
+		    dmi_match(DMI_PRODUCT_NAME, "iMac11,2"))
 			enc_idx = (dig->linkb) ? 1 : 0;
 		else
 			enc_idx = radeon_crtc->crtc_id;


