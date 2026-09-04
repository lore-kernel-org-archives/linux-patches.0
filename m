Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5C33ECBCF;
	Fri,  4 Sep 2026 05:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500170; cv=none; b=gEtMRMMWJf0uh3lnEywQ/peRxQeFwwMZcZbOtWCNkAtdXLRVNPx8m0y8oPL2vnIWgSk7K2UZPcN4vn7LoFxeJ7oXiqf5MYe8JYg+dyDV85hbMO9qFq4biYjnTzadpvKc4pCpAA3VWR+eKQp9gWnQpEZ8d8rjWuH9sY0gHDdO3g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500170; c=relaxed/simple;
	bh=xnaQYOoilqh/VKLjzHujxmT8jvnXK9Unp4YodH/gD1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=reu7yTjkzxqM8Ixiwp0OA4emBcCjB/BBDlJSKd+LYFwiDzDqg7kCQNq8YzfKiYizpVzDEEf4E4EeNsMfVsMfyPZP3MnL/XFbHm93qrRqOQhre6V1XlgoypIlCsgPKS2TAhX5WohUCtcY8aTa+Iu8Y/adhTDEYT8tx/FLRNMFf1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1Fs83FA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1Fs83FA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9324D1F00A3D;
	Fri,  4 Sep 2026 05:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500169;
	bh=7GPjxDTa14L1DBEY+uwnhVQIJ64mYOqvM0lGTPcQyOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K1Fs83FA+Z6iRy4I0212r5yz/95eyB1CscF7UHAcAEniy7NbRS8Io2KBVj7QWCAgu
	 tjwHTlGg6rOIU5F9zG9ggqOP7ZTgPHeSkUgKeKbdrlnJ2meOx55JynjTFGTsH00Hha
	 8+gEWNBLiKpfR1uFMj82/f+D5xzejquOaJWCMUxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 7.2 673/713] i3c: renesas: Restore STDBR and EXTBR registers on resume
Date: Fri,  4 Sep 2026 07:00:41 +0200
Message-ID: <20260904045818.919936507@linuxfoundation.org>
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

commit 21cded44e69c630799e65baadb72ad123d1347c8 upstream.

The Renesas RZ/G3S supports a power saving state where power to the most
SoC componentes (including I3C) is lost.

The STDBR and EXTBR are configured in initialization phase though the
struct i3c_master_controller_ops::bus_init. Set them on resume function
as well to keep the same state of the controller after a suspend with
power loss and a similar initialization sequence as in bus_init.

Fixes: e7218986319b ("i3c: renesas: Add suspend/resume support")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/20260713130545.568657-3-claudiu.beznea+renesas@tuxon.dev
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/renesas-i3c.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/i3c/master/renesas-i3c.c
+++ b/drivers/i3c/master/renesas-i3c.c
@@ -260,6 +260,7 @@ struct renesas_i3c {
 	u32 dyn_addr;
 	u32 i2c_STDBR;
 	u32 i3c_STDBR;
+	u32 extbr;
 	unsigned long rate;
 	u8 addrs[RENESAS_I3C_MAX_DEVS];
 	struct renesas_i3c_xferqueue xferqueue;
@@ -622,10 +623,9 @@ static int renesas_i3c_bus_init(struct i
 	renesas_writel(i3c->regs, STDBR, i3c->i3c_STDBR);
 
 	/* Extended Bit Rate setting */
-	renesas_writel(i3c->regs, EXTBR, EXTBR_EBRLO(od_low_ticks) |
-					   EXTBR_EBRHO(od_high_ticks) |
-					   EXTBR_EBRLP(pp_low_ticks) |
-					   EXTBR_EBRHP(pp_high_ticks));
+	i3c->extbr = EXTBR_EBRLO(od_low_ticks) | EXTBR_EBRHO(od_high_ticks) |
+		     EXTBR_EBRLP(pp_low_ticks) | EXTBR_EBRHP(pp_high_ticks);
+	renesas_writel(i3c->regs, EXTBR, i3c->extbr);
 
 	renesas_writel(i3c->regs, REFCKCTL, REFCKCTL_IREFCKS(cks));
 	i3c->refclk_div = cks;
@@ -1494,6 +1494,8 @@ static int renesas_i3c_resume_noirq(stru
 		goto err_clks_disable;
 
 	/* Re-store I3C registers value. */
+	renesas_writel(i3c->regs, STDBR, i3c->i3c_STDBR);
+	renesas_writel(i3c->regs, EXTBR, i3c->extbr);
 	renesas_writel(i3c->regs, REFCKCTL,
 		       REFCKCTL_IREFCKS(i3c->refclk_div));
 	renesas_writel(i3c->regs, MSDVAD, MSDVAD_MDYADV |


