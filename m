Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618136;
	b=ELmXG+RRLwEaeMX6goX5W4FPFvDqc20u3Uda/0XAKNmFbh0OWWzsuOzvmBvVcXvIS88Z
	 lhrW2pEGk/fVLEu2NyWfXJ6rPPhSQTwejy9Fm+5QHo/jyCi9gXgLIskUgN4O3FAvwT1TD
	 MwhJ1a646Q2QST97CGCfRTU1o0hDrQDhLcTqWDmv9CeXxSII7S8xwyZPQjGDPMjLyb6YA
	 3zWryMvDVxiysSCo6cYtB7VWpbTxezNcBd5uAkrChA7Dn5nT0yITWE2k4zbpiuunxPzjS
	 sgGPHWLaYt/Apk2vGHop76NHp9fy1a/7aTyDA6ws7uKTUwWHclC6ddjvAALIHuIp2Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618136;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6VO8ujGMQHblkuWVRzu6j/vSyMk3q5hTX+YY3+bxxXU=;
	b=k7PYxwUbZCjkaJX2q/Z3u/a614eBletrTZh/NzaIVWq4lmVYyIEQxfgKkBoLlxdyCTnM
	 nBIHfc99pp9DurI6fGk1SIrz5ck0BeCTXodXMAHLbIcKBYIp15xCg9/Fr2idKuNd5jf0i
	 kfE+F1G5v4+vz5xzKju9Aum+300hTsk1g7oIv73yPjoisuZzwFL0qEo19+n6AgQvoGZDo
	 Buhva4jzoqJ1KLOUJ+R4tb78MlcdKSHnZLBOxX0r25LTku5dqiAgTpCCIvwS5tvchRSsk
	 vT5UU9Lr8v5yDZQdrfnGyTC4N/K0dKu/OYzh2nlZzpKCRChEKoYOnWm/S1BMlHEj2xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gO7qI1YU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49502606A31E;
	Wed, 25 Nov 2026 14:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gO7qI1YU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FD81F000C6;
	Wed, 25 Nov 2026 14:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618135;
	bh=6VO8ujGMQHblkuWVRzu6j/vSyMk3q5hTX+YY3+bxxXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gO7qI1YU/fe+p/Uuea2h828f0WBcEd54tr5kG+2KOiRhEYa7DQVYPaLOHpvdhGtkU
	 mK16e64T6V/gzV6wpQ0HHFdspQDQ3mM4I57LEsJFnLVXBFAFd1ee4tnvHPD2gecxx5
	 Um8BBzDqiBsREvVxkIRgklJ58Qi00s/toXIMpnAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <liguangshuo@mail.sdu.edu.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0167/1005] gpio: mpc8xxx: Fix potential use-after-free of IRQ domain
Date: Wed, 25 Nov 2026 15:25:05 +0100
Message-ID: <20261125143825.654676301@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>

[ Upstream commit 9e4b35c95fede87bad36f68b7ff1eae94ea6b910 ]

GPIO chip cleanup can call the to_irq callback while releasing requested
GPIOs. Removing the IRQ domain first leaves that callback using a freed
domain, both on removal and after an IRQ request failure.

Register domain cleanup before GPIO chip registration so devres removes
the chip before freeing the domain.

This issue was found by our static analysis tool under development.

Fixes: 257e10752c13 ("gpio: mpc8xxx: Use of_mm_gpiochip_remove")
Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
Link: https://patch.msgid.link/a4fec7fe970d6fc9135b488f57ba7e145b809359.1793377433.git.liguangshuo@mail.sdu.edu.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mpc8xxx.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index a6868f6738315..605393d3c9920 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -319,6 +319,14 @@ static const struct of_device_id mpc8xxx_gpio_ids[] = {
 	{}
 };
 
+static void mpc8xxx_irq_domain_remove(void *data)
+{
+	struct mpc8xxx_gpio_chip *mpc8xxx_gc = data;
+
+	if (mpc8xxx_gc->irq)
+		irq_domain_remove(mpc8xxx_gc->irq);
+}
+
 static int mpc8xxx_probe(struct platform_device *pdev)
 {
 	const struct mpc8xxx_gpio_devtype *devtype = NULL;
@@ -405,6 +413,11 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 						       mpc8xxx_gc->regs + GPIO_DIR);
 	}
 
+	/* GPIO chip cleanup still needs the IRQ domain. */
+	ret = devm_add_action_or_reset(dev, mpc8xxx_irq_domain_remove, mpc8xxx_gc);
+	if (ret)
+		return ret;
+
 	ret = devm_gpiochip_add_data(dev, gc, mpc8xxx_gc);
 	if (ret) {
 		dev_err(dev,
@@ -437,7 +450,7 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(dev, "failed to devm_request_irq(%d), ret = %d\n",
 			mpc8xxx_gc->irqn, ret);
-		goto err;
+		return ret;
 	}
 
 	ret = devm_device_init_wakeup(dev);
@@ -445,19 +458,14 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, ret, "Failed to init wakeup\n");
 
 	return 0;
-err:
-	irq_domain_remove(mpc8xxx_gc->irq);
-	return ret;
 }
 
 static void mpc8xxx_remove(struct platform_device *pdev)
 {
 	struct mpc8xxx_gpio_chip *mpc8xxx_gc = platform_get_drvdata(pdev);
 
-	if (mpc8xxx_gc->irq) {
+	if (mpc8xxx_gc->irq)
 		irq_set_chained_handler_and_data(mpc8xxx_gc->irqn, NULL, NULL);
-		irq_domain_remove(mpc8xxx_gc->irq);
-	}
 }
 
 static int mpc8xxx_suspend(struct device *dev)
-- 
2.53.0



