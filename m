Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3833D9475;
	Wed,  2 Oct 2024 14:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880343; cv=none; b=u9BT145Go8X04BeceHczpxTAYtsWvr0zdcW/fIEXVd2oHYgfXRjYyUrc5ewC2LBVVzULlgKBPNnsRXI6LmWdXcSGRwCLJ7sAURHBxtj4V+obVKyaNl7ChBD/6nFnhI74F443/1Qh8WTxWCgbqApY/nnT+mCVq3uSgQdl5tRGI44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880343; c=relaxed/simple;
	bh=DqCEFDxWwKAcCeoPmCN2wM6SucyBg5pu/Dnq+LshsiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ooJLcjO8yP4UZqXmCMc6A1uuUJG1XlFryNk+zfD1oCyRvvbZhaDinG+KGre6JDU0WC1HqdLVfVmPTXu3lTVIpvfniJ9aSRogZmq4rDEDX6kUJVm6ELW3BIMtjkYV7rlw+YWTflAZNE/C1vs55ODohB0eQjYfzKx82zN+gW3LlIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B6fg0DVk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B6fg0DVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB76C4CEC2;
	Wed,  2 Oct 2024 14:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880343;
	bh=DqCEFDxWwKAcCeoPmCN2wM6SucyBg5pu/Dnq+LshsiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B6fg0DVkyy/QpO3Jpnic8JGpdfJmHEf5sX6InBdmo9CDAkC0C5gbt/gBUBnH9jz0w
	 3EU0UIthw8XlvOVLymoicVFiu62gTpo63tgvvL9naVQnPT/tYI/bgJTRIYrilFKaht
	 kv81XBCvcM47L+15zK4odUqNsqc/hh00K2oIoRao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manish Pandey <quic_mapa@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 426/538] scsi: ufs: qcom: Update MODE_MAX cfg_bw value
Date: Wed,  2 Oct 2024 15:01:05 +0200
Message-ID: <20241002125809.251549683@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
 
 static struct ufs_qcom_host *ufs_qcom_hosts[MAX_UFS_QCOM_HOSTS];


