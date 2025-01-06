Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA13E39FCE;
	Mon,  6 Jan 2025 15:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179163; cv=none; b=FI8SKoSZAv23ojStwR04UsIpjLXlhE9Ugro0mo2T2omu+qcKd6DDikBUiPWVrlh4Q8SVWqOFxKGxuRAG7aIDugmxsT9gBU2siVPNSINOdbOoBCg6wszO47ohSoupbTEhEw9F4vbhljrkZv9JsFxetR6TVYuR32sztnt1BTmdsig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179163; c=relaxed/simple;
	bh=QaIYaXSDup925lEL5+uC3pQ98hMWb7hpt3+rdSnBPlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/E5VtP45yo8/sF40j9xMwuRnjr32y4nOgFyresItkoeaWsE1WXvNNym6Ec0n7e1HtTQm2TXTZ/1YmKR1VVauwk2+voPfXGTG78DibirTzwi1ifR0NxtPAgj+qJpSqe2wZ2Z/Ny+/zpBPliDlR9ofrvhhIjd2yEY1okPJ16ZXh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XVi5Tlic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVi5Tlic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1A2C4CED6;
	Mon,  6 Jan 2025 15:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179162;
	bh=QaIYaXSDup925lEL5+uC3pQ98hMWb7hpt3+rdSnBPlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XVi5Tlic5ZbmadjShEt6qhCDQEcW8PwWqb3y5n8Z26h2+LAt8EpPTQisfDNLBhsgL
	 DrZQNPAEQhPDhY1DmalhgL06Fx10sUBehjzQqiBDuIrZ582sASikJgpGRNpOaDdlUw
	 dNg2bzpEzfOkCpJSFS2xHW/HDLXuWFpy7jn9dlnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Lindholm <linmag7@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 45/93] scsi: qla1280: Fix hw revision numbering for ISP1020/1040
Date: Mon,  6 Jan 2025 16:17:21 +0100
Message-ID: <20250106151130.402198872@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a1a8aefc7cc3..9d4c997c3c82 100644
--- a/drivers/scsi/qla1280.h
+++ b/drivers/scsi/qla1280.h
@@ -117,12 +117,12 @@ struct device_reg {
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



