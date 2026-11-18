Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015967;
	b=MRv8PSj4UYrtTVOinWQr7NWmGT+sHufoYd2q8nk5UMEdWq7q18sUJka3rrohtIRCgpFz
	 EjhGtBMFrI4KjWM+2dTjMQnLKXh76qsj1OxlsCp8K6Nu9Aj/njlU03G4d1n3cRX5R2a4P
	 xxzhJn3Q2g6RDAXAflhywsAFdoZTq4d/mVy4f0aUOMtQsTjwJIIVrxDe+VdnU2dm+DANb
	 UiRyHNUhwiTzbDWLy2NNx+RbY+ZKumcHiBzFLISvp950MDAMTWcLvOvFgXyYlZjxEgD6R
	 vqfaeE4EZ6NTujH/8U2vHJUP47EfeyL+eMeajGU5rYizuDlHvC8A4oTSXgjrOlYNseA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PZEilf14ss3BW4ZM1xxbsQ420Ic7Ts44pIu67/42GGs=;
	b=FibqqJWV7cmlXt0hz57XFua00ZLoO2Wtw8ELdCGBmW3V8bc2GmJZBuZMre34w0b02ckb
	 2XPh7wzbVkxhAyCuRDzcgN6iIxAWchG4zAfkKYK71BLYSH8r6ac05VRelNdcnkK1yBZ/+
	 MtT9K3sA95ExE//JDxYY/htB/UR96amo61t9mQLNT7txG3nrrSPcN4jLT7seGq4gXNMBA
	 YzowxQzJMwwbx57jCxXxrLtJ3szo1o2/4Tzl4FYla0PXwAnM0S4YMGED2eVLbktWXdmEw
	 bVpr95Agm9335SDGBli1/5Z4G/LETrlAs2UQMHguCDZbQhYGR4Vix6Ev+ZLSIrHnmvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GOe9suKe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4926E606A31C;
	Wed, 18 Nov 2026 15:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GOe9suKe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD291F000C4;
	Wed, 18 Nov 2026 15:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015966;
	bh=PZEilf14ss3BW4ZM1xxbsQ420Ic7Ts44pIu67/42GGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GOe9suKe+xCZe1TQnIwMISxs7YLcvjbq7ujJUyAlYWNP7TK8o/Mgpt7OX9yL3pAc0
	 SzR//Ovwg4j5nmnAdnuNmLbnz0dYeVfpiKmTzeO6oXd+I8tEN9x5xca1mJrSZSpLWn
	 kO1GJk/2ii9zVBl/zigANvZ+5pZqz/e7+Xm03a8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Arka Mondal <arka@arkamondal.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0361/2651] usb-storage: alauda: fix out-of-bounds zone index
Date: Wed, 18 Nov 2026 15:26:41 +0100
Message-ID: <20261118150300.831737411@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arka Mondal <arka@arkamondal.net>

[ Upstream commit c4542993c071fcafe7335698bf52650dee7e3555 ]

MEDIA_INFO(us).lba_to_pba and .pba_to_lba are arrays of num_zones
pointers, allocated by kcalloc() in alauda_init_media().
alauda_ensure_map_for_zone() reads lba_to_pba[zone] and
pba_to_lba[zone], and when either is NULL alauda_read_map() writes a
pointer back to both. Two separate errors let zone reach num_zones, one
element past the end.

max_lba is capacity >> (blockshift + pageshift), which counts physical
blocks, but zone is lba / uzonesize and uzonesize is 125/128 of
zonesize. On a 16 MB card (alauda_card_ids id 0x73) num_zones is 1 and
uzonesize is 1000, so lba 1000 to 1023 pass the bounds check and index
element 1 of a one-element array.

alauda_read_data() also calls alauda_ensure_map_for_zone() before it
compares lba against max_lba, so any larger lba is used as an index
before the check rejects it. alauda_write_data() already checks first.

Bound lba by num_zones * uzonesize on both paths and move the read
side's call below the check. alauda_transport() reports
num_zones * uzonesize * blocksize for READ_CAPACITY, so the new bound is
exactly the range the device advertises and no block becomes
unreachable.

sd never issues an lba past the reported capacity; an SG_IO READ_10 can.

Fixes: e80b0fade09e ("[PATCH] USB Storage: add alauda support")
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Arka Mondal <arka@arkamondal.net>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260901065831.43567-4-arka@arkamondal.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/alauda.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
index d47ce01d519a0..5e7f99ba8ac01 100644
--- a/drivers/usb/storage/alauda.c
+++ b/drivers/usb/storage/alauda.c
@@ -949,6 +949,7 @@ static int alauda_read_data(struct us_data *us, unsigned long address,
 	unsigned char *buffer;
 	u16 lba, max_lba;
 	unsigned int page, len, offset;
+	unsigned int num_zones;
 	unsigned int blockshift = MEDIA_INFO(us).blockshift;
 	unsigned int pageshift = MEDIA_INFO(us).pageshift;
 	unsigned int blocksize = MEDIA_INFO(us).blocksize;
@@ -973,7 +974,9 @@ static int alauda_read_data(struct us_data *us, unsigned long address,
 	/* Figure out the initial LBA and page */
 	lba = address >> blockshift;
 	page = (address & MEDIA_INFO(us).blockmask);
-	max_lba = MEDIA_INFO(us).capacity >> (blockshift + pageshift);
+	num_zones = MEDIA_INFO(us).capacity >> (MEDIA_INFO(us).zoneshift
+		+ blockshift + pageshift);
+	max_lba = num_zones * uzonesize;
 
 	result = USB_STOR_TRANSPORT_GOOD;
 	offset = 0;
@@ -985,10 +988,6 @@ static int alauda_read_data(struct us_data *us, unsigned long address,
 		unsigned int pages;
 		u16 pba;
 
-		result = alauda_ensure_map_for_zone(us, zone);
-		if (result != USB_STOR_TRANSPORT_GOOD)
-			break;
-
 		/* Not overflowing capacity? */
 		if (lba >= max_lba) {
 			usb_stor_dbg(us, "Error: Requested lba %u exceeds maximum %u\n",
@@ -997,6 +996,10 @@ static int alauda_read_data(struct us_data *us, unsigned long address,
 			break;
 		}
 
+		result = alauda_ensure_map_for_zone(us, zone);
+		if (result != USB_STOR_TRANSPORT_GOOD)
+			break;
+
 		/* Find number of pages we can read in this block */
 		pages = min(sectors, blocksize - page);
 		len = pages << pageshift;
@@ -1052,6 +1055,7 @@ static int alauda_write_data(struct us_data *us, unsigned long address,
 	unsigned int pagesize = MEDIA_INFO(us).pagesize;
 	struct scatterlist *sg;
 	u16 lba, max_lba;
+	unsigned int num_zones;
 	int result;
 
 	/*
@@ -1078,7 +1082,9 @@ static int alauda_write_data(struct us_data *us, unsigned long address,
 	/* Figure out the initial LBA and page */
 	lba = address >> blockshift;
 	page = (address & MEDIA_INFO(us).blockmask);
-	max_lba = MEDIA_INFO(us).capacity >> (pageshift + blockshift);
+	num_zones = MEDIA_INFO(us).capacity >> (MEDIA_INFO(us).zoneshift
+		+ blockshift + pageshift);
+	max_lba = num_zones * MEDIA_INFO(us).uzonesize;
 
 	result = USB_STOR_TRANSPORT_GOOD;
 	offset = 0;
-- 
2.53.0



