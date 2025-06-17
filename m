Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269252FA630;
	Tue, 17 Jun 2025 16:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179050; cv=none; b=X54d/cMLyg8s8cpbxDooazbR/FiBlcw8xE+4X7AMUbmuDJPR2tHN3hSKfLb4eh6f1RcSHUlAoP3Fa+kcO3VbMW+AvAg1nEpkGIiF4vB79QX05FDgu1E3hsuJ3DWaou4qKg6TUSaLZSRItB1JDyAF4717ehXT4nfz4FLfBAhw62o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179050; c=relaxed/simple;
	bh=dvO9JJtEwNBtlJDMYOtdkd7wkNXkDY6WVDIti7H0xpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IsIYDsQujedMTLLL4uaVRDjiAPGEWhVSUQ+3NaT/+mvScdJFAU1/GFM2x5KLL4mQoO8BB0lim2u32gu6eBeoUYMpsDaQKy/8/gvINJl5Aui9bUWTnPUTdYDb1MT46VO69ufBWMMYAU10hKedV4QNUKbV/3ymQkoHNCh1OMxdEAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GONzvnJo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GONzvnJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89EE3C4CEE3;
	Tue, 17 Jun 2025 16:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179050;
	bh=dvO9JJtEwNBtlJDMYOtdkd7wkNXkDY6WVDIti7H0xpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GONzvnJoDoVm9jCzVLxGY7xB7VmRglwtwpRld3Q7ixdUViUs9ebPeyotr8yYcQJfo
	 MNf8VTQaZe8iq3Q2ebEXW+hGVB6YBbxN6qg6HKM/1225bnb5qvNYs0/6LD4hh1I4S8
	 +nrQkxTcpWpERcn+diqxF6Ck2OqYoJqXTGCNQSMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziqi Chen <quic_ziqichen@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bean Huo <beanhuo@micron.com>,
	=?UTF-8?q?Lo=C3=AFc=20Minier?= <loic.minier@oss.qualcomm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 632/780] scsi: ufs: qcom: Check gear against max gear in vop freq_to_gear()
Date: Tue, 17 Jun 2025 17:25:40 +0200
Message-ID: <20250617152517.210867795@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziqi Chen <quic_ziqichen@quicinc.com>

[ Upstream commit 663d0c19f3acc0d697f623d34b8eb3b438bf2bda ]

The vop freq_to_gear() may return a gear greater than the negotiated max
gear. Return the negotiated max gear if the mapped gear is greater.

Fixes: c02fe9e222d1 ("scsi: ufs: qcom: Implement the freq_to_gear_speed() vop")
Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
Link: https://lore.kernel.org/r/20250522021537.999107-2-quic_ziqichen@quicinc.com
Reported-by: Neil Armstrong <neil.armstrong@linaro.org>
Closes: https://lore.kernel.org/all/c7f2476a-943a-4d73-ad80-802c91e5f880@linaro.org/
Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Loïc Minier <loic.minier@oss.qualcomm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index c0761ccc1381e..28515f89ce798 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1924,7 +1924,7 @@ static int ufs_qcom_config_esi(struct ufs_hba *hba)
 
 static u32 ufs_qcom_freq_to_gear_speed(struct ufs_hba *hba, unsigned long freq)
 {
-	u32 gear = 0;
+	u32 gear = UFS_HS_DONT_CHANGE;
 
 	switch (freq) {
 	case 403000000:
@@ -1946,10 +1946,10 @@ static u32 ufs_qcom_freq_to_gear_speed(struct ufs_hba *hba, unsigned long freq)
 		break;
 	default:
 		dev_err(hba->dev, "%s: Unsupported clock freq : %lu\n", __func__, freq);
-		break;
+		return UFS_HS_DONT_CHANGE;
 	}
 
-	return gear;
+	return min_t(u32, gear, hba->max_pwr_info.info.gear_rx);
 }
 
 /*
-- 
2.39.5



