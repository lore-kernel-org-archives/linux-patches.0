Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D44C3382CB;
	Sat, 12 Sep 2026 14:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223499; cv=none; b=DAn6k6ik7sBLgnHK7el9jOpMOYO+ZU0tFuEK6faItHx5i6BNm9+1c/7Sl8oDVwXvNTYK5Wysy2R920iX2DlSAyURmr3W+VTtLDeCyrUqR/+W257RtD05u2inmZxsCh8We2vnmutyYbGGHO+MqV9bc20qBUb3NgG/XA4HFovX+cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223499; c=relaxed/simple;
	bh=cixWZ4tsxwgDsUaCMMehbdJ7aXHqLruZFM/bn5Sm4rI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAR19mWyJMBwT8VnIpd59aFweGsBFGKSlMsEHwEVuGkCwQcyab5M7as5UzPGjw+24Jt7ObGqDDoxbAQdhLCQNtzy8I7XuEgqMaeEB5i6qYuRhe6EYpO28k49P6iVMJRn9hIfYgMyZgIz/ixRpUfY27U+FFvNwo65ayuhovqpb2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LzotJvyj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LzotJvyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA731F00893;
	Sat, 12 Sep 2026 14:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223498;
	bh=BJmAv5rpx51t42+tT5BVpdWbDbAHHzK/TfCchMZMz5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LzotJvyjwtGv3DK5rUtfFOXyzb9SsnAYmvkAkER84TuoFNhxGoAz6EoTFZUlJ22r3
	 8kP72y9rYb2WwNfv8LJPujPerzu9oQTCc7xTw7gjV4j3GdDGtrLl+S+FJ2OjPtcF6J
	 mEPCRp2BHbcxFhihieLmrVapE89Wh/c2VIV6s8CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Vaibhav Gupta <vaibhavgupta40@gmail.com>,
	Jens Taprogge <jens.taprogge@taprogge.org>,
	industrypack-devel@lists.sourceforge.net,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0801/1424] tty: ipoctal: convert to u8 and size_t
Date: Sat, 12 Sep 2026 08:53:53 +0200
Message-ID: <20260912065625.232502172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit 2f982313279baa066f03f4816f3fa3521a4d41cb ]

Switch character types to u8 and sizes to size_t. To conform to
characters/sizes in the rest of the tty layer.

Signed-off-by: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Cc: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Cc: Jens Taprogge <jens.taprogge@taprogge.org>
Cc: industrypack-devel@lists.sourceforge.net
Link: https://lore.kernel.org/r/20231206073712.17776-14-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: b6b5d64cb161 ("ipack: ipoctal: fix UAF, null-ptr-deref, and use-after-free in cleanup on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ipack/devices/ipoctal.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index da308be6c4877..ba2e9e52d72bf 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -158,9 +158,7 @@ static int ipoctal_get_icount(struct tty_struct *tty,
 static void ipoctal_irq_rx(struct ipoctal_channel *channel, u8 sr)
 {
 	struct tty_port *port = &channel->tty_port;
-	unsigned char value;
-	unsigned char flag;
-	u8 isr;
+	u8 isr, value, flag;
 
 	do {
 		value = ioread8(&channel->regs->r.rhr);
@@ -202,8 +200,8 @@ static void ipoctal_irq_rx(struct ipoctal_channel *channel, u8 sr)
 
 static void ipoctal_irq_tx(struct ipoctal_channel *channel)
 {
-	unsigned char value;
 	unsigned int *pointer_write = &channel->pointer_write;
+	u8 value;
 
 	if (channel->nb_bytes == 0)
 		return;
@@ -436,11 +434,11 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	return res;
 }
 
-static inline int ipoctal_copy_write_buffer(struct ipoctal_channel *channel,
-					    const u8 *buf, int count)
+static inline size_t ipoctal_copy_write_buffer(struct ipoctal_channel *channel,
+					       const u8 *buf, size_t count)
 {
 	unsigned long flags;
-	int i;
+	size_t i;
 	unsigned int *pointer_read = &channel->pointer_read;
 
 	/* Copy the bytes from the user buffer to the internal one */
@@ -462,7 +460,7 @@ static ssize_t ipoctal_write_tty(struct tty_struct *tty, const u8 *buf,
 				 size_t count)
 {
 	struct ipoctal_channel *channel = tty->driver_data;
-	unsigned int char_copied;
+	size_t char_copied;
 
 	char_copied = ipoctal_copy_write_buffer(channel, buf, count);
 
-- 
2.53.0



