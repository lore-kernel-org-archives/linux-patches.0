Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A94387361;
	Tue, 10 Mar 2026 11:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141937; cv=none; b=M33/rSxlRO0Nboig5HisUqPEet+POmmxIFr/2IgKUGh1xcT8rBPoxAJsQoFOOvpxlrT7ots1/RPdAs89ZRYsLsfFM7pYJ0yVIF7onZm/XQE202w3ELMGImAcwHOGQ70Pck0afxe6DUxh1BmwJFmgIVg1Eb/RbNkOqEhpvTP4yN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141937; c=relaxed/simple;
	bh=ibFK0H6tkI3FNdOrqJy9FiRaU14NuWz5Iae4Q86LMCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uohl1q7IVCWnXF7puTCbINySG0Ca3V0gImo27VmALpkLdZahQRk33LTzFUp9z00fnvSRg6EinzZK411oWiS4Q7UbbMlB9gHE4VdQx7ipKSu8Mk1EKFhe73odKFYXPCV18YaMVPDu6BMLW5e6SGeDp6oT80XPoUCDuOyWTuSsYfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g8b+0Z6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g8b+0Z6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F48C2BC9E;
	Tue, 10 Mar 2026 11:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141937;
	bh=ibFK0H6tkI3FNdOrqJy9FiRaU14NuWz5Iae4Q86LMCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8b+0Z6gLoYKv5ndjYgINu/4MhTxtFhSHC4cwnGDUwWIM6tfLBtF0NJBJMV8sReob
	 d/mHRLl4Vfh/omOl6MsloKDWS6UglO457Uk+AeQCAD/uPWOnxnLYqQtqm3Evsor1CU
	 pRFeyTIkNoc2vd0GqkPpAdqQt9fA8SkoiHGWECYAThn9GixzxrUMWeg7/Q2wI5ImAB
	 41O/ki/2TXtUYhOXMUGSR6flYMs6pk7QEdLZd4T1Ups9j8+L3pjqDhWSqD4HBgN1qY
	 +KL/M3+FVwEp9B/E56GodumuOo7gcwIeRbrE+22zaz8wfW9HgJ6XFZvqTbxpr6JQKn
	 shnsWBt4MmGvA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 061/314] ASoC: SDCA: Fix comments for sdca_irq_request()
Date: Tue, 10 Mar 2026 07:15:20 -0400
Message-ID: <9cfd1c62771975d4bca2d42c1a7e45dfb77a1b8a.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 71c1978ab6d2c6d48c31311855f1a85377c152ae ]

The kernel-doc comments for sdca_irq_request() contained some typos
that lead to build warnings with W=1.  Let's correct them.

Fixes: b126394d9ec6 ("ASoC: SDCA: Generic interrupt support")
Acked-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260226154753.1083320-1-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_interrupts.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sdca/sdca_interrupts.c b/sound/soc/sdca/sdca_interrupts.c
index 79bf3042f57d4..f83413587da5a 100644
--- a/sound/soc/sdca/sdca_interrupts.c
+++ b/sound/soc/sdca/sdca_interrupts.c
@@ -246,9 +246,9 @@ static int sdca_irq_request_locked(struct device *dev,
 }
 
 /**
- * sdca_request_irq - request an individual SDCA interrupt
+ * sdca_irq_request - request an individual SDCA interrupt
  * @dev: Pointer to the struct device against which things should be allocated.
- * @interrupt_info: Pointer to the interrupt information structure.
+ * @info: Pointer to the interrupt information structure.
  * @sdca_irq: SDCA interrupt position.
  * @name: Name to be given to the IRQ.
  * @handler: A callback thread function to be called for the IRQ.
-- 
2.51.0

