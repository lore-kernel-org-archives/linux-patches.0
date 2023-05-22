Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F637168DC
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0B4C433D2;
	Mon, 22 May 2023 19:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784064;
	bh=s72tG+owOxd2jQa0PcjeIq9KRK2nC41g3mGC1A/T7x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=REWYD4O2WdbBfa9D3lh8qo4TwVHKY1Eqtrub0yv/3Tgi3NzUl3ysi3isypC4eOmHT
	 /Hz4G8K4qQtF2BXA+42yobItlqPJoSNWj8CS6ixKHhBfMWK0P9ks5Yb2lN4vE/2LwB
	 ypcvtPz1Cv/7onj+KEW9ISswJW8F26PuK/pZr9Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 252/292] can: kvaser_pciefd: Disable interrupts in probe error path
Date: Mon, 22 May 2023 20:10:09 +0100
Message-Id: <20230522190412.246570354@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jimmy Assarsson <extja@kvaser.com>

commit 11164bc39459335ab93c6e99d53b7e4292fba38b upstream.

Disable interrupts in error path of probe function.

Fixes: 26ad340e582d ("can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices")
Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/r/20230516134318.104279-7-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/kvaser_pciefd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -1861,6 +1861,8 @@ static int kvaser_pciefd_probe(struct pc
 	return 0;
 
 err_free_irq:
+	/* Disable PCI interrupts */
+	iowrite32(0, pcie->reg_base + KVASER_PCIEFD_IEN_REG);
 	free_irq(pcie->pci->irq, pcie);
 
 err_teardown_can_ctrls:


