Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2A3569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE75C433D2;
	Sun, 28 May 2023 19:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301957;
	bh=WRz3vTAwf2EbxCfKrr/MP2/BD8jcLkHG5ZtZpLmlqFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUfl/tqqcS76YHWYOt1Ze1xEZAprsSkANXhHU7K+m2s+JBzSt/dnXIdZ1MvfIAxlf
	 9g/D4urN5j0kr3ZU0Rr+GMF738b8CXfxQOty4SzXAMyBOZ/lQp0UK2k0T/u8/5+r4p
	 mQOP5z6FFK3tbUbLklt9fUSt3+qOAV5g/b4CNvgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 096/161] can: kvaser_pciefd: Disable interrupts in probe error path
Date: Sun, 28 May 2023 20:10:20 +0100
Message-Id: <20230528190840.172417710@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
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
@@ -1859,6 +1859,8 @@ static int kvaser_pciefd_probe(struct pc
 	return 0;
 
 err_free_irq:
+	/* Disable PCI interrupts */
+	iowrite32(0, pcie->reg_base + KVASER_PCIEFD_IEN_REG);
 	free_irq(pcie->pci->irq, pcie);
 
 err_teardown_can_ctrls:


