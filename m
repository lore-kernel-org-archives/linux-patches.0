Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8EA4BEE2A;
	Sat, 12 Sep 2026 10:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210527; cv=none; b=KUPtuUopmA9mSUArdf/fp4kFuEwx7VdWUmwEp0ypFUXCO2MKhEao/UhKqA/2Hsai2RyRz5UT7BySF2mPHtmR4Be7INLUs5G/DHtI/S3u3rqb2qcBa3lsuIvJVUvOudOGBQr1jCdUtICIQ4ReYyytXr26Hn9y6KBxHShtcQa8CBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210527; c=relaxed/simple;
	bh=nMbhurTmVOZSlffa/XZlWws1P60Cn6INvyntfA1MDQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlqq7b9ffHXWQtxcIl4/GluKyLT92P1X45YRlqTU+c5bgZqD9mt6GGGC+4Rnsqw8v+2stStmVKVXd2bPsid337OIMADc3w/BkUOsJF5cxLOn+5hdPD9Edwrnen32Ap4BWn8Y31r+fu2UZysh4I1P86WFZCTUPvhWFaW+znjVGcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZd6dJf1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZd6dJf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA9E1F000FF;
	Sat, 12 Sep 2026 10:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210526;
	bh=LU+093f8AcfHCawDX+L3XmuGUEfX+pv6HHS1wzFbrIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BZd6dJf1Q01WtQwNU4pcOy7/ScJDEGs2JNZV/Ne54f8Z2WeBurnjhBnFtDsz3mIMN
	 4HEsm+jQFihVRRMD1pFDsXZKxPLUctt0PKTChWGBEyQXWfbKE2oAQX+nPlv8cnEhIu
	 0hZ+apHaDQCtx3HniQqcL0ekqBF4XsNdPdyMhpkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Frank Li <Frank.Li@nxp.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1043/1518] i3c: renesas: Return immediately if there is no transfer
Date: Sat, 12 Sep 2026 08:53:32 +0200
Message-ID: <20260912065647.046671644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 33b5ecc5a16e270c8e0dd9835e7d9d2522f64129 ]

There is no need to allocate a transfer structure when i2c_nxfers is zero.
Return immediately instead of unnecessarily allocating memory.

Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/20260713130545.568657-11-claudiu.beznea+renesas@tuxon.dev
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: b6e56fd8c8a8 ("i3c: renesas: Don't register devices when ENTDAA times out")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/renesas-i3c.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/i3c/master/renesas-i3c.c b/drivers/i3c/master/renesas-i3c.c
index b6c4dfc51fe5b..b12f548543643 100644
--- a/drivers/i3c/master/renesas-i3c.c
+++ b/drivers/i3c/master/renesas-i3c.c
@@ -940,13 +940,13 @@ static int renesas_i3c_i2c_xfers(struct i2c_dev_desc *dev,
 	u8 start_bit = CNDCTL_STCND;
 	int i;
 
+	if (!i2c_nxfers)
+		return 0;
+
 	struct renesas_i3c_xfer *xfer __free(kfree) = renesas_i3c_alloc_xfer(i3c, 1);
 	if (!xfer)
 		return -ENOMEM;
 
-	if (!i2c_nxfers)
-		return 0;
-
 	renesas_i3c_bus_enable(m, false);
 
 	init_completion(&xfer->comp);
-- 
2.53.0



