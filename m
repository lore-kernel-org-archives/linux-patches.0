Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618738;
	b=aGIROl0ED+TnAJV/lDHtPpMoY1cLvsDXoPv7DRY21uqN/qIoDIjg0JtYJTMpNUkLW6cf
	 MEbFV1MQX64Jv800Yu64bgJ2gOMjU4zRZ0bRLR0NN/c6w86bM79GeJCWszdDurhjh3RHa
	 CCLODPlHTFK+6wrlaaO1GdAtxBMC87h7Qtq1QjeJUMIYoFs6gvirEvzZ3vdbAi0SPEFCw
	 EbcSbXqJOk+7z1i8CQtHA7lOiIziN5EnqUQcMvJLXaYpwOBlooKMf2xRAKXQYw2sAWziJ
	 5RhKrbFJW5erxyOHFhctlNFKBvOhiKgmDYDdxwtNtZiUxwlhJb2eaUaDs8tCsB4E3mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618738;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MihfscRt7bmj/so8B8lf23eJavZpyrlHg16q4KosAo0=;
	b=eV+WuH0E+KB0V9Q6H2JcbxezaPAROTw4u7iY1QzH1Jdz1ItNn0s5+lpv9+qmydulsd5M
	 pzM8FsoSF9Wzxm8b5GZEmhs9FChm3gRSu4AinxljT6j2zOMqTHkkp4bJnYRu78uroXVoX
	 H0WR/iHBvu8jkyV70Apvw0i+zN0stlWa/Gp/2WLRtGYAtDqo0UvUBujISw7mHu9n+lN0Q
	 6i9+yuN4B81MJoRbqB5IOBis5SoWbVaM3V9tjlEtWeOvWZ881Qnp8NaKgnmOB737seG+9
	 7iRchYPtGV+4GAYO594d31d0Hl9OvCKhefpNAgUzXtgVu1sAf8thoygahw24LxHa4hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WOPJ70l2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38BB606A31E;
	Wed, 25 Nov 2026 14:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WOPJ70l2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD4F1F000C6;
	Wed, 25 Nov 2026 14:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618738;
	bh=MihfscRt7bmj/so8B8lf23eJavZpyrlHg16q4KosAo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WOPJ70l2jcMbtVYmu0PDVQB6IWDK2DGswmac4XqHXdde/InVEl/zInRSdNiVPmli2
	 E98rqMkIV/enfSzOK7G10GQP3BONLcixBvWLUQi25RhugdAllTFoVDntGshf20wDxK
	 L/2iGCAd9bGzbEyLLZEuPl2rDC7miE96bX135OjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0375/1005] ata: libata-scsi: set the field pointer when rejecting CDL
Date: Wed, 25 Nov 2026 15:28:33 +0100
Message-ID: <20261125143830.521201675@linuxfoundation.org>
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
index 74273bd7d1add..c423a91535563 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4480,6 +4480,7 @@ static int ata_mselect_control_ata_feature(struct ata_queued_cmd *qc,
 		if (dev->flags & ATA_DFLAG_NCQ_PRIO_ENABLED) {
 			ata_dev_err(dev,
 				"NCQ priority must be disabled to enable CDL\n");
+			*fp = 4;
 			return -EINVAL;
 		}
 		ata_dev_dbg(dev, "Enabling CDL\n");
-- 
2.53.0



