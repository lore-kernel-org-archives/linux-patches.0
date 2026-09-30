Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4043CB56A;
	Wed, 30 Sep 2026 19:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795820; cv=none; b=XL5KU2VqrGZ7n8NErgvufZPypZZMiHiNAC6I9DU1AZz0Pggz4TscJb2nxo+tzCdWhU+UvHPojA0uRvZIWOeVT7UQdY0Gmk6Yu+CkSudOiWvBXp17tRn/Oba9pe1I3eG4cry1zCg92A1EWdyerfpgx6co1TGUQNxwQuNmiQal+Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795820; c=relaxed/simple;
	bh=ePaP6tBtddwRO0sSPfHaIVCd4UIOlIsBw4/R0sNuolA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTCd2vuhbgu6Z0h5r9jepSM2xx4x9lLr1mjyRlHiJKzYH/ZOoImLTvmB0ZIOxK/BPIjaZBcegYzj86j6ayPRMVGMt6u7of1St4bk1ZzOwmgx9CXC8Y/Lj/NVBiqBH6Rxv0Vle4IXX0Y8C4aQZ5AgW9WKem05HKUYOtd3K7wC5Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a0xPpP3j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a0xPpP3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870761F000FF;
	Wed, 30 Sep 2026 19:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795819;
	bh=Hl7dEZYvUN9zIHmG1q4rb9FKWdDVrdBBvasPIWlon5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a0xPpP3jShUOuhBqTQJHAhq/B5R+E+cJ34tHPb5Z9xtyHLnI5vDTTohUtOlSoJnPo
	 F4mg41PsBHqB9OI0wfvVVGzWx8qkqKi8YTMpJgp5xPWVksNbISUDbSqpSfzJKDinRe
	 z1s39DPS+gLWQqtqJSO/swXPQB6eAh76KgmvFs/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Ebner <manuelebner@mailbox.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0694/1193] usb: serial: spcp8x5: dont store usb_device_id
Date: Wed, 30 Sep 2026 17:22:58 +0200
Message-ID: <20260930152449.667227308@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gary Guo <gary@garyguo.net>

[ Upstream commit 934e1322f18c1b58bca431c0d5d01e002060c990 ]

USB probe functions should not keep usb_device_id for longer than probe due
to presence of dynamic ID removal. USB serial does not support ID removal,
however in this case only driver_data is ever needed, there is no reason
keeping the usb_device_id in the first place, so convert it as well.

Reviewed-by: Manuel Ebner <manuelebner@mailbox.org>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260707-usb_dyn_id_uaf-v2-3-632dcf3adfba@garyguo.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/spcp8x5.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index f6e222c36899e..0272da9d3d168 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -145,14 +145,14 @@ struct spcp8x5_private {
 static int spcp8x5_probe(struct usb_serial *serial,
 						const struct usb_device_id *id)
 {
-	usb_set_serial_data(serial, (void *)id);
+	usb_set_serial_data(serial, (void *)id->driver_info);
 
 	return 0;
 }
 
 static int spcp8x5_port_probe(struct usb_serial_port *port)
 {
-	const struct usb_device_id *id = usb_get_serial_data(port->serial);
+	unsigned int quirks = (unsigned int)(unsigned long)usb_get_serial_data(port->serial);
 	struct spcp8x5_private *priv;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
@@ -160,7 +160,7 @@ static int spcp8x5_port_probe(struct usb_serial_port *port)
 		return -ENOMEM;
 
 	spin_lock_init(&priv->lock);
-	priv->quirks = id->driver_info;
+	priv->quirks = quirks;
 
 	usb_set_serial_port_data(port, priv);
 
-- 
2.53.0



