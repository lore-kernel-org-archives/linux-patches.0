Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF66D1E907D;
	Tue, 15 Oct 2024 11:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992126; cv=none; b=LmWlSvAV1i/U/1FTliAxFG8aymjdNQIL9fzb9TssoP2EIHvoMgtzOFSxESrQpe3o0hLeD5bcTEMGYfGdecq41Qbv7Q/fKZ3VYSP5jHtlv7HKI9nSgb3wqJLBq7CAv0i0/uD6QzMUFvjFJ26FgpHPmS6oRpMSTkCjB+ryAiEQ8vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992126; c=relaxed/simple;
	bh=OrkDED4+q3jl1ytEsh8bOfyRyR/5OAYNJO4j187LCQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1+G5uUN1y05wjKzsqd3nniDZpowDCPtpCPHU4eIoy8QQALpI9pVLbdIKtJncweklQn1d0sIhLiMmn6tBUGYUGvZoVDyDd6kUcOy3ulv+o0z/LvmLlpnxrWgL7O3rcGMJ70mmOEDx4K0Lkdm0Kwyjk2R/5IkZKkQSSdo3UWHFMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMpp//fl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMpp//fl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41207C4CECF;
	Tue, 15 Oct 2024 11:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992125;
	bh=OrkDED4+q3jl1ytEsh8bOfyRyR/5OAYNJO4j187LCQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMpp//flGDdzjityuBODRie3mYC2alEB/jEwh0sEzI1G6u7AAasMQG1Jplv7sZEY4
	 65hh+OhOfWKMbQo3sqornjj3e+5diMem1G3dpbvl+WT0cqKd4l8pB8iWpTe3ltvM2r
	 54pE/nw96amK9uUft1FBZgXAOGoHYjjx60/s+QGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/691] Input: i8042 - add Fujitsu Lifebook E756 to i8042 quirk table
Date: Tue, 15 Oct 2024 13:19:34 +0200
Message-ID: <20241015112441.372479725@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 49d87f56cb90..a6474090a882 100644
--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -617,6 +617,15 @@ static const struct dmi_system_id i8042_dmi_quirk_table[] __initconst = {
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



