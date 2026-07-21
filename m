Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9482E736D;
	Tue, 21 Jul 2026 17:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654592; cv=none; b=IzM36h4encxO5xZwdMZ0RtK0puUrqInE1QsbeBxhp05Nl2glyWvPF7lPxHRRk16h3I3MCho3J1tsHp0KlnLzJPgSlvuOVLSIiet22cBcGKcmMkBRjYQl7A76aXLIrbpF4iGDWpErBHMQqXExFLeykUjPYGCVBwDqc/TFSKmsvNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654592; c=relaxed/simple;
	bh=iV9Re+wn29smm6Z/23lUfnAmxZ2Tt7m1Nq/kZ32S7/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDErpcUlXBR8t4h5Vfk2Hs9zG+kLx2h7lSRMyWrXJHlsUKTvVD3eylIB5STIojLgz6QJM/lVvgdWzVc/CI0pdsh3RwphNMV9NQ6ixqhtZEHq5hcey7GzrDi7vNgfG1y6FeDeNKxfOCYDQWwB3ABdyRccdBHPThXh0uo3ZCr4wng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bxmQfMUL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bxmQfMUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA12A1F000E9;
	Tue, 21 Jul 2026 17:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654591;
	bh=SPcwSE3u4wrljB2Y5xOvNskGn7hLRg6eqBRD9vzPiAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bxmQfMULjTz1HDDUr4d/XfcZR4LcfMEDnCm1qetfYImv4fy4WxuugopFCA3GkpSs1
	 tJP6yfTL4L3DuYm5eXSENKL8Xq8yN7GKO9+/CkjHVpFqBFb0Zin36IAXg+v83CWv8i
	 vFLzjb3s8vzkp5X4oYrmcOa7GAc19fZ4B5JOAH24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Pratyush Yadav <pratyush@kernel.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Takahiro Kuwano <takahiro.kuwano@infineon.com>,
	Michael Walle <mwalle@kernel.org>
Subject: [PATCH 7.1 1764/2077] mtd: spi-nor: spansion: use die erase for multi-die devices only
Date: Tue, 21 Jul 2026 17:23:57 +0200
Message-ID: <20260721152634.351797117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takahiro Kuwano <takahiro.kuwano@infineon.com>

commit 306e443156b82a2a14a3f33da908c303be45529c upstream.

Die erase opcode is supported in multi-die devices only. For single die
devices, default chip erase opcode must be used.

In s25hx_t_late_init(), die erase opcode is set only when the device is
multi-die.

Fixes: 461d0babb544 ("mtd: spi-nor: spansion: enable die erase for multi die flashes")
Cc: stable@kernel.org
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Takahiro Kuwano <takahiro.kuwano@infineon.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/spansion.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -674,7 +674,9 @@ static int s25hx_t_late_init(struct spi_
 	params->ready = cypress_nor_sr_ready_and_clear;
 	cypress_nor_ecc_init(nor);
 
-	params->die_erase_opcode = SPINOR_OP_CYPRESS_DIE_ERASE;
+	if (params->n_dice > 1)
+		params->die_erase_opcode = SPINOR_OP_CYPRESS_DIE_ERASE;
+
 	return 0;
 }
 


