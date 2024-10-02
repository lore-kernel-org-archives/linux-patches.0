Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD5C1D0E24;
	Wed,  2 Oct 2024 14:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878812; cv=none; b=OwHUs4h22Q9whmuuzANnrJ6seC5+7LfSXV+JPWk253HSXFE4fPIrjC7HTLb/gR/BgJwTIHNSux8ABdEBLmyn7Znu70Aavd01hr0syla09BO9cUJ47Jnz0DzhPCRe/xyRcZlhZ9uKv78ce3J78J7YFqE2lZGh/4Klb+qabjGdHvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878812; c=relaxed/simple;
	bh=70XUcbSN/RtfdKwC8JwpfKPGXvvpVk1BwcpolGFeeEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p57XYXwczBxJv2dAfPyseS6aC+WU73mjje+16S1n6iD/rBPOLC83KVvs3iRlmtyJxpMORD2vzuD3mr79oWiKzCdBLDxlgUWFg5jHku+NyxN1XEj4b5PRL/lwvj+IOEmCaYc+tGPxfUs9yXCcOU5mAaC8ui55g7pzi4IzPyRTePc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C46Np6mP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C46Np6mP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F764C4CEC2;
	Wed,  2 Oct 2024 14:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878811;
	bh=70XUcbSN/RtfdKwC8JwpfKPGXvvpVk1BwcpolGFeeEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C46Np6mP/w64fEzE/yvp+Wl9hT5cPqJr0W0PaqX0O9iMQaRfuseMXeIVIxBdSnw51
	 X/bx4EivFUjmeEQ1dDoy+CZ3mfkHyeMljmY50r4ZX+SI/Tq9CSfBMCsvyYDmzoKBWe
	 7n92e1g9yoGG42YsAyUxV2JzFxl8uDRi638DiiJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manish Pandey <quic_mapa@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.10 509/634] scsi: ufs: qcom: Update MODE_MAX cfg_bw value
Date: Wed,  2 Oct 2024 15:00:09 +0200
Message-ID: <20241002125831.195718519@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manish Pandey <quic_mapa@quicinc.com>

commit 0c40f079f1c808e7e480c795a79009f200366eb1 upstream.

Commit 8db8f6ce556a ("scsi: ufs: qcom: Add missing interconnect bandwidth
values for Gear 5") updated the ufs_qcom_bw_table for Gear 5. However, it
missed updating the cfg_bw value for the max mode.

Hence update the cfg_bw value for the max mode for UFS 4.x devices.

Fixes: 8db8f6ce556a ("scsi: ufs: qcom: Add missing interconnect bandwidth values for Gear 5")
Cc: stable@vger.kernel.org
Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
Link: https://lore.kernel.org/r/20240903063709.4335-1-quic_mapa@quicinc.com
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/ufs-qcom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -93,7 +93,7 @@ static const struct __ufs_qcom_bw_table
 	[MODE_HS_RB][UFS_HS_G3][UFS_LANE_2] = { 1492582,	204800 },
 	[MODE_HS_RB][UFS_HS_G4][UFS_LANE_2] = { 2915200,	409600 },
 	[MODE_HS_RB][UFS_HS_G5][UFS_LANE_2] = { 5836800,	819200 },
-	[MODE_MAX][0][0]		    = { 7643136,	307200 },
+	[MODE_MAX][0][0]		    = { 7643136,	819200 },
 };
 
 static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host);


