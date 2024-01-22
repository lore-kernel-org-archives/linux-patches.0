Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6C313398C;
	Tue, 23 Jan 2024 00:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969328; cv=none; b=n3Q5HhP5QtUqVXrcKA19rVFttVSbQZ0u1f4DOciT1GqTBQaBP/Kfhqmn0X84OUXa+G5NRWct1YJNNxHZnl0bvFuWus4399/WkQieTpgmwoKKYRs0jQ4Rk7bvc+WP2UxDaiNAE5EjAmdf5Pzg1k8V5Eo/J3vt/gXzWalqG/8jCDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969328; c=relaxed/simple;
	bh=mngxT/Ho3C1EL1R2R96gdlfRteOTfQmCyE+JkJ1svco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0dU4xiDUySpHj56wAgMHQmJqZN0btNRyScuuMD1+sqxYSFZUnFXYn9Lb64Lo5JhjThRUke9mTaNi5J6sDWykgU+ScDumbqvo0yG1RQ6SDC0iuCHq73aBo5P0WuIpxa7HSZDjlMguEgNxitUrWMBylNbhLYj3Q+xOjmgnVtJeAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLOIOPD8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLOIOPD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7174FC433B1;
	Tue, 23 Jan 2024 00:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969328;
	bh=mngxT/Ho3C1EL1R2R96gdlfRteOTfQmCyE+JkJ1svco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLOIOPD8bP+jurJLxycxQdwGQeTIVQLgWXUPT7KXbGTNqbg8gpV5krKRH8jq2THui
	 HscSg4ykMRiSV3zUpwnXYGltAVgvW97mzCoUEcQXAyfhcr2g0smoMPCvhGOcKF/Z6B
	 IlKtATnQKg95ujT/W3HdVfnDLaMWAiAqpNQyi5Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Halaney <ahalaney@redhat.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 176/641] scsi: ufs: qcom: Fix the return value when platform_get_resource_byname() fails
Date: Mon, 22 Jan 2024 15:51:20 -0800
Message-ID: <20240122235823.511286725@linuxfoundation.org>
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

[ Upstream commit 3a747c5cf9b6c36649783b28d2ef8f9c92b16a0f ]

The return value should be -ENODEV indicating that the resource is not
provided in DT, not -ENOMEM. Fix it!

Fixes: c263b4ef737e ("scsi: ufs: core: mcq: Configure resource regions")
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20231208065902.11006-4-manivannan.sadhasivam@linaro.org
Tested-by: Andrew Halaney <ahalaney@redhat.com> # sa8775p-ride
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index c92cdca21fe1..0f4b3f16d3d7 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1787,7 +1787,7 @@ static int ufs_qcom_mcq_config_resource(struct ufs_hba *hba)
 		if (!res->resource) {
 			dev_info(hba->dev, "Resource %s not provided\n", res->name);
 			if (i == RES_UFS)
-				return -ENOMEM;
+				return -ENODEV;
 			continue;
 		} else if (i == RES_UFS) {
 			res_mem = res->resource;
-- 
2.43.0



