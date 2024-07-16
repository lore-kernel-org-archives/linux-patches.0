Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D46419F498;
	Tue, 16 Jul 2024 16:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145788; cv=none; b=PDW4JHPEwDxy/X7D/s62/lUjEs72P7spd3Fy7axzBLlrb3Ah9QTh3OaCFKPpqsfVGfLYe7ZLFZs+lYBTQRoPMslqgYZrnxTdJX6e7jCHbOLPgfWybs7DT+kuxZoXo/4p5Ue7ghsjX229tGycV5WP78CWGzf3JEvXkQuEJpjZOl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145788; c=relaxed/simple;
	bh=FmNAgN9w1XoAc+DZi5bgUJt23EOlWEvkeRlpOZE/rSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6y0FZL+ngsKtkigQhkd4ihfje66opYb7ERzVMuw5VBVg3Orecl4/H3OsXaWZjoGZmQCVZeycdjslpjAo2XKX0+2/2MfSH2+H+aqOlNAxoetp2AYdE6O+K5qP1R77UHuUfKLs69UmxKyWEsiYre3PG5brxlbgN4xE2yrjxELbsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kNMEdJW8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kNMEdJW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87951C4AF0B;
	Tue, 16 Jul 2024 16:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145787;
	bh=FmNAgN9w1XoAc+DZi5bgUJt23EOlWEvkeRlpOZE/rSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kNMEdJW8DhHzodys2Ch4OmGYbC/U15LG7CNUFJJcn3ezEbkUBqRCHbNVDCleii29F
	 U+k8bu1nR80plqLfRo0aYofYrevDcqQT4rjgL5+CZ4a1VDw1LnB+WBh6vPi/kuOwku
	 IaNpCjYRzuy6hvVtRhb3OKH4XdDWp/SW1WHH10KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jacky Huang <ychuang3@nuvoton.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 083/121] tty: serial: ma35d1: Add a NULL check for of_node
Date: Tue, 16 Jul 2024 17:32:25 +0200
Message-ID: <20240716152754.521430138@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacky Huang <ychuang3@nuvoton.com>

commit acd09ac253b5de8fd79fc61a482ee19154914c7a upstream.

The pdev->dev.of_node can be NULL if the "serial" node is absent.
Add a NULL check to return an error in such cases.

Fixes: 930cbf92db01 ("tty: serial: Add Nuvoton ma35d1 serial driver support")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/8df7ce45-fd58-4235-88f7-43fe7cd67e8f@moroto.mountain/
Signed-off-by: Jacky Huang <ychuang3@nuvoton.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20240625064128.127-1-ychuang570808@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/ma35d1_serial.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/ma35d1_serial.c b/drivers/tty/serial/ma35d1_serial.c
index 19f0a305cc43..3b4206e815fe 100644
--- a/drivers/tty/serial/ma35d1_serial.c
+++ b/drivers/tty/serial/ma35d1_serial.c
@@ -688,12 +688,13 @@ static int ma35d1serial_probe(struct platform_device *pdev)
 	struct uart_ma35d1_port *up;
 	int ret = 0;
 
-	if (pdev->dev.of_node) {
-		ret = of_alias_get_id(pdev->dev.of_node, "serial");
-		if (ret < 0) {
-			dev_err(&pdev->dev, "failed to get alias/pdev id, errno %d\n", ret);
-			return ret;
-		}
+	if (!pdev->dev.of_node)
+		return -ENODEV;
+
+	ret = of_alias_get_id(pdev->dev.of_node, "serial");
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to get alias/pdev id, errno %d\n", ret);
+		return ret;
 	}
 	up = &ma35d1serial_ports[ret];
 	up->port.line = ret;
-- 
2.45.2



