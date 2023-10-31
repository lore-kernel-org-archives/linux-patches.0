Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B10208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDHN7Cbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481A1C433C8;
	Tue, 31 Oct 2023 17:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774612;
	bh=ee/xhwhDhAKEjQwBU6vlgXhwBZMOv6k4+7Vryl/BM8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDHN7CbskTntzkEHMryobYqeQ2ihERbmAlZqO1pzcVJr+n6riQGOwFS1jdXo8Rduc
	 BG8sU/VhAhy0yY4cR5aHWcgU1RwI6XqS11Dn9il2rY17VAn2WS+JFulo1mUL+MfwEJ
	 jB0lLH87pFehoMyLqgYL/BfkQ3/gYREFQFL0lqUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dell Jin <dell.jin.code@outlook.com>,
	Ciprian Regus <ciprian.regus@analog.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 059/112] net: ethernet: adi: adin1110: Fix uninitialized variable
Date: Tue, 31 Oct 2023 18:01:00 +0100
Message-ID: <20231031165903.182164849@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dell Jin <dell.jin.code@outlook.com>

[ Upstream commit 965f9b8c0c1b37fa2a0e3ef56e40d5666d4cbb5c ]

The spi_transfer struct has to have all it's fields initialized to 0 in
this case, since not all of them are set before starting the transfer.
Otherwise, spi_sync_transfer() will sometimes return an error.

Fixes: a526a3cc9c8d ("net: ethernet: adi: adin1110: Fix SPI transfers")
Signed-off-by: Dell Jin <dell.jin.code@outlook.com>
Signed-off-by: Ciprian Regus <ciprian.regus@analog.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/adi/adin1110.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/adi/adin1110.c
index ca66b747b7c5d..d7c274af6d4da 100644
--- a/drivers/net/ethernet/adi/adin1110.c
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -294,7 +294,7 @@ static int adin1110_read_fifo(struct adin1110_port_priv *port_priv)
 {
 	struct adin1110_priv *priv = port_priv->priv;
 	u32 header_len = ADIN1110_RD_HEADER_LEN;
-	struct spi_transfer t;
+	struct spi_transfer t = {0};
 	u32 frame_size_no_fcs;
 	struct sk_buff *rxb;
 	u32 frame_size;
-- 
2.42.0



