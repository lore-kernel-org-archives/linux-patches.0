Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03BE7C
	for <patches@lists.linux.dev>; Sun,  6 Mar 2022 06:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=9Vr7FjCblwwACbp4fWjCXUxCOAXQxFXyRroWnqEsGlg=; b=B2Iye4rocCysjxtdMVfEtUxXvL
	A4PFY69NUOqtw3UsYm51C44aqsZCnnTtO1Ejed/tWW/aNRUzTS0C5vEleiARiubcVEk2qSAKcWR8L
	ZbkqPtO4tq0qnqP8EKnUbshLiJZQkS1NFDNJPMsUdb49X2xzXj2ijklz+GrtswzWCHver4oZ5DdmL
	Ws9cU5pgLTuyAAw26+F4Bl+wLGbCtYLRmBkg1ZUYV5Rka6RPGKjZ+EEiE9OE2V1lvyVZZiGOTVKas
	MYk0PWEd3yJ5o9Pouz/5bxGpoWvIQ8+/Xy65XZsToJrTEOTa3hFCD3BSaQPjz70nEYPD2+6gPthor
	FKfPx3Ag==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nQkqW-00EFJO-AT; Sun, 06 Mar 2022 06:58:24 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org,
	Yury Norov <yury.norov@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: patches@lists.linux.dev,
	Tian Tao <tiantao6@hisilicon.com>,
	Mike Travis <mike.travis@hpe.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] lib: bitmap: fix many kernel-doc warnings
Date: Sat,  5 Mar 2022 22:58:23 -0800
Message-Id: <20220306065823.5153-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix kernel-doc warings in lib/bitmap.c:

../lib/bitmap.c:498: warning: Function parameter or member 'buf' not described in 'bitmap_print_to_buf'
../lib/bitmap.c:498: warning: Function parameter or member 'maskp' not described in 'bitmap_print_to_buf'
../lib/bitmap.c:498: warning: Function parameter or member 'nmaskbits' not described in 'bitmap_print_to_buf'
../lib/bitmap.c:498: warning: Function parameter or member 'off' not described in 'bitmap_print_to_buf'
../lib/bitmap.c:498: warning: Function parameter or member 'count' not described in 'bitmap_print_to_buf'
../lib/bitmap.c:561: warning: contents before sections
../lib/bitmap.c:606: warning: Function parameter or member 'buf' not described in 'bitmap_print_list_to_buf'
../lib/bitmap.c:606: warning: Function parameter or member 'maskp' not described in 'bitmap_print_list_to_buf'
../lib/bitmap.c:606: warning: Function parameter or member 'nmaskbits' not described in 'bitmap_print_list_to_buf'
../lib/bitmap.c:606: warning: Function parameter or member 'off' not described in 'bitmap_print_list_to_buf'
../lib/bitmap.c:606: warning: Function parameter or member 'count' not described in 'bitmap_print_list_to_buf'
../lib/bitmap.c:819: warning: missing initial short description on line:
 * bitmap_parselist_user()

This still leaves 15 warnings for function return values not described,
similar to this one:
bitmap.c:890: warning: No description found for return value of 'bitmap_parse'

Fixes: 1fae562983ca ("cpumask: introduce cpumap_print_list/bitmask_to_buf to support large bitmask and list")
Fixes: 4b060420a596 ("bitmap, irq: add smp_affinity_list interface to /proc/irq")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 lib/bitmap.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- linux-next-20220304.orig/lib/bitmap.c
+++ linux-next-20220304/lib/bitmap.c
@@ -492,6 +492,11 @@ EXPORT_SYMBOL(bitmap_print_to_pagebuf);
  * @list: indicates whether the bitmap must be list
  *      true:  print in decimal list format
  *      false: print in hexadecimal bitmask format
+ * @buf: buffer into which string is placed
+ * @maskp: pointer to bitmap to convert
+ * @nmaskbits: size of bitmap, in bits
+ * @off: in the string from which we are copying, We copy to @buf
+ * @count: the maximum number of bytes to print
  */
 static int bitmap_print_to_buf(bool list, char *buf, const unsigned long *maskp,
 		int nmaskbits, loff_t off, size_t count)
@@ -512,6 +517,11 @@ static int bitmap_print_to_buf(bool list
 
 /**
  * bitmap_print_bitmask_to_buf  - convert bitmap to hex bitmask format ASCII string
+ * @buf: buffer into which string is placed
+ * @maskp: pointer to bitmap to convert
+ * @nmaskbits: size of bitmap, in bits
+ * @off: in the string from which we are copying, We copy to @buf
+ * @count: the maximum number of bytes to print
  *
  * The bitmap_print_to_pagebuf() is used indirectly via its cpumap wrapper
  * cpumap_print_to_pagebuf() or directly by drivers to export hexadecimal
@@ -553,12 +563,6 @@ static int bitmap_print_to_buf(bool list
  * move to use bin_attribute. In result, we have to pass the corresponding
  * parameters such as off, count from bin_attribute show entry to this API.
  *
- * @buf: buffer into which string is placed
- * @maskp: pointer to bitmap to convert
- * @nmaskbits: size of bitmap, in bits
- * @off: in the string from which we are copying, We copy to @buf
- * @count: the maximum number of bytes to print
- *
  * The role of cpumap_print_bitmask_to_buf() and cpumap_print_list_to_buf()
  * is similar with cpumap_print_to_pagebuf(),  the difference is that
  * bitmap_print_to_pagebuf() mainly serves sysfs attribute with the assumption
@@ -597,6 +601,11 @@ EXPORT_SYMBOL(bitmap_print_bitmask_to_bu
 
 /**
  * bitmap_print_list_to_buf  - convert bitmap to decimal list format ASCII string
+ * @buf: buffer into which string is placed
+ * @maskp: pointer to bitmap to convert
+ * @nmaskbits: size of bitmap, in bits
+ * @off: in the string from which we are copying, We copy to @buf
+ * @count: the maximum number of bytes to print
  *
  * Everything is same with the above bitmap_print_bitmask_to_buf() except
  * the print format.
@@ -807,7 +816,8 @@ EXPORT_SYMBOL(bitmap_parselist);
 
 
 /**
- * bitmap_parselist_user()
+ * bitmap_parselist_user() - convert user buffer's list format ASCII
+ * string to bitmap
  *
  * @ubuf: pointer to user buffer containing string.
  * @ulen: buffer size in bytes.  If string is smaller than this
