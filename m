Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2D9379EE2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301692; cv=none; b=c8iVR6vTba4Nn12y9Aa6VYI2686qx6qyoXcj6xRvMqfI8m5sbFssXiQY/x7SVA+OTUg2jbG2b5nuK6BZVOWFonKb142WgM5o35XQ5TD8k5exdLkrEjqSO9iEdoQr3vra7NDjsd6V844cprO75RYEnr19POkoghgrlqqhuSCsTYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301692; c=relaxed/simple;
	bh=qQ8SRzWNg80Ad38u4kZjfmfvHTa/ixcIDRm6XOwk8tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2LK1mg/lbPo3vhF+1laO3qI8WHUzixEjWsqRmOXlf0SGOA4qt45og3YnlW4NuBVPTu83IH+Asqgx2osCVafz7d/2lMoF7UNVHU3RtRNFCkdVeRzZlPU8rkKuwsUr6GZzv7h1DNlszgH42UB2vTIgVU6/jQOtxaLZYGjUlyj52U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WLY4lhyt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WLY4lhyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD422C116D0;
	Sat, 28 Feb 2026 18:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301692;
	bh=qQ8SRzWNg80Ad38u4kZjfmfvHTa/ixcIDRm6XOwk8tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WLY4lhytW4hG5KaFz4+Z5hVtzGmKeLzVijBp/RU79PpMCNmujZdAlmRVIDv3PQZ7S
	 9lJJwteIVbMVrw++45U8cM8APmXyiDmWoSeQ88VfvjJz1bKhJheguAgBfunxxhzSU8
	 2y6OqnGAGEqG2th89ypL0T6RpHLS6vL6UlvxMHGKFkf/XspMGNBh+WDWAcGi9nGG0F
	 BXXgDdZRC1VCu5qzO8h2s9A1j+esQIKN+6iFrW9rL0tXuSLQUWTLcAR28WWKV68PRO
	 yendeQm7LluTb4DBHOUrq/FQ6w/eTpFMgmIUZaxlt7N1UjY2dndO/OWWIQ3uBg9aW1
	 ELu/RZ57eA8Sg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/385] media: pci: mg4b: Use IRQF_NO_THREAD
Date: Sat, 28 Feb 2026 12:55:05 -0500
Message-ID: <20260228180011.1568201-83-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit ef92b98f5f6758a049898b53aa30476010db04fa ]

The interrupt handler iio_trigger_generic_data_rdy_poll() will invoke other
interrupt handlers and this supposed to happen from hard interrupt context.

Use IRQF_NO_THREAD to forbid forced-threading.

Fixes: 0ab13674a9bd1 ("media: pci: mgb4: Added Digiteq Automotive MGB4 driver")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260128095540.863589-21-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/mgb4/mgb4_trigger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/mgb4/mgb4_trigger.c b/drivers/media/pci/mgb4/mgb4_trigger.c
index d7dddc5c8728e..10c23f0c833d5 100644
--- a/drivers/media/pci/mgb4/mgb4_trigger.c
+++ b/drivers/media/pci/mgb4/mgb4_trigger.c
@@ -114,7 +114,7 @@ static int probe_trigger(struct iio_dev *indio_dev, int irq)
 	if (!st->trig)
 		return -ENOMEM;
 
-	ret = request_irq(irq, &iio_trigger_generic_data_rdy_poll, 0,
+	ret = request_irq(irq, &iio_trigger_generic_data_rdy_poll, IRQF_NO_THREAD,
 			  "mgb4-trigger", st->trig);
 	if (ret)
 		goto error_free_trig;
-- 
2.51.0

