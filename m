Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062530;
	b=OYTxf4jrSXHnSm6KhGhCV8JmYM+PqQrGwjG5UI/AhJzwf0CwGYwKRUBocxXQh+tB9ewZ
	 22syHgGN0sLE5Zop9YX2iq5RT/vMjV6HDtz/g3vxfDexmJPKseUJ79IjMWbI0Z+35lPOx
	 iygDFo82P9sbZpOxhzjOun2YH5Q/zi03Oyh4kTfYouOKc2SH7p4dDoRnKQJcfAH4wNIHO
	 tv9rsBI1jPTgCH0M8H/mkDS3Y9DgP29ZvSMUmTeKopyFchOfMdJ6LCh5sVosa6wLGEUQJ
	 +nreyM4PjpSCPLiHgxbO+ZTtjKCDCUtpTWZ0lMXDxCgdjj8H8DB/K9+NyOc+IMbj7sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Tmzxk5LBpr2JqfsYb+TvLSPlDi0NDSCVPbOENCf4PFI=;
	b=IsjsswIwfh6hf3DkkrxmAZaEd3fmd5crtaZN9+6tkndcsOiAaJJktyGhLqsQqeSWvoeB
	 XKwRrw1trdzm1rchcY2SHTPxUFn3NIoUNXGZpqrWPv2DAHAYtY+VWAx18qGjBJkEgeyid
	 1oUNM+4c2V2u66vUIknxI6z/WvuOBCG1j/eenr3qr5aRQH7g+qbpalR8ZFgG0VXxnPZ1c
	 odTZx31U3ZiFoVUG7srMfpCvHG++vUG82AsGkil3PQGfPoFV8Lnf2trx35tzO7QFyfDf2
	 RPcyBoV/+wWjF+8au9mUwH45ORU5B8mPGhRFmw06/1gHqoMilhux7QL3ohL/KCC27VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AE9XJPqT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92564606D80F;
	Sat,  7 Nov 2026 14:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AE9XJPqT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBDA1F008A2;
	Sat,  7 Nov 2026 14:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062530;
	bh=Tmzxk5LBpr2JqfsYb+TvLSPlDi0NDSCVPbOENCf4PFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AE9XJPqT7V1gX3O+okIi2R7HbTIRvVceh2QPfbYBSaPl65v6Q8G0hEUhybMv/PhXF
	 8hkKzV8+7YnqKgxEyzMh43Vy/GiGWQafKGusIYd41/9mDfOCa+itcrJ0sc9KUG6EK8
	 v5lpGOwanmzpNMfWo1wiMOzKkoEvi5WEqasxwt18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delu <jeandelu@tutamail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1422/1536] parisc: eisa_enumerator: Fix out-of-bounds reads of the EEPROM buffer
Date: Sat,  7 Nov 2026 08:57:18 -0500
Message-ID: <20261107135037.767892793@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



