Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7EF408035;
	Fri,  4 Sep 2026 05:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500156; cv=none; b=TiefyyEh2uUyYLJiIKmVOy0ILPMxqOp86xwzTb8KsFp8+Z056kzATv9uPBXFWKZpzY3JEWVLlakvJK4dmgjHBynfhnsTHfOw+UuYxBeyf4UxFXdZN/sf5dQYNHpkGk8MAcr32K6GY+JWvCcbVIo7G9tiJSHEBvmwJbGfD8smCQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500156; c=relaxed/simple;
	bh=6m3LlVQWCCJLDdNkUWsxdaucwFOjnSzxcqLfv96K3HM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOCtR6IIeDp8p6FXi3m8GMkX4iMImzJmSXeI0jG5GT/MM0ULesweOGnwDFRISSj+I9auLLj+fdujCySnUB2Khq0ZNL5Emf9vYhW2H6Bou2FCkCqjcsZKy+mHaQUZzGbugWEbQDuKBdU0hfGacCt9U53mn253z9wJ/CJ8GWwRF9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cNJLPx3C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cNJLPx3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420671F00A3D;
	Fri,  4 Sep 2026 05:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500154;
	bh=tCVTOaY0rYjpQfcAuI55tv+1HsyK60vgYhEfhzpBiWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cNJLPx3CicIAV1Izwz1Bi4nCsIzphCEXlBuZ2xrQaHD8jGx06BRYbTc8N5XuL8ppF
	 vPbAkpBI5Fi7NDF455jR4lAvgcwnJHA4Yy5bZ8jP61PFlpQTiVyuHlP3Z/nvGbzaA2
	 cw0ifyx6/2U8J+hbOG2qR+dXsQ2O28CC/nXoyCcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 7.2 669/713] i3c: renesas: Clean DATBAS register on detach
Date: Fri,  4 Sep 2026 07:00:37 +0200
Message-ID: <20260904045818.832093385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

commit 797ed83c0cd495be4b345750c59e0363bf4d6207 upstream.

The controller uses DATBAS registers on TX/RX logic. Clean the DATBAS
register for the detached I3C device to avoid issues.

Fixes: d028219a9f14 ("i3c: master: Add basic driver for the Renesas I3C controller")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/20260713130545.568657-8-claudiu.beznea+renesas@tuxon.dev
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/renesas-i3c.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/i3c/master/renesas-i3c.c
+++ b/drivers/i3c/master/renesas-i3c.c
@@ -924,6 +924,8 @@ static void renesas_i3c_detach_i3c_dev(s
 	struct i3c_master_controller *m = i3c_dev_get_master(dev);
 	struct renesas_i3c *i3c = to_renesas_i3c(m);
 
+	renesas_writel(i3c->regs, DATBAS(data->index), 0);
+
 	i3c_dev_set_master_data(dev, NULL);
 	i3c->addrs[data->index] = 0;
 	i3c->free_pos |= BIT(data->index);


