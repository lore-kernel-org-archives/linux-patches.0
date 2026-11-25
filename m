Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624842;
	b=ACGCaZsfAxyIj3xk9fiWxiNbdlvOCzaXmEZOOMZA5oFpYiIEguTCUaqP1iCdtgM3q7+N
	 6NYiTGwnlrCq1BZ2CEyfFJIStVDWQvYMLZyX8jRfeEPRDeQdFqmcrIXIFBhPunFcMV6TZ
	 t2u0OxJAvZSFsM4W5lhm/PH1R5sgZjH06Xf3NEnaWZm2o9FkvZrqOQLPNjxsoE3YnHr6A
	 gDsccRNqtxQmfN4gpoHjcACVTw3RMwTevxHLAdmpqLASLI+9ne9SXGMKYVqTJlzcpWoZ6
	 EgmP/J8PXu0TzClGDyOxAZjWbuzPX1kNmKOjocu7Gxplhjy/cIWoD+5kMPVtx4/72KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SY5iIUb/evDE0XDslNo53mKij/6VbVKzg9YbHYHzUGk=;
	b=BkwqmUcqskEBy1UtKsX7Jjx05soZkQZ91aCAW29/XV7+F9VAEY1P+jeY0TLbA5tVjmNV
	 nHUdbj+1YmBVAi4woZo1tNkeKK5hZ2hv1gwSFN3z1kLe8VNqA3A+SC3SxkrnbyvSt3TF/
	 lXuiDdOI30GHSs/uB+KvtP01ocj+JkiHFYHn1a3sDDqnIJRtMM2TQBxN4lVDvtLjMiNGU
	 kVj7A11kCgW2wwkprU8bFH1Z8xSFHskpcSvo9x2OMvDcVTMaQk/oLMlDgOqLHcL1/65XN
	 mDssWLo4T0wdPDzwLKeEY0PZoQxqkWJ/iVjnmGbTk+4knsS0Q/MxM5U0rkXvkRpncqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pekIdNdv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3F9606A32A;
	Wed, 25 Nov 2026 16:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pekIdNdv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3221D1F000D1;
	Wed, 25 Nov 2026 16:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624841;
	bh=SY5iIUb/evDE0XDslNo53mKij/6VbVKzg9YbHYHzUGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pekIdNdvMsso745EPMz5svwhrDT6IQhFoEgOkRkSk28R7bpflnogLq94g7xYHotJH
	 ID0wDdjitlZjx/rmqscU7n8/Td/z/IgrlhsgBoQYY2MjoWI5WiPiwnHvrLYPY7Fy4i
	 +0ogOj3cZyTs+CBSAwR8BnmaVlFN20E9bxM9D5Rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 279/816] ata: libata-scsi: set the field pointer when rejecting CDL
Date: Wed, 25 Nov 2026 15:30:27 +0100
Message-ID: <20261125143855.666959570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shao Mingyin <shao.mingyin@zte.com.cn>

[ Upstream commit 7c972e73641cbe5f77f63c336de15c7a30268d49 ]

ata_mselect_control_ata_feature() rejects enabling CDL while NCQ
priority is enabled, but unlike its other error branches it returns
without setting *fp.

ata_scsi_mode_select_xlat() initializes fp to 0xffff and, when the
handler fails, adds the offset of the mode page in the parameter list
to it, i.e. the length of the mode parameter header and of the block
descriptors. As fp is a u16, this wraps around, so the resulting sense
data reports the byte before the mode page, i.e. the last byte of the
mode parameter header or of the block descriptors, as the FIELD
POINTER, instead of the byte containing the CDL_CTRL field that
requests enabling CDL.

Set *fp to 4, i.e. to the byte containing the CDL_CTRL field, like the
branch rejecting an invalid CDL_CTRL value does.

Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-page translation")
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
[cassel: set *fp to 4, the offset of CDL_CTRL in the mode page]
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20261103205448.931471-17-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 7f093456fa3b7..5be76156f1dc1 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4222,6 +4222,7 @@ static int ata_mselect_control_ata_feature(struct ata_queued_cmd *qc,
 		if (dev->flags & ATA_DFLAG_NCQ_PRIO_ENABLED) {
 			ata_dev_err(dev,
 				"NCQ priority must be disabled to enable CDL\n");
+			*fp = 4;
 			return -EINVAL;
 		}
 		ata_dev_dbg(dev, "Enabling CDL\n");
-- 
2.53.0



