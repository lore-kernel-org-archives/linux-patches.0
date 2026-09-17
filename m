Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CAD4E4C30;
	Thu, 17 Sep 2026 15:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660740; cv=none; b=Ubn6AQAtoMU+tq5PcCDG9bDau/uANH+giAorUNSK9i6Npgc4fKLmt+6Oa27tmtsgxAi7LmDaNcZAYpj1OmwOjEDHgmEN5UpzeNZERF4r7kfeonQBFKwfoWrFZpS1eE+z0jdlCM+UeQKVe5DX9ox7vZ9u4vJqi4lNuSta5Zrv4MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660740; c=relaxed/simple;
	bh=kdoD7Rrgeqxzjdq/2vLNoOzUpQUnOepmAdRTPrl0f1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvvTmKlg+b1+6rIDPNwLEYReC+GcJjN+XwHdhuwjLbsSuMY17V01L1reKAHTJbqwo627mTMPR5guA9ou+FNNhOZ/XaOFK3aTVYxMaZhfoVM40CTQSCzqyT2kbfxRKjNaZfjWrf0AvaOS36mrzSRB+GitOm2KI7UaWTPqZbeh4rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nv2SbA7r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nv2SbA7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BE31F000FF;
	Thu, 17 Sep 2026 15:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660739;
	bh=3XhW48Mpg9DNkhaCD/GzvYMCfYmTv1kT4t2MiHYOv7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nv2SbA7r+Da8YcCc6SIjY81ASrvJe91bl11e7MHSjHX1qaIcrJT+WMQBznkFjOkkt
	 HuEoTp3/5oDPL1hnvsXcSK88jEFo9uzta6n1hvwNrlJqiWLuzb98RsGYa+suj93tps
	 NDakPHaITJzgV7SI7KQgp+yFTP+zBI9UkyfPnJL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Ebner <manuelebner@mailbox.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 692/733] usb: serial: spcp8x5: dont store usb_device_id
Date: Thu, 17 Sep 2026 16:16:40 +0100
Message-ID: <20260917151410.061021557@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index f610aef6bf59b..3ef7ca2c0cf44 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -133,14 +133,14 @@ struct spcp8x5_private {
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
 
 	priv = kzalloc_obj(*priv);
@@ -148,7 +148,7 @@ static int spcp8x5_port_probe(struct usb_serial_port *port)
 		return -ENOMEM;
 
 	spin_lock_init(&priv->lock);
-	priv->quirks = id->driver_info;
+	priv->quirks = quirks;
 
 	usb_set_serial_port_data(port, priv);
 
-- 
2.53.0



