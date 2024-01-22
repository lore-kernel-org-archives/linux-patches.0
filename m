Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3A43C0C;
	Tue, 23 Jan 2024 02:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975742; cv=none; b=Yr+Z8cZsc4FpBtCEsFKqUmrOASpakEdc4HwSEb5a1rpEdiSp7jzo9Jr0mZdt6eFXSKbP7yG95MPfy+ThB/mCNYWBhxbZa5ybdUixJvFvO26toCGW6ELxhf5akAvDoop1+VVZ4c42bCqNlTBmNk6n2VAFJNRGt/4RO/3V+Jz8Gy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975742; c=relaxed/simple;
	bh=1gvtui4MQpELUVhSLSMPc8uEb9La2UXrMlHAd9/kRgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHrFZMX7nY1iHZQozdoWfwjgOOB35RmInTO5GPyD2aaHPQbfAeRNSMQ4OWMHTDjhEmCoXX5Da/+JwNWwqTKYd50h7SS4Tg3tUtLLl/2lICfXlDTYly1hRK6MmMPEBjndPghwbnm2+j0n4u6Ryq98itfHkLomhkMjW6hz6QXSQI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yioXoJs9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yioXoJs9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC695C43394;
	Tue, 23 Jan 2024 02:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975742;
	bh=1gvtui4MQpELUVhSLSMPc8uEb9La2UXrMlHAd9/kRgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yioXoJs9+czgwtrL6CNwVODTW2p/hi6N4PEHHxv3hpCOItE9wYVPWZ+mR/Yafjh/c
	 LvgwEasa348LLgGzJ8abMORFpE+HQoHv12+yMoDFLkLhNZgryr3Kd3n0VKEqZ7lg8I
	 qBfOGZTV9r0Wh6v4afj1fV/gKAqDCEjvGztdSxb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nithin Dabilpuram <ndabilpuram@marvell.com>,
	Naveen Mamindlapalli <naveenm@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 526/583] octeontx2-af: CN10KB: Fix FIFO length calculation for RPM2
Date: Mon, 22 Jan 2024 15:59:37 -0800
Message-ID: <20240122235828.189766183@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nithin Dabilpuram <ndabilpuram@marvell.com>

[ Upstream commit a0cb76a770083a22167659e64ba69af6425b1d9b ]

RPM0 and RPM1 on the CN10KB SoC have 8 LMACs each, whereas RPM2
has only 4 LMACs. Similarly, the RPM0 and RPM1 have 256KB FIFO,
whereas RPM2 has 128KB FIFO. This patch fixes an issue with
improper TX credit programming for the RPM2 link.

Fixes: b9d0fedc6234 ("octeontx2-af: cn10kb: Add RPM_USX MAC support")
Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240108073036.8766-1-naveenm@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index 4728ba34b0e3..76218f1cb459 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -506,6 +506,7 @@ u32 rpm2_get_lmac_fifo_len(void *rpmd, int lmac_id)
 	rpm_t *rpm = rpmd;
 	u8 num_lmacs;
 	u32 fifo_len;
+	u16 max_lmac;
 
 	lmac_info = rpm_read(rpm, 0, RPM2_CMRX_RX_LMACS);
 	/* LMACs are divided into two groups and each group
@@ -513,7 +514,11 @@ u32 rpm2_get_lmac_fifo_len(void *rpmd, int lmac_id)
 	 * Group0 lmac_id range {0..3}
 	 * Group1 lmac_id range {4..7}
 	 */
-	fifo_len = rpm->mac_ops->fifo_len / 2;
+	max_lmac = (rpm_read(rpm, 0, CGX_CONST) >> 24) & 0xFF;
+	if (max_lmac > 4)
+		fifo_len = rpm->mac_ops->fifo_len / 2;
+	else
+		fifo_len = rpm->mac_ops->fifo_len;
 
 	if (lmac_id < 4) {
 		num_lmacs = hweight8(lmac_info & 0xF);
-- 
2.43.0



