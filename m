Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704745;
	b=ej3G0+UnRe2AMa16bHG/IJCEXUIsmhpfm8OMPHcRVxWT/tCkbrAn9IeIEwMIHYlvUL2t
	 WQ3+CDxjYmu83jsNHrMliD7oYhBKAy3OxdR9j8SAcbM6mXfVwpKIxHBvPQ3Ly08RTm+2r
	 XzY6gf2UZxTGkCk2I5cFtpEZoY8WK3Tfha16qlZJyXA0CBz0BkiA8lxph0+stnDAT7djW
	 JJwhgDX851xKxPmuhHAldc/v748yKI+lWd5Uvd+kYFfziP8yQt+rS7jQZcFPWEH2jfI4o
	 XGFjLX3Fz4Imi9gqzmtp6SX9JVWW4r6AoIl9/KBGV1U+NgM7OtTnYhs6txWd4pkXx8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jj2n/BfmLiQn0lt9zBOT7siS1ky0JbV/Q8l0hoQn7Jw=;
	b=kwJjBhES1ILDbfoVhbeWxjiO43+CmAXhsG/w9tqzsR8ZgYn6KKFFA/Tp2PSpQt2EHL3Q
	 UyWcJQnocmt9Z3XPSAbQmtZZ0XMn9hZfJ5ECcgLcpIu6V/7+9omfRc2WbCPfVCTiuZ0o6
	 RZBaOzhuIDxof71+epk/vrYr+HFWN6UjGsdvz0IhSXusJzeD+ku4T0X1q+Y9B6IEkuDXg
	 FOooBHsmJMhHG2EUobz3AnHn5wME5i4wv45T/osZ9EQajCZNd2+Kjg3ZrPz1j7AtYB69N
	 AJEn0BA2Jg/2gn2Loa1+RxvMxilC2Iazn26KO+XD+YimSlQ+PPdJ1NeJzCHc7lLeJQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LDY2e26Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF75606A327;
	Thu, 26 Nov 2026 14:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LDY2e26Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD861F000D0;
	Thu, 26 Nov 2026 14:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704745;
	bh=jj2n/BfmLiQn0lt9zBOT7siS1ky0JbV/Q8l0hoQn7Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDY2e26Z2QX7c88kNH+24DrRR+mg9Gnees2/T+lYoqKrcMQnACthRG2c3D8PjAK14
	 tu0+3VUZaRY3aRi/g2kB+mPOX1O3CEg18V/g+nuy9LXgwTXGltDs5Jdb3A20+6qOaQ
	 PXFhvD+EK0vAl9DZ2Zb9oU/pB3jSlp2onH7U+RME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 5.10 228/265] w1: ds2482: set the strong pull-up with its byte
Date: Thu, 26 Nov 2026 15:39:18 +0100
Message-ID: <20261126143621.197318942@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 
 


