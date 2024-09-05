Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620D21925AA;
	Thu,  5 Sep 2024 09:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529397; cv=none; b=Eki2Vg8IYn1p9/E5LJoc3xKP6e7SpQ3enmJWfBdAGv/vSi54RBY5eRudJwD2PxBLl4m085XZ2s+8pV73aT8L4nCKhrQjnnq/EAs+JcXkCHn6OhRl5v8iYHWykZ7RSTrkn/T/UdPBE0S0Z4gaM+SHb8rTZ1lLoepntESSpEBmMFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529397; c=relaxed/simple;
	bh=45UxVciiizWW6gK8+FTkX2VYvicrGRKn+04pqupZLPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUwWh/ITBZMIEVu2LBbm8Xl6fV66zPSqN/cZw6xKxefOR156A6N+Ko5uyx+RCAmtR/Twj4v410F/3RmGVCdLVLJa1XysKM/Ky3wtgiX+WYC8eZyGnSpKnVb6CIn6WY4JZEJevodkMoRa7gm9dZ82G1r/t6RXaUOjvHa2LFc0Y9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=InJlH/bM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="InJlH/bM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7463DC4CEC3;
	Thu,  5 Sep 2024 09:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529396;
	bh=45UxVciiizWW6gK8+FTkX2VYvicrGRKn+04pqupZLPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=InJlH/bMgSP8+VjGahm3x9QRoHZD26qKZIXUhLzCkv95rr12YAu31EYRnjMYQA1/7
	 9L5ZvPxs1XW16NRa8f14k8pWSGThxtZfslvNhfnYCrlaGQDh7S6ZDe8H4vtY4TLU05
	 oqU//cruAQxetRWw8yLok/IrW63I19QIiwp1L8e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Mueller <philm@manjaro.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 002/184] drm: panel-orientation-quirks: Add quirk for OrangePi Neo
Date: Thu,  5 Sep 2024 11:38:35 +0200
Message-ID: <20240905093732.337974858@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3860a8ce1e2d4..903f4bfea7e83 100644
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



