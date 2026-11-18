Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043245;
	b=PFLzOypz6e2YR+C4OfE2DvH/vpKeqrIyvpDqt9JsiGp0cKIvnRSPhP5wZa/SZKrJDllU
	 f1Tmb7ONOB1CcuF4C+usnBS382/EP/Psokr70zeFYzhYhyyVL6XnwULus98t4cT+0mRhx
	 DYWepw1H7APy2gT5z0Ruj3++OI+lqqT+A3Tr6ixOPCYsrsFSet5ZsTBk1JKuDmh07+yNY
	 clr+N31AcmzC8yi7yhxGxqBK1lkhL77zbDaWpZOpofJkLoH13wUldsc9DuUMCjKq01IMR
	 fgQlY8ltAnIi6XqB8vyt66uRCGbv+a5ot9KRlAx+X1pAQDxjn6zfOb9YKtp7JLuVSGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043245;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=znIwbys33MaqAjGyEv6CZ9qrEQ2ryuw1pIAsiWQNHaA=;
	b=NdSd03eKkrDe4dZUZaxorfUZmhWgTIhmU8lef6QuA66aVBnDrq78/+1slOxGi+vwsO0Q
	 lTKbm8t0SL4svCviEuT1vZ3WI9qS+FIeAk9y2Z+2DMK9V3fH2m8AZ3ZOrIHnaq7/7faav
	 E2eXYPqLfWtAGEHECGshuNmwussdqubGMk0VQQHWf9/b15pNTWuSnlOKemFd7oEdqq2O2
	 klkEjKJzJMS0pq+6YeHgxHI1q4M7iZZ5kWYvo331MjUYgjQgy+MBnJSKcGgDAWPxsoT0q
	 /8MO1LaiuF3D8jDAZI1Td/16TMp4keIC9K5MYgXr3td2nrUpgzQzEy3yNpiH4iQFYkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=arlJXc+M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FF9606A320;
	Wed, 18 Nov 2026 23:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=arlJXc+M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54AD1F000C4;
	Wed, 18 Nov 2026 23:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043245;
	bh=znIwbys33MaqAjGyEv6CZ9qrEQ2ryuw1pIAsiWQNHaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=arlJXc+MOnVDrkIRrzbJf5Ed+C3YrVxZrYK29mOjAi4k53jZDLbb2TCc/+15ywKJE
	 T3MIVLJRS8qiWoZnHPnUflloaZR5UajB5eDujrIzvwA0RvPuT4nJmOmQpD4Ibye/ly
	 CcFJ/CE2RWC2yQ9DbGJmRbVeHcl6XHqtCJl1IEZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0141/2857] iommu/qcom: Check pm_runtime_resume_and_get() return in probe
Date: Wed, 18 Nov 2026 15:19:35 +0100
Message-ID: <20261118150206.430395093@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit e910315ae08a23bc953daed10b1c518abac1df49 ]

The SMMU_INTR_SEL_NS register write in qcom_iommu_device_probe() uses
pm_runtime_get_sync() without checking the return value. If runtime
resume fails the subsequent writel_relaxed() would access hardware with
clocks potentially disabled.

Switch to pm_runtime_resume_and_get() which handles the usage-count
cleanup on failure, check the return value, and unwind the already
registered iommu device on error.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/qcom_iommu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index 96910ad0c9a7f..8fd68d7e9b361 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -851,13 +851,17 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 	}
 
 	if (qcom_iommu->local_base) {
-		pm_runtime_get_sync(dev);
+		ret = pm_runtime_resume_and_get(dev);
+		if (ret)
+			goto err_iommu_unregister;
 		writel_relaxed(0xffffffff, qcom_iommu->local_base + SMMU_INTR_SEL_NS);
 		pm_runtime_put_sync(dev);
 	}
 
 	return 0;
 
+err_iommu_unregister:
+	iommu_device_unregister(&qcom_iommu->iommu);
 err_sysfs_remove:
 	iommu_device_sysfs_remove(&qcom_iommu->iommu);
 err_pm_disable:
-- 
2.53.0



