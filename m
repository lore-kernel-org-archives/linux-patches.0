Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028634;
	b=BXWzDtAXIzAbitDkBxQ0f2eYSq/4LSQ9wwK6Vg3asdvXHkSsyKG5PM9QbXeDoRt613xw
	 d7aDyCdWpkqDj+tl2snTOQo/AEXOzQiZ2DqYsluP5eWGaDXt5nk1c5b1Zn61kAtSiJsfj
	 LnkW8fqMGnHeT99yw82UtTTlnC8CdPP3xffcjFp6sB9LW1NN+zV38DfvHdKns4V6+D8EK
	 cqq2OlXoKGZOp8MAUBnla2K4dwn3YTzSvekVaiAWRYzeBKHCm36fgbzkqfUUpQr/MlwUD
	 DNcbieNFyCvZsRh7m8f9YSfAp2bTTcN6fNMUxKtXX832rpcUsEsbEqhVfq0gUEKF8fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X3ZfY5Oc6I7ME0CdJkC+nYUJcmEg0N3zLyNkh5zB0To=;
	b=POxhUOr4P0KrrYfCZ7/C6wenbSpe/wDhzXsf7qx0YNzK0ZT2bsZgCNgAZ4e01/dn6ZJA
	 9Oiy4MBTD6TPBgcdyuvOWOkmBElkxS/gFozrzmSilmyN1Kv6N9hwa4Cv0n5ZA7Ngic/bR
	 ztLs6STeeVN8kAHm1Zg8FwTpLIrwjHQOJI7XFlWE8dG3xIpgNObHK+YFRhtbuza1K7TXG
	 jdOfmgK1e4f3EoE8pknsZfO2FJuBWqcFquouLCRd8FF4dKIFpMz0+GZesxOVIJ4GjSCDY
	 qERCF33+EtUcFNzZ0tqYcMehotnTkalsBIKd7R54rCOOcVxwGf96SJdEDIOFKWneDGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=08SRBfh7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7E2606A31C;
	Wed, 18 Nov 2026 19:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=08SRBfh7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F9D1F000C4;
	Wed, 18 Nov 2026 19:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028634;
	bh=X3ZfY5Oc6I7ME0CdJkC+nYUJcmEg0N3zLyNkh5zB0To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=08SRBfh7YfibpZmuK7B7RDuPMZPGqyAAnh81JKPHL/OkNlH+AD/9MijbshT4kJVi5
	 H7CUB4aomsV/SAXVibPOFDppQC2GgjuctmF8b9gv7fSRrRaXoRE0zrHXhPsNDwUBDa
	 z+TejyxgxWrVG93+qCTvI4Xyciiz10ag68AaozJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0063/1756] hwmon: chipcap2: synchronize ready IRQ state
Date: Wed, 18 Nov 2026 15:36:30 +0100
Message-ID: <20261118150010.861824354@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8d2f7ba4c1789..e466f8f39d52f 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -120,6 +120,16 @@ static int cc2_enable(struct cc2_data *data)
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
@@ -127,9 +137,6 @@ static int cc2_enable(struct cc2_data *data)
 		return 0;
 	}
 
-	/* clear any pending completion */
-	try_wait_for_completion(&data->complete);
-
 	ret = regulator_enable(data->regulator);
 	if (ret < 0)
 		return ret;
@@ -159,6 +166,9 @@ static void cc2_disable(struct cc2_data *data)
 	scoped_guard(mutex, &data->irq_lock)
 		data->process_irqs = false;
 
+	if (data->irq_ready > 0)
+		synchronize_irq(data->irq_ready);
+
 	/* exclusive regulator, check in case an enable failed */
 	if (!data->regulator_enabled)
 		return;
@@ -503,8 +513,10 @@ static irqreturn_t cc2_ready_interrupt(int irq, void *data)
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



