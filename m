Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29D7143C57;
	Tue, 23 Apr 2024 21:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908614; cv=none; b=Eod2sZgjv79OabbVtt28Jc4L3O7147cTGJRqNdn7sn3d6fNI/vDoB1nOBBh3UaW1kzft/KTcsieZ22kc2UuY1A0Sqfj2n1LHYU2kDrXXp5MDtUQOwxTbwHaDZyADToVGu70H1Kdvvrj+2wXj9gdriTw5Is4AySmClYzcJZkRLVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908614; c=relaxed/simple;
	bh=U+8DRnmNLXlCzat/mTYgZqTh3Q7ElXnxDzKZfqd56RY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S0WYeFrkTN04Ab82EQxpT8bVwTmJ4B/YD4fcZkPkCPipTPtYvRKqmxFypSmkh+NwsqLR7IAr3d1mG2Jtq+c5VYUXJRwa+WyVDZb5gRZaiLfumIB+unjJeMzuGIb0IEu3dUf60fn56PBPpgfj9XpioxRnGLd0LLJG0Xzk59LTuLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJe17hfJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJe17hfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7906EC3277B;
	Tue, 23 Apr 2024 21:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908614;
	bh=U+8DRnmNLXlCzat/mTYgZqTh3Q7ElXnxDzKZfqd56RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJe17hfJ2PjOGMfbwXEL5dw3cE6PUjAJEccCwxJG+P1azVEO5OAXkW6kBsICC9/eB
	 6dYEXR7Kq/cMybqJBRPasp/s8zPXcyk8/z5qC5ReQQg087gOlF0JljcEMwaPpRvz6+
	 kT/xyp8En/AMN2Ozt3fuehGKfDdsgjsiBE956Uk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brenton Simpson <appsforartists@google.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/158] drm: panel-orientation-quirks: Add quirk for Lenovo Legion Go
Date: Tue, 23 Apr 2024 14:38:43 -0700
Message-ID: <20240423213858.553038442@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Brenton Simpson <appsforartists@google.com>

[ Upstream commit 430143b0d3611f4a9c8434319e5e504244749e79 ]

The Legion Go has a 2560x1600 portrait screen, with the native "up" facing
the right controller (90° CW from the rest of the device).

Signed-off-by: Brenton Simpson <appsforartists@google.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20231114233859.274189-1-appsforartists@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 3fe5e6439c401..aa93129c3397e 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -348,6 +348,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "IdeaPad Duet 3 10IGL5"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
+	}, {	/* Lenovo Legion Go 8APU1 */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Legion Go 8APU1"),
+		},
+		.driver_data = (void *)&lcd1600x2560_leftside_up,
 	}, {	/* Lenovo Yoga Book X90F / X90L */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
-- 
2.43.0



