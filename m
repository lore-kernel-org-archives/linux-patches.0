Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705682;
	b=L94S9eGUvGglv4GmlwXLPJoQ+sXBEBsCcrN17+aOO522roSbJyKg+HKM1GKue1PGZPj5
	 +4QDJFmx3XrqsVadG1NYiD7PM19bsbqEus3rRjYcn1o3F6Af7iZH//EJFJMKwp0MxU9Tz
	 O4dC08C5yyjQiiAQHwvJq/x4Ir7bPojbExrrFG22JrvjKBGb+WG/BYeGXz4aAjk4nnkJ1
	 cwGJj+z1/E8i+tbSXb8u+i0ItoVlz/Jg4+GPUH/CgtMSfPUhlV3cmETVSN/In0SscGcK8
	 BNZWxIUyGhLWr+b3kCvcVXiY1oREPM9wbx5HC3D77SQG4DBecwByJtoS9lSrlC6aDMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+7eOqufy449fq8eUoQhHMCbFY1UC45vnAzFeAe0C/Hc=;
	b=AW0CA4CqRc3TEgXl8pz4uK5x42HDxLduP6UFA3QqElUInFGm8U3aTUbFNLlvm+8BAzZX
	 KurPo1VQEdgMEw3PlyIzmupSAo0hM6dT2pVlJpCvgFuNFl5cwQ1LfJFlkoibLddhAXkp0
	 Zq0FsUK2kc/YCYeaIEaShonKeHIzKieKuqnOWDC730/ksZUsOCW22vaq3vA71VruWbbUo
	 Pb+BuCWaBPFpoHucuVoHYqdUdwxb3S68Ruh1Vw/8kVs7FbN+S6UR0vGazBCG7iVepsesm
	 +129ZEIcvKpjOr+V9tp6YDjhygkUuQTh7abx9qKmeHa0HvlYZYXmMGowPotT1zL7ezw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yaOInYc3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39ED606A32C;
	Thu, 26 Nov 2026 15:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yaOInYc3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078271F000D3;
	Thu, 26 Nov 2026 15:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705682;
	bh=+7eOqufy449fq8eUoQhHMCbFY1UC45vnAzFeAe0C/Hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yaOInYc3pPM9WAxnc28cWvB6HHE6exEaGB2Fanvczi171aq6B9gpn8JvuaIGrZcPF
	 2z0va5oByFwFJG8fzaXCQ5Cwjd2/P2PBLqau6VnQY09d6wMaU6k8xjZJtLhFZ0M6Bt
	 zWMtVxgFbl+g33dZyloHFGLUxsr8sTs8ej5Raylo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 5.15 281/319] w1: ds2482: set the strong pull-up with its byte
Date: Thu, 26 Nov 2026 15:40:49 +0100
Message-ID: <20261126144013.098071973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit e4f673632fa8292a2922bcfbb39519b08016b382 upstream.

The eight channels of a DS2482-800 are eight independent 1-wire masters
for the w1 core, but share one I2C device. Each bus operation consists of
several I2C transfers: select the channel, send the command, poll the
status, set the read pointer, read the result. access_lock keeps the
operations of the channels apart.

ds2482_w1_set_pullup() polls the status, writes the configuration and
polls again without the lock. Polling sets the read pointer of the device
to the status register. In the middle of a read on another channel, after
that one has set the pointer to the data register, this makes the read
return the status instead of the data. The cached copy of the pointer in
pdev->read_prt can go wrong as well.

The lock alone is not enough. The strong pull-up is a setting of the
whole chip which is used up by the next byte. If an operation of another
channel gets in before the byte it was meant for, that channel gets the
pull-up, and the sensor converts without power.

So only note the request in ds2482_w1_set_pullup(), and write the
configuration in ds2482_w1_write_byte(), under the lock and after the
channel has been selected. The w1 core calls the former right before the
latter, under the bus mutex of the channel.

Fixes: 9c95bb6f25ff ("w1: ds2482: Added 1-Wire pull-up support to the driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-llm-char-misc-w1-v1-3-d2e6bfafb6a4@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/masters/ds2482.c |   36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

--- a/drivers/w1/masters/ds2482.c
+++ b/drivers/w1/masters/ds2482.c
@@ -105,6 +105,7 @@ struct ds2482_data;
 struct ds2482_w1_chan {
 	struct ds2482_data	*pdev;
 	u8			channel;
+	bool			spu;	/* strong pullup after the next byte */
 	struct w1_bus_master	w1_bm;
 };
 
@@ -338,6 +339,19 @@ static void ds2482_w1_write_byte(void *d
 	if (pdev->w1_count > 1)
 		ds2482_set_channel(pdev, pchan->channel);
 
+	if (pchan->spu) {
+		pchan->spu = false;
+		/* the wait above and this one are crucial, otherwise devices
+		 * might not be powered long enough, causing e.g. a w1_therm
+		 * sensor to provide wrong conversion results
+		 */
+		/* note: it seems like both SPU and APU have to be set! */
+		ds2482_send_cmd_data(pdev, DS2482_CMD_WRITE_CONFIG,
+				     ds2482_calculate_config(DS2482_REG_CFG_SPU |
+							     DS2482_REG_CFG_APU));
+		ds2482_wait_1wire_idle(pdev);
+	}
+
 	/* Send the write byte command */
 	ds2482_send_cmd_data(pdev, DS2482_CMD_1WIRE_WRITE_BYTE, byte);
 
@@ -422,27 +436,19 @@ static u8 ds2482_w1_reset_bus(void *data
 static u8 ds2482_w1_set_pullup(void *data, int delay)
 {
 	struct ds2482_w1_chan *pchan = data;
-	struct ds2482_data    *pdev = pchan->pdev;
-	u8 retval = 1;
 
 	/* if delay is non-zero activate the pullup,
 	 * the strong pullup will be automatically deactivated
 	 * by the master, so do not explicitly deactive it
+	 *
+	 * The setting is used up by the next byte on any channel of the chip:
+	 * ds2482_w1_write_byte() makes it, in one go with the byte.
 	 */
-	if (delay) {
-		/* both waits are crucial, otherwise devices might not be
-		 * powered long enough, causing e.g. a w1_therm sensor to
-		 * provide wrong conversion results
-		 */
-		ds2482_wait_1wire_idle(pdev);
-		/* note: it seems like both SPU and APU have to be set! */
-		retval = ds2482_send_cmd_data(pdev, DS2482_CMD_WRITE_CONFIG,
-			ds2482_calculate_config(DS2482_REG_CFG_SPU |
-						DS2482_REG_CFG_APU));
-		ds2482_wait_1wire_idle(pdev);
-	}
+	if (!delay)
+		return 1;
 
-	return retval;
+	pchan->spu = true;
+	return 0;
 }
 
 


