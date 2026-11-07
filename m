Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065347;
	b=Wvh4xvu+grKjrqQkfa5/TpM2y6fmPNs3MkT0fDo0VG5RDve4DqaQVct4xy7dJozDHM+3
	 HnGrCXyI+s7+OI3hCoM6Fk1yyWRgyjM0qBZznZLaFxaL8KLVP19VjpYKPisNHvBPpBqH+
	 bO6RV/39SYSwIxpihGe7fQLhfPNzHUYNr/KQUK+A9535GSlJYUsFT/Oj8pFhWzckq4D5k
	 zTsBhjyN7nT02uiNpnD4nItXEEQIMv/qZK40eTASSBXXazXa/W4SzKHI7liW1KmJ3DhbC
	 kAxykK4d6Kdq1h9nVcWdbHbkaD4DIqSITPk9K02uRRmQdQRkSLDZnhIzcPEULZAkupQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=xSe5juUjy+wJVQv7giNB830ZriESdiPDHakjdO8kwic=;
	b=Qlfbd06aWPtrNZFN3dazyoboPlEeBSBh+vV0djmJHdMvk+wVpntsOXIu0xRhGCEKUMEG
	 26sKEeGNh5+qzttvIbExVz07Cw90pf38RNU5+Gb+sCHSm39DBXrHUH6iJjRqAmqXjbJNv
	 DUBJzQbPmgZBBBhUpFTf6pMXIE+HA79sVIPgC9vl9eGjPpQYkzWOJmJdL9N76WgC5GPM7
	 jy+kD5Gg6eEftWIvltLslUOdNcGvaHQjccJthbhlAKkDwVfs9tlgLUIxp29GDObtO/te5
	 6seT4bHcwdK9OdGgPCSDD+Tj7KX1Le0tmKTkLppgEA0hiZsw67QyPMNO54Te0c3Z7UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fs4cIaNZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5EA606A326;
	Sat,  7 Nov 2026 15:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fs4cIaNZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF7C1F0089F;
	Sat,  7 Nov 2026 15:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065346;
	bh=xSe5juUjy+wJVQv7giNB830ZriESdiPDHakjdO8kwic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fs4cIaNZybtxMGIARv6b1rSVO8TglfGuKoRDIbmQess1UJJ7YKcxyH0aVLXTSAD0O
	 eE0GREPR8ycV4QzA36f3IbpVa2zq5SfqskbeAecLpVbIRmE4aW3f1Ymnvqa0CzP8Yp
	 EZ3/TTp2YfeD5YUYPSrZykEE6Z5ZPkOMSvmaCNFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delu <jeandelu@tutamail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1034/1257] parisc: eisa_enumerator: Fix out-of-bounds reads of the EEPROM buffer
Date: Sat,  7 Nov 2026 08:55:30 -0500
Message-ID: <20261107135007.879562517@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index e0a57086a8a86..011b9ac6f97be 100644
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



