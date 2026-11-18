Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036969;
	b=GhI49U10h8CKHn3DWGxaTsVyhD70mCL2HUjKRBgiBfd0OXOnG+A7NGt4WZ7asXEmKM0G
	 qEkjPR4WzzcURhghvk7zgg/o2F6GHb+/1RniYBmYsb8NpfokjWh8UkLUiSaHelUjv1uBE
	 c5EyjRF8VcWccQjTgFZuUes+0bLoTfziBx2Fi6EihHoIOAFm+Jnzick/wCqDffMXQnORU
	 uD0mvxakESmNTWQFKj2CiOaVPD6D55KCBDUtF70xoMnUMdV3/hLsrxx7mB78HzgB5feqq
	 eushYuRd6YHiUwwYbl8TtWVPRu6Yrq/gC9Y1H0YJOqBxJAfGXxtBUN9RzRN0Y6BmARQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Ohmz/kzhdN/D/stexFJYxExMaEBlt+RNGQLoP7HlVLo=;
	b=AKcyykIx2pDQbchkG/d0djaJJNYBV5K34uSwObVissnDjUC0IwOEVwCQUqFe7aBNFP4g
	 BAOXQgMrLYQXTe4X/Q6JnFyWWQDrIDFo87N9dhL4MdvAFRNWJYpsyP35mYjDTaLY/FW1l
	 +XIAHNM/i4FZK8K9yjlnLB1rWggHNk7q54hun9dQSF1CQ0XEqXPSXv+2LCdFq1+2Kfsud
	 0b6G9BJAMRk6ejU3Of0U3LZcY+tHzXX6wsyOFhtGOIFvQRWHgSxRQT9DutZfVnIBzvs7k
	 6dzGMxIt5LQnEq3bv5qlUWthFfciCmfglbW5COEGsOp/Zryu6tIgEg5vy/+SqndXq8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AQJLpFfa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EEF606A330;
	Wed, 18 Nov 2026 21:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AQJLpFfa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF9D1F000C6;
	Wed, 18 Nov 2026 21:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036968;
	bh=Ohmz/kzhdN/D/stexFJYxExMaEBlt+RNGQLoP7HlVLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AQJLpFfaF4qmhUq22/L7VPmi2AYmQ0dLOT3NktETwK3jJ6KsSWadlyai7ONcCjSCv
	 n3kdepgP84xGMCnWU4CqHEJRpft3P8UeXSthDa8NfOfdKp0RHh8rvR48wyNngZgxT6
	 Xia3vjFWPFbo2RUyiNORTWAdLfHEEQKnalD05tVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delu <jeandelu@tutamail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1204/3318] parisc: eisa_enumerator: Fix out-of-bounds reads of the EEPROM buffer
Date: Wed, 18 Nov 2026 15:30:26 +0100
Message-ID: <20261118150356.290459626@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delu <jeandelu@tutamail.com>

[ Upstream commit c0a3e153804f0c14f4159ddbd2b73483c9cb3577 ]

eisa_enumerator() trusts the contents of the EISA EEPROM.  The number
of slots is read from the EEPROM header and used to access the slot
records at HPEE_SLOT_INFO(i) = 20 + 48*i within the fixed-size
eeprom_buf (HPEE_MAX_LENGTH, 8192 bytes) without any bound check.  As
struct eeprom_eisa_slot_info is 48 bytes, only 170 records fit into the
buffer, but num_slots is a u8 and may be up to 255, so a corrupted
EEPROM makes the code read up to about 4 kB past the end of the buffer
(e.g. record 254 is accessed at offset 20 + 48*254 = 12212).

parse_slot_config() has the same kind of problem: it clamps
config_data_length against HPEE_MAX_LENGTH but does not take
config_data_offset into account, so the parser can walk past the end of
the buffer even when the offset itself is valid.

Clamp the number of slots so that all slot records fit into the buffer,
and hand the number of bytes actually available to parse_slot_config()
and bound the parse by it.

Signed-off-by: Jean Delu <jeandelu@tutamail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/parisc/eisa_enumerator.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/parisc/eisa_enumerator.c b/drivers/parisc/eisa_enumerator.c
index f0cb31198a8f0..aa41d3abc6c22 100644
--- a/drivers/parisc/eisa_enumerator.c
+++ b/drivers/parisc/eisa_enumerator.c
@@ -311,6 +311,7 @@ static int configure_function(const unsigned char *buf, int *more)
 
 static int parse_slot_config(int slot,
 			     const unsigned char *buf,
+			     unsigned int buflen,
 			     struct eeprom_eisa_slot_info *es, 
 			     struct resource *io_parent,
 			     struct resource *mem_parent)
@@ -333,8 +334,8 @@ static int parse_slot_config(int slot,
 	printk(KERN_INFO "EISA slot %d: %s %s ", 
 	       slot, board, es->flags&HPEE_FLAG_BOARD_IS_ISA ? "ISA" : "EISA");
 	
-	maxlen = es->config_data_length < HPEE_MAX_LENGTH ?
-			 es->config_data_length : HPEE_MAX_LENGTH;
+	/* never parse beyond the data that is actually in the buffer */
+	maxlen = min_t(unsigned int, es->config_data_length, buflen);
 	while ((pos < maxlen) && (num_func <= es->num_functions)) {
 		pos+=configure_function(buf+pos, &function_len); 
 		
@@ -491,6 +492,13 @@ int eisa_enumerator(unsigned long eeprom_addr,
 	printk(KERN_INFO "Enumerating EISA bus\n");
 		    	
 	eh = (struct eeprom_header*)(eeprom_buf);
+	/*
+	 * The EEPROM contents are not to be trusted: clamp the number of
+	 * slots so that all slot records fit into eeprom_buf.
+	 */
+	eh->num_slots = min_t(u8, eh->num_slots,
+				(HPEE_MAX_LENGTH - sizeof(*eh)) /
+				sizeof(struct eeprom_eisa_slot_info));
 	for (i=0;i<eh->num_slots;i++) {
 		struct eeprom_eisa_slot_info *es;
 		
@@ -503,7 +511,8 @@ int eisa_enumerator(unsigned long eeprom_addr,
 		
 		if (es->config_data_offset < HPEE_MAX_LENGTH) {
 			if (parse_slot_config(i+1, &eeprom_buf[es->config_data_offset],
-					      es, io_parent, mem_parent)) {
+						HPEE_MAX_LENGTH - es->config_data_offset,
+						es, io_parent, mem_parent)) {
 				return -1;
 			}
 		} else {
-- 
2.53.0



