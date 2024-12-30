Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66D315E8B;
	Mon, 30 Dec 2024 15:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573553; cv=none; b=A2FpyP4UbpeTBnbZ3cyvPX5GytLDBU3PFXK1RqIHUUc/0WoCZkFPhG02BwvB89vJ4Xtd5PplCQNMDt6PS8OmXOhYzXvJZULA9sejyJecEJMgLa+cXPzV/sCnJbOSl4BOevHFpn17H8GOEhreIHpJvrlPxzaJAG+sgcSKzWeDB8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573553; c=relaxed/simple;
	bh=vZFGpod5xsnNLSNrmiXW9HkloRfCaMkvO72M5BIu3Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d18JQlx42zTyBMCRZjeUf6lhqPZNJMTv5rYA5ZGSUQ8FKxpnfPQXbtT5tK8IuLfxcBCgFhDK5u/OF/2Xlt4q3PPQppk1k2keKguxCOLei3e+3hVnHFgUEAeap4y0G28R5ZZB9ZPYH5YF1an6kkGoEwyHFdwwnE5sG6IfrdsIC90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0IqoSRtv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0IqoSRtv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D671FC4CED0;
	Mon, 30 Dec 2024 15:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573553;
	bh=vZFGpod5xsnNLSNrmiXW9HkloRfCaMkvO72M5BIu3Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0IqoSRtv3YCZRWU9Gcm9fa9cKTCZERh9D2xCPI09fDH1MUtWTcLYYmWQ5b+0KHhek
	 bVoDSqCjdEChN+zSc0pgZwbRur784qGqi5Y4ulRS8PN1WNp+Rbw9bWY53c5g3JwS1R
	 VAYDZInZ/nsrM8nWh47SfSV871/YeQuWXYfmzFbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Lindholm <linmag7@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 28/60] scsi: qla1280: Fix hw revision numbering for ISP1020/1040
Date: Mon, 30 Dec 2024 16:42:38 +0100
Message-ID: <20241230154208.354400307@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit c064de86d2a3909222d5996c5047f64c7a8f791b ]

Fix the hardware revision numbering for Qlogic ISP1020/1040 boards.  HWMASK
suggests that the revision number only needs four bits, this is consistent
with how NetBSD does things in their ISP driver. Verified on a IPS1040B
which is seen as rev 5 not as BIT_4.

Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20241113225636.2276-1-linmag7@gmail.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla1280.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla1280.h b/drivers/scsi/qla1280.h
index d309e2ca14de..dea2290b37d4 100644
--- a/drivers/scsi/qla1280.h
+++ b/drivers/scsi/qla1280.h
@@ -116,12 +116,12 @@ struct device_reg {
 	uint16_t id_h;		/* ID high */
 	uint16_t cfg_0;		/* Configuration 0 */
 #define ISP_CFG0_HWMSK   0x000f	/* Hardware revision mask */
-#define ISP_CFG0_1020    BIT_0	/* ISP1020 */
-#define ISP_CFG0_1020A	 BIT_1	/* ISP1020A */
-#define ISP_CFG0_1040	 BIT_2	/* ISP1040 */
-#define ISP_CFG0_1040A	 BIT_3	/* ISP1040A */
-#define ISP_CFG0_1040B	 BIT_4	/* ISP1040B */
-#define ISP_CFG0_1040C	 BIT_5	/* ISP1040C */
+#define ISP_CFG0_1020	 1	/* ISP1020 */
+#define ISP_CFG0_1020A	 2	/* ISP1020A */
+#define ISP_CFG0_1040	 3	/* ISP1040 */
+#define ISP_CFG0_1040A	 4	/* ISP1040A */
+#define ISP_CFG0_1040B	 5	/* ISP1040B */
+#define ISP_CFG0_1040C	 6	/* ISP1040C */
 	uint16_t cfg_1;		/* Configuration 1 */
 #define ISP_CFG1_F128    BIT_6  /* 128-byte FIFO threshold */
 #define ISP_CFG1_F64     BIT_4|BIT_5 /* 128-byte FIFO threshold */
-- 
2.39.5



