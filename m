Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022531;
	b=1YzyJROJpGUXn4EAGbVW8F2YmylmsTDzY7PKW+i/mQFxtjEidYW5II29lQqRysZUalza
	 VH4k9kG6+HZaRn42favZWEJgJmJpFSnVEhNEMH61gY1CXso52W7+hZbg+qGANo8pNbQmK
	 EPxbtFlJjZDFa3MhwyWu2InomerBG81GDFvRDDyfBg4DdcNMbLRaXc9mjzAL4gpBQfrQu
	 HD7bOrBldCCYg4BuVSb5+3W+7LjDXINn2rFOSqYk0kLTjAiZxbG4tNZ2Q5uaCdANjyPeF
	 4wtCaS4p9UbwlxBtv61drnHx/bKphZDaP+JtDiaBB8JZa86a8LCz54/LMAMNE+BVX3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022531;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KjAaf5xeDokF8u4SQ12pZ8E4Aq64YFB9pg2e4EOvWGY=;
	b=cVbUEcQobg3hut31douV5Bw8UcAPZfeBBSOsIWCDRFkvtA5XQwXK9mv9KzuQ9YwTVYBT
	 PdCzVTfheAWwwEkWyGdD1djgSxzbXe1UrKvEIFpRDe3JpCyU8zQ0Cv7BjGxd491kNsWAY
	 SfBXFCKQouEPqA4Z5bSJCE0dEw59Wac10zOj3slcvT32OJJ3aAN7h9Hp13Ihz+dyYGN/x
	 E3yj46TcWOTJ/inzJEnW2uyHNeM4Qb1MPuHn2j3fBnZTsLtHEFJA5NubrstUbK2pUrPat
	 wSq0IpSjAVx0E4w07VZpQhH1AEnXMRjXaf988CCoodf78cgBIHRkFOTQ+TYyL6pm/7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2tQ0N73q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22565606A330;
	Wed, 18 Nov 2026 17:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2tQ0N73q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769901F000C6;
	Wed, 18 Nov 2026 17:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022531;
	bh=KjAaf5xeDokF8u4SQ12pZ8E4Aq64YFB9pg2e4EOvWGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2tQ0N73q/DT+hsuJvuyEui5pcJ7eeOeokoYkisYUWOvs57DHe+XRad7ecowZ+5Oq/
	 qtcWOcZse9hLI167hi4xQsUqZJkbwWzD18T8z0uKY6f4P4MqUbwkJKDAMBiO6CNqle
	 GRfWrsQ2vWKPAftJBCkoqhOUypbhoXo3a3BKop5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0044/2151] hwmon: chipcap2: synchronize ready IRQ state
Date: Wed, 18 Nov 2026 15:29:39 +0100
Message-ID: <20261118150123.316055302@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8dca9d1e9945d..2bbb707cc1f5a 100644
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



