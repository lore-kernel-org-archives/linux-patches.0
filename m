Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1918E56448;
	Mon,  1 Apr 2024 15:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986693; cv=none; b=oqvFX9VTlsYL9B0kxqc4Y1KiFYSGw2h0jF4VbKwwFo7eWHWEWJeruJN3r6nviQC8X/TNwtDpQHEKDo5cXKU2IWgTX2eaEZi/dpIRGTcaYx/WaZtBFZn857TRZn3MZ4UGpKgLt8+AjCsBDwx0LFnkrrE8cD2gakR+8VsRw8MKJ8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986693; c=relaxed/simple;
	bh=X1mwflUElWsqmVMN11gZUlNo8I6NlqMb9Iy3LAYoy6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RjlWBKYg21e8vNGbnDp2DHbhs4WkDklwgdjVk8Vcn/9yZs11SdilaomRFMBHoVjhhws9kZnFc/00xNwESaILFMm5wiDcillB9HmEvMhxFXshcNFv/iC+xbgRQukqGoCWcAcYwhvu6tFyQndj/dPZXQdfotZO6gABp7QUyM0a6q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJcJqu0d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJcJqu0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485FDC433C7;
	Mon,  1 Apr 2024 15:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986691;
	bh=X1mwflUElWsqmVMN11gZUlNo8I6NlqMb9Iy3LAYoy6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJcJqu0dWvh0UCzXlk1JpEZySM1UqOJ816x0+yhR7tLuxoNuhIIY+FfqKD9larctl
	 Ti67fpp3F5KxDa5ZQXhQ42egVlMcvJXnqwdoUY/1wG1/vsQH0d7oigRVi4IOmW565T
	 ddm83j75kO4ufXpurHelf2BIBO0uR46DW4AIFKaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Stable@vger.kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 054/399] mtd: rawnand: meson: fix scrambling mode value in command macro
Date: Mon,  1 Apr 2024 17:40:20 +0200
Message-ID: <20240401152550.797122574@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arseniy Krasnov <avkrasnov@salutedevices.com>

[ Upstream commit ef6f463599e16924cdd02ce5056ab52879dc008c ]

Scrambling mode is enabled by value (1 << 19). NFC_CMD_SCRAMBLER_ENABLE
is already (1 << 19), so there is no need to shift it again in CMDRWGEN
macro.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: <Stable@vger.kernel.org>
Fixes: 8fae856c5350 ("mtd: rawnand: meson: add support for Amlogic NAND flash controller")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240210214551.441610-1-avkrasnov@salutedevices.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/meson_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/meson_nand.c b/drivers/mtd/nand/raw/meson_nand.c
index cdb58aca59c08..2a96a87cf79ce 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -63,7 +63,7 @@
 #define CMDRWGEN(cmd_dir, ran, bch, short_mode, page_size, pages)	\
 	(								\
 		(cmd_dir)			|			\
-		((ran) << 19)			|			\
+		(ran)				|			\
 		((bch) << 14)			|			\
 		((short_mode) << 13)		|			\
 		(((page_size) & 0x7f) << 6)	|			\
-- 
2.43.0



