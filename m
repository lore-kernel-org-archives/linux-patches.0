Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058662;
	b=aHMOC04Ts5ZW1UWXRhp5FHtTyDHXi3yOkmT2OugKls3YXdXigSxYhg1vQlfolUG+Avkb
	 TemCY5E1g03mhNzRiNVnIb8zYPpGJB40RfbVdTdH2A9UTx4yIvfs6q0EJItzieLhG6NPd
	 f5NUypQqPgFH9XvKf7LgUp3Z9o47BqYQfT3F8JlRs1tzpXOrVvKglWCAiSrmkt2vgFlBD
	 TYdAcBzPFgQvQDVrYx2QiLRRb1SuXwhFjNgpKBSd130kwQUkNTGJYekomr8tbcSdSnkrP
	 2X4n52Qrjfw54NX7tfwfONfxFRUnwRHMucDNZS1bQiRYMie/dk0Dzo/BOS9TSGfGZ9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fclHfrlGBLHFhZxbP5kcOaez3QREsalTXPZO67rtETA=;
	b=H7I/aWeS8AD4bd8WElXN8vfX+/PgmDf44s1Xxd/n5Uvl+THeOjByiseOL01II7sWrT4N
	 o7nVcrWC3Gc1mZoTFvAjgvGa2mo+23ESx+IBZD0uQy5k/A/bDiDwYMloaHouUkrFLvles
	 AOb29grv+ld0sd3MwHVBCMC3gHDJIbFaYHM9MLFHQde0u+IJsIHYQwQhc1rYnhqhqtdWE
	 loBi3mLpjBOVU8GIMahaXiSCy1QcyWs2uexQOEiKX81rGKl6uYDg2WbQXzMJL2aELJIEo
	 kz3X7Qe84cdBD7pN0i9XDIryHXP2cJtp7hld1X9wEhkzEUbYVbpEhOJZgCMr3GCbdWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=suut0LAY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217D6606A31C;
	Thu, 19 Nov 2026 03:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=suut0LAY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA631F000C5;
	Thu, 19 Nov 2026 03:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058662;
	bh=fclHfrlGBLHFhZxbP5kcOaez3QREsalTXPZO67rtETA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=suut0LAYewuBx76iiqpTxEb3lf2g+u7Ah759Q3BphjdFchMcJOnDgNwLZYkW0n8Fw
	 24ecEhi9tqEvwfCGd+l0amDqRene/bTFwXB/xKTBOvMGmGmbts6t8HehKYpBsSuc6x
	 ZH/oRZykdCCidoI2QwA+meXi0XsYykWWxA1lwVbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delu <jeandelu@tutamail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0564/1848] parisc: eisa_enumerator: Fix out-of-bounds reads of the EEPROM buffer
Date: Wed, 18 Nov 2026 15:43:22 +0100
Message-ID: <20261118145938.568961555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f54a6f4503915..c77fadc1bacaf 100644
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



