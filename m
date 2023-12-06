Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1083D1A5B6
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 23:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t1v/QW/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5250AC433C9;
	Wed,  6 Dec 2023 23:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701904657;
	bh=xHlmGR20SCrHf8Fi+WuUdvFz6wf3sL0KK/pWnjjJEHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1v/QW/16H+qXUvY+0BysMSAcM1TrX8UQoPoodoywnixyHSWOX0FleDPIUyTbzsKh
	 Fdp39iypGh5vfvEkubP/VBns0GzPnRPHZx67aEAdvYBFhmlZz3/3aRgNoH23J5JdI6
	 mIOPe9o9uqQihp3rNJwVvQVYCgyYzDHqyqdL73IZPu0Svyx+c9PkqQUM9YH1Gny9Ly
	 WKTYtGbmr+Sb9SlWp5+VcnH+98sqWoa6swfZmd1yE5D4b7cXKmv2ZG629mYM7Cgi0P
	 +Wcg66LT40iYTvGlAFr51Jk5G/BWc8GgtlMPMwAX3CWAN4Gahea5lP7S9dYMEsZkEa
	 fATtFkcS851Iw==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sen Chu <sen.chu@mediatek.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 8/8] spmi: mediatek: add device id check
Date: Wed,  6 Dec 2023 15:17:31 -0800
Message-ID: <20231206231733.4031901-9-sboyd@kernel.org>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
In-Reply-To: <20231206231733.4031901-1-sboyd@kernel.org>
References: <20231206231733.4031901-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sen Chu <sen.chu@mediatek.com>

Add device id check for spmi write API.

Signed-off-by: Sen Chu <sen.chu@mediatek.com>
Link: https://lore.kernel.org/r/20230518040729.8789-1-sen.chu@mediatek.com
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/spmi-mtk-pmif.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/spmi/spmi-mtk-pmif.c b/drivers/spmi/spmi-mtk-pmif.c
index cc660da6a037..5079442f8ea1 100644
--- a/drivers/spmi/spmi-mtk-pmif.c
+++ b/drivers/spmi/spmi-mtk-pmif.c
@@ -384,6 +384,12 @@ static int pmif_spmi_write_cmd(struct spmi_controller *ctrl, u8 opc, u8 sid,
 	u32 data, wdata, cmd;
 	unsigned long flags;
 
+	/* Check for argument validation. */
+	if (unlikely(sid & ~0xf)) {
+		dev_err(&ctrl->dev, "exceed the max slv id\n");
+		return -EINVAL;
+	}
+
 	if (len > 4) {
 		dev_err(&ctrl->dev, "pmif supports 1..4 bytes per trans, but:%zu requested", len);
 
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

