Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8044E37E5CF;
	Sat, 12 Sep 2026 12:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215096; cv=none; b=rc4MIvQgL/w0dguz/odwOWn/zEo9ebRO2yckALOy4HTigr2n6pb5dwGbEKXQQl3/fvn15U20m5Q6UTAAW0eGLVHL5NcKOIPjJY0SBlaZomIBSxcmJ9lBx/9aZ121EoVfJZB3o7gr6bTJjFGtUlpuA/ztak8UiYHWntc+lyxtHFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215096; c=relaxed/simple;
	bh=a68VkOVgWesyfiFUUTrjQIvapWdPj3JE26XajsCAe6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOWB9A6e2PkYp9+YbzkpiKRGrHxvTKfefxh8eDjejGSIU7jNgqymdLOibZtH8fU7BVThPakbCrFoE1nQ+7ZMmcpP3vT/k3q6ElTb9GIZdTOEd887t6oOq+9a8EPlut56Yi0cL3ZXCOQujg8gitU861Ja37PBsWSg/ceAhsKNx2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bbToMuwQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bbToMuwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7D51F00893;
	Sat, 12 Sep 2026 12:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215095;
	bh=ij8Tbm27oEkMhiYy0Nm47R1cUxKFPyuhMhxr+IhoRtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bbToMuwQWndpQGZfFfkNXhoqhuuYNo7cYRcVr/O/kEauVz96Nb9JEiG38e5zb/wZR
	 R0vZRy0IPLLj/Tf8Ug7s7hZh1R3CMx54s3AD+ZN8iJzPuvrC8AqZfeJKkzJ6/CTrDB
	 uh2g55j2C7AiJJ1mDj/gz3iDVJ11krGqr+oDALLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0460/1376] iommu/msm: Return -ENOMEM on memory allocation failure in probe
Date: Sat, 12 Sep 2026 08:48:06 +0200
Message-ID: <20260912065617.783268191@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vz@kernel.org>

[ Upstream commit b0d50c9016c4c2959dfa61bf9549cf98f9aa19cd ]

If dynamic memory allocation in driver's probe function execution fails,
it should be reported to the driver's framework with -ENOMEM error code.

Fixes: 109bd48ea2e1 ("iommu/msm: Add DT adaptation")
Signed-off-by: Vladimir Zapolskiy <vz@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/msm_iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index 989e0869d8055..036bacd162c72 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -720,7 +720,7 @@ static int msm_iommu_probe(struct platform_device *pdev)
 
 	iommu = devm_kzalloc(&pdev->dev, sizeof(*iommu), GFP_KERNEL);
 	if (!iommu)
-		return -ENODEV;
+		return -ENOMEM;
 
 	iommu->dev = &pdev->dev;
 	INIT_LIST_HEAD(&iommu->ctx_list);
-- 
2.53.0



