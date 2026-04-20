Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A876133F5BC;
	Mon, 20 Apr 2026 15:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700024; cv=none; b=dX0tP4F7aEB8BcIEcZ9QBzTv+Jz4Mtr79woEf1km9gb42hG5jUfiqMfhMQ8zEimo/JUUWbx72O2VrjbC2QZE9XmqnSvQa5HplEZe3uvdWO5ORZEIzpYCScv9MOFF762jsl/38O8vbBRlWFDkafZ2kVTub5ORbnIEvxcDG1sNHq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700024; c=relaxed/simple;
	bh=3viq9MH/JCFxeuc4XB39LU+lAy0upibbvxxX139bimc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFx62JvoEdUegKpx/z6XoPBP7CybR6TrAWK2we+/bMm6IVHzL01RJaNSaJiNUXQFCHNEPfRXCRdaleguU72ciAQK6OkgVXRyTm3FKP/uhuuSWjBi84gpw4GbryyXzdiTfssV0dh2MF0gbAAI02KaQbhrW/C4PB+whtSQId9cMro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nurKHLZO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nurKHLZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364DBC19425;
	Mon, 20 Apr 2026 15:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700024;
	bh=3viq9MH/JCFxeuc4XB39LU+lAy0upibbvxxX139bimc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nurKHLZOfVcLfNmOKdk/lCBPwaQoGE4gmvKum1ZXK9aejCX5HFSaAEv8jnJmstUpC
	 X/GXKrhz52SccgLLQ1bHJQLEtlo1y+bcINm1zU7XITvyEmUJQnHTGuigBp/RNEwmGE
	 GEqeVgfrIkP6eFESV6GGyVnPgSwJUlAKYFC/4tEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hasun Park <hasunpark@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 013/220] ASoC: amd: acp: add ASUS HN7306EA quirk for legacy SDW machine
Date: Mon, 20 Apr 2026 17:39:14 +0200
Message-ID: <20260420153934.504865441@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hasun Park <hasunpark@gmail.com>

[ Upstream commit 2594196f4e3bd70782e7cf1e22e3e398cdb74f78 ]

Add a DMI quirk entry for ASUS HN7306EA in the ACP SoundWire legacy
machine driver.

Set driver_data to ASOC_SDW_ACP_DMIC for this board so the
platform-specific DMIC quirk path is selected.

Signed-off-by: Hasun Park <hasunpark@gmail.com>
Link: https://patch.msgid.link/20260319163321.30326-1-hasunpark@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-sdw-legacy-mach.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/amd/acp/acp-sdw-legacy-mach.c b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
index 4f92de33a71a0..2e0f751afe250 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -111,6 +111,14 @@ static const struct dmi_system_id soc_sdw_quirk_table[] = {
 		},
 		.driver_data = (void *)(ASOC_SDW_CODEC_SPKR),
 	},
+	{
+		.callback = soc_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HN7306EA"),
+		},
+		.driver_data = (void *)(ASOC_SDW_ACP_DMIC),
+	},
 	{}
 };
 
-- 
2.53.0



