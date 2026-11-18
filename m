Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051118;
	b=baMvrW12VHyYPxO7xsobWd2OLjjYHWx9FvoLkOUlyZLt60yj7fTIks9R7omhr5eNVo0/
	 kOlNXwu9ngbrHrixd4QK+zNrLVa5Cb157AW6mP9l3v6GjGXsOBrUjmLGxfMmk2SNCDuAO
	 guk43lKrYHyO2NkdpYVH06YIjdx5k8/T3akF/CaFpDHOne3TARx1mOIkaYI2DlqEB8cMr
	 cK+3gP1ppQsE2OXp2kj58m8JGchnM5Myi7VljI9aZbiAWcsiteSNOmkojm+qKkOKz5LdQ
	 gTkA8X8HBVX8GMfSwEiBCQzP9ZyUEqiopV4Ho795/SiT8KVCpoLPlgSmuUofrPMLDHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dh5kzeDRkssdm2eojQdfi0QruE3nVHVgUszdEB/OlG4=;
	b=sCJwZEoN9YJ70ZAHh4/P3todM1TLQfJmYG/YztbYzJ0Kk/y2piD+PGe7jAaq4OQGBW8p
	 vJtjxAkcE1w1zz1q4KBNhnlbK3WIshIQDe1az8v3YqSzRo8bvfzZn7QqkObk9EjsAXqhC
	 lfg6YUqfPerJP2GNe1ajNt8acv/cPaMQBAe2PCQhhZ/C7kidAD5sIKM5iSRwL6bcVDG7f
	 TQSRIdqo8gCZm47O8mP7VuK7Tm+C11ehoiJLuyOp3s/Idf1ZLTVYGV1eF/w9r+oXbELQR
	 u8oyqUoqmjga4n9klVm+Fv9IioE68Whda8DuZRTh2f3xxIdDZ6Q6/G/iBfJBTBdu9EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rg1HKMV0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA17606A32A;
	Thu, 19 Nov 2026 01:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rg1HKMV0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAAA1F000C4;
	Thu, 19 Nov 2026 01:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051118;
	bh=Dh5kzeDRkssdm2eojQdfi0QruE3nVHVgUszdEB/OlG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rg1HKMV0jRnl7bRQvzMLzm23+LUM5aKc+JH7fTYdMWJ52Qpoj8aTOM8dBQ3ovn69Z
	 di1fy397oOuWiJMysrnwLdXc3DHOo1W73MmljqTvr5UcMGCSqPDfwdv62oo0Rx/I7I
	 ySu0isDIE318C+3LKIxLxfGrjIj9kBiwEav7A5/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0096/2214] comedi: pcm818: Fix sanity check in interrupt handler
Date: Wed, 18 Nov 2026 15:29:32 +0100
Message-ID: <20261118150013.794786526@linuxfoundation.org>
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

From: Ian Abbott <abbotti@mev.co.uk>

[ Upstream commit 956e8478261a575d1e87490f2e5db1788b8c209d ]

The driver requests an interrupt handler for the device before it is
fully set up.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing the dev->read_dev pointer which may be NULL if
dev->attached is false.  Move the check to avoid the possible null
pointer dereference.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-9-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/pcl818.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/pcl818.c b/drivers/comedi/drivers/pcl818.c
index d327af771c20a..a05b05652cda5 100644
--- a/drivers/comedi/drivers/pcl818.c
+++ b/drivers/comedi/drivers/pcl818.c
@@ -536,13 +536,14 @@ static irqreturn_t pcl818_interrupt(int irq, void *d)
 	struct comedi_device *dev = d;
 	struct pcl818_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_cmd *cmd = &s->async->cmd;
+	struct comedi_cmd *cmd;
 
 	if (!dev->attached || !devpriv->ai_cmd_running) {
 		pcl818_ai_clear_eoc(dev);
 		return IRQ_HANDLED;
 	}
 
+	cmd = &s->async->cmd;
 	if (devpriv->ai_cmd_canceled) {
 		/*
 		 * The cleanup from ai_cancel() has been delayed
-- 
2.53.0



