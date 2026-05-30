Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F09933E36A;
	Sat, 30 May 2026 18:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166222; cv=none; b=ZpH4JpEjx+ibGrAQyN4E3ARRtcHN0R3P0tcIlkQgsR4yvJltOhAn/DnKVIy7PeayzsOiYXy1M/pDiT+xecr0jgHdOFDOB3z8zyyOmmLlWz2BkgVOxvkD3Wl72BDFdSy0UlZIHH6F2XA0LhYxZCmRgLks0h9+3u+xRjaEAMj3blM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166222; c=relaxed/simple;
	bh=8pyl6TTw/507P8GidiHnfP7c5dcRE8Gv0AfHjyzoPPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBcIzuxiUCvIV73+WtDqt5YJwKyX/DU0yii4jHVOh/NkyuGGOqt+jMJhosdMZnwTy6FAHGkKBo1kMgIEI8CDu3yb3AojXoy343V15z/oBBQ58gBV6j1z54h3HHuQFnM+xj7GHoMSojlgetwQQOoflKmAPNHawbt1Ss6S7J1p6tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZovPycl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZovPycl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D63A1F00898;
	Sat, 30 May 2026 18:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166221;
	bh=HrjVyo9XIm45mzCT+kcIWHQttqvfkOLvG2Cy+OzZ3YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pZovPyclAyJc3EY1zRK/X4MBU7AKnUDTJ5Qww00gF5dYENTJ59ibfDiFU7jO9Qcs7
	 7sWHlaiFNB+2DoVaat61gBEx8D+/5spQh8AXSBOY3bel3P3b1+PkOl9YHIzxB+znls
	 VI+o5ZRFYvm7jIp3PZt/rLTmye5HQdB7S6HpPG6k=
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
Subject: [PATCH 5.10 308/589] 6pack: propagage new tty types
Date: Sat, 30 May 2026 18:03:09 +0200
Message-ID: <20260530160233.047547197@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 83dc1c2c3b84b..1964ccbb62c6f 100644
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
@@ -337,7 +337,7 @@ static void sp_bump(struct sixpack *sp, char cmd)
 {
 	struct sk_buff *skb;
 	int count;
-	unsigned char *ptr;
+	u8 *ptr;
 
 	count = sp->rcount + 1;
 
@@ -435,7 +435,7 @@ static void sixpack_receive_buf(struct tty_struct *tty,
 	const unsigned char *cp, char *fp, int count)
 {
 	struct sixpack *sp;
-	int count1;
+	size_t count1;
 
 	if (!count)
 		return;
@@ -830,9 +830,9 @@ static int encode_sixpack(unsigned char *tx_buf, unsigned char *tx_buf_raw,
 
 /* decode 4 sixpack-encoded bytes into 3 data bytes */
 
-static void decode_data(struct sixpack *sp, unsigned char inbyte)
+static void decode_data(struct sixpack *sp, u8 inbyte)
 {
-	unsigned char *buf;
+	u8 *buf;
 
 	if (sp->rx_count != 3) {
 		sp->raw_buf[sp->rx_count++] = inbyte;
@@ -858,9 +858,9 @@ static void decode_data(struct sixpack *sp, unsigned char inbyte)
 
 /* identify and execute a 6pack priority command byte */
 
-static void decode_prio_command(struct sixpack *sp, unsigned char cmd)
+static void decode_prio_command(struct sixpack *sp, u8 cmd)
 {
-	int actual;
+	ssize_t actual;
 
 	if ((cmd & SIXP_PRIO_DATA_MASK) != 0) {     /* idle ? */
 
@@ -908,9 +908,9 @@ static void decode_prio_command(struct sixpack *sp, unsigned char cmd)
 
 /* identify and execute a standard 6pack command byte */
 
-static void decode_std_command(struct sixpack *sp, unsigned char cmd)
+static void decode_std_command(struct sixpack *sp, u8 cmd)
 {
-	unsigned char checksum = 0, rest = 0;
+	u8 checksum = 0, rest = 0;
 	short i;
 
 	switch (cmd & SIXP_CMD_MASK) {     /* normal command */
@@ -956,10 +956,10 @@ static void decode_std_command(struct sixpack *sp, unsigned char cmd)
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



