Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB768223C44;
	Thu, 12 Dec 2024 15:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018134; cv=none; b=YAuceWXcg3fQlisii58lzjRwpZZREzLWbn7ukJTNrgeffdSvEfLxVPcsHrLIQ/pcNJkcIJupx7+7tjAPcKdXcvhkR9y4v/Lx0518Dp/3oi4s8xqA6jEsgtyCZ3n3IiHSs6UKV+On53UOBaoPAHRTnpGLxMYuOhlWaNuMHVcPs4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018134; c=relaxed/simple;
	bh=gUjsuoa1V/G4UoztsPvneUYkzgpTLC8N1RhiyWy2t1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QWLXTTjKiYcYxF7kwyH69H8V6l4qwEc0BXxsnB5leHq/iJx+JE3zmFJm6dTRgp6veJGaPUZ2vwn/1AqyRCY5WJKg3vPH9orEAqgPjTO8q3N/uO9BEDkOfCLV+loEAE/hlDFtAZF1C8HgKKzGOw6pyYaWUJAznrnd+KiGMUTPtto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiUiLd99; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiUiLd99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D15BC4CECE;
	Thu, 12 Dec 2024 15:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018134;
	bh=gUjsuoa1V/G4UoztsPvneUYkzgpTLC8N1RhiyWy2t1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UiUiLd99SeZTgRhUhzJD1EzMr8gYaFX5kq6tRuzQTwGFK6LbKXjEkipxagjD/xxZ2
	 agiSfByUDPkY2u/kfeedUVjr51+zXgcHc0zGJKLkcLQedfqHmEZgSzK9Sxo6NbF+QP
	 LkpXQKXAteIF81hXmx4w4BoWpLVTnJOhpZayBXKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Joaqu=C3=ADn=20Ignacio=20Aramend=C3=ADa?= <samsagax@gmail.com>,
	Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 208/356] drm: panel-orientation-quirks: Add quirk for AYA NEO 2 model
Date: Thu, 12 Dec 2024 15:58:47 +0100
Message-ID: <20241212144252.832392791@linuxfoundation.org>
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

[ Upstream commit 361ebf5ef843b0aa1704c72eb26b91cf76c3c5b7 ]

Add quirk orientation for AYA NEO 2. The name appears without spaces in
DMI strings. That made it difficult to reuse the 2021 match. Also the
display is larger in resolution.

Tested by the JELOS team that has been patching their own kernel for a
while now and confirmed by users in the AYA NEO and ChimeraOS discord
servers.

Signed-off-by: Joaquín Ignacio Aramendía <samsagax@gmail.com>
Signed-off-by: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/2b35545b77a9fd8c9699b751ca282226dcecb1dd.1726492131.git.tjakobi@math.uni-bielefeld.de
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 259a0c765bafb..55635c7bfcefc 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -184,6 +184,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "T103HAF"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
+	}, {	/* AYA NEO AYANEO 2 */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "AYANEO"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "AYANEO 2"),
+		},
+		.driver_data = (void *)&lcd1200x1920_rightside_up,
 	}, {	/* AYA NEO 2021 */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "AYADEVICE"),
-- 
2.43.0



