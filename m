Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212831;
	b=EUwgIi6Sq6IZGd2H+kXidOx/iOueWg6wLy3JCa24O100w1aCy+SYCrdcY2jP16xTls/r
	 izR/Tg1yXo75AahlGOt4zli8FPPW/uPLd9nD6bGPXHA9IUcvlHdaHdsANcC0lHQ2sy0ap
	 Qx+tiO/27PmwCzclQiMReLHOxla6xy0ULhapjW7SrvVemDrpOpdKjtnzUhk7b4jE5Nvkt
	 8RsBrNNXcDyjTLAuzklyAgKbZkKZ8L+yEyfk1DmhEyCNM0fqLNLs5CjOAPxAgt/EmCIa5
	 q0T2/fCtyl+fK7WW30F6oRphvY4cEokqtlujRILu5uJNgJiCnyn7QgHa5W8haIeM7DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E9XYuUt9NXkE9nOXF7I6GgtB9CZPwKxUoJghmyfl0Eg=;
	b=eLV7nb34Uz4n7P3JWHK/n/WGearZsn38EciLCT3n/7U80LO+kaEIjq1M+oerjGGZmDgl
	 Wn52es7cEBrzqZEUjV8InTTGqxqk1AufDw4fK/yb4NDmG7hWQsW28X3qRqwbBQrdcfkf/
	 V1j+/7Y2qbgLTkbSgzm5b3Esp9ifwmia4HqaQilJpydu01hx8DjcRU3py35b8Y7XOIaBH
	 rN7RSsaDUmACIzz697x4H9obENh31S95rV2dugh2lLbkAAJ+jEREw/TIjICk0o4LxcN7G
	 5z0gzmrd7yD/QsY6FGHdFixd5PJXHjZvXEsnvKzlTJTCdA9rTL2PS9puvqOHV0mIUBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mEh+h5/R";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985DA606A31D;
	Wed, 28 Oct 2026 18:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mEh+h5/R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E1E1F01828;
	Wed, 28 Oct 2026 18:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212831;
	bh=E9XYuUt9NXkE9nOXF7I6GgtB9CZPwKxUoJghmyfl0Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mEh+h5/R1iroKqpvhy51tOA4fo6RcAUHFkD76NgDrzu2BPY7hSPiVMMIcDvZ7MpO7
	 xqZd1750cPIitrgQcIEPTYpio8cys586jPZEZ/CurVDeGFq/cA6qR0PQJO3v5NYExM
	 ZKS3CJ5oYzEnIrSemMpYyeVZo1Wqapfwfqi22sh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Johan Hovold <johan@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.1 0290/1887] tty: amiserial: fix broken TIOCMIWAIT
Date: Wed, 28 Oct 2026 17:39:46 +0100
Message-ID: <20261028170505.827968391@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 615f35fd5aee169cc4881a8594f2fa234a4d0bb8 upstream.

A change replacing interruptible_sleep_on() inadvertently broke the
TIOCMIWAIT implementation which now immediately returns -EIO (unless
there is a racing modem status update).

Replace the old hangup (and signal) detection with a check for the
TTY_IO_ERROR flag which is set on hangup.

Fixes: 591cee0a3563 ("tty/amiserial: avoid interruptible_sleep_on")
Reported-by: sashiko-bot@kernel.org
Link: https://lore.kernel.org/20260910132029.D80801F00898@smtp.kernel.org
Cc: stable@kernel.org	# 3.14
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://patch.msgid.link/20260911090132.723531-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/amiserial.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1140,11 +1140,6 @@ static int rs_ioctl(struct tty_struct *t
 				local_irq_save(flags);
 				cnow = info->icount; /* atomic copy */
 				local_irq_restore(flags);
-				if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr && 
-				    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts) {
-					ret = -EIO; /* no change => error */
-					break;
-				}
 				if ( ((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
 				     ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
 				     ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
@@ -1152,6 +1147,10 @@ static int rs_ioctl(struct tty_struct *t
 					ret = 0;
 					break;
 				}
+				if (tty_io_error(tty)) {
+					ret = -EIO;
+					break;
+				}
 				schedule();
 				/* see if a signal did it */
 				if (signal_pending(current)) {


