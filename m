Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEAA157A4F;
	Tue, 23 Jul 2024 18:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759231; cv=none; b=ieJT7poJasK0vefhr0s4dBr1FPdVpETjmMtlum/1oI8Vb2j+gsYjy4EdI6cn5OFP55kSv414HZE81xtexVV0mWOQke9KHxUXpoTT7/tUqV3pFYUd1tH8sUVj+5dZYmHP5DUb8nttl/oD53iSrVLxtlPscLu3QAgjkSt5ZbZBpDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759231; c=relaxed/simple;
	bh=4FsxlUhBL7+Ex2xFZCNw3l7DKSqxl44SRZb4W5wlnJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VviquA31oIq/ZqCdBzAg62+N28U4t7KpWkgfxFj0tFOCE+2wk8iOXf4OfCWhxtkq9b5TactkkW6OERLSk2vxHjk/8JaqKKQm0+hoq8d4WaO8dh+6g8d4hLQEZLVkolRErq+fkuiMSJQPsI8IRt5u65sxKcWJJ/BskOSp1s/8rzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=01Ib/2Ci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="01Ib/2Ci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C84C4AF0A;
	Tue, 23 Jul 2024 18:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759231;
	bh=4FsxlUhBL7+Ex2xFZCNw3l7DKSqxl44SRZb4W5wlnJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=01Ib/2CiTDiNjYi2hDpZN1eSwIyp1wcdVclXFQjUHC4tbOtxEcEdIDSKjvEWsU7nF
	 7ztzNNuhb4NUYn96kvJRyI5hDjjtfbYOaKa95ptZsTz+6NtOUyWP3OV/92JKzHRaIb
	 ViB4dSXNhaLji0FM0RAowykXcpNqA49kIOhgbMqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/105] drm: panel-orientation-quirks: Add quirk for Aya Neo KUN
Date: Tue, 23 Jul 2024 20:23:23 +0200
Message-ID: <20240723180405.022903468@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>

[ Upstream commit f74fb5df429ebc6a614dc5aa9e44d7194d402e5a ]

Similar to the other Aya Neo devices this one features
again a portrait screen, here with a native resolution
of 1600x2560.

Signed-off-by: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240310220401.895591-1-tjakobi@math.uni-bielefeld.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 426bbee2d9f5e..5db52d6c5c35c 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -202,6 +202,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_MATCH(DMI_BOARD_NAME, "NEXT"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
+	}, {	/* AYA NEO KUN */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "AYANEO"),
+		  DMI_MATCH(DMI_BOARD_NAME, "KUN"),
+		},
+		.driver_data = (void *)&lcd1600x2560_rightside_up,
 	}, {	/* Chuwi HiBook (CWI514) */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Hampoo"),
-- 
2.43.0



