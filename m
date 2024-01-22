Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721F6629E1;
	Tue, 23 Jan 2024 01:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974966; cv=none; b=WS6achaWuSxGQ/vs1fjqQMCqcfLnlnM/2gW32PZd+A6SjkUNADKBNSnPKldvqpuqXdc5iVrkuvLqouDD5J7oDua8C6sLKI894AW+IRwx5qn9Wdq21uWNTAVyw0i6jOeDNbQnf+/o3zzSig8XkizVoOAvtZsNdUIXVixZp80HPzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974966; c=relaxed/simple;
	bh=50O3UWUy4GRFE+bwCgIqF01X9kkekzOClc5O+QZrLdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLi6D40f4eB8XYzZuFLmIUkovwHEbxCNUAn/9gOzuHL9UzC4L7iTfdFV92fIUJt53YbZJiFGnihzSJeTuSLqSlptxK6CpqMzVP8dYsAnUKMS5HOcTuKMNHBEeL6978TkKRTf0UAReC+oGDjxKNM/wX2KkUmEYLhBNwMooxiMDCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJvGqfNT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJvGqfNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E75C433F1;
	Tue, 23 Jan 2024 01:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974966;
	bh=50O3UWUy4GRFE+bwCgIqF01X9kkekzOClc5O+QZrLdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJvGqfNT7hiUEgJJ8iTCMvGK9lGE8L9SmM+PDno6PCfgPQKDYNNwllMTAs2sAIElr
	 dJJJtu3NPD45TaeZs6qIgUUYMu+mqNXPoU5J+a23L2QShZ9mBHNPv5madzyHvqZDbm
	 lX1xDADVj7u7LMOQD7JAVmXm/OniIwz8C2zXRMVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH 6.6 158/583] scsi: ufs: qcom: Fix the return value of ufs_qcom_ice_program_key()
Date: Mon, 22 Jan 2024 15:53:29 -0800
Message-ID: <20240122235816.884473966@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 3bf7ab4ac30c03beecf57c052e87d5a38fb8aed6 ]

Currently, the function returns -EINVAL if algorithm other than AES-256-XTS
is requested. But the correct error code is -EOPNOTSUPP. Fix it!

Cc: Abel Vesa <abel.vesa@linaro.org>
Fixes: 56541c7c4468 ("scsi: ufs: ufs-qcom: Switch to the new ICE API")
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20231208065902.11006-3-manivannan.sadhasivam@linaro.org
Tested-by: Andrew Halaney <ahalaney@redhat.com> # sa8775p-ride
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index fc40726e13c2..fc0fa1065a30 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -159,7 +159,7 @@ static int ufs_qcom_ice_program_key(struct ufs_hba *hba,
 	cap = hba->crypto_cap_array[cfg->crypto_cap_idx];
 	if (cap.algorithm_id != UFS_CRYPTO_ALG_AES_XTS ||
 	    cap.key_size != UFS_CRYPTO_KEY_SIZE_256)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	if (config_enable)
 		return qcom_ice_program_key(host->ice,
-- 
2.43.0



