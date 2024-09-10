Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7223017BB01;
	Tue, 10 Sep 2024 09:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962363; cv=none; b=amGweS/XPPin5kxxWHoG2DEs40S+FKov5W7WtPA4G+A9tkkPCmKhcfB+nTB5mB+cAFOE6E5RYvSvNVrCRJAxx7+R5mIrJZWbuEQueivKTzWTvqs3PnxkWyiVP+03BQLfHg3ixXdP4Qz4jtz/GEMtGnlAZuFcCJPe2EhwZss5EmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962363; c=relaxed/simple;
	bh=i1AoxKkk58WUMSI94qUKG2vjuv/q4ZbbWU1pRj7wWbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8YG5mFZG53uUByOq5ruu1HR3e3mabkqobImtIZUVO2+8ZPQUa0eGUj98oq2jZce5AFEK+VGg/EE1eB9YWF9bZ5GhtahOjErnKG0QuPzQjCQcXassHTRm3fNdD6ms7AfdhCgnIhK61Jrj0kbsrEaFCFkkpUt5JHtF69tnl6s00w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGCbqNv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGCbqNv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBC2C4CEC3;
	Tue, 10 Sep 2024 09:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962363;
	bh=i1AoxKkk58WUMSI94qUKG2vjuv/q4ZbbWU1pRj7wWbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGCbqNv93brY0+oj97Nj+tK7N45kCLWO0vpzgi2EKeanTkN7kvhUssJG/ObNAPIvS
	 MFJpYY6JJ1PQIPDwJHzYm6WKrOgas5UTE0S1McAf66NKhI4+fn7T16ZbJ7UHvx27WS
	 xxy5FeI2OIwGFUjTwCfQum1bxfGyY/79KBhr8tck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Mueller <philm@manjaro.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 001/121] drm: panel-orientation-quirks: Add quirk for OrangePi Neo
Date: Tue, 10 Sep 2024 11:31:16 +0200
Message-ID: <20240910092545.803994043@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 43de9dfcba19a..f1091cb87de0c 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -318,6 +318,12 @@ static const struct dmi_system_id orientation_data[] = {
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



