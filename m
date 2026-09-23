Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9C853A3B6;
	Wed, 23 Sep 2026 14:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175016; cv=none; b=BXrIJnoL5M287FxFeSFxtYkXHCaA3wNELhk9odvW9+1oW4dqAvdVIXKzRS9cnawe1ze0ZY8KQeelNtMEJnqs6yVFm16ZGJmAc+QH7MMrgil3VN1DqOhzphpHo4NefsMgiZ5k3eIiGix/bo1qBJdC4onENL1Fv4X7vxybAorwI9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175016; c=relaxed/simple;
	bh=E0ZiWSlwPgLYruoyAgoFFNnJR6aDphE6DA+xnhuj/vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNoewP554svYDFyc6DRCeYUnbs6q2w22qUAOhjsrLQ9AhTs1DnpMi/bMKep0o8hV0qgB+j6ZkBiEid1f7OXNnf2gZtaiu8GSGL6p/WCSH2hQcCq0RLDWY2I74MedhKoDsD6e1VaDTb4awT31pGMqLwMlX9d62x/QtQh7DDOx3xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ufYdB7aQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ufYdB7aQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48101F000FF;
	Wed, 23 Sep 2026 14:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175015;
	bh=ETd4yeoxT2bYmHwdLPOymSUrOd3iilZMM0QWG2XdAts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ufYdB7aQ4RP71dPksSNcritSI3BBz06U2YFWu7bn3mrmqfqPxBLR5MWA+jxjNMUNb
	 RvntSlWT7fh2VkTklDZhBIGJ/g/5m9suo3B/C8g+Bk59lPmHXl0v0RAqmkz8Cs59Y4
	 UHUPRwX68ubyUYZYXqNBHMaBPhU5Rq47cmR9Po3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 296/398] Input: cyttsp5 - clamp the HID report size before memcpy
Date: Wed, 23 Sep 2026 16:06:10 +0200
Message-ID: <20260923140651.095174662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Linkai Gong <gonglinkai@kylinos.cn>

commit 85f080fb87ed5cd3e46121be677f52c82f26a0ab upstream.

The size field comes from the device and is used as the memcpy()
length into response_buf, which is CY_MAX_INPUT bytes.

Fixes: 5b0c03e24a06 ("Input: Add driver for Cypress Generation 5 touchscreen")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Link: https://patch.msgid.link/20260901122649.1173066-1-gonglinkai@kylinos.cn
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/cyttsp5.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/touchscreen/cyttsp5.c
+++ b/drivers/input/touchscreen/cyttsp5.c
@@ -711,6 +711,7 @@ static irqreturn_t cyttsp5_handle_irq(in
 		size = 2;
 	} else {
 		report_id = ts->input_buf[2];
+		size = min(size, CY_MAX_INPUT);
 	}
 
 	switch (report_id) {


