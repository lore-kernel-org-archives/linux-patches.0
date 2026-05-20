Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56BA3D7D66;
	Wed, 20 May 2026 17:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298741; cv=none; b=JhnyPsEU3pnNG2QOGXpyJUyVC54B7ogyTKrJIuFrCGN+hgbESKOj7CPaI4vPMN4tNGGTO6vUjgAswcJL1qUPlSH0/SjgiqSid6J6ebrz7K5kXeh89FQi4wd/D4E6FAx9FcE4NhUM5zgENwryASKwzA5bGy4l2enN+4IsB31xf5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298741; c=relaxed/simple;
	bh=f1KFYi06XsidkpZUD9+EY4QEDRh27EnTgnWiX3k7N0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=je+s4dSV5KHWJtRlK/PjwR84qa/aXGgAIKlJQPQLBq4BUHb6PbXk+oa47nE+GeyVTW6qUKhbqeJzr0449INi3VhDKWyzGm4TjmHjdbT5qdXfdtEo+qDnOggGrECc8Cq02oIAbVqvmrajUYnvE608OQgaqXp9t75yRI0sFlInF7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t3M0h1pp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t3M0h1pp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C3E1F000E9;
	Wed, 20 May 2026 17:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298740;
	bh=SmZQ+lVTXQNr7m1DWDjUJzL92ufMa5CDg4BVjT674bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t3M0h1ppIVYHzkwiDF6Pn0mcrsnj91cfeSkgb01vnci51SYUGJAbXwo5B7Omt0J/I
	 9/SD/HY/yk6ZtVnVRW6ZwOken/ujgCH/RPgmSyvroCXarhzhWp9IFJ+Q/yqZLEFcUi
	 lHP/ox9KD6JURxrKtoCoyPMGcAzPn2J3/xfkWC9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Frank Li <Frank.Li@nxp.com>,
	Felix Gu <ustc.gu@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 524/957] i3c: master: renesas: Fix memory leak in renesas_i3c_i3c_xfers()
Date: Wed, 20 May 2026 18:16:47 +0200
Message-ID: <20260520162145.898022517@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit d7665c3b4f575251e449e2656879392346ca612b ]

The xfer structure allocated by renesas_i3c_alloc_xfer() was never freed
in the renesas_i3c_i3c_xfers() function. Use the __free(kfree) cleanup
attribute to automatically free the memory when the variable goes out of
scope.

Fixes: d028219a9f14 ("i3c: master: Add basic driver for the Renesas I3C controller")
Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Reviewed-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260406-renesas-v3-1-4b724d7708f4@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/renesas-i3c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i3c/master/renesas-i3c.c b/drivers/i3c/master/renesas-i3c.c
index 275f7b9242886..5b1bf5a0266cc 100644
--- a/drivers/i3c/master/renesas-i3c.c
+++ b/drivers/i3c/master/renesas-i3c.c
@@ -8,6 +8,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/bitops.h>
+#include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/err.h>
@@ -800,13 +801,12 @@ static int renesas_i3c_priv_xfers(struct i3c_dev_desc *dev, struct i3c_priv_xfer
 	struct i3c_master_controller *m = i3c_dev_get_master(dev);
 	struct renesas_i3c *i3c = to_renesas_i3c(m);
 	struct renesas_i3c_i2c_dev_data *data = i3c_dev_get_master_data(dev);
-	struct renesas_i3c_xfer *xfer;
 	int i;
 
 	/* Enable I3C bus. */
 	renesas_i3c_bus_enable(m, true);
 
-	xfer = renesas_i3c_alloc_xfer(i3c, 1);
+	struct renesas_i3c_xfer *xfer __free(kfree) = renesas_i3c_alloc_xfer(i3c, 1);
 	if (!xfer)
 		return -ENOMEM;
 
-- 
2.53.0



