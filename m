Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2423188A0E;
	Tue, 29 Apr 2025 18:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950412; cv=none; b=O6/wV2wccJr52dDJA6cNMufOIRH/mai6PUCCFSyp4nW66KRhCk7OcYGK0sDtB+ljHABBn31A+jXQ+aPI+JP6VLtAWam/noXaPdcMmXQQ0YLxisiG2NRO73+xVFmTaLB7ccHcmpzbxl2vVXuRfPaMRWnzbSonxKRTcOQwTmjXvMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950412; c=relaxed/simple;
	bh=owDnYZN8lIn1z1d9vltJjVJuOqCguwBPY00Oh+lUDog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIacMVGSPIt9iT1KNu7xGU6pihhHVp+VYRyX0a0wv6xKW5Jms/cVQnjUoXKeVqBie8j4+dKHjhCv1ATxbo6zt/USd2tH6/+ofB97wcR5MPGqiB7Bp9HYIV/wYUF3Ih8VNMJ+KtgqGhSKTCTs2qhB7mCw8WKoLpG0wOwR4YmUBBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DCG8E/D3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DCG8E/D3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32632C4CEE3;
	Tue, 29 Apr 2025 18:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950412;
	bh=owDnYZN8lIn1z1d9vltJjVJuOqCguwBPY00Oh+lUDog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DCG8E/D3SxNrs2B6HTckIo5kdzKPJZDlpqc7uxa71iE9+CTPFPQvIcZgEeyl25bq4
	 gxAlYCpU+nz5CI4hGcPbFezxHzlBmumhrjpXRvq4LSfU4tR/3DJWwqu5XjLqPg09Pd
	 uoacMZB+mrfliqYpYSC+OjQT1FTXan/oSjKnnTQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>
Subject: [PATCH 6.6 087/204] ata: libata-scsi: Fix ata_mselect_control_ata_feature() return type
Date: Tue, 29 Apr 2025 18:42:55 +0200
Message-ID: <20250429161102.985255025@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit db91586b1e8f36122a9e5b8fbced11741488dd22 upstream.

The function ata_mselect_control_ata_feature() has a return type defined
as unsigned int but this function may return negative error codes, which
are correctly propagated up the call chain as integers.

Fix ata_mselect_control_ata_feature() to have the correct int return
type.

While at it, also fix a typo in this function description comment.

Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-page translation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3764,12 +3764,11 @@ static int ata_mselect_control_spg0(stru
 }
 
 /*
- * Translate MODE SELECT control mode page, sub-pages f2h (ATA feature mode
+ * Translate MODE SELECT control mode page, sub-page f2h (ATA feature mode
  * page) into a SET FEATURES command.
  */
-static unsigned int ata_mselect_control_ata_feature(struct ata_queued_cmd *qc,
-						    const u8 *buf, int len,
-						    u16 *fp)
+static int ata_mselect_control_ata_feature(struct ata_queued_cmd *qc,
+					   const u8 *buf, int len, u16 *fp)
 {
 	struct ata_device *dev = qc->dev;
 	struct ata_taskfile *tf = &qc->tf;


