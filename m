Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93300395AEA;
	Sat, 30 May 2026 17:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160935; cv=none; b=MO0W21eFVSp+cA9ucV4J8BJxZJAXBCBO7H9EZzvW4UZ6kh5E+if8bjSC+GJ8Y9Yzamg3t3+u7piVbX/eGB9vMCbhZej9QWwY9HAmIgcGWFvjMl4FnX1JZlJDJKskg5atLpZdFn0j8Oy7EPstc4NJGj3ed4Fr6KAWwkS3uV+6S5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160935; c=relaxed/simple;
	bh=3C1hhorlhb13mtLj4IF6TSg3nTQ0aq+YLlOP3lAjpUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+EsLqfhALkUlsT8jk9+AXcrpIuKumAv8UaAOQ1aecNS7xLp1H7ZQRj4oZfBgCrkjUluX7pxRDIXuJMTHEU6YlZxV0RHIp64P+nwVGgSOj4AGLTTypFP3eCcW2Q8Tyi5JNK6agGEmFIcEIWKEOrcNZ8MYw5HuZjvXfYMpPkz5LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DB5YJL/w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DB5YJL/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFAC1F00893;
	Sat, 30 May 2026 17:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160934;
	bh=0qSdK7WBQISit5ApePwTYMq9CjqLh8G79AedJ+s050g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DB5YJL/wOCwo15HWUH00J0yrHxeUAJc2VOPpLGDPX3/JEURfJ+343PLl9uy+h0LV7
	 Zqyr1M//LGSDSE+jHsr+3xs7gx/t8vx8JutwHZmvwZuove/EwXz0fG31g+i4aD5AyM
	 QJUdHg0HeGnm61N/kV85PFgIuuvr1UfV1xmLx1ug=
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
Subject: [PATCH 6.1 478/969] 6pack: propagage new tty types
Date: Sat, 30 May 2026 18:00:02 +0200
Message-ID: <20260530160313.498423975@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index 1b007dd174794..fe85cffa4f945 100644
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
@@ -113,8 +113,8 @@ struct sixpack {
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
@@ -126,7 +126,7 @@ struct sixpack {
 
 #define AX25_6PACK_HEADER_LEN 0
 
-static void sixpack_decode(struct sixpack *, const unsigned char[], int);
+static void sixpack_decode(struct sixpack *, const u8 *, size_t);
 static int encode_sixpack(unsigned char *, unsigned char *, int, unsigned char);
 
 /*
@@ -331,7 +331,7 @@ static void sp_bump(struct sixpack *sp, char cmd)
 {
 	struct sk_buff *skb;
 	int count;
-	unsigned char *ptr;
+	u8 *ptr;
 
 	count = sp->rcount + 1;
 
@@ -397,7 +397,7 @@ static void sixpack_receive_buf(struct tty_struct *tty,
 	const unsigned char *cp, const char *fp, int count)
 {
 	struct sixpack *sp;
-	int count1;
+	size_t count1;
 
 	if (!count)
 		return;
@@ -773,9 +773,9 @@ static int encode_sixpack(unsigned char *tx_buf, unsigned char *tx_buf_raw,
 
 /* decode 4 sixpack-encoded bytes into 3 data bytes */
 
-static void decode_data(struct sixpack *sp, unsigned char inbyte)
+static void decode_data(struct sixpack *sp, u8 inbyte)
 {
-	unsigned char *buf;
+	u8 *buf;
 
 	if (sp->rx_count != 3) {
 		sp->raw_buf[sp->rx_count++] = inbyte;
@@ -801,9 +801,9 @@ static void decode_data(struct sixpack *sp, unsigned char inbyte)
 
 /* identify and execute a 6pack priority command byte */
 
-static void decode_prio_command(struct sixpack *sp, unsigned char cmd)
+static void decode_prio_command(struct sixpack *sp, u8 cmd)
 {
-	int actual;
+	ssize_t actual;
 
 	if ((cmd & SIXP_PRIO_DATA_MASK) != 0) {     /* idle ? */
 
@@ -851,9 +851,9 @@ static void decode_prio_command(struct sixpack *sp, unsigned char cmd)
 
 /* identify and execute a standard 6pack command byte */
 
-static void decode_std_command(struct sixpack *sp, unsigned char cmd)
+static void decode_std_command(struct sixpack *sp, u8 cmd)
 {
-	unsigned char checksum = 0, rest = 0;
+	u8 checksum = 0, rest = 0;
 	short i;
 
 	switch (cmd & SIXP_CMD_MASK) {     /* normal command */
@@ -901,10 +901,10 @@ static void decode_std_command(struct sixpack *sp, unsigned char cmd)
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



