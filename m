Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585547;
	b=auejx54Ay5DNQkWy6J2pgMcykW2VcGBbFwddHAs0w/44YQ8eVKvONbBYlpGmBIenERw8
	 0RiIQGEJ9bVYkbBvlT0XJQ4t48xOd+HIrf7bwplIHNm8jiIgyj33nRS1qJbFdtEwdpcwW
	 Z9Fy8QHuufBIK1E9Y7PJVgBghqW9rm/GG2La0J3pZbs/K+N/ikzx7dgD2DG4pj+gsWVce
	 RsiGQszTJEEZE2CpJSCcKgqAnjeKRnBgSVnFSXyfLuLNTd5a8ONoYRwy+jWIJ1qG+ZWi7
	 ov9iQBf+uw60+x0V/TKatTHHukW3OBrIrKVs4soNaJqlvWI+txtPDKhENmitx64v5gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KcYMXFaVHpa2CNf7LbepA/A/Dn0ZvrC8B/bASgGm1eU=;
	b=ZFoURVBv0J+7ojDkkokL6u4B8NkNCa4jK/EAiM1PuLFCipMY5Fvr9IgC7CdYZYg+jqVF
	 5aplzDm/tBAdiRPsX/hz4OaECm+F0enXQBnSq96ymdSbF//kmWvj27XsXqtHkhTCCfp/2
	 qPRsoqykhUMzuC+YuX1Ju0XDyfyNRWAqCeciGyScgHDYnyBuh22Ox9InaLMGQBEiLbNnc
	 zKJZ0jikEhio7X4kHw/wSVy2FRzHtktBQc2GB1ODdTTviGJy2U+0EoGrkJKo3sztG0xUl
	 7ys0lP9FhIt7VnegSQIt9Ndbp/w1+2MtApI3ch7lr8zcRafSc2OPQs14Ad2v2vp/Alw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qfbanpVz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB8E606D473;
	Fri, 13 Nov 2026 15:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qfbanpVz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5921F000C4;
	Fri, 13 Nov 2026 15:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585547;
	bh=KcYMXFaVHpa2CNf7LbepA/A/Dn0ZvrC8B/bASgGm1eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qfbanpVzYB3levMJjCJWfs75FmUASvItuRun+M+ifC/BCDxBXFCQjobOV4S1MKSSW
	 X9ENdTp1Oh4jRHYrfKouHgWQX7eWf6L1+g3e1Q51tJX43lUDuP7C2yDUmrEV7tZvgK
	 LOnVcbXFm+UY6gtQenDnZfn1tM1PGvcK9BC9BHBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 183/507] hwmon: chipcap2: synchronize ready IRQ state
Date: Fri, 13 Nov 2026 10:48:07 -0500
Message-ID: <20261113153800.684822766@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 8c02722be2caa6604a837b81faeaba78250eda4a ]

The ready IRQ handler can race with reinit_completion() in the enable
path. In particular, a handler from an earlier operation can complete
the completion after it is reset for a new operation.

Use irq_lock to serialize access to the completion and process_irqs.
Disable IRQ processing and synchronize any running handler before resetting
the completion for a new operation.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-11-27ebfc2c5b9e@gmail.com
[groeck: Dropped obsolete 'Assisted-by: tag]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index b3b725cc7224f..00f62a33d4637 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -123,6 +123,16 @@ static int cc2_enable(struct cc2_data *data)
 {
 	int ret;
 
+	if (data->irq_ready > 0) {
+		scoped_guard(mutex, &data->irq_lock)
+			data->process_irqs = false;
+
+		synchronize_irq(data->irq_ready);
+
+		scoped_guard(mutex, &data->irq_lock)
+			reinit_completion(&data->complete);
+	}
+
 	/* exclusive regulator, check in case a disable failed */
 	if (data->regulator_enabled) {
 		scoped_guard(mutex, &data->irq_lock)
@@ -130,9 +140,6 @@ static int cc2_enable(struct cc2_data *data)
 		return 0;
 	}
 
-	/* clear any pending completion */
-	try_wait_for_completion(&data->complete);
-
 	ret = regulator_enable(data->regulator);
 	if (ret < 0)
 		return ret;
@@ -162,6 +169,9 @@ static void cc2_disable(struct cc2_data *data)
 	scoped_guard(mutex, &data->irq_lock)
 		data->process_irqs = false;
 
+	if (data->irq_ready > 0)
+		synchronize_irq(data->irq_ready);
+
 	/* exclusive regulator, check in case an enable failed */
 	if (!data->regulator_enabled)
 		return;
@@ -510,8 +520,10 @@ static irqreturn_t cc2_ready_interrupt(int irq, void *data)
 {
 	struct cc2_data *cc2 = data;
 
-	if (cc2->process_irqs)
-		complete(&cc2->complete);
+	scoped_guard(mutex, &cc2->irq_lock) {
+		if (cc2->process_irqs)
+			complete(&cc2->complete);
+	}
 
 	return IRQ_HANDLED;
 }
-- 
2.53.0



