Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F45A171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30FEC433D2;
	Mon, 22 May 2023 19:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783304;
	bh=QICWxuVBGk0ImBsvXxod1gs9WgMc/laPy4CSbbuwNzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QAWgd/RoT0r0QTjz0B3KZPKLUBfljFEBWzTckixU5SOL+Ulu+RBcly9cPbqUEFqHO
	 rIrH9T6ao6oEn0p48dZVM6WrkeWFJHEOsVxgka+raJC+ucYqbtQQFHe68OddosLc4c
	 5GrwNrCmKSbS3DxtJB0nHaezSsbWpDeZKLB6KMUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 180/203] can: kvaser_pciefd: Clear listen-only bit if not explicitly requested
Date: Mon, 22 May 2023 20:10:04 +0100
Message-Id: <20230522190359.985043580@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
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

commit bf7ac55e991ca177f1ac16be51152f1ef291a4df upstream.

The listen-only bit was never cleared, causing the controller to
always use listen-only mode, if previously set.

Fixes: 26ad340e582d ("can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices")
Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/r/20230516134318.104279-3-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/kvaser_pciefd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -561,6 +561,8 @@ static void kvaser_pciefd_setup_controll
 
 	if (can->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
 		mode |= KVASER_PCIEFD_KCAN_MODE_LOM;
+	else
+		mode &= ~KVASER_PCIEFD_KCAN_MODE_LOM;
 
 	mode |= KVASER_PCIEFD_KCAN_MODE_EEN;
 	mode |= KVASER_PCIEFD_KCAN_MODE_EPEN;


