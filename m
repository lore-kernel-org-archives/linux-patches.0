Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021620;
	b=Ja6mwuYej6s++tSEd5f0ycLlp1Sw/Rks9COJUpy0ZRB212V47m4mYTpGGYwUYUMzOczO
	 RLDXmmkv3RXhHDffC1ndiDUKjIaiJO8psJLNHU3eIRwZ7ARnQEAN9HandbqcnCrJn/BqO
	 zMzfEByymr7zj2SiEIekB13CbJyxeAmwinX5BIwkVjYOX8hZWbZavCnKJ/Hy6kagluBhv
	 HPCa3O7VeXiod2od9iCd0k2aFBmz7s9c505rfVbD8mc6hLqF270sE+PwQSRcjmrlZfJlN
	 7nyMcU+Fb9FygYz7RYhk74lB9u+7daM2Y5dRlJEUpm1aXBO4dlvfK0CTTFCpCMzydxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tWBNhRZAnpD79Tay1v9qNgOHwMh8Xn7KCshUZBEjay8=;
	b=BE3fRUP0iECT+GO8WvvV4bEqcqG79W4EXq1fo8l9lf/ug3Fjuneo+lIhJbrmJqt+Dkss
	 skkTA/Dt6rbZbfYvEFvsweLPgN2cPFsDN52nZQgmGMqiqmAidTXxvBknjnIbMhulfWCBW
	 Wsk+0SxGk1up1S2wznVfBix3o0/N9WEu0atJiEhM0Trc+Hzz6Q/RLMXDGWphwZ0U6r9bu
	 GaAtBnglk4s/h8y+ugWrpuOpaR+2SA3iH1ATO/ofxY9QcBjMZ04sOqrwVte1SiIobY/ym
	 rVjFULng8NXoVKGFcKRKyVS5OU+dYv7pI/sjpxSAgTauNsstAYl5G9J7bcV1L6M5lxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h3UNu42U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87686606A335;
	Wed, 18 Nov 2026 17:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h3UNu42U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67B71F000C4;
	Wed, 18 Nov 2026 17:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021620;
	bh=tWBNhRZAnpD79Tay1v9qNgOHwMh8Xn7KCshUZBEjay8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h3UNu42Uw2B25nEh3QsjUadkH8+ByCIDSGFPemW5aEJtudmQHzoIpYG0z+UjlLNOf
	 21f1KPoeRU0MbcDrCqTfkE2BxkePKPJVmSVUSfNoK6mg0N+932wawFGpWuTeP8U/iB
	 m6wG8GRUC5lPQCqBOkD+JPA82yfBySA2iu1pmlUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Kubik <piotr@kubik.pl>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2373/2651] net: pse-pd: si3474: keep detection enabled on the other PIs
Date: Wed, 18 Nov 2026 16:00:13 +0100
Message-ID: <20261118150410.934534603@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Piotr Kubik <piotr@kubik.pl>

[ Upstream commit b530456be77160b13efe8dececb6c826538bd4a2 ]

DETECT_CLASS_ENABLE holds the detection and classification bits of
all four channels of a quad. si3474_pi_enable() wrote the register
with the bits of its own PI only, so it cleared them for the other PI
of the quad. In AUTO mode that PI keeps its admin state and a PD that
already has power keeps it, but the port runs no new detection: a PD
plugged in later, or one waiting for detection when the other PI is
enabled, gets no power.

Read the register and set the PI bits, as the PORT_MODE update above
already does.

Discovered by an AI code review agent. Confirmed on an SDG-9000 board
(MediaTek MT7988A, two Si3474 in AUTO pin mode) with Linux 6.18:
with both PIs of one quad disabled, enabling PI A and then PI B left
DETECT_CLASS_ENABLE with the bits of PI B only, and a PD on PI A never
got power. No kernel change was needed to reproduce it.

Tested on the same board with the same sequence in both orders:
DETECT_CLASS_ENABLE keeps the bits of both PIs, and the PD gets power.
No kernel selftest covers PSE hardware.

Fixes: a2317231df4b ("net: pse-pd: Add Si3474 PSE controller driver")
Signed-off-by: Piotr Kubik <piotr@kubik.pl>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20261019162453.1244120-2-piotr@kubik.pl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pse-pd/si3474.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pse-pd/si3474.c b/drivers/net/pse-pd/si3474.c
index 2f4f241a48af6..e4eff88ae6723 100644
--- a/drivers/net/pse-pd/si3474.c
+++ b/drivers/net/pse-pd/si3474.c
@@ -312,8 +312,13 @@ static int si3474_pi_enable(struct pse_controller_dev *pcdev, int id)
 	/* DETECT_CLASS_ENABLE must be set when using AUTO mode,
 	 * otherwise PI does not power up - datasheet section 2.10.2
 	 */
-	val = CHAN_BIT(chan0) | CHAN_UPPER_BIT(chan0) |
-	      CHAN_BIT(chan1) | CHAN_UPPER_BIT(chan1);
+	ret = i2c_smbus_read_byte_data(client, DETECT_CLASS_ENABLE_REG);
+	if (ret < 0)
+		return ret;
+
+	val = (u8)ret;
+	val |= CHAN_BIT(chan0) | CHAN_UPPER_BIT(chan0) |
+	       CHAN_BIT(chan1) | CHAN_UPPER_BIT(chan1);
 
 	ret = i2c_smbus_write_byte_data(client, DETECT_CLASS_ENABLE_REG, val);
 	if (ret)
-- 
2.53.0



