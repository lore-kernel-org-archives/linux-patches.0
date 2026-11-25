Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621797;
	b=u3QvCrw3n9wmCPXxPY9og5+VzfKCkc51JfuxlpDh2yPYCYaq/FPscm7a211/2evXuerh
	 5KG+9Xo2eNRs5jNLH3TDwFNATKL8k2R+otWe2BrDJDAwGMaxGCI88437cjiDwfQhjt6XU
	 mPbXevk/deEQL3lliSZYVfUbbYw9PCc6O+1+cPSAZ0yzdaj+i0hc0eaXyZeMfu9TmSM3O
	 7Da844IRW28ZIADSzL/JGRTs2O9mjqD8m7m5tBE04AACG0EBP/jDPGpV5QY1Rvu5SplRD
	 qZ3SvtKzRhg2B9lQ2Mqds4G7Pb7xBlrndEYZl/lWBzciYFKK+hCK1C6JRkXnSpw3Q9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c9vJWujKdlR9pZknGqgRs7W6xDCBPntNHXLw/G0ThTk=;
	b=kZjob24JLaREJb7Ouz1xyrEtZr7Dh46z8QcdcA0AS+t/US6buao80u4lvdk2bOg4jfm4
	 8i7amdZT2K4Vwt/37H7DU3G/rvgvZkirr+Q9go4g/nRPbulV8yA+yHlEy/UiBiKv70hpY
	 K7pB7vZJi0a7YUc+kKdcd7uISgi3nKohw05ZiYGGulmQjKkHCncQ09tXntWiRhWPfHNa0
	 oXpamjPPGdo5sNOhnTRfeWjqmdj9AfGIF5aLJRLqaIV1lV97zdscEbxZGE54IMaRWrojb
	 IesUs/npDbOht5BkvxALr/s+ERkYbpUNgle4RYWFYXmvyltgjMRvD9XSYXEQj+eIbGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I6vjhrDG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED93606A329;
	Wed, 25 Nov 2026 15:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I6vjhrDG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2D21F000C6;
	Wed, 25 Nov 2026 15:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621797;
	bh=c9vJWujKdlR9pZknGqgRs7W6xDCBPntNHXLw/G0ThTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I6vjhrDGAhbBFl3mbrc7goyS2NiUXh/qbhgLjk/JqK5QN+Lg8QrLi7ZwRos3GZEk0
	 KA/JkZKdl/Yt7+2+P7R8Jxrsm8MtJU0k9koJyOZDX+W9eWb/S/dHvlJX4kLy/hmkbC
	 STOTgz79ABocPsRLTmiGGRsZXJRoBGNVK058JtUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 338/990] ata: libata-scsi: set the field pointer when rejecting CDL
Date: Wed, 25 Nov 2026 15:28:25 +0100
Message-ID: <20261125143830.010906556@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index c9aa4521a4fe5..5defffb9a3e09 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4210,6 +4210,7 @@ static int ata_mselect_control_ata_feature(struct ata_queued_cmd *qc,
 		if (dev->flags & ATA_DFLAG_NCQ_PRIO_ENABLED) {
 			ata_dev_err(dev,
 				"NCQ priority must be disabled to enable CDL\n");
+			*fp = 4;
 			return -EINVAL;
 		}
 		ata_dev_dbg(dev, "Enabling CDL\n");
-- 
2.53.0



