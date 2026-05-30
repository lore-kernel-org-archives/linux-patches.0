Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699D1320CAD;
	Sat, 30 May 2026 17:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163971; cv=none; b=q+KHVY0CDU1cYEtnr8KS3uF/5Nd3vz6/Wn8pZ2Cp87DII0P2UoLsYIvajzmxQXmwBTRCOCpFyOL4uTgpt2D9S+Arjs9GPv6y1E7DxThjOrjE8iMWkkxHgI3hTPO2G3aivIqkRq4tvH0fMMRrs63RgZdZtLu7TpZ5PHfCRw+aJ3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163971; c=relaxed/simple;
	bh=hCG+OIRnaalrgvox5qxUnmKarMAoNkiizvztOdxVyOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kjs+/3FhQK8fEtFuuZbCoFBmwD/jagO4NEzK0r5X/Ujz6FZsM3S8SzQlDPNoxQD0qhpm7V2q74Jpw050+BMa5AtsC1c5GbHG59kAsfhkm0DQd2T+gYl+mUW1s1UDtzBxTgmeSa9OLBkR8cJzl7olrW/dMqetz7hb1TFJxHSWrHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWW9r8K/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWW9r8K/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC921F00893;
	Sat, 30 May 2026 17:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163970;
	bh=3yetR+r2N+u+1MYJrfeFDpiLwk3zQ5nbQn/Bif/B7+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aWW9r8K//BPDhf8tMyRuFbEdnAL/eQKwAyI4bFY3i0dEHixifCVPgn3GwJTXrSic0
	 XrxFo3jYDDuYMkYmc2OYHjTgkJCBtBqsSe1V5wcVoGi2sfThn70kiqf/YPu18weaWM
	 IJwmNe7hGGPutdNqnIRGgLjQR/TV/kle2IzsQGL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Andreas Koensgen <ajk@comnets.uni-bremen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-hams@vger.kernel.org,
	netdev@vger.kernel.org,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 416/776] 6pack: propagage new tty types
Date: Sat, 30 May 2026 18:02:10 +0200
Message-ID: <20260530160251.226092026@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit 1241b384efa53f4b7a95fe2b34d69359bb3ae1b5 ]

In tty, u8 is now used for data, ssize_t for sizes (with possible
negative error codes). Propagate these types to 6pack.

Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andreas Koensgen <ajk@comnets.uni-bremen.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-hams@vger.kernel.org
Cc: netdev@vger.kernel.org
Reviewed-by: Jeremy Kerr <jk@codeconstruct.com.au>
Link: https://lore.kernel.org/r/20240808103549.429349-12-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: bf9a38803b26 ("net: hamradio: 6pack: fix uninit-value in sixpack_receive_buf")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/6pack.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 36a9fbb704029..7ccf56a7f0e0c 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -94,8 +94,8 @@ struct sixpack {
 	unsigned char		*xhead;         /* next byte to XMIT */
 	int			xleft;          /* bytes left in XMIT queue  */
 
-	unsigned char		raw_buf[4];
-	unsigned char		cooked_buf[400];
+	u8			raw_buf[4];
+	u8			cooked_buf[400];
 
 	unsigned int		rx_count;
 	unsigned int		rx_count_cooked;
@@ -112,8 +112,8 @@ struct sixpack {
 	unsigned char		slottime;
 	unsigned char		duplex;
 	unsigned char		led_state;
-	unsigned char		status;
-	unsigned char		status1;
+	u8			status;
+	u8			status1;
 	unsigned char		status2;
 	unsigned char		tx_enable;
 	unsigned char		tnc_state;
@@ -127,7 +127,7 @@ struct sixpack {
 
 #define AX25_6PACK_HEADER_LEN 0
 
-static void sixpack_decode(struct sixpack *, const unsigned char[], int);
+static void sixpack_decode(struct sixpack *, const u8 *, size_t);
 static int encode_sixpack(unsigned char *, unsigned char *, int, unsigned char);
 
 /*
@@ -332,7 +332,7 @@ static void sp_bump(struct sixpack *sp, char cmd)
 {
 	struct sk_buff *skb;
 	int count;
-	unsigned char *ptr;
+	u8 *ptr;
 
 	count = sp->rcount + 1;
 
@@ -430,7 +430,7 @@ static void sixpack_receive_buf(struct tty_struct *tty,
 	const unsigned char *cp, const char *fp, int count)
 {
 	struct sixpack *sp;
-	int count1;
+	size_t count1;
 
 	if (!count)
 		return;
@@ -818,9 +818,9 @@ static int encode_sixpack(unsigned char *tx_buf, unsigned char *tx_buf_raw,
 
 /* decode 4 sixpack-encoded bytes into 3 data bytes */
 
-static void decode_data(struct sixpack *sp, unsigned char inbyte)
+static void decode_data(struct sixpack *sp, u8 inbyte)
 {
-	unsigned char *buf;
+	u8 *buf;
 
 	if (sp->rx_count != 3) {
 		sp->raw_buf[sp->rx_count++] = inbyte;
@@ -846,9 +846,9 @@ static void decode_data(struct sixpack *sp, unsigned char inbyte)
 
 /* identify and execute a 6pack priority command byte */
 
-static void decode_prio_command(struct sixpack *sp, unsigned char cmd)
+static void decode_prio_command(struct sixpack *sp, u8 cmd)
 {
-	int actual;
+	ssize_t actual;
 
 	if ((cmd & SIXP_PRIO_DATA_MASK) != 0) {     /* idle ? */
 
@@ -896,9 +896,9 @@ static void decode_prio_command(struct sixpack *sp, unsigned char cmd)
 
 /* identify and execute a standard 6pack command byte */
 
-static void decode_std_command(struct sixpack *sp, unsigned char cmd)
+static void decode_std_command(struct sixpack *sp, u8 cmd)
 {
-	unsigned char checksum = 0, rest = 0;
+	u8 checksum = 0, rest = 0;
 	short i;
 
 	switch (cmd & SIXP_CMD_MASK) {     /* normal command */
@@ -944,10 +944,10 @@ static void decode_std_command(struct sixpack *sp, unsigned char cmd)
 /* decode a 6pack packet */
 
 static void
-sixpack_decode(struct sixpack *sp, const unsigned char *pre_rbuff, int count)
+sixpack_decode(struct sixpack *sp, const u8 *pre_rbuff, size_t count)
 {
-	unsigned char inbyte;
-	int count1;
+	size_t count1;
+	u8 inbyte;
 
 	for (count1 = 0; count1 < count; count1++) {
 		inbyte = pre_rbuff[count1];
-- 
2.53.0



