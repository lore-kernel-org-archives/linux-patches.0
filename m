Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6889813398C;
	Tue, 23 Jan 2024 00:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969327; cv=none; b=hE5mql59lsvHQsdkw8vzMgBGYU8C//CCA8wI8zL611GPh2pCx3sW82XlBuFR3iLuK0zWmy0naW61AfxFN5jZsrK8ke6DZHmGr9q2SiTwJatBV8T/6V4jcKLOSGpZPgXHRuYT0TG/pl2lgy25dy7ceOBBIy7oIgbxt2/RQkDtMQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969327; c=relaxed/simple;
	bh=pEq0Sul7zNlxTHUi5zmeHTvpY/vlph+rbfdqJLLUta4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlJx9/4Rtb9ljU9cN4A6ZMYaKe9VBUd64TR7yeeczT8rHOmIIfBqyVZnQvbys6xhIjkEdDSwaRvob1oqtTbRI1jZidnNwZ31qoRP6nNm9+sspENsSEzMl6fRObEsCJPbh2WUr+lwSc+U7udRwX3NWqNBorAfQ2aZyk6v4vudcfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9+/lVGp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9+/lVGp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1250CC43394;
	Tue, 23 Jan 2024 00:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969327;
	bh=pEq0Sul7zNlxTHUi5zmeHTvpY/vlph+rbfdqJLLUta4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9+/lVGpLWyZCW+y5VEXTK5VicVhVQ+VSkHFBu3MLBWL3oAlEYNE+rbXyXvxNiukc
	 JVefHR0algF9lpA8zh0yO3pS6g7cTOHB86jsGJN4xAgZMzv4ax0bohQ4ohaRIaxWp7
	 sVMxn+fSepZFhV9Pf3wuZisp3UWsGKW4qUS9c8e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH 6.7 175/641] scsi: ufs: qcom: Fix the return value of ufs_qcom_ice_program_key()
Date: Mon, 22 Jan 2024 15:51:19 -0800
Message-ID: <20240122235823.483533285@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 17e24270477d..c92cdca21fe1 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -158,7 +158,7 @@ static int ufs_qcom_ice_program_key(struct ufs_hba *hba,
 	cap = hba->crypto_cap_array[cfg->crypto_cap_idx];
 	if (cap.algorithm_id != UFS_CRYPTO_ALG_AES_XTS ||
 	    cap.key_size != UFS_CRYPTO_KEY_SIZE_256)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	if (config_enable)
 		return qcom_ice_program_key(host->ice,
-- 
2.43.0



