Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9E03603D5;
	Sat, 12 Sep 2026 16:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231773; cv=none; b=WhlVHlaY7+mGjtkjq7nLKF/JIevUoa5vziID/b0tNi2bpLRBidDjju3zTlRxx+e0PknDFZw/0ZczwkbCvOq5ImSZAD9lUtH3Pq1ykO7UoRMYhQUesSry2aCsZKY7/NCM8GKbB8xKFFsw80uK82pkFu8TbqH47PCXa2ksSgkjyPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231773; c=relaxed/simple;
	bh=TpVcavaOP7n9pY1hjIyZD1naMhfMshwcGlqXHixjpQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmZxFaxVwh67JI+gDB/UH6X2c9dwPPbeWDlCQlXj1oKtayaazaXP6rfKmu72HYxpKzXWBv+YF2DBfUqz+sHq6kLFZ1+oqMghgf1363fjYl5MJZTtLed/8b/zxxIOcyqjVe5W6bpLzvZyL9p5ObJs3d61XGWxAwwLwwV452yyJOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sayXt/fX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sayXt/fX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446541F000FF;
	Sat, 12 Sep 2026 16:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231771;
	bh=qj08cbEz1Ds7AkatIb2xAtS5rHHpc3UHBqOKbpqznjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sayXt/fXGpnzmVLeBncWydQM4QSPpajKkNWiPnr8OP/va5hpsEodY1WTmWli52LDa
	 OhkZLXF6A0KF2Ids4f6xTcIXaJFhhpxhgu26BiDI0JoNFeFLhurWJTezZa9jsQ7Aix
	 PNQ0bDSNzYmHITPWOUuF64z9ijW+x0qtwVBQHZRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Yen <Patrick_Yen@asmedia.com.tw>,
	Jian-Ming Liao <Jm_Liao@asmedia.com.tw>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1068/1191] i3c: mipi-i3c-hci: Fix missing STAT_IBI_STATUS_THLD in PIO mode
Date: Sat, 12 Sep 2026 09:03:16 +0200
Message-ID: <20260912065612.162416481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jian-Ming Liao <Jm_Liao@asmedia.com.tw>

[ Upstream commit 308ecb824db329a8e22dd0b10f2a3411a6fbbde3 ]

In PIO mode initialization, STAT_IBI_STATUS_THLD was missing from
pio->enabled_irqs. As a result, the host controller interrupt signal for
IBI threshold was never enabled when transfer starts, preventing IBI
status descriptors from being properly processed in PIO mode.

Include STAT_IBI_STATUS_THLD in pio->enabled_irqs so that the IBI
threshold interrupt is activated alongside error interrupts upon the first
transfer.

Fixes: 9ad9a52cce28 ("i3c/master: introduce the mipi-i3c-hci driver")
Co-developed-by: Patrick Yen <Patrick_Yen@asmedia.com.tw>
Signed-off-by: Patrick Yen <Patrick_Yen@asmedia.com.tw>
Signed-off-by: Jian-Ming Liao <Jm_Liao@asmedia.com.tw>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260818104106.763772-2-Jm_Liao@asmedia.com.tw
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/pio.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/pio.c b/drivers/i3c/master/mipi-i3c-hci/pio.c
index da28934a63286..d8ef51cea6e2b 100644
--- a/drivers/i3c/master/mipi-i3c-hci/pio.c
+++ b/drivers/i3c/master/mipi-i3c-hci/pio.c
@@ -187,8 +187,11 @@ static void __hci_pio_init(struct i3c_hci *hci, u32 *size_val_ptr)
 	pio_reg_write(INTR_SIGNAL_ENABLE, 0x0);
 	pio_reg_write(INTR_STATUS_ENABLE, 0xffffffff);
 
-	/* Always accept error interrupts (will be activated on first xfer) */
-	pio->enabled_irqs = STAT_ALL_ERRORS;
+	/*
+	 * Always accept error interrupts and IBI threshold interrupt
+	 * (will be activated on first xfer).
+	 */
+	pio->enabled_irqs = STAT_ALL_ERRORS | STAT_IBI_STATUS_THLD;
 }
 
 static int hci_pio_init(struct i3c_hci *hci)
-- 
2.53.0



