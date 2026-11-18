Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038503;
	b=O5t1qdfEmgjn4P4Kb4NV0u3R5D3FjdzLru5AxRLiK3VylZPwWH0RUn7mQUg0khFdB+Ry
	 JfdZzkY2Z8xDHQUCDXPs2BjV8SRYXmT3p4xufI4+fs3N+gxKiH9i1rHFwXEtd9TajbUkd
	 i9lrlA4g/OINF1RYgAjV0UIac3bPQbuy17wHgpRRFa+0DZ6i8bmygSvvegI4NbITweuRb
	 XK4a0i6YOQT4NwqpNY6LeYZBp8N7fXFO1e4SR/LqaiWH3vAOT6qMtX/0ydHUut7ajCoPs
	 B4fiuJ66MLCklHZQzjYscF026LlXfKkd5ELHweCCGfySfXNspd8x55XOnDpb6O90m2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GQWKCYWtHxLvBIb01HuVUdI+ES69VStf9tBqT7aQEnE=;
	b=YQIdtmpKV2+Bkr38dqN6HaHldUqJLm1F/5o+1dEIXADvwssar7ez2QYkVVFr8cpK8OaY
	 +qCQMVgsdjV0gjLpJrUif7pZdubEFFpuolg2Kx9rSUWaehRlHUzo17PlAJeyOBprHZ9dH
	 s76YpbiRvGyuRhiWUImN/OqkuwngPQ+kOkF2D7V4LKnJ8FN0f/mEYvrMT30xaMdnAW/Z6
	 7/2DoVQh+6AoRTswElu+wHxfIpKv6W0Qz6RIMnq/XWepsJ4Kh+DlMR7kNO5dwlzK5JlU0
	 aZE2cJ8YGnXO2wgnfLFyP3C0ZBMNgLjR20fQiJqN22gNHIBc6VmEnkFFAJa5urL+IvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ktXQoroL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC04606A339;
	Wed, 18 Nov 2026 21:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ktXQoroL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CC21F000C4;
	Wed, 18 Nov 2026 21:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038503;
	bh=GQWKCYWtHxLvBIb01HuVUdI+ES69VStf9tBqT7aQEnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ktXQoroL0RMph7pVNYe4BYF/yheqwQ8hpKOcxyLHanjoJaSWVMZxLfhBWVuQgm5ml
	 aLZl8MsSaH4AOqDQTR/98tOV+h+MW7c3CWYixc85G42LiRA+mhvVG402sCxtDkAZR8
	 MqfG2IvNiGJwoJAlSpiM56abhtXiu57o1Q/otPhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parker Newman <pnewman@connecttech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1739/3318] serial: exar: add optional board_init function
Date: Wed, 18 Nov 2026 15:39:21 +0100
Message-ID: <20261118150414.033717161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parker Newman <pnewman@connecttech.com>

[ Upstream commit 393b520a99b21d9ec6d4bb32e7c05bbb4f6dc777 ]

Add an optional "board_init()" function pointer to struct exar8250_board
which is called once during probe prior to setting up the ports. It will
be used in subsequent patches of this series.

Signed-off-by: Parker Newman <pnewman@connecttech.com>
Link: https://lore.kernel.org/r/0e72a3154114c733283ff273bc1e31456ee101f4.1713382717.git.pnewman@connecttech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 33d337816e00 ("serial: 8250_exar: store the GPIO platform device in struct exar8250")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_exar.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_exar.c b/drivers/tty/serial/8250/8250_exar.c
index 95cde2c001118..d8e2dd5a2451e 100644
--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -177,12 +177,14 @@ struct exar8250_platform {
  * struct exar8250_board - board information
  * @num_ports: number of serial ports
  * @reg_shift: describes UART register mapping in PCI memory
- * @setup: quirk run at ->probe() stage
+ * @board_init: quirk run once at ->probe() stage before setting up ports
+ * @setup: quirk run at ->probe() stage for each port
  * @exit: quirk run at ->remove() stage
  */
 struct exar8250_board {
 	unsigned int num_ports;
 	unsigned int reg_shift;
+	int     (*board_init)(struct exar8250 *priv, struct pci_dev *pcidev);
 	int	(*setup)(struct exar8250 *, struct pci_dev *,
 			 struct uart_8250_port *, int);
 	void	(*exit)(struct pci_dev *pcidev);
@@ -730,6 +732,15 @@ exar_pci_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
+	if (board->board_init) {
+		rc = board->board_init(priv, pcidev);
+		if (rc) {
+			dev_err_probe(&pcidev->dev, rc,
+					"failed to init serial board\n");
+			return rc;
+		}
+	}
+
 	for (i = 0; i < nr_ports && i < maxnr; i++) {
 		rc = board->setup(priv, pcidev, &uart, i);
 		if (rc) {
-- 
2.53.0



