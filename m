Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BE51586D7;
	Mon, 29 Jan 2024 17:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548055; cv=none; b=CVm7XLxeuB2wCB3K5fFw81YXg4hTrme45P7Xv9nfI0ZLTDYPeLF3PjdpIWCBFxQCB+iAU6uDOk3sD4Y27v2K7WJLAFQx0ag4u7MqdzDJpsLz03GwckOY2XrHiu5ADV+V7EqGMxBFlVAn1dPzJHsPHSGv972Z3Ah+NLRrH+9REes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548055; c=relaxed/simple;
	bh=r+VH3w76J0NVQCnrdkbalUFjyuZ7SJK884C7b5dItWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCkIpkZW92wbas+uB+9MN8a0f2WZd9AWnAsfsFvWaR7/CbgHbiWs50JkJdeCvAhdKi8HMfM8Xya6V9MpwQIs5vkotdOFYi0Z52qlbLTpzG10gUXimaJWe10VxeQA4jyHMCCsBwZj4xuOmLvUzdOW5Q98VwkogejgE2pWXkhiJ8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=flRJ4O0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="flRJ4O0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6D2C433C7;
	Mon, 29 Jan 2024 17:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548054;
	bh=r+VH3w76J0NVQCnrdkbalUFjyuZ7SJK884C7b5dItWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=flRJ4O0DDMJgeC36OU7bHs66N7SYWF6KRnSimhBUKDRolim70JakaayoQyOORzupc
	 Y9wPuR1y825MbaZN49jT6iX9iWkg+wCT6dkPbEY5GlPnZBz7EMRocutPTroND1kZMt
	 HKVFoVOLVtAHs3izoFwTBIHcrfAoN2FBD+UBef7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Herve Codina <herve.codina@bootlin.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.7 033/346] soc: fsl: cpm1: tsa: Fix __iomem addresses declaration
Date: Mon, 29 Jan 2024 09:01:04 -0800
Message-ID: <20240129170017.360953587@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

commit fc0c64154e5ddeb6f63c954735bd646ce5b8d9a4 upstream.

Running sparse (make C=1) on tsa.c raises a lot of warning such as:
  --- 8< ---
  warning: incorrect type in assignment (different address spaces)
     expected void *[noderef] si_regs
     got void [noderef] __iomem *
  --- 8< ---

Indeed, some variable were declared 'type *__iomem var' instead of
'type __iomem *var'.

Use the correct declaration to remove these warnings.

Fixes: 1d4ba0b81c1c ("soc: fsl: cpm1: Add support for TSA")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312051959.9YdRIYbg-lkp@intel.com/
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/20231205152116.122512-2-herve.codina@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/fsl/qe/tsa.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/soc/fsl/qe/tsa.c
+++ b/drivers/soc/fsl/qe/tsa.c
@@ -98,9 +98,9 @@
 #define TSA_SIRP	0x10
 
 struct tsa_entries_area {
-	void *__iomem entries_start;
-	void *__iomem entries_next;
-	void *__iomem last_entry;
+	void __iomem *entries_start;
+	void __iomem *entries_next;
+	void __iomem *last_entry;
 };
 
 struct tsa_tdm {
@@ -117,8 +117,8 @@ struct tsa_tdm {
 
 struct tsa {
 	struct device *dev;
-	void *__iomem si_regs;
-	void *__iomem si_ram;
+	void __iomem *si_regs;
+	void __iomem *si_ram;
 	resource_size_t si_ram_sz;
 	spinlock_t	lock;
 	int tdms; /* TSA_TDMx ORed */
@@ -135,27 +135,27 @@ static inline struct tsa *tsa_serial_get
 	return container_of(tsa_serial, struct tsa, serials[tsa_serial->id]);
 }
 
-static inline void tsa_write32(void *__iomem addr, u32 val)
+static inline void tsa_write32(void __iomem *addr, u32 val)
 {
 	iowrite32be(val, addr);
 }
 
-static inline void tsa_write8(void *__iomem addr, u32 val)
+static inline void tsa_write8(void __iomem *addr, u32 val)
 {
 	iowrite8(val, addr);
 }
 
-static inline u32 tsa_read32(void *__iomem addr)
+static inline u32 tsa_read32(void __iomem *addr)
 {
 	return ioread32be(addr);
 }
 
-static inline void tsa_clrbits32(void *__iomem addr, u32 clr)
+static inline void tsa_clrbits32(void __iomem *addr, u32 clr)
 {
 	tsa_write32(addr, tsa_read32(addr) & ~clr);
 }
 
-static inline void tsa_clrsetbits32(void *__iomem addr, u32 clr, u32 set)
+static inline void tsa_clrsetbits32(void __iomem *addr, u32 clr, u32 set)
 {
 	tsa_write32(addr, (tsa_read32(addr) & ~clr) | set);
 }
@@ -313,7 +313,7 @@ static u32 tsa_serial_id2csel(struct tsa
 static int tsa_add_entry(struct tsa *tsa, struct tsa_entries_area *area,
 			 u32 count, u32 serial_id)
 {
-	void *__iomem addr;
+	void __iomem *addr;
 	u32 left;
 	u32 val;
 	u32 cnt;


