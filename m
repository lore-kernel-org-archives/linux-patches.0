Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618483;
	b=bcUDTMWzxhRzTZoWY4GX3CGG+lrKaMJb8FdBq4jJXLSzZAGNZCqx+PujbTG508JtCDZ3
	 cVs0YryC43h5Wj0z9O5IEgvsVWLeQTm+qka2F+rMoXM+0uW80ebb0kOi8M/lSSB5KBEfO
	 rf5dKl592alCB2OPnSCI0e2OJEKFz+muR+MUZKafpBj/Y/EHenbyyESSSfSDmV7h4R+yl
	 7uIa4aCt4XBmQfYlz9ExPTRB/p/b9vVQvCSctLl/1IMqX1zOJUwMJGH0nZfoOOgu7ASPi
	 Agi+Gro/0UFwCHgCn4apxm0voQX2yXMBRJg9vqTLMyRaTFYkGBx9gIZmAlvGrD7HcXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z1Uip50HGOCVF9opeJMTSBOcSxhLz7V/zO3Er54OOuU=;
	b=jCW1vwpu3GUHNvHBskFOOlkIyqBEPsah21j0T6a1c/2x88HjfSoQJqJ/aMaaLv7ZimR4
	 FD7IjOD13vdWFoo41AOhw+qbU5f9YwG1H8Kmd/dMdLtgErlhDnYPuNta6Ir/2jGD+96Tq
	 6jAReH/X58X0pH0FHV8r76yBtilBz/D5rBLzajB+oinQ/HD8rdSx2x9CIJs25wQIO7seK
	 baMQ+S4JQkogsOU+HAIgcw1x4lP5brCiSPBW9Y1+u+fafZXSAp7C1ap8sysJD8ElCHfUx
	 d0YF+N3VMLfZ8Fj68bRs9ZuS+JO+AbVfTphLrceY8btRsVQpUtKV6mx8esNuyJ/MoGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GNTJy+fk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5185F606A321;
	Wed, 25 Nov 2026 14:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GNTJy+fk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D4A1F000C0;
	Wed, 25 Nov 2026 14:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618482;
	bh=Z1Uip50HGOCVF9opeJMTSBOcSxhLz7V/zO3Er54OOuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GNTJy+fkmMUX6+G5wVa/shR0VfPtoCeLuG1NxG+69w3sXi2q4+Zo3jeKkGGrMWk16
	 WgJRizQiI2An7vEC9QdNE4jv4x1BmuSjzE1gxJYYN7yg0CCgzYRNORLqNPsga1PEwD
	 HPT//ONnW2A12pII93IoM2VJDzcPXm2+xRg0Aye8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislavs Nilovs <valorcool@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0293/1005] Bluetooth: qca: Disable SoC debug logging for WCN3950
Date: Wed, 25 Nov 2026 15:27:11 +0100
Message-ID: <20261125143828.600442455@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislavs Nilovs <valorcool@gmail.com>

[ Upstream commit d97b618b6675516d63d55b8f31ee6cb3b164bd6b ]

Added WCN3950 module to the switch-case to disable SoC debug packets.

Fixes: 590deccf4c06 ("Bluetooth: hci_qca: Disable SoC debug logging for WCN3991")
Signed-off-by: Stanislavs Nilovs <valorcool@gmail.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index 002307000d3cd..60735b70d89ad 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -943,6 +943,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 	switch (soc_type) {
 	case QCA_QCA2066:
 	case QCA_QCA6390:
+	case QCA_WCN3950:
 	case QCA_WCN3991:
 	case QCA_WCN6750:
 	case QCA_WCN6855:
-- 
2.53.0



