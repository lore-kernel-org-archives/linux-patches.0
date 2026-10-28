Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215812;
	b=vB81t3T/I9Xrr1Y2WjvxkmagML1cGwka/3yie+aQ7vPpEwcuiXFLLFKoaLnOsgnXJ+al
	 eNDuAyF8SWtPlksiIwyxRvAFxnoUkpXCIdoL1KgkEbVgb+WgQfhorgT2G4R0HynJyo9yn
	 rnIapKapPaEBOkQAaIJxu4GK38AzTdw5zBaZSiZIWyJx8GgUS6b28cN20r+1pjOjxiZm1
	 0Qa2PDU0s4rLRHqhedr4Gp0S5E9qezYf1NnfPnz/kI7l83QG9ZcLiRKfW5MKU2pAr6iW+
	 hQk/xxim1Jlw1O7pI9IyTgn5h2+h4PZ//oPZnkyhaKoY47cpckJMfTJYcj0caBmUShg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215812;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=T5wQvdPSsC24c6KYrwj4eBPDWQzzt5zxQZqlnTmDW5g=;
	b=oqms22kuI5uip9hZyFZslKKN9bCflauk228uEOZyVlrup39aka4KuTln4zzTyHYCxWI6
	 ScL7A2Xanmda0YBvnCAaUCV4MmwuAzOYkB/lCiU0lw0XY04+TXkeTXLKbSbqcCOz43Qg9
	 g9nDN+o+tf6C+wY41x31CyyXLCsMZpzqdFasWXAtoHxCS0b7yNLepspVa4rLwZCEKpd33
	 BnFuT3xXr9mfHMUD3G6ZpN9ZxatFwzAl4qpTtgvayMmOD8xRGrnnrCW/IBhnR084xUSBT
	 AR3LVzCnP6rgCoQJhpFFL0//E04rYxnvMvXBCe0rdETsfIXy3ZVqkovWjKbCMJix8Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="F7H/sxQp";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679BF606A31A;
	Wed, 28 Oct 2026 19:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F7H/sxQp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B086F1F01825;
	Wed, 28 Oct 2026 19:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215812;
	bh=T5wQvdPSsC24c6KYrwj4eBPDWQzzt5zxQZqlnTmDW5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F7H/sxQp5Kmb1c2FLXFm5qxdZjPome9nwOLgp5W5vYOUKhv5MUFcYlkOJfxbOrmMn
	 uVQ81PRDHVuoOn0rmzV1QjbxD3/fZv+GC21UWEuaTp+jeCye2XTf8UjBrutDlElduU
	 g4BwJDv0lDvsXN6twJhSpf6JneDDOp7NgpH8Corg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1341/1887] s390/dasd: Fix undersized format-check buffer
Date: Wed, 28 Oct 2026 17:57:17 +0100
Message-ID: <20261028170529.957003270@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Haberland <sth@linux.ibm.com>

[ Upstream commit 7f40b346462f563a0d6e841a77b5163d2a882a04 ]

fmt_buffer_size in dasd_eckd_check_device_format() is declared as
int, even though one of the multiplicands, sizeof(struct eckd_count),
is a size_t. The expression

    trkcount * rpt_max * sizeof(struct eckd_count)

is therefore correctly evaluated at 64-bit width, but the result is
silently truncated when it is stored back into the 32-bit
fmt_buffer_size variable. For a sufficiently large track range
(start_unit/stop_unit are caller-controlled) this truncation
yields a buffer size far smaller than the number of tracks actually
requested. kzalloc() then succeeds with an undersized allocation,
while the subsequent channel program build still operates on the
untruncated track count and writes past the end of that buffer.

Compute the buffer size with check_mul_overflow() and keep it in a
size_t, so that a value that no longer fits results in -EINVAL
instead of a silently truncated allocation size.

Fixes: 8fd575200db5 ("s390/dasd: Add new ioctl BIODASDCHECKFMT")
Cc: stable@vger.kernel.org #4.7
Reviewed-by: Jan Höppner <hoeppner@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Link: https://patch.msgid.link/20260727142840.567286-4-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/block/dasd_eckd.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 76c3156902b0c..e83a43c09d74a 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -23,6 +23,7 @@
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
+#include <linux/overflow.h>
 
 #include <asm/css_chars.h>
 #include <asm/debug.h>
@@ -3518,11 +3519,11 @@ static int dasd_eckd_check_device_format(struct dasd_device *base,
 {
 	struct dasd_eckd_private *private = base->private;
 	struct eckd_count *fmt_buffer;
-	struct irb irb;
+	size_t fmt_buffer_size;
+	unsigned int trkcount;
 	int rpt_max, rpt_exp;
-	int fmt_buffer_size;
+	struct irb irb;
 	int trk_per_cyl;
-	int trkcount;
 	int tpm = 0;
 	int rc;
 
@@ -3533,7 +3534,9 @@ static int dasd_eckd_check_device_format(struct dasd_device *base,
 	rpt_exp = recs_per_track(&private->rdc_data, 0, cdata->expect.blksize);
 
 	trkcount = cdata->expect.stop_unit - cdata->expect.start_unit + 1;
-	fmt_buffer_size = trkcount * rpt_max * sizeof(struct eckd_count);
+	if (check_mul_overflow(trkcount, rpt_max, &fmt_buffer_size) ||
+	    check_mul_overflow(fmt_buffer_size, sizeof(struct eckd_count), &fmt_buffer_size))
+		return -EINVAL;
 
 	fmt_buffer = kzalloc(fmt_buffer_size, GFP_KERNEL | GFP_DMA);
 	if (!fmt_buffer)
-- 
2.53.0



