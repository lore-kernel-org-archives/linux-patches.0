Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DFD4DDB23;
	Wed, 30 Sep 2026 16:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786980; cv=none; b=NIN5H1MCK99ZnViv0+r/vVbTlYcqTPShVH8x7PP6intI9kyROqUF/bx9YxxDEis4KWqDiw4dJtsl9B9ktIpHZDKNN8vx0IX28wnTrXOFf3/FQsQrMA8OTE1NwGPADPgb11J5sVJfDZV+uagykVXcz9Ci/HQLKIQwi+gDyfZSvmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786980; c=relaxed/simple;
	bh=2ak4TNoUimjXxkh1+z3aNjs0oIqJZt/fMLhnQN1HEJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNqRj4GWKxUYQGJOpzieFhK9hMt/MTvTcmp90SMQgRNFf/N8kw7OLkbcoa0s68WEIHi4Cm7WRR+GJNfrCgqU48esnGTNBtGc81urwGF5JxAixMati4VZg8bdv8ssDsF64REltcKlasvr2/Qy60YRVNDHAxlrlC+grNWoJG8fbZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cVW6zIVm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cVW6zIVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01DC1F00893;
	Wed, 30 Sep 2026 16:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786978;
	bh=VizPG/gDKo1AjQaorb8AsmVUTnuFLZyEinGEeZqFbxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cVW6zIVmlHhOw2N3XvEIknA3GeQFtlZ/w1p5xx4rMFFhxN2M7LxeLQiyBfCHCyM8N
	 oMAHRJaPfAjXGI+UpedUbhwkb2NCmE1ZRnW/hQgd6XihOWjnNEEcgnQj6DYXFTUHKi
	 hh0h+lml6xNBo6PkkLpFRUFbsnTrLYwgmpR3x3Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Kyle Hendry <khendry@reliablecontrols.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 070/457] net: pcs: rzn1-miic: Fix config array initialization
Date: Wed, 30 Sep 2026 17:22:55 +0200
Message-ID: <20260930152347.560269515@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Hendry <khendry@reliablecontrols.com>

[ Upstream commit daf677c2c6449011ee695d55b48b5b2977a36f88 ]

Fix memset parameters to initialize the entire DT value array

Fixes: f39e968dc168a7bd ("net: pcs: rzn1-miic: Move configuration data to SoC-specific struct")
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Kyle Hendry <khendry@reliablecontrols.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://patch.msgid.link/20260915-rzn1-miic-fix-array-v5-1-b7173fd5b97d@reliablecontrols.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pcs/pcs-rzn1-miic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/pcs/pcs-rzn1-miic.c b/drivers/net/pcs/pcs-rzn1-miic.c
index 2b72fa98ddf13..cb74861e823c8 100644
--- a/drivers/net/pcs/pcs-rzn1-miic.c
+++ b/drivers/net/pcs/pcs-rzn1-miic.c
@@ -683,7 +683,8 @@ static int miic_parse_dt(struct miic *miic, u32 *mode_cfg)
 	if (!dt_val)
 		return -ENOMEM;
 
-	memset(dt_val, MIIC_MODCTRL_CONF_NONE, sizeof(*dt_val));
+	memset(dt_val, MIIC_MODCTRL_CONF_NONE,
+	       sizeof(*dt_val) * miic->of_data->conf_conv_count);
 
 	if (of_property_read_u32(np, "renesas,miic-switch-portin", &conf) == 0)
 		dt_val[0] = conf;
-- 
2.53.0



