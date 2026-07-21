Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECFE47043F;
	Tue, 21 Jul 2026 18:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658815; cv=none; b=C0JwfIwy+Yk0SXAuyrUwCWYc0iHcR0P+gMbkqVAp1vXVqtnoWLJwyKvt8wpuoFfN1OVb+vJ4b3dvAPfy+MmfbZYZ6/ka8Zu+9M15SJh3rKhwo7+yzryVOuSxXedNApADpp2ZooRYAp8J1N96BwGNmVCzg0DuP5QlU6+3NabBGL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658815; c=relaxed/simple;
	bh=SXFaFr9QfTBzFkAYFPiAnGrTMGZklPslnq++AG+9aaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fh2KVn4YcDBbQDsYhaw748yvrOapWjNQ7BzkadCIkj/UWaQB82umr1jgcPbfl2CTYXq/+VILhHdG9wY18Gcp/nQWyETs0HveDZyqtZ43KDeaOHHR7hoFuMJLD5iOlwJL+pdX2A5Ld+QZX+u0DXsvFfhdeKAigCJ/Hjnx6JgcYLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1uBriKg+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1uBriKg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3111F00A3A;
	Tue, 21 Jul 2026 18:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658812;
	bh=YLYPzvwdz2xHIHSFTCkIJtFL9+8ff677o3Rd9LUecbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1uBriKg+jczIE+YibkTpXMOOSU1hKTTo9vYCjwHgFCmGz4pRp/M6NOCkY33I94hSd
	 wg2Z734YDTmzpmHPt/5t4iUWKC15QE+noXyd2MibOdmM9Nn4AAHeKpCvWL11MZzjQb
	 nu0qcY3w2z8Jv+WE0sdZc62CQEDrq4lxlqhBnXjg=
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
Subject: [PATCH 6.18 1284/1611] mtd: spi-nor: spansion: use die erase for multi-die devices only
Date: Tue, 21 Jul 2026 17:23:20 +0200
Message-ID: <20260721152544.326296383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


