Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94FF8F75
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41531C433C9;
	Sun, 16 Jul 2023 20:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537871;
	bh=G/fRDDXF+wbPdFTF+iImDKj03jTNpdYjWGoxazJ2UaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqfqWmmB8ywtYkIrE3QO6b/jVQKyBBGxZc2//JYV9Rpm4+ec7X3TCWZoR+YO6Xy2a
	 MlvwJAkPm9s7YkrgkYJuYmhGxjmdP46f5rDdf4jEY2pTmQeWLDru6aeAW9B5tbw/tU
	 mJntvphlhYBEknljlwttFhKiklqNP+Duz/A0be4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Michael Hennerich <michael.hennerich@analog.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 251/800] Input: adxl34x - do not hardcode interrupt trigger type
Date: Sun, 16 Jul 2023 21:41:44 +0200
Message-ID: <20230716194954.928494466@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit e96220bce5176ed2309f77f061dcc0430b82b25e ]

Instead of hardcoding IRQ trigger type to IRQF_TRIGGER_HIGH, let's
respect the settings specified in the firmware description.

Fixes: e27c729219ad ("Input: add driver for ADXL345/346 Digital Accelerometers")
Signed-off-by: Marek Vasut <marex@denx.de>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Link: https://lore.kernel.org/r/20230509203555.549158-1-marex@denx.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/adxl34x.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/input/misc/adxl34x.c b/drivers/input/misc/adxl34x.c
index eecca671b5884..a3f45e0ee0c75 100644
--- a/drivers/input/misc/adxl34x.c
+++ b/drivers/input/misc/adxl34x.c
@@ -817,8 +817,7 @@ struct adxl34x *adxl34x_probe(struct device *dev, int irq,
 	AC_WRITE(ac, POWER_CTL, 0);
 
 	err = request_threaded_irq(ac->irq, NULL, adxl34x_irq,
-				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
-				   dev_name(dev), ac);
+				   IRQF_ONESHOT, dev_name(dev), ac);
 	if (err) {
 		dev_err(dev, "irq %d busy?\n", ac->irq);
 		goto err_free_mem;
-- 
2.39.2



