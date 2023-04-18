Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AC82572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4622BC433EF;
	Tue, 18 Apr 2023 12:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821961;
	bh=uPMOlphHBamsx4/oDxVMrw3tPvD+rItJxPuTUtzs+Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VO892dOUN0VAPVsKuhlrTw8DLmRgg9vAFmPqsl4Y0TOvajOS8L1tDCd3h2C9IGtYf
	 +TMr3IWQwwGk/ZyCucWVrda1YQihQVFVWICaQqAV7JbOwyDIrqJ25OSBks6gsx72Yz
	 ixYQizXDon+PKXRujVyPVPP9wfD9i4gZIbp193QI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/134] i2c: imx-lpi2c: clean rx/tx buffers upon new message
Date: Tue, 18 Apr 2023 14:22:13 +0200
Message-Id: <20230418120315.739811438@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 987dd36c0141f6ab9f0fbf14d6b2ec3342dedb2f ]

When start sending a new message clear the Rx & Tx buffer pointers in
order to avoid using stale pointers.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Tested-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-imx-lpi2c.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i2c/busses/i2c-imx-lpi2c.c b/drivers/i2c/busses/i2c-imx-lpi2c.c
index 9b2f9544c5681..a49b14d52a986 100644
--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -463,6 +463,8 @@ static int lpi2c_imx_xfer(struct i2c_adapter *adapter,
 		if (num == 1 && msgs[0].len == 0)
 			goto stop;
 
+		lpi2c_imx->rx_buf = NULL;
+		lpi2c_imx->tx_buf = NULL;
 		lpi2c_imx->delivered = 0;
 		lpi2c_imx->msglen = msgs[i].len;
 		init_completion(&lpi2c_imx->complete);
-- 
2.39.2



