Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8943343E096;
	Sat, 12 Sep 2026 08:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202744; cv=none; b=iYlYEkuia4n001EcaX7/UnhzDOXSmFKDKxwljS5PVDF7hxmZA+XsSVrRggv4rzvGnn4HZzWUW1nZTgMeun1Wsl/fg0II1WBGh4ORVFrZ7GHl3Rg43RjLERqEDlYVNjNsBxKE0shQUiAPQhLxV1mBsEq/95ByHrOjUyOjgjFgJpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202744; c=relaxed/simple;
	bh=xGWFUvudB5863BnGtKSj+2F/kg2V57gvzG4vnDYV6SU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSGOnAeyh4o0mOB7dEZms7KtHKPVCCBVqwQIe4SRZp0uf3RGyN0L7MDf6JJTtLH/3VOdyD6SpCe5UsIjJu1OvKPKNTNKCx4MAqIIW2YM6wxOwuvYgpNuHlbF9PuOXTohPgEDDnbYeuF+7AKGvzC0uKkHsutfrC1B8HChDLF8TwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mEDy9LLP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mEDy9LLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFF91F000FF;
	Sat, 12 Sep 2026 08:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202743;
	bh=sYJwczUUftPFELYzJof3Awp8VI4Dkuw6gB6h0UYcN5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mEDy9LLP/t+OPme2Blob9oDuLmF2qygYzpDWUFz2hSv52h5oFSIyUzVy6RUZ9b+UY
	 CcqFXcYLdZbCsfBDRKVkuk0KzaKRmSIlWVhFz9NkWGp1GLFfis60qn39XO+f1dei+2
	 4MnZqAMSCf2tPTJ64G2maWTnHuZwKLO+cqlH3xGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Frank Li <Frank.Li@nxp.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1265/1815] i3c: renesas: Return immediately if there is no transfer
Date: Sat, 12 Sep 2026 08:50:15 +0200
Message-ID: <20260912065718.713448757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index c459e40fd5ffc..424bc239c132f 100644
--- a/drivers/i3c/master/renesas-i3c.c
+++ b/drivers/i3c/master/renesas-i3c.c
@@ -957,13 +957,13 @@ static int renesas_i3c_i2c_xfers(struct i2c_dev_desc *dev,
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



