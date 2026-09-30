Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB80509EF3;
	Wed, 30 Sep 2026 18:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792890; cv=none; b=u3TDv5Ums5LAM0Z766ZHYlTwXzFPiPTkEoKRCnVn8qmWuMUEe5rXQpqjp2Av6KpvA5dDO7mkQvaFn1zDcovZR+P7HwgstXvXZxcI8ygLUT26iUS/b4tMsgQ4QnGJ3//iwBzoEdtBhbNFEO9ad/S91o+1b0bfHIacc61wetyuHlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792890; c=relaxed/simple;
	bh=AvnK3ZstbEsgzvZ/Ps8b5kEreDpTyG0OvQWXnHKVXWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IH3qZsys/vYUo2CGlw6mS+d7Qj5EZPsJEOaBzZw7hPzsQLagzJXu25C4sNpunURkjQmtf42Tb2Ih5uTiUWmW43BVE6oSncqAxct804PTV4BOY82r7xcrCJ28wwTQ587nsHZX0dJ3aslFTHC37s72xuRS59hPSJWkD+b6Ti96jLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0PRut+03; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0PRut+03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3419B1F000FF;
	Wed, 30 Sep 2026 18:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792888;
	bh=XVmQkOizDoUAOFnPkxhDTUbWi6KMXpeEMLkxDqiQgtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0PRut+031SVkD5AJItuXNIKJ5lB2PoRnNLv+3HJhdcvI1R2i0mW28o9145N0Q40PE
	 frSp4HZ0nGDaQXcD4KuNzZDO5GOfw2TkvVijgVu1joE7Qwp7253/kwb605j03w6v3v
	 Dqgf0jV7MHmB6Its1Bp6W1UFoe+Ik4jbu6bvNkrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Kyle Hendry <khendry@reliablecontrols.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 060/395] net: pcs: rzn1-miic: Fix config array initialization
Date: Wed, 30 Sep 2026 17:25:22 +0200
Message-ID: <20260930152341.935545153@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
index 885f17c32643b..cea350745a7b6 100644
--- a/drivers/net/pcs/pcs-rzn1-miic.c
+++ b/drivers/net/pcs/pcs-rzn1-miic.c
@@ -594,7 +594,8 @@ static int miic_parse_dt(struct miic *miic, u32 *mode_cfg)
 	if (!dt_val)
 		return -ENOMEM;
 
-	memset(dt_val, MIIC_MODCTRL_CONF_NONE, sizeof(*dt_val));
+	memset(dt_val, MIIC_MODCTRL_CONF_NONE,
+	       sizeof(*dt_val) * miic->of_data->conf_conv_count);
 
 	if (of_property_read_u32(np, "renesas,miic-switch-portin", &conf) == 0)
 		dt_val[0] = conf;
-- 
2.53.0



