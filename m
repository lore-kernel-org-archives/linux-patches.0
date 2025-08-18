Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12973219A7E;
	Mon, 18 Aug 2025 13:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524116; cv=none; b=hlEuG8FE+1zM5Wt5CeHToTIt+nEY+IQr2qWlZfbFOuo4SbzjU1oYD9H5D7qa7naVrdKn3vZInWswuByZSC4tZ9ATWarpo/N9PgBYnui8jkXouucIVTc3OzsPAS3VXbFoTLdpDgtP3BrRsLRJRXTl+rNviUTQon47/VNfPMZSPvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524116; c=relaxed/simple;
	bh=Nq/nYQcXg8MuyzJpalYDsCBYT3FtbnGYl54j9m/z92s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oq762/8v0+CxDx7YEFsPjE6ixKUETZZy4XDrv7LbPU+ojado6dsvU3zlWndOlA29nIvAirvhtjR8oXR+AcIR0qja1pcATqBJYq7muwy3gAsfXjlbA4xkLx2u55zSEJCj6Mcsv+YtDnLciQ+p7WJBL+NAwYPOQykXNkGR63MKRis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ac0Y4Hmb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ac0Y4Hmb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87330C4CEEB;
	Mon, 18 Aug 2025 13:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524115;
	bh=Nq/nYQcXg8MuyzJpalYDsCBYT3FtbnGYl54j9m/z92s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ac0Y4Hmb93nd6YOLbSUCj1Db0olpdgqUA7+YWvSBdZ+6cKgMfLNFDKMyrU5yaks5K
	 BVz0iGRmDj4w9ZncaWXlr3J5RmPeGUFyetp4QWSNTVj8npcTmJPcpKFjv/WdY6oOom
	 eTdqOg6ADl+KMEFQ7N9MlV2wi06PFE5OgmC0n9pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheick Traore <cheick.traore@foss.st.com>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 373/515] pinctrl: stm32: Manage irq affinity settings
Date: Mon, 18 Aug 2025 14:45:59 +0200
Message-ID: <20250818124512.775658534@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheick Traore <cheick.traore@foss.st.com>

[ Upstream commit 4c5cc2f65386e22166ce006efe515c667aa075e4 ]

Trying to set the affinity of the interrupts associated to stm32
pinctrl results in a write error.

Fill struct irq_chip::irq_set_affinity to use the default helper
function.

Signed-off-by: Cheick Traore <cheick.traore@foss.st.com>
Signed-off-by: Antonio Borneo <antonio.borneo@foss.st.com>
Link: https://lore.kernel.org/20250610143042.295376-3-antonio.borneo@foss.st.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index cc0b4d1d7cff..ba9dbb21b497 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -408,6 +408,7 @@ static struct irq_chip stm32_gpio_irq_chip = {
 	.irq_set_wake	= irq_chip_set_wake_parent,
 	.irq_request_resources = stm32_gpio_irq_request_resources,
 	.irq_release_resources = stm32_gpio_irq_release_resources,
+	.irq_set_affinity = IS_ENABLED(CONFIG_SMP) ? irq_chip_set_affinity_parent : NULL,
 };
 
 static int stm32_gpio_domain_translate(struct irq_domain *d,
-- 
2.39.5



