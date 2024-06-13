Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B37142658;
	Thu, 13 Jun 2024 12:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282808; cv=none; b=qd1s9mEk+co/wkI3Dos4UrvpqkkxwrzH5JFIuCHESOk+LB/elxbMCjM+351EcJgtTFNbY0AUCPv40QgsTf4xKniyt5kTf6nyPAKGSGTA65WJgxPaV0hjE2QvUBy68P5x4KpiZoZK9q/EEn37qaYMgbZ5jwwJeXcwSNod1NvN8es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282808; c=relaxed/simple;
	bh=IzdslEgt4nLGZgdmP9b/AOCap2U1VmW1nzka0z8qs/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBeogccxRnhgX42eEd6werQSacAVPJP3/iH27dZWyDeH7WKAn0TD/+FaRAzz1N4ateb5ftLyF3IGAsJ8M74osHvTc2a+63qMyEFxzkrctE3veiwq7fTD4gMrXeBld7zJ+/6gDOkB5mKiVt7Chc6FLJf8mS9DXxZCIBN7oFKFwag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3NuKrku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3NuKrku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBDFC2BBFC;
	Thu, 13 Jun 2024 12:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282807;
	bh=IzdslEgt4nLGZgdmP9b/AOCap2U1VmW1nzka0z8qs/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i3NuKrku+BLeojhe13LRYemB6wfEXspUf6f8TrKU8Z7rAxLROBvObCdaKnJLQrDQY
	 UkzLQ6bDORd7/A98Ji+WNc+DnT6eC4HXJ1YzD6+HTO2U+SdvigbFl1aA0jwyx5mIYY
	 vi+G7hzkBJ18sQDmKRioL1IFXpoONE/B7JwF06Fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 402/402] scsi: ufs: ufs-qcom: Clear qunipro_g4_sel for HW major version > 5
Date: Thu, 13 Jun 2024 13:35:59 +0200
Message-ID: <20240613113317.832635491@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


