Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065344;
	b=E+3bAAHq9HAgnBMcNcVRoN2c+vIQ32DS/HHtRkWZu0hZIaTApm0281k74xnPv7RQJVuO
	 hWwJG2VQDPxLjh/THzU9mfvHAOgDXEUqY0DofRjhAqW/x2l2xEClcaUGheXuX9454U88v
	 svk4unth1/YaDL1fxqo7BN0CQJ3NXdpRfDxioTBUpEdZKgDaOkbmvD7md6PA0eM9eKNGA
	 CbR7q04NUiDz7cEWUz0rj7DkhvsVBzYwoRMI+tCAxV6OOJQNVhcAHleGX2zNQQuBYWHnx
	 le7+Tqf1nYzZMCSX+A3qRo1doaSnJM1wzol8C6czo8iMv/nTcIgCF4N4jrSBG1ILJbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ptnSOVszen+J8UufZiTa/PBGsc0DD9f8VMO8UPL2QPQ=;
	b=B88S0m36l0CHFZn4MFssKKhrf2aOLqcnbp5dQl5r0x2HgMd7+B9TvoQDlz5uqU2puFtS
	 YQC7hU+M4j1ybMaW7RcCleLNdoD+i7PKcRz22ai41uaDaPTPSgeNOXsLYC6UvpBKUstQO
	 s73oXE1e06tLMrchJrxleRHvbB2y6MTQ7nGdGrSlk1pdA4ce+OHw1spOsvyH6TRexuJSx
	 qa0v3GCVOKlhgCRLZtaqXECarTLQoB3YH9fCElaparwdhA/g1rgq/X3+ac6gBDO4NgrKK
	 t4sA/2DLgzsc+/XeQd7OT2RQc2Hn907d10++mfPPfg4ZL4VPc5IVrS6KAEo+RmWPseg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dgF5sVaN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FCE606A326;
	Sat,  7 Nov 2026 15:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dgF5sVaN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CB61F0089F;
	Sat,  7 Nov 2026 15:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065344;
	bh=ptnSOVszen+J8UufZiTa/PBGsc0DD9f8VMO8UPL2QPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dgF5sVaN4AgPQf9I0B6FZhXSCfCwuHR3VlNF9KHv3gy/40cyhb2SksImYNw9UZmAf
	 mt1Qb4/a4igBJU4VleJoOAi60piCMfLEJkl171Te4LNWN2Tc8tSNtkWgbZDr6bLH4i
	 5aJoUNozZ8s0EiLtK8ViK2v8k1vjiqq2kmu3Uq2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Adrian Ambrozewicz <aambrozewicz@nvidia.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1033/1257] gpiolib: dont report -ENOMEM for a requested line without a label
Date: Sat,  7 Nov 2026 08:55:29 -0500
Message-ID: <20261107135007.853882731@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Ambrozewicz <aambrozewicz@nvidia.com>

[ Upstream commit dae739137441667d67fbfcc4d303a0ecc6618662 ]

gpiod_request_commit() sets GPIOD_FLAG_REQUESTED, calls ->request() and
only then sets the label. A line in between has no label, so
gpiochip_dup_line_label() passes NULL to kstrdup() and returns
ERR_PTR(-ENOMEM), which for_each_hwgpio() then passes to kfree():

  BUG: unable to handle page fault for address: ffcc73074355ffc8
  Call Trace:
   gpio_sim_dbg_show
   gpiolib_seq_show
   seq_read_iter

Return NULL for such a line, as for an unrequested one.

Reproduced with gpio-sim: reading /sys/kernel/debug/gpio in a loop while
lines are requested and released oopses within seconds; with this
change, 100000 cycles pass.

Fixes: 35b545332b80 ("gpio: remove gpio_lock")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20261020-gpiolib-chip-removal-v3-0-aambrozewicz@nvidia.com?part=2
Assisted-by: LLM
Signed-off-by: Adrian Ambrozewicz <aambrozewicz@nvidia.com>
Link: https://patch.msgid.link/20261022083343.3905973-3-aambrozewicz@nvidia.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 239c0d54843b3..226ed5b8d4442 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2719,6 +2719,7 @@ void gpiod_free(struct gpio_desc *desc)
 char *gpiochip_dup_line_label(struct gpio_chip *gc, unsigned int offset)
 {
 	struct gpio_desc *desc;
+	const char *name;
 	char *label;
 
 	desc = gpiochip_get_desc(gc, offset);
@@ -2730,7 +2731,11 @@ char *gpiochip_dup_line_label(struct gpio_chip *gc, unsigned int offset)
 
 	guard(srcu)(&desc->gdev->desc_srcu);
 
-	label = kstrdup(gpiod_get_label(desc), GFP_KERNEL);
+	name = gpiod_get_label(desc);
+	if (!name)
+		return NULL;
+
+	label = kstrdup(name, GFP_KERNEL);
 	if (!label)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.53.0



