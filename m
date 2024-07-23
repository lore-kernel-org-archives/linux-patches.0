Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DE71586CB;
	Tue, 23 Jul 2024 18:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760018; cv=none; b=gbKNDeXEX+p2alBsCD98ZfHi/ew3rVKz5/zodvki4a0HxrxmJezIqTwWqGkvSOmIvWu/Bbf4VUXoOSaV4bX4MsvIDMnGADuXTRfj7s4aNC9cbrQx3V8Rhr+yJKnVnLxejLYg23bvI/Q2oPqfAnghlYJBz7FhspJku3y5a5BG0Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760018; c=relaxed/simple;
	bh=KbFOT0RlzmtwkWrbcURfuWnLO7/LHSZRmjl6qytRztU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LksjwXoRMGapLvfa/8oLMEzAHDvDzNzHP+qDGj+qbxPlJAkK8P4Hm/DbyeoSk484kV4+HDh09ui1LKleRxu5hHKaxb76KRj0a1JknugpEg67r/tw/kx1d9TOOGconMGAq9833MWNMaYatMSJREd0KmirGrpDWWjCBb5YlmMxHcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ef4yZRCX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ef4yZRCX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191EBC4AF09;
	Tue, 23 Jul 2024 18:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760018;
	bh=KbFOT0RlzmtwkWrbcURfuWnLO7/LHSZRmjl6qytRztU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ef4yZRCXElbLwohLH44LNtnkLP6yYu6Y1XWVUrpwHPZdz8TAVK03pFXsg3nRvFAc0
	 zeESrqTYPH3OL3Vy1ff/zo6B0OZ6KDSKqkOu2DAB2VpZF/lWmoPpvNXYLYiAA6qQJi
	 fEgllYl+Byut7mdcGMY4DKB3LBGv1zJNpg1rFo/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 068/163] ALSA: hda: cs35l41: Support Lenovo Thinkbook 16P Gen 5
Date: Tue, 23 Jul 2024 20:23:17 +0200
Message-ID: <20240723180146.097530049@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 82f3daed2d3590fa286a02301573a183dd902a0f ]

This laptop does not contain _DSD so needs to be supported using the
configuration table.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240606130351.333495-2-sbinding@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l41_hda_property.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/hda/cs35l41_hda_property.c b/sound/pci/hda/cs35l41_hda_property.c
index 4f5e581cdd5ff..e034828df4452 100644
--- a/sound/pci/hda/cs35l41_hda_property.c
+++ b/sound/pci/hda/cs35l41_hda_property.c
@@ -118,6 +118,8 @@ static const struct cs35l41_config cs35l41_config_table[] = {
 	{ "17AA38B5", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 0, 0, 0 },
 	{ "17AA38B6", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 0, 0, 0 },
 	{ "17AA38B7", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 0, 0, 0 },
+	{ "17AA38F9", 2, EXTERNAL, { CS35L41_RIGHT, CS35L41_LEFT, 0, 0 }, 0, 2, -1, 0, 0, 0 },
+	{ "17AA38FA", 2, EXTERNAL, { CS35L41_RIGHT, CS35L41_LEFT, 0, 0 }, 0, 2, -1, 0, 0, 0 },
 	{}
 };
 
@@ -509,6 +511,8 @@ static const struct cs35l41_prop_model cs35l41_prop_model_table[] = {
 	{ "CSC3551", "17AA38B5", generic_dsd_config },
 	{ "CSC3551", "17AA38B6", generic_dsd_config },
 	{ "CSC3551", "17AA38B7", generic_dsd_config },
+	{ "CSC3551", "17AA38F9", generic_dsd_config },
+	{ "CSC3551", "17AA38FA", generic_dsd_config },
 	{}
 };
 
-- 
2.43.0



