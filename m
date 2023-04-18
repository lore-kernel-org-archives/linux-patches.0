Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73812572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27727C433D2;
	Tue, 18 Apr 2023 12:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821624;
	bh=U5HtpG+d0dVGhYPv5g+6ZximuYd5Po6rEhcReZqduq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7gFwByyOg2ti3xemgGcEtIzwwuzHYq97n/czEGlpCqg6AvqHzHx0pABIwA8OA3PO
	 c8ZIpu/Byd7lCBGXBy20sNw69VDAJvkiJsMghRRSyGi6RGs/W5oHrGjcsVk7rygw9A
	 W36ZN2PZLKPZ/MpMtfa37r/oZtCn3qgds5/M+DPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 41/91] i2c: imx-lpi2c: clean rx/tx buffers upon new message
Date: Tue, 18 Apr 2023 14:21:45 +0200
Message-Id: <20230418120307.005599509@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
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
index 2018dbcf241e9..d45ec26d51cb9 100644
--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -462,6 +462,8 @@ static int lpi2c_imx_xfer(struct i2c_adapter *adapter,
 		if (num == 1 && msgs[0].len == 0)
 			goto stop;
 
+		lpi2c_imx->rx_buf = NULL;
+		lpi2c_imx->tx_buf = NULL;
 		lpi2c_imx->delivered = 0;
 		lpi2c_imx->msglen = msgs[i].len;
 		init_completion(&lpi2c_imx->complete);
-- 
2.39.2



