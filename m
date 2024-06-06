Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680AD198A35;
	Thu,  6 Jun 2024 14:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683394; cv=none; b=Q17A474/foIYckT/z3fAzHrJ780bnAfwuLS564aLPRpKE7p08PAor7TjD+vbkcEIrp5tYanXZDliAxN/WX7jNU/KaQmFd6RZduKjrDPfrotWJlTTjPaB+QPxvcqNw2aIxAyVji4dcT60ZUf5IeqXPjiQOAnFlenlcaSs5pAMm+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683394; c=relaxed/simple;
	bh=lEd9Bcg1Os5jg6/aTOROBMFCaMnXNSHbwc17fB6f/vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OV2McttdyIDTxxzVbB8TYU7tUkbAVJ8rJhMfWGIheHK5/pI9XI7Eed7+1wKHjCV9aSwmO+Hm8Y+2wNbiiVew04Uqinh3wjRC7ROLoD0+FtdCxaGHatfXn7uS8im4Cqc6kEaKwAlKnY5/VwM4ys2Z5uSjI9LoPaHCExeLoQSQEFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZY44X0eZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZY44X0eZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4462CC32781;
	Thu,  6 Jun 2024 14:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683394;
	bh=lEd9Bcg1Os5jg6/aTOROBMFCaMnXNSHbwc17fB6f/vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZY44X0eZYbbXTNeVfp6ahfU9scP0KV/VrjeVNytiIDA11AfFIf/zU/T9wiViBjKr7
	 0sZRv0cS0Mre4mJg+HoTpRHRvEP/GnOyyDy+3pAibJacLTgpcMkwB/wRzy3dZ1yuai
	 DjrN7TXFBSjVC7kCnV+1RNI9gBjz4WqF0W/Xrh2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 278/473] scsi: ufs: ufs-qcom: Clear qunipro_g4_sel for HW major version > 5
Date: Thu,  6 Jun 2024 16:03:27 +0200
Message-ID: <20240606131709.098562581@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit c422fbd5cb58c9a078172ae1e9750971b738a197 ]

The qunipro_g4_sel clear is also needed for new platforms with major
version > 5. Fix the version check to take this into account.

Fixes: 9c02aa24bf40 ("scsi: ufs: ufs-qcom: Clear qunipro_g4_sel for HW version major 5")
Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Nitin Rawat <quic_nitirawa@quicinc.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230821-topic-sm8x50-upstream-ufs-major-5-plus-v2-1-f42a4b712e58@linaro.org
Reviewed-by: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 337c0ef0fab6d..ecd5939f4c9a6 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -227,7 +227,7 @@ static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
 		   ufs_qcom_cap_qunipro(host) ? QUNIPRO_SEL : 0,
 		   REG_UFS_CFG1);
 
-	if (host->hw_ver.major == 0x05)
+	if (host->hw_ver.major >= 0x05)
 		ufshcd_rmwl(host->hba, QUNIPRO_G4_SEL, 0, REG_UFS_CFG0);
 }
 
-- 
2.43.0



