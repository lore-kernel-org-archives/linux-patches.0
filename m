Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDE53A451F;
	Mon, 20 Apr 2026 13:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690955; cv=none; b=YvXb7vehq+Z5eG3sVJupP+nnCXpU5vccHPPgdIh9joUQLhQ0MaNH/h8Pt8AWzOMF6Iu66f8CReyXiafxQ9ZHclkD1o9FlN1BeWAddWZtzm4fn9VICharr7WmKkjf8VTm61qNbDIlds+6EBHs+gUnzqSuTLuaQG1qvrVRhUPS+po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690955; c=relaxed/simple;
	bh=rin35+9vT4DY1bInuQye8vN8xXn//w1ChbUG8r247Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWU2PagT7Gg8yDyWRHo6H2eAS+meHZTQ8QNPmC0rdzF4pBH9DVTOVxxr/17SFQmGszlD90GHs0g0IEiV4zlzH4959GJbNA6cbgwHq0LOkn8T2rKPqIsalmtnwKroIbAPqvBGHkl/d9CJRmtg+kvrJKwEbnt5i/Jq2L4lvgtbIVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BPNVlaTW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BPNVlaTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DFBC2BCB8;
	Mon, 20 Apr 2026 13:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690955;
	bh=rin35+9vT4DY1bInuQye8vN8xXn//w1ChbUG8r247Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BPNVlaTWsFZ/jwjEvM67TuhUTqIEzAJDLUsUkyRoQmk2Uv2hT1ZYdimLlGSp3Wj2n
	 /vShBNrXjn/neUcR0poTg3m4D64ISD+MkekpmKVYS1EV6oy2hbuTUci9ZRfqE6Mwtz
	 8HDa2dRGUHicloTIleKMDh/9+vMNWbpsmQrcKWN0F7tadj02xITau0rAlqAUWUpDsn
	 qYTWrcMLwlqifM8cbuA2oqrd7HtdKN+uRq5BM87N/CxTgNo9+SEvtCXFY6JszeVp3x
	 8i86mQ3sxCyCwrxn3WCMvJn31YXiU/8pLmn1myx38ON4tMPKFLHvqegOA9jiu9MOe3
	 cNOb8YojF9nJg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hasun Park <hasunpark@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ASoC: amd: acp: add ASUS HN7306EA quirk for legacy SDW machine
Date: Mon, 20 Apr 2026 09:07:56 -0400
Message-ID: <20260420131539.986432-10-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 sound/soc/amd/acp/acp-sdw-legacy-mach.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/amd/acp/acp-sdw-legacy-mach.c b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
index 86c534d827448..504b700200660 100644
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

