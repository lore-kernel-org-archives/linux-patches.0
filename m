Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027806;
	b=jGcu2bA2mHuQixYKJ2MIFch+8uMfKBWVUInLME8pObFJqq5MRYmEeVkrbkSjPuc2aMI/
	 osfIIea+HP+YcWk5lorn5OAIS6I3oJcTYqNrFDVjZ+HfCtXn33DGuO2aYiRV/MuvTr9fn
	 y0fleCbJ+YrsM20ylrvv2G/zzzLEK0qUV4K+CDniSK6QzLylpreay2KfZA7mZI6LE4vKh
	 kOqS8ZzbRGKyGnq/vJ1VMcw99DA7fm+aqtEtm6nSM0F9/r0ifAp1Tr4WcWgcenybE3Ijt
	 kumj0/1REWCpdsaNO1vfCtiaQjFQ2ppyC4stuEexB8DbWQAEbblD7PJwDgptU8t5HDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6ZILwL9OX2NY0ioG50jwK5Ybg2zhfFzWv0A5PLPtY7M=;
	b=Iaj/solo+XqJI3979TT8ZNt8wIs+NtumUsWs1oO7u1XB334r1p4HVvm+C94lntZ4QKtV
	 Q/4GsZzyCPQZNgMjgYwFO1G23oQY8htwIdm6XcFVZFI1SJPJYykMEIENFbzcXFS61+BA5
	 3XLUXFjW5B/5C8zQY7FOKRiZvTMgLUtqMp4iaCmAbYw00L9b8+wlPwmcKRC+c5vHsp2nl
	 A29+Ouyi05+lUXHwyfVJQ35qCInoirrDrsm29lajd/Nv29M9Cc6Qi+md99cKdR4EoYO1U
	 Ld7uQUHLu8sgi1uJ2ZPoxRc+wq954Ayj3Nx+SyPiSrCiV6CaphSNqpHy+3xSNEMppLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KC/6nvHZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D4760A2604;
	Wed, 18 Nov 2026 18:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KC/6nvHZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FD01F000C8;
	Wed, 18 Nov 2026 18:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027806;
	bh=6ZILwL9OX2NY0ioG50jwK5Ybg2zhfFzWv0A5PLPtY7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KC/6nvHZyTknGvgsF2ZC4WzRkom7P5SJ4tjLDXsitcYE4Qm6AZUrwrdAMGs4Jg/f5
	 tU0opa9xeeaDWNzgx5BnRW3cIOq4N0WAH+CW5HbH8i3bFoiFQ6P6cuxWRQXvFtk/dd
	 tmmtILOo6XnOnacXbDeOiqmTOPso0h5n/FgTSXKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Kubik <piotr@kubik.pl>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1921/2151] net: pse-pd: si3474: keep detection enabled on the other PIs
Date: Wed, 18 Nov 2026 16:00:56 +0100
Message-ID: <20261118150231.759076256@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 77c3e92a154b7..a88ec2564364b 100644
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



