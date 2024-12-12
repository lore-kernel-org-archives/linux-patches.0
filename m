Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63002225A5E;
	Thu, 12 Dec 2024 16:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021241; cv=none; b=Fy0glmxs7oo5jp8c8dWi45arvtPSpLldYGkg7xbLOBiqjRPQEXeUREtuenBrkofkWkfAJO+NXNU4UUcsRuw5HfQWhNt/2TsZVTVs0h0CUurO/mFKehrTgxuQmOHkv/0qXtK/ACDbrEAfqr7K4GGMYPNii+sXq/a6Gm3QRMOezyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021241; c=relaxed/simple;
	bh=GCbWl5zohmDYJUERd3gBI+192Ymuw9D6sVDFu4Qdgks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IGhB6HFMwJkXZObENWkwzd2WdzHEN17LcMVIMwoy39P5dQaqU5kZT+O17/rcdW5ylG5t+mlqZ9ypMuilfxWD7aItHwWeUGBS2a5LF9zSZ54tbAEGI4xH1b+2TdUEIgoR29kN2vPY7tHnCXLE2LX3EoFMPVcGTgYZvop7ZsUFYdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ONQO6CWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ONQO6CWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C38C4CECE;
	Thu, 12 Dec 2024 16:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021241;
	bh=GCbWl5zohmDYJUERd3gBI+192Ymuw9D6sVDFu4Qdgks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ONQO6CWdI3QXDtI8/Xuz1ZWkB8nhsRpq1MquG3B2/Zcg6WUlcEWj83dpBtwUElhid
	 rZmUEt6zQkQowD5fyvuEuOPJn+X5gM4/gViPNuTORaMJ7IgZswgqqbVqOkGBplAzae
	 AbIWfXijWq8FNbY0tPKXLrJcyBc4mQyIbeWdDMWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Joaqu=C3=ADn=20Ignacio=20Aramend=C3=ADa?= <samsagax@gmail.com>,
	Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 655/772] drm: panel-orientation-quirks: Add quirk for AYA NEO 2 model
Date: Thu, 12 Dec 2024 16:00:00 +0100
Message-ID: <20241212144416.986446346@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



