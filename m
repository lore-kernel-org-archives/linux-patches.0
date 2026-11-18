Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053900;
	b=AnHuqCLBl0LWVqdMwb5eX4afktESmGULofr11kwYqVePxsNIpqRWNxDQGsKMS/H5N0Ti
	 a8bQ6v6OCGE+LTq7jpj1IUuMlapI2pt02X2AnqgQrBpYq6nNGbxNr0afozAYW3d/kEGAm
	 7ISpi4n8Gzi1j8gmwhWVMNSIeXR5bWDbH3TCuACsm4LgnSvcUtoNqvnP205sQMpXKLPLK
	 Nx/iszNdDGRvKe35OymRcZEl2REBOjPxj7jOTAsO3AomaVOo/9kCkUv1KV9FMNq1H2yXx
	 cWQA3gpSmFx+5TqFEIdWj42Z8InhzybQ6t41dQUJj+hVAm9F4tqMH7wf+pcHTiouaZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053900;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YLoe2SxKV3XbT8AHCDsmaOpOOBSUEZczRPJSlxweD+A=;
	b=ITQKvwlzfS2stlISX5ZFso8zzFPhNfrbE7xcTzkg54Mvdjji33YcNTngALkZeGxi3VkT
	 oAoQ5lM+zPtruLVYPUpMYFWhhbX+cMO1EHtLAYiTg1g1qjs5/r0JzbJNDhwk8+EkbIMK/
	 edNlcKTU1poFPeJ9Gl1TB9mossRhxIuSMyRs3ubNFPHEDUfVUuT9yaFtJZgErCpKFPQmO
	 dBA/powiMX2stGbv3OO/Gtr3SvCGbsfuqtzTJ4/SL4fqrmwG4Xr27cvTG6HPs+bs86uKK
	 2CEINAJUL3SKOB0L4tgz67t0leFcPxwOjUSxyWL/B4WvHsEBqtkZ2pztxUJHnm93KPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qawEmgTT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94D8606A325;
	Thu, 19 Nov 2026 02:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qawEmgTT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4878F1F000C5;
	Thu, 19 Nov 2026 02:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053899;
	bh=YLoe2SxKV3XbT8AHCDsmaOpOOBSUEZczRPJSlxweD+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qawEmgTTzpaBjHuUy851LjT7VYLxCLM5TloxIvb/EnHBjKUZD2yf3GbeH49ui5sip
	 SbFvDNHHmFPDILGtynBSkSULoQhwH1IdBJTJToNkZAEl/rz8QFSr1N8t8u8itTSf/W
	 SDguCe2ay/6eyHsFRKbGAsOhELgcUTii2f9Pdqgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parker Newman <pnewman@connecttech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1084/2214] serial: exar: add optional board_init function
Date: Wed, 18 Nov 2026 15:46:00 +0100
Message-ID: <20261118150055.608533559@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8672c8d06a89e..2740840679d78 100644
--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -176,12 +176,14 @@ struct exar8250_platform {
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
@@ -727,6 +729,15 @@ exar_pci_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
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



