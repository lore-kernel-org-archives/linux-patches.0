Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4B02D24B7;
	Tue, 10 Mar 2026 11:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141081; cv=none; b=oCEOBPci9KFCGfFsGnWMuSChJTKMdAJWGZrrJn5Nl27j4qA+tdsfWIIOe0OcDHM91ZrClAKdfLrt85wWDYjMThthxKy9vv9Yzd6dWBimUnCg/fzYGONrfTmtdLyo7aBs7srNidNzntYojE32N/0XHETi+rtkSVbGqGAXMX4KZ2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141081; c=relaxed/simple;
	bh=g/vbj5Kb7n4YwXgxFXfsDTRHeTSLwUr5CNKhocKeaag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukX3RmGhNcxzh8T7n/fndnxjqYdPPsjR/+AwDYlTYHKMZJRLTuR6p7aQlEnaJRRYe6BLcPnPWgjrKzkt+P+AhfTHIIQHeYiVjo5w64EP1QjxFokPdJcvyrkySwTtoqSvtTvCi1ASwgHea67qJIMV1NCLUzOhGIilqeN25R6D9lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n4s1rZBU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n4s1rZBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871EEC2BC86;
	Tue, 10 Mar 2026 11:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141081;
	bh=g/vbj5Kb7n4YwXgxFXfsDTRHeTSLwUr5CNKhocKeaag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4s1rZBU8QhINoaHDl1aMYGdF9Ag1AI3+TFfDGI2Ju4JCibTxT3qpURoJyO1etvsS
	 NlTN3+P5hPnnh1NU0CQQhaaI2tiYRGeFjXC+XLY6vFE48lsO6hCcy1+ijf7RiD0TTN
	 2Y0JNtrEKEfyi3hPrVaJXCXUuNjGVhH6HoxIGqdiRuTe8H3hkhWbF9dGWogl+V6shK
	 6vf18DDtJdgjwpFQx2U+Z9Pxbt9ZRl83VMjY1v5sI6XDAwr1at9PXYiVRTUyB/wIHJ
	 nwnbjLU4fBAARWE6V98kUxKFVP/gfisVzIop3gUK3ikyB2NmJyba7yA+ijJIZoJDDz
	 +Fl9jLEdhf3Kw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 081/311] ASoC: SDCA: Fix comments for sdca_irq_request()
Date: Tue, 10 Mar 2026 07:02:08 -0400
Message-ID: <ba7baaf90b2818f7ad77f292cb100adb1af6a19d.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index ff3a7e405fdcb..49b675e601433 100644
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

