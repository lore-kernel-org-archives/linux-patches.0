Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA90D44C6F;
	Thu, 13 Jun 2024 12:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281613; cv=none; b=AXF1KmdaJUy0k36MvF0kTMesLlX3VF0x7zyTqfLjLSc68flHOmqLVaac9aVshe1kcaRPhY4dZsOdztpvq1npLBkT/fRql+fwRmrU9zbJZUDj4BBmiEWiaTChtG2ghwFM7RxMcKOGK70ZmhLY/aPHhJB8R18wEGTw+RheYdUO8R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281613; c=relaxed/simple;
	bh=VcKMX4QxLG1DCSuSm2QI03QSqNw0/N2UvzHnN0cYoms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5EBzSlSu43CsdDR0MkXT7Rt1oM117Y0SWp10auag03EeMpvNuhs4WNbiPzSPSLjEQBdjcPNW7NH4jasH7NSgLuWJZUMGP/JtK3+XEVEyPHsIALmzwom+Jl32fFOiIk4+xlI9aJEfWCxPvCoVlAvvrR1EOTuD/YiQqPCPI8Lq/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VETKMF8a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VETKMF8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A0FC2BBFC;
	Thu, 13 Jun 2024 12:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281612;
	bh=VcKMX4QxLG1DCSuSm2QI03QSqNw0/N2UvzHnN0cYoms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VETKMF8aFSDIMeFIIXLNNFVGTPZDLkVLU++KsEfFW9ViKyCPGDlyFy1d8DhmbSLNH
	 AopxcxDiy+WAHzI4X4CEvCoy+iahBppvCqCXKP102xC0w95q+SnREFDyOrzDl5OntL
	 xkMFbt7xIc0/GlVOwGi+F9wWwVEiK1h3NkiCLiq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 314/317] scsi: ufs: ufs-qcom: Clear qunipro_g4_sel for HW major version > 5
Date: Thu, 13 Jun 2024 13:35:32 +0200
Message-ID: <20240613113259.700658775@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

commit c422fbd5cb58c9a078172ae1e9750971b738a197 upstream.

The qunipro_g4_sel clear is also needed for new platforms with major
version > 5. Fix the version check to take this into account.

Fixes: 9c02aa24bf40 ("scsi: ufs: ufs-qcom: Clear qunipro_g4_sel for HW version major 5")
Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Nitin Rawat <quic_nitirawa@quicinc.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230821-topic-sm8x50-upstream-ufs-major-5-plus-v2-1-f42a4b712e58@linaro.org
Reviewed-by: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufs-qcom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -243,7 +243,7 @@ static void ufs_qcom_select_unipro_mode(
 		   ufs_qcom_cap_qunipro(host) ? QUNIPRO_SEL : 0,
 		   REG_UFS_CFG1);
 
-	if (host->hw_ver.major == 0x05)
+	if (host->hw_ver.major >= 0x05)
 		ufshcd_rmwl(host->hba, QUNIPRO_G4_SEL, 0, REG_UFS_CFG0);
 }
 


