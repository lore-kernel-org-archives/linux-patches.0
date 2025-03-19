Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1A0221F2E;
	Wed, 19 Mar 2025 14:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395249; cv=none; b=oz+rg5NbauJJy2WfMsQXM1/4AegXCnzpLAbsfvJhfvk56k7XEPPT25z8Jn5axiArNSTMEogyrbqX0QlMci9Im7fDWK7JmuyO5merYLCsBVQ1Zapw2kFYxZt6WQznl1+PMLdqPRPYoKBI33D2Y1G4DvbFZKO98qbOYEHoKTrmWPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395249; c=relaxed/simple;
	bh=1vAWMRmg3gyFxi2tHvUbWlCQsLLfYAiDbvmvof9/Pqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUTD/B5g7Fo78MnMV815oiLHBczHqoov0E1SG9KfdtMiEBNplumxijPFwei3zXwTU1rvxaF4p43Jx9Ie7wpTzygJQt6kYKz/5MSAuPv3BwOEdTRAaGFgTrEDK65yLeMu5SCCWhmv5oHSzeDW9n00+BNbqr5jrgUkmSeJ/uGVK/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSALsLz9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSALsLz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E678C4CEE8;
	Wed, 19 Mar 2025 14:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395249;
	bh=1vAWMRmg3gyFxi2tHvUbWlCQsLLfYAiDbvmvof9/Pqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSALsLz92s4u3IrRwRAIW9zHB1OvtSzYHw0neZ4eAo4DIVEki4vlyAV3BZlBGyrjW
	 tmWTnPPmEXiZh262QxEM/3R74AWSq7PNdwnZp56Li/Chwn1KOEdAOtFKrojNqvOUoK
	 oJ4NP4cnheu2ztk/bYwFQ+wjJ5B4WxpxcXO9shPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Mizrahi <thomasmizra@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 130/166] ASoC: amd: yc: Support mic on another Lenovo ThinkPad E16 Gen 2 model
Date: Wed, 19 Mar 2025 07:31:41 -0700
Message-ID: <20250319143023.534308114@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Mizrahi <thomasmizra@gmail.com>

commit 0704a15b930cf97073ce091a0cd7ad32f2304329 upstream.

The internal microphone on the Lenovo ThinkPad E16 model requires a
quirk entry to work properly. This was fixed in a previous patch (linked
below), but depending on the specific variant of the model, the product
name may be "21M5" or "21M6".

The following patch fixed this issue for the 21M5 variant:
  https://lore.kernel.org/all/20240725065442.9293-1-tiwai@suse.de/

This patch adds support for the microphone on the 21M6 variant.

Link: https://github.com/ramaureirac/thinkpad-e14-linux/issues/31
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Mizrahi <thomasmizra@gmail.com>
Link: https://patch.msgid.link/20250308041303.198765-1-thomasmizra@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -252,6 +252,13 @@ static const struct dmi_system_id yc_acp
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21M6"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21ME"),
 		}
 	},


