Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023576;
	b=sowGHzn3mXtRofLVX4nsh+NwToz2wWc0422H5PV62q1ZRv0NSKdNVvgrKit+wu5Byqz5
	 3iH4p21WaRHF9wTjZT5p75vy0TDp78HM446gveB++bCvoiHQZh2VI8smBIFew6GdUnZkx
	 AXlhsYefGULPZvgHH4sxLqMnBGyY0EbJlfRm1MTdlnQiVgVGAc7jNIOD1YvLGAV2N0hgJ
	 3miX/SMhvBhCVoav02TFil6P87Z/zqXfqYPNQTuLaIKpbwRhzqJMVmCbdjXIxgPw3I/AH
	 y/mcUZFq6QbA546MUD37C0DyH4FnOYZSa90QUpxSYEW4OSNgo8s2ecQjr2LNt7buWGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e6PxrKEVP+RnaHecUW1QqZoDC1q2axgpX/xuucWO23g=;
	b=tu2HrN/e2g1b3pIyAMu6A8qj6LMQSeYRhDtOwJYLPTEjcCdMXtRR4pU23UsJcfjUd0HJ
	 QKzYnXf2AwtKd5otORXKN/+zq0Rk1KL6fp+GKj3ZIX1froRj/ivXRraldXm3WNJZWluWQ
	 eMco1uNnBKgW1vpAwWHms1KF3oxp8LjSsGHOK2U+tHSWA0ZiGHAoELofOkCBsTzIEsIkj
	 iBdpxNf53nFM786dYfpvq0BRyrCTB5NyIC0bPrAxPlYD6q8hfKyJZmN4DH/rDKdFetwS4
	 3SUW9c41Bh2elrW/PGep6QuYAMII5oZSyEZf8e9YPTIjoEM3d+UKK2i40sxOK3gX1Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M1qxpQCu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E1A606A334;
	Wed, 18 Nov 2026 17:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M1qxpQCu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A701F000C4;
	Wed, 18 Nov 2026 17:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023575;
	bh=e6PxrKEVP+RnaHecUW1QqZoDC1q2axgpX/xuucWO23g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M1qxpQCuC810GCJfos/yxb4RoMY3aIHGgSOfhNVQEo6RsKvrbUiNGmYJnYZcqM5II
	 7TZisBDthOK+6Yzs1jDpi1sTw0wKeOooq9MwWUZ0NQEL4LkOMxvOjhmANYAu8+/EOF
	 nFBJdNSYKAOg9LNiPvau/51e6x+zvsFRbZenX470=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0417/2151] ata: libata-scsi: Fix ata_scsi_hotplug() reference in kernel-doc
Date: Wed, 18 Nov 2026 15:35:52 +0100
Message-ID: <20261118150137.245582194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0988bf574b81e..ce206f90d8bc4 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4919,7 +4919,7 @@ bool ata_scsi_offline_dev(struct ata_device *dev)
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



