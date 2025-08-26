Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3CD2820B1;
	Tue, 26 Aug 2025 11:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208010; cv=none; b=hZnVRnF7t4MQxoGFNbGUV61IOmJHoBS0HYR2TLV8apLKCEhyG+usWmQWCiQjebf07bCtXEGWOjKBfKEzivUgP3AXeUY2GCkAtjDIOe1QquOxgKkY85VB2BHDiI9I7mJLReh3q2eWtkx5sJOg6Cd3s0D9s1aofLOOZ+LKxK+5Iwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208010; c=relaxed/simple;
	bh=ucijE42LmTzi4DP3J37CCRZw0TtT4AVX9Ai6MsZXfvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQpuA6HYvAGjZaGHclg12uhUCmHfZMs1lNu8jL2yPK+jYcxq4C4QMpEDo5wG9pcYLUewSCzLsiBz3yoGz2hDl6K1oWS8Xqb0OHAzudigky8WeIAPT+MX06XWVg0LiEytUKizC+l1k69J026XkawrF3re0SMeVj88d+JZ5Fhfuq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ciCWcbD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ciCWcbD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161B2C4CEF1;
	Tue, 26 Aug 2025 11:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208010;
	bh=ucijE42LmTzi4DP3J37CCRZw0TtT4AVX9Ai6MsZXfvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ciCWcbD0F9BsUdoHK7WbbTGd6xuey4jobFYBHNlkeiZD6vlghNZVEuNvuD1xMEfBE
	 Pb1yk0SLVk2eoYwGaajzs8vFX4ccoAtEYLODVVbnhzdqWEY/E1svQ/hZAq6WGG4kQr
	 Rk9Pdvm3VCQH8nTpPy5LAQcd2aWjowoFQpaYsumE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 403/457] scsi: ufs: ufs-qcom: Update esi_vec_mask for HW major version >= 6
Date: Tue, 26 Aug 2025 13:11:27 +0200
Message-ID: <20250826110947.255096646@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bao D. Nguyen <quic_nguyenb@quicinc.com>

[ Upstream commit 7a9d5195a7f5871a4ad4e55fc567a2b3bee49a59 ]

The MCQ feature and ESI are supported by all Qualcomm UFS controller
versions 6 and above.

Therefore, update the ESI vector mask in the UFS_MEM_CFG3 register for
platforms with major version number of 6 or higher.

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
Link: https://lore.kernel.org/r/20250714075336.2133-2-quic_nitirawa@quicinc.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 6300d5c54387 ("scsi: ufs: ufs-qcom: Fix ESI null pointer dereference")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 18a978452001..53301a2c27be 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -2109,8 +2109,7 @@ static int ufs_qcom_config_esi(struct ufs_hba *hba)
 
 	retain_and_null_ptr(qi);
 
-	if (host->hw_ver.major == 6 && host->hw_ver.minor == 0 &&
-	    host->hw_ver.step == 0) {
+	if (host->hw_ver.major >= 6) {
 		ufshcd_rmwl(hba, ESI_VEC_MASK, FIELD_PREP(ESI_VEC_MASK, MAX_ESI_VEC - 1),
 			    REG_UFS_CFG3);
 	}
-- 
2.50.1



