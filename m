Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D39B18732F;
	Thu,  5 Sep 2024 09:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529987; cv=none; b=G/DSQzGdzsgB+hfmSA0ih+AKhua2hvCPmHMwaDQCZgtnjTBZ9LvdAWWO5VT1TOW1j0DNcK41/eoSL2r39jGuJxWjwpr9gfeaUXq7icZPniq8riwE5tiS1+YsMYZ04dT9pyHuZHAegGxnVVFGrwmc5ENi+VvwJbuXaI2e6MqVCVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529987; c=relaxed/simple;
	bh=FhVzybxvjlcByIE/jkGbZJkYGQi1JBp6VGqw3FWHJEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZa9A1ajWHF72pOE9DbwrPC/nH2SdGxxLWBwXHSY0x6t/lPNOP1iu9MYVaGRX46L64b97DG5w6tEEI+ITbDShGwwHVsVMl5bOIFM24L6TCrU2SRRvsbAuF4Zh6OZWS5N+4KO71pOXN6Y2/bkQ469XkcX2An/Fp5JqpB2R4l0MXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cNj0wJs8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cNj0wJs8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E246BC4CEC3;
	Thu,  5 Sep 2024 09:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529987;
	bh=FhVzybxvjlcByIE/jkGbZJkYGQi1JBp6VGqw3FWHJEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cNj0wJs8/WEsLweJgZZri/P0na9mwgrY0DdJVhQTVmeKo7pEtuI7PgngnKfiMvAvv
	 uXPfxf4emNhPk/QBjgVGKq6m8IqIXlfwiCwLSz0SiLKmi/GcYf3I3DlLO8iobOxts7
	 2U97nsnzExgwIYFvvh26Flfl4Ft/C965FiFQi4aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Mueller <philm@manjaro.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/132] drm: panel-orientation-quirks: Add quirk for OrangePi Neo
Date: Thu,  5 Sep 2024 11:39:49 +0200
Message-ID: <20240905093722.329864739@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: Philip Mueller <philm@manjaro.org>

[ Upstream commit d60c429610a14560085d98fa6f4cdb43040ca8f0 ]

This adds a DMI orientation quirk for the OrangePi Neo Linux Gaming
Handheld.

Signed-off-by: Philip Mueller <philm@manjaro.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240715045818.1019979-1-philm@manjaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 5db52d6c5c35c..039da0d1a613b 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -414,6 +414,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "ONE XPLAYER"),
 		},
 		.driver_data = (void *)&lcd1600x2560_leftside_up,
+	}, {	/* OrangePi Neo */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "OrangePi"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "NEO-01"),
+		},
+		.driver_data = (void *)&lcd1200x1920_rightside_up,
 	}, {	/* Samsung GalaxyBook 10.6 */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
-- 
2.43.0



