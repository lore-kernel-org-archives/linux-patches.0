Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A754A35AC12
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302732; cv=none; b=P6BiO4FJFZm0XlZKj/A4PKLrSYshvqIidHBuHvMgwtV+GoPv/jczT4UBalX1ERNmw7EbN1Pavc1knf2Akg4b/MqjiI4+e+Z8g2FZO5Dn1uiy9JtJN1JqUsZIo9oL04r5qEHE8q1bCaHHnL9IoIjp+Nk7I57kThHFRHfkkOF9Wms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302732; c=relaxed/simple;
	bh=S0Lcse+eXtblkoyqJ0e6/DYsO0vR74jJ9R2nZ9qCRME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBkxcHZmybUVD8J2paoeDP5wYltKrr5pPbqESnA5qBdKu+ayWWgInJDk6aHKBATJTwdUH4q/SpCVm/ymch000W2toiDSedChPqulYY8deFKK+jAxURh7IOL63IhUrXHP7it/s46+8t1LsUuJFIClW10QYSGxNKfHm3F9Rq45Hjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eqHKUJ5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eqHKUJ5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190F8C19423;
	Sat, 28 Feb 2026 18:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302732;
	bh=S0Lcse+eXtblkoyqJ0e6/DYsO0vR74jJ9R2nZ9qCRME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqHKUJ5zeWZm9EJh2I/xwXEFQDl/nj8FxikH0c7pkxMsGT5YG+IZ0v9SIk2jvC1Ww
	 oE01IKuGRaJd12jdv3h65EDmW4EHFpnyHP11VRxyuHk6I+dcbhQbwgXFL8TLQmWsAu
	 CQKq4cUUaGxW/XGTCcg06KJuJzQlE5MrlKPuKR0L02oFkf9ljDvj9ME52Ft/XHlTtr
	 ppAybLw45fSU246kgC+c/kTEKUtJcq822OEIh5mQuhnXqgzVA5vbj2flV8mo0Nkvo6
	 Qd18xClgBp7ARby5kcih9FhJoGFPE6gLb7x/JBpcGOkJMDhOZDGkWbLYk3BY5vjNz4
	 m88sxCHjeS+WA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alok Tiwari <alok.a.tiwari@oracle.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/147] mtd: rawnand: cadence: Fix return type of CDMA send-and-wait helper
Date: Sat, 28 Feb 2026 13:16:43 -0500
Message-ID: <20260228181736.1605592-95-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 6d8226cbbf124bb5613b532216b74c886a4361b7 ]

cadence_nand_cdma_send_and_wait() propagates negative errno values
from cadence_nand_cdma_send(), returns -ETIMEDOUT on failure and -EIO
when the CDMA engine reports a command failure.

However, it is declared as u32, causing error codes to wrap.
Change the return type to int to correctly propagate errors.

Fixes: ec4ba01e894d ("mtd: rawnand: Add new Cadence NAND driver to MTD subsystem")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/cadence-nand-controller.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/cadence-nand-controller.c b/drivers/mtd/nand/raw/cadence-nand-controller.c
index db565a0edcfd0..544cf5fe946a7 100644
--- a/drivers/mtd/nand/raw/cadence-nand-controller.c
+++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
@@ -1018,7 +1018,7 @@ static int cadence_nand_cdma_send(struct cdns_nand_ctrl *cdns_ctrl,
 }
 
 /* Send SDMA command and wait for finish. */
-static u32
+static int
 cadence_nand_cdma_send_and_wait(struct cdns_nand_ctrl *cdns_ctrl,
 				u8 thread)
 {
-- 
2.51.0

