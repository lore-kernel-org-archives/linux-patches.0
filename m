Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5317A171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54B9C4339C;
	Mon, 22 May 2023 19:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684785107;
	bh=h7dh3KkyJjGKYQdkWqhkbHfMUiiUp9Fd9wZiShJylW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=coBWrrrT2Lqbh0elMakwtGwcgEiCYXACj6QoeuujTYaJZ4jY0K7J0zM9cRHRAuLru
	 +4LuBBPyyOIUQn4WK8M/mGInh0NsQEcEyJNqqiJD28cvormFEMzc2eUqy1RAZD1gkg
	 u2ZeurN9G2GTHp+1LzRpB7AS+iVMGvwwDGpg1PzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.3 310/364] can: kvaser_pciefd: Set CAN_STATE_STOPPED in kvaser_pciefd_stop()
Date: Mon, 22 May 2023 20:10:15 +0100
Message-Id: <20230522190420.525815971@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
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

commit aed0e6ca7dbb8fbea9bc69c9ac663d5533c8c5d8 upstream.

Set can.state to CAN_STATE_STOPPED in kvaser_pciefd_stop().
Without this fix, wrong CAN state was repported after the interface was
brought down.

Fixes: 26ad340e582d ("can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices")
Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/r/20230516134318.104279-2-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/kvaser_pciefd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -719,6 +719,7 @@ static int kvaser_pciefd_stop(struct net
 		iowrite32(0, can->reg_base + KVASER_PCIEFD_KCAN_IEN_REG);
 		del_timer(&can->bec_poll_timer);
 	}
+	can->can.state = CAN_STATE_STOPPED;
 	close_candev(netdev);
 
 	return ret;


