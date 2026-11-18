Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046993;
	b=fEze6Y005H2yGdQxG1l98xK9hbcDpKz2+qcICe4vJ4T2r3pUztCLuZdMK7JKhDJ0myRS
	 Ucjy4WTmMUuhED7Fr4zbpxK7N5knGsVcx7r61DmbntLEXTuFdjdtNSDrVX0FlsgrI7VBL
	 gxg7UEW4gdAGocEFFAkxUnQxMvrJGCrfgXydcnsEji/7nBaeiozc9FWxksQHSty8PhbqQ
	 roRl2iDvoWXfig4kXDYLSDuhp7g5LRwJ1gGWpIPxkUrtFeOVFEEOX7u6FSqnwgyNgTtkk
	 IwuyqRznjWh6+sI5E4nUEl6WCzPkl7pJ3sJv90UaU1cS5fp1PsYsCsgz/+2WMvvlwOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046993;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dsvuwyijku2/LzHnbH01XaW9x+kBeLHdwYIA95wvdj4=;
	b=xDfcidfHqnaGoYFBNq4azRcTGrLqts3iTyTQNi56Q8WJV23iA1OaWi7ZRtkmNBk8mMHW
	 3E7oKR6TwEzVD2wQ+U+8mnUfeykPUH8ew06c5EiezD5HnHIHRFSgACMmt90LcAeQ5Ba/P
	 TID/UgWgxa9C/54+EDdlMyx7X9gSOVvh3SXpKGtBmSx6yuMPGgjfBtA7pCZdWo9XdGZQf
	 BuKNBqt8b02+96aCZu3rsdxYESkL0ZEri20sEG0XwF7n1tyDREdSB4/yuibO7maGsGVe4
	 hgEC/uVAyXVbvrPtvt8l/icfGppemLYziZB/rP/3JGmZR2CVUvUcx+6ix28DtoCybpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aDXP8VKi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBC1606A339;
	Thu, 19 Nov 2026 00:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aDXP8VKi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8D31F000C4;
	Thu, 19 Nov 2026 00:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046993;
	bh=dsvuwyijku2/LzHnbH01XaW9x+kBeLHdwYIA95wvdj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aDXP8VKipuLOMewN9qSKrNtKh+6MswoZM5Ny4HaCr4zB57xFp3+sfueMapMigjPMj
	 p32eHRjfMlnVCLzx+xMsqQ5aDsZKrHiioSHPKi7lfp0SmDPX/xzOyX/lKf1RBl1Erg
	 A3/AnTXqDRYwMdx0oOcjecE5j2L1a8wSZK/sbyJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parker Newman <pnewman@connecttech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1481/2857] serial: exar: add optional board_init function
Date: Wed, 18 Nov 2026 15:41:55 +0100
Message-ID: <20261118150254.633054642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b8efa464f1b3e..060090adabac6 100644
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
@@ -726,6 +728,15 @@ exar_pci_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
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



