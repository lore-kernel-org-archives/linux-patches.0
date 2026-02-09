Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC3A23B604;
	Mon,  9 Feb 2026 14:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647456; cv=none; b=D9R24R0Ui42PI8wWeWlpzz292SoVl1HEYP+FfNstGV7jMcyxvz57n7mB7Xosf0Vi/Fv7BmPq2FWjtAZcErtgrQ3QHABHiff2iFaABupYdP91Sax4srfB5zBQLKiUtphDtzbH0B9deAQDTg73234e1v8OPCDZw8rZZZ+jXLim3DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647456; c=relaxed/simple;
	bh=xoYEupr1HnHHePBjeEZRWVPqua/eEW0Jmpza8r8wFQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwY2KNhjGf5eEH7lgrMge5WMwNd50QyWsQ7QS/sq3EFWqv5VNoGDsh7nwoaRgOh63ueIxWIgr4x4DBP4YM/37p7U8vhKgwgw5BgukFdia4o59X+pK1cFi1YL22+giUOCp/SFjqTr2/mlVZnr1FUZW8DnGzKgJp/RKUIeIY3LARM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWdYvLW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWdYvLW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A818C116C6;
	Mon,  9 Feb 2026 14:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647456;
	bh=xoYEupr1HnHHePBjeEZRWVPqua/eEW0Jmpza8r8wFQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWdYvLW39QmmTGIslBvHJSeytkLtmzf30GHhxQyEm5Y785DKmAEfLGVvkgryKn3vb
	 dhdI8QlWhbFv/16S34oJUsn7awGTJVEjdShXLfsqiFJgOZSYABVKSIHpl72P3xxM09
	 cMwNl4c84DiedKvls4CPKdEsF7r6/sFZJ/8IuJtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 088/175] ASoC: simple-card-utils: Check device node before overwrite direction
Date: Mon,  9 Feb 2026 15:22:41 +0100
Message-ID: <20260209142323.599780943@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 22a507d7680f2c3499c133f6384349f62f916176 ]

Even the device node don't exist, the graph_util_parse_link_direction()
will overwrite the playback_only and capture_only to be zero. Which
cause the playback_only and capture_only are not correct, so check device
node exist or not before update the value.

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/20251229090432.3964848-1-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/simple-card-utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/generic/simple-card-utils.c b/sound/soc/generic/simple-card-utils.c
index 355f7ec8943c2..bdc02e85b089f 100644
--- a/sound/soc/generic/simple-card-utils.c
+++ b/sound/soc/generic/simple-card-utils.c
@@ -1179,9 +1179,9 @@ void graph_util_parse_link_direction(struct device_node *np,
 	bool is_playback_only = of_property_read_bool(np, "playback-only");
 	bool is_capture_only  = of_property_read_bool(np, "capture-only");
 
-	if (playback_only)
+	if (np && playback_only)
 		*playback_only = is_playback_only;
-	if (capture_only)
+	if (np && capture_only)
 		*capture_only = is_capture_only;
 }
 EXPORT_SYMBOL_GPL(graph_util_parse_link_direction);
-- 
2.51.0



