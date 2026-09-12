Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153094BEE38;
	Sat, 12 Sep 2026 16:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229949; cv=none; b=QjA6voJb44kOhcawj7WqmPhhfkyo3WKhF08WPZKOHlcegB/m2jOK95vu64mewP7l4xdzCK/i6TjjK5s+qwnfFwXIrbf7N2Mwjry+75GSHG7lPJN6E5OOdYwAxIPctZz0rwdh8hUjA3GhXnTwekkIYw3jWMX54Y6LXZxu7mTNjw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229949; c=relaxed/simple;
	bh=OLMDyLOvTbcCgemz45Kwh17GLFh6NJxpKZp55ywKB9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LvjTsVm3uvrsjRc3kIqiL1AAQbCStl0Z9yR8t0f5Rk3Nn+Sm9iHRfXQmxLojSWoO3C7UGGViftqMW2GylCzbaFjekNEmfUmYnhUevbYlOrYrUyP8prC7RxwUXaLWzzbExncwP7KuD2vCt8+qj+cE0blrreAikIg+XkVQYC2V9GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVnyDF7j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVnyDF7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB141F000FF;
	Sat, 12 Sep 2026 16:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229948;
	bh=K10b8LiyALd/vj8dwelta7/3L5c1nhnRCIvdUwsjNQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wVnyDF7j9R+Te0Ld3F2zJa52V3/bJ2SZf9uqX3C+6yPJPzat36WSyocF66kygp+sv
	 aXtgz0pr8G902cBsK3keEz3lvjxg5kfY6f2ltjQLWgEK6M31jZuDMmhLBArK/F67Va
	 gLVfoEuIRA22PBZMT9pxhcPpix7WM6F/n5PtQEKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Vaibhav Gupta <vaibhavgupta40@gmail.com>,
	Jens Taprogge <jens.taprogge@taprogge.org>,
	industrypack-devel@lists.sourceforge.net,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0651/1191] tty: ipoctal: convert to u8 and size_t
Date: Sat, 12 Sep 2026 08:56:19 +0200
Message-ID: <20260912065602.878475820@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b350ee8324d41..62811a70eec46 100644
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
@@ -461,7 +459,7 @@ static inline int ipoctal_copy_write_buffer(struct ipoctal_channel *channel,
 static int ipoctal_write_tty(struct tty_struct *tty, const u8 *buf, int count)
 {
 	struct ipoctal_channel *channel = tty->driver_data;
-	unsigned int char_copied;
+	size_t char_copied;
 
 	char_copied = ipoctal_copy_write_buffer(channel, buf, count);
 
-- 
2.53.0



