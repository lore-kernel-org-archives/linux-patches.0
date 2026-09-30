Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C533BB138;
	Wed, 30 Sep 2026 19:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796392; cv=none; b=t7xwlfAfZzg0rrnvpl4yOsnS+KbowwyCNhIbzFVGQmu4SRF9aUmawnrSx30AVg3xcbwnNPUik65nEfgcpyuGx4GWQTv3XZyUzDgCsipn0zQGBigVxNyPGzkoQB3UycJfB1CMovZLPQg1ilzIllSgKTxPpCDmU9+mONE8k2Z49WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796392; c=relaxed/simple;
	bh=0KF+XnfbGrSHLODfNUdYECAC0CbPIWsBG7394J9U0gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oW+7FreqAt0FDbrZhPHlkfVwH3SIjVdSIrZXI43Q9VddkzCP+m8HGgyUhqa6MG5xDlIuvqZ9G6zsumMvehWu6HTQFByCgT4Wftm0hk9SxAvaAQ0QQxm5s8tkABonqYQwwlR+0od+RLhKytYECuhEMRZzqaFBszm55LFbFgdsP5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnwGTqq6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnwGTqq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375711F000FF;
	Wed, 30 Sep 2026 19:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796391;
	bh=1r1i1Wf/BHE9tL+9BHpUrraIiW6AADR61mdRCL0pWPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AnwGTqq6OqGdWKLARdk1jmVSBR+jl7ucpbLAKIhwQD+tUm2KyHA66OoheOHs7RpH7
	 RdaVxKMDFEwyVRB8UEbaSI+MZLCqD0sV90aN4JiDQ91b0pzq5IWujDQysW3gSPfT5c
	 moK6D/nxrcEyYsn1yiGre+6x2iFkoVYDpIYjVIh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 0895/1193] Input: cyttsp5 - clamp the HID report size before memcpy
Date: Wed, 30 Sep 2026 17:26:19 +0200
Message-ID: <20260930152454.127925636@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


