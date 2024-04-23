Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB0E143882;
	Tue, 23 Apr 2024 21:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908736; cv=none; b=Xcx5jp9XFcY/A5KNcfOACON8BHrZME90yxEPijz5q/CSB78CNbYdM+cZBLw5F77F4ZGknziQDiE0b6Vnm0JntG2biSiBI0cjp4UiJW9rG1g7UfU4bNbG8cl7UNNGymTCB719Tz7pAONST2Xes4acuSNp3RkPenVK0SevI2c22eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908736; c=relaxed/simple;
	bh=2A+nTHD4zDbA+5cd3eeaAMbdXk2Q+cMwZaj1gZ46xis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ekyu+B2cIan+on6I5hyD9IuhRH8A25FN3SxmTIlbhhsEdbiKj1K+eysQ5r0pGgwx8lZJSVSwFt8eHbz16hdX6XMYa7Jujun0ahBAVDAbZM5aOCYnPau2vEsETlbTBwcqQk210lqfNncbV/SXUFZVOSasJbFzEZKgXSvAHQwrCYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FNURMzZ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FNURMzZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F230C116B1;
	Tue, 23 Apr 2024 21:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908736;
	bh=2A+nTHD4zDbA+5cd3eeaAMbdXk2Q+cMwZaj1gZ46xis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FNURMzZ6zZM7+p39yTyCMK19i5Ca0LAhF3rh9bIiAzuz0JFP5S2Us3NxkDRln0178
	 n41Q4gRlJzzk+Zy8hPJWmOljlZ05vU4c5DHd8lThAg7EJnzzjNorzvEv4jBibs/iGZ
	 JcDWOsDWNB7BovxtJt75gqs8OciFHu4lxY9ab/tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brenton Simpson <appsforartists@google.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/141] drm: panel-orientation-quirks: Add quirk for Lenovo Legion Go
Date: Tue, 23 Apr 2024 14:39:08 -0700
Message-ID: <20240423213855.785394726@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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



