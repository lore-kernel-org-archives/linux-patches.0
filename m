Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78098462;
	Thu, 17 Apr 2025 18:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915446; cv=none; b=Hy7pL99C7G22KRWula+7S71Daz9KpZbgRZS5EiMylF4UsFnHzjiC0cwI1m080A1RsVegroCQk1gVOO8MNps3UbISLVFb8eRwx0btmGJbmPVHn67qUyw18+c3e5BOGXjfBg57Fx3BMZ071JBZG+BeXJOR6VngHbd9WQyodKYqcVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915446; c=relaxed/simple;
	bh=9Qoyyn/puFOi3AILAHr7D/hEgfdwd4qbNIVg1oJl02Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsEngB32r6BRJ0Oryoq7a6zPbEln5HIwQkHtIUFtsX2Kr9VVYH/pE8qatO/PhQLwK15dWCNKja0S4891xBXt8SdclUCPq9+r+Yz4S5qnizmPnv++Qu3fv5Zttzm9unLdEgDBiTdHdEobPBAuO4+3fK58ZW4nwkn1ZixMlR/9NiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AWNDaXx9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AWNDaXx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B53EC4CEE7;
	Thu, 17 Apr 2025 18:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915446;
	bh=9Qoyyn/puFOi3AILAHr7D/hEgfdwd4qbNIVg1oJl02Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AWNDaXx9URumzvfvYpUMwqh7Lr1UYThTp0G2vTvIHYrtyxx+VyosJxK/Ts40FROV6
	 tZFNqq9m0mhgjXFSnuQR3+83csvzdlXFY2+OKBUPOEqz/WYQ/ukkBEahSUkPn4+E+R
	 bCseS1vofzjixbXYDQUS15HcaDDDPDk8OdtvJxV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Wyatt <fewtarius@steamfork.org>,
	John Edwards <uejji@uejji.net>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 131/393] drm: panel-orientation-quirks: Add support for AYANEO 2S
Date: Thu, 17 Apr 2025 19:49:00 +0200
Message-ID: <20250417175112.858111411@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Andrew Wyatt <fewtarius@steamfork.org>

[ Upstream commit eb8f1e3e8ee10cff591d4a47437dfd34d850d454 ]

AYANEO 2S uses the same panel and orientation as the AYANEO 2.

Update the AYANEO 2 DMI match to also match AYANEO 2S.

Signed-off-by: Andrew Wyatt <fewtarius@steamfork.org>
Signed-off-by: John Edwards <uejji@uejji.net>
Tested-by: John Edwards <uejji@uejji.net>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20250213222455.93533-2-uejji@uejji.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 4a73821b81f6f..f9c975338fc9e 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -184,10 +184,10 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "T103HAF"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
-	}, {	/* AYA NEO AYANEO 2 */
+	}, {	/* AYA NEO AYANEO 2/2S */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "AYANEO"),
-		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "AYANEO 2"),
+		  DMI_MATCH(DMI_PRODUCT_NAME, "AYANEO 2"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
 	}, {	/* AYA NEO 2021 */
-- 
2.39.5



