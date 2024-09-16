Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1AD156641;
	Mon, 16 Sep 2024 12:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488316; cv=none; b=JK9ZCXwg0/QovUIWGgsUunyXGl0y+UvApwCoFMwwy6hV1UsFK5tmdWPejp/EqsEU8+OVKoFkvKgEgUG4p8Dv1L9CQ4q40WADiET+HNfzj6lRoxpbnXeLaitO93p2e/IgjH+9PD+IXOBQFFRK39oehQt04L1nveAOUBgBeOzsoSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488316; c=relaxed/simple;
	bh=1JRYX/fmyWujRbGYPDY7VpN5ZiQvYWSVS0REM8DG1uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUUVgSiD4RngNPs1SPmPO0z1s+lSwipvVcD359R3uHQj0hmP+PHFq+hjyz1w9UPdepSPKr0oN2Ma6aPb/0b6yiXI2QHQ7YH3NmekTQ3DcePq3+hnbQ7WfYKebKReSyV0WLw2nJPe8RkA/o6zsf99r6HMD6+Fw0ic5d517RZgR40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VqgmTZas; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VqgmTZas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85815C4CEC4;
	Mon, 16 Sep 2024 12:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488315;
	bh=1JRYX/fmyWujRbGYPDY7VpN5ZiQvYWSVS0REM8DG1uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VqgmTZasHnLBrNIGLDweFWcm19S3/1RIZNLvtG7fQZWnZo9NqdWTcKOcKGyK14EuT
	 MzF1syOimpcq2MRoqGWG5uB6UuKADZH018QmATiErzVZk9P0CXnQ8Rd8IrnxRqUN5l
	 TXP8o79yBOrYHVSEsTXmIOkC/7HZU/22c6Bme6zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 034/121] Input: i8042 - add Fujitsu Lifebook E756 to i8042 quirk table
Date: Mon, 16 Sep 2024 13:43:28 +0200
Message-ID: <20240916114230.259413785@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7ce7c2283fa6843ab3c2adfeb83dcc504a107858 ]

Yet another quirk entry for Fujitsu laptop.  Lifebook E756 requires
i8041.nomux for keeping the touchpad working after suspend/resume.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1229056
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240814100630.2048-1-tiwai@suse.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042-acpipnpio.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/input/serio/i8042-acpipnpio.h b/drivers/input/serio/i8042-acpipnpio.h
index e9eb9554dd7b..bad238f69a7a 100644
--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -627,6 +627,15 @@ static const struct dmi_system_id i8042_dmi_quirk_table[] __initconst = {
 		},
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
+	{
+		/* Fujitsu Lifebook E756 */
+		/* https://bugzilla.suse.com/show_bug.cgi?id=1229056 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK E756"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
+	},
 	{
 		/* Fujitsu Lifebook E5411 */
 		.matches = {
-- 
2.43.0



