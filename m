Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016286;
	b=U7TkXXv7Ewm87Lty2XVJtZPg0CDFuzkB0Z66VgcI4Cpzw63an+r3aHZcrevokKwn07qF
	 CzjzKgR8g7/RN4e5eMH+tPFe1jtHtqLcaaVcz1vOmJg93rJolo1fKwmBxFw7wTB1vSghk
	 uXg4LphHM0Pinh099+oNQyPQUJMYGXpqmkk6BpQ5COhzr37EB42xmVSuNVgj3xVT4wy4v
	 lnO7NYrey7Ro9jbsQtX7xi1Ki3oySmDrfAtYP98psBK0HZBY6T9dFuzBt7x48uekkgGxw
	 vnR9DBKGdZ6udP+lCTFOoz/RadKFu2XTpkHTnT1YUGJ5jyNygONZbSRWsyuy1k7u9sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m0E1YvB3Wqb2veHEQ/Oo+miYxMcDCUoj6fcuARDob/c=;
	b=HK2R3+WygQ0xSUBZ/hU+j2lkDYcYn3s3zx4xqyRRDDHK96/pEoOmywWf6QIXaZUP34ya
	 +aWWeLh5mZ7N2sonZVv/pcTcT3XzbdkAOeX4KdckfQSScaj2H76I+QLTZLdbyx1Jo/BOi
	 8SjPX54026PHoM70WmXYbTmlFtaEa0Kad82Wqrbppur7f5wJlqIZjS9GZAeEjUjPgRebg
	 fhf3xL+aLO+zGzGuhiSSolZ4YUIIu9TV7w+fd8JpDxy/0weagjs4dSZEsZ4/F7m9I9CjS
	 KOIdKI1nU5LvI7DVxWwjMvyc8IoLeQ586LDpawlUYlieBRHAHr1tS/dNkgan+rHeN1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUXQUAjj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E6D606A337;
	Wed, 18 Nov 2026 15:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUXQUAjj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA1A1F000C4;
	Wed, 18 Nov 2026 15:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016286;
	bh=m0E1YvB3Wqb2veHEQ/Oo+miYxMcDCUoj6fcuARDob/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mUXQUAjjTShAjv30+SKLJiDcOGJPd9ZpHxR/YluHSNH9KseZHi3Faee1RByTCDcTR
	 NQdbjCWYF8RzzK0UMiQqeWyrazPn7uAvtEBarhVkH/aMy/a4wMWcwjZyb9FTyIcgp4
	 hb52/AJEUAk+XOBjUMgTbSe6RgrbtsFT54zM2h6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0434/2651] ata: libata-scsi: Fix ata_scsi_hotplug() reference in kernel-doc
Date: Wed, 18 Nov 2026 15:27:54 +0100
Message-ID: <20261118150303.450267902@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 5915ab523e33057224a0240e27b88c6c2798b919 ]

The ata_scsi_remove_dev() comment misspells its caller as
ata_eh_scsi_hotplug(). The caller is ata_scsi_hotplug(). Correct the
reference, which predates libata's move from drivers/scsi to
drivers/ata.

Fixes: 580b2102327a ("[PATCH] libata-hp: implement SCSI part of hotplug")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20260912101215.86413-1-kmehltretter@gmail.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 023de0e633b71..5be2e2597770f 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -5422,7 +5422,7 @@ bool ata_scsi_offline_dev(struct ata_device *dev)
  *	ata_scsi_remove_dev - remove attached SCSI device
  *	@dev: ATA device to remove attached SCSI device for
  *
- *	This function is called from ata_eh_scsi_hotplug() and
+ *	This function is called from ata_scsi_hotplug() and
  *	responsible for removing the SCSI device attached to @dev.
  *
  *	LOCKING:
-- 
2.53.0



