Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD8646EC8B;
	Tue, 21 Jul 2026 19:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663845; cv=none; b=qmSXNXvciLUdrNsmKFfHJPp+C2sRloFV+nRkR0aczj3vhQVaeVUViNrUgthwnB3FwP9hv+kXuDK/32RyY5CeXXwtbnV74Ai87Kx4A5huEL6ijjenfsxovHgGNOWfbeMCXAVGMQvONEQ2ub0aXKzTuiJJPr5k4eAwL7wyTWn7lmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663845; c=relaxed/simple;
	bh=BXoZcbjAgVFv483S8X3wLjfnz3Ut7DDdHUlwUx5YFi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwP6gPhzFR8F1UxXF41pze9lOrx1DlkspayKjZUm1CWfMPQVxghtlkP5Z5xhtGSx/LOBkeIui2VruPXbdRmpIOwUSfZKHdCRQF3Y0kvcs6kLKPwQVYuc1mjYYfMtMLBJ7lD60CCT0JaEZxhGVnMALBZFJROvt0KNq8muE9rwcgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQgjUFNe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQgjUFNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1DE1F000E9;
	Tue, 21 Jul 2026 19:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663842;
	bh=ZPQYaA8u9VxDeWRMGtSiilwDVfMeVHGI/G5vN62I7vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UQgjUFNeukvtKO76QJ83zuaPromxTLsWnKttOvlwXHKTWX9ImOCR+Z5B3LXFEszo0
	 giiqotpCIb5h5IPRLhQXJtYhwCfpX7llAO84rbm7xA9GSBtFcONWYtiD8c+Y3UosBy
	 niOVwv5eiPUR4vrYdeORIdCmc69jAh4eTAJuXhEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Vivchar <rva333@protonmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.12 0977/1276] i2c: mediatek: fix WRRD for SoCs without auto_restart option
Date: Tue, 21 Jul 2026 17:23:40 +0200
Message-ID: <20260721152507.883550043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Vivchar <rva333@protonmail.com>

commit deb35336b5bfed5db9231b5348bc1514db930797 upstream.

MediaTek mt65xx family SoCs have no auto restart, however, they still
support the WRRD mode in the hardware. Because auto_restart is set to 0,
the WRRD mode will be never enabled, leading to read errors.

Fix this by removing auto_restart check from the WRRD enable path.

Fixes: b49218365280 ("i2c: mediatek: fix potential incorrect use of I2C_MASTER_WRRD")
Signed-off-by: Roman Vivchar <rva333@protonmail.com>
Cc: <stable@vger.kernel.org> # v6.18+
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260709-6572-6595-i2c-v2-1-b2fb8510d1d3@protonmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-mt65xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -1253,7 +1253,7 @@ static int mtk_i2c_transfer(struct i2c_a
 	i2c->auto_restart = i2c->dev_comp->auto_restart;
 
 	/* checking if we can skip restart and optimize using WRRD mode */
-	if (i2c->auto_restart && num == 2) {
+	if (num == 2) {
 		if (!(msgs[0].flags & I2C_M_RD) && (msgs[1].flags & I2C_M_RD) &&
 		    msgs[0].addr == msgs[1].addr) {
 			i2c->auto_restart = 0;


