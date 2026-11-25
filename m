Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618732;
	b=3ik7iNM7Xnraocd/W1oi3zczHS0I9Au3GQjLdup5RxG9NNCja4gmIwyvDciTe8i7FIoG
	 F5GUGRTfg45K2lVbAs9vIzKlcYh8C8PfWOA6YLJn3710dKZ0YF64/77QbBnbS5qCuEuhJ
	 iREsIUWeBLDoWnSmir3Fa+6byzzRUT0HgBEIEdGKa3TzAR8DeTOMPQr2MXNHyJ7NzQdFt
	 Y0EOYGbMM2xYf5+MGWLAnyKOfWm/BUe3IpJGawkCTJPQ0qBxhdZH/mYcumWwRpzkJnkG9
	 eDEiyJs3XNQSDRJhS5EOnkvcFd2tmyVGiu89j2+6SFTJ1RfaGRe6oHYhMTPT+xCDlRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=asCbhoQROwFNXQYuJt8TVtG/67dnfI70r0Oszr+Mi7g=;
	b=j13XhvkKqf4PZEa2EgBUtmUVZCq94ZH6WH7QQ7IoN581FzVlRPLzf9Glrq7tCEFznTX3
	 a1wvaSVINGJ6t56fKxrl0jGwjqoE50B/TJq/lZEw2TIz2pLB8GHouzgtVx+oMyo6RtmAp
	 DLr0yiehqtw6+mKJvYnZrNijE/Pk35haSC+3Ur+92XWV/zIPef7U4qVVn3TozG3NeqqcR
	 LVWZ1PV6S9TLYm6rZkq15qvZa0DOkOOlppQjYKXELnw7se0JPk5sQATH2JEXA4LLXgORW
	 mhE+TSqFg/DvdIgLStFVCtGk6B9qIsJEtpOSFwJZhGwHUBCl8lqNBzMenRpkEC3eVLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xqrcoh1m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0A5606A31E;
	Wed, 25 Nov 2026 14:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xqrcoh1m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52CA1F000C4;
	Wed, 25 Nov 2026 14:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618731;
	bh=asCbhoQROwFNXQYuJt8TVtG/67dnfI70r0Oszr+Mi7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xqrcoh1ma+/FOWrjz5cljfEIaVuuJlpFFe6e3uWQ+kFxnAjZ3p3h96vqthIjGd44m
	 f518Os3x2t2eHHDNKhByNXzVI+a1WLB6GTPDYIALmYoMsAKmK/15zQSgrp6WjUh4PQ
	 12YU+biLUZBy4tqxfNcwD1pKo/OOjJEPokOdhskc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0373/1005] ata: libata-scsi: fix MODE SELECT field pointer for block descriptor length
Date: Wed, 25 Nov 2026 15:28:31 +0100
Message-ID: <20261125143830.474645502@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit a3e52dcf0fbaa1a103accef3e8861cdc250ee5d6 ]

ata_scsi_mode_select_xlat() only accepts MODE SELECT parameter lists
without block descriptors or with a single 8 byte block descriptor. For
any other BLOCK DESCRIPTOR LENGTH, it terminates the command with
INVALID FIELD IN PARAMETER LIST, and the FIELD POINTER should point at
the BLOCK DESCRIPTOR LENGTH field, i.e. at byte 3 of the mode parameter
header(6) or at byte 6 of the mode parameter header(10), as SPC requires
the FIELD POINTER of a multiple-byte field to point at its first byte.

However, the mode parameter header length and the BLOCK DESCRIPTOR
LENGTH are added to the offset of the field, so the FIELD POINTER points
3 or 6 bytes after the end of the block descriptors instead. For
example, a MODE SELECT(10) with a BLOCK DESCRIPTOR LENGTH of 16 reports
byte 30 instead of byte 6.

Do not add the mode parameter header length and the BLOCK DESCRIPTOR
LENGTH to the offset of the BLOCK DESCRIPTOR LENGTH field.

Fixes: 7780081c1f04 ("libata-scsi: Set information sense field for invalid parameter")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20261103205448.931471-15-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 71db0c4d4914a..fc3c04fd27ad7 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4572,7 +4572,6 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 		goto invalid_param_len;
 	if (bd_len != 0 && bd_len != 8) {
 		fp = (six_byte) ? 3 : 6;
-		fp += bd_len + hdr_len;
 		goto invalid_param;
 	}
 
-- 
2.53.0



