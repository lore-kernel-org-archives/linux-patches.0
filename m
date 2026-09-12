Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEDD47987B;
	Sat, 12 Sep 2026 12:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216294; cv=none; b=d6pEKopcq0Wp6uUPKaebTwAWtnkzkr0YcRvcEeewkF8Okwy8j/5L/v0lJCI+E7RvXgPiTZa5ZqS3H1S2f3PiNL0S//9ozy1rofQsEnNV9mphjauW2ZND5lFoCQCJcUop6sGJjfvbftfMnzm9+7820Uebro0ddK3SUeOMvubCD0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216294; c=relaxed/simple;
	bh=SV+NCQ1b583PtS+9nzTg6BBWXX4u5txO5KO3V8ywg2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kb28RYjbD0f/hywLuzScwhgyvfLxn77lMQyIrktvWZaeQIhVpMr66FtbLP5+hwi71pdb8QYrec43HPrbzkuEoZJ1ROiIu7VWRteSMOFiKyMwU74TwSIeDETICvdmxy2pVuZCdxnYvvgGlYF4WL8PbpSwadvRxvkcbXtGcwgCalM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkRy4lHL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkRy4lHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCB01F000FF;
	Sat, 12 Sep 2026 12:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216292;
	bh=K4bj7fSHqyWq1FO1eB27Wn9W2iJFKOzoLWMQnLW1m+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SkRy4lHLWXqX3oUs85iSArN7WY1LlN/EMifYwtzkF7P/R0qCVphbZXSGnsR4Y5gMi
	 WQ0/upvrL8+/mUUnwy77S94FVLrJmSpYYDSWnRr47MGInvU+WD5fTAXkDKWQJIeOLZ
	 57MznG5deDXfrFxPFYP2oR4U6PUYZzNiC5eiZb2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0708/1376] iommu/tegra241-cmdqv: Use request_threaded_irq
Date: Sat, 12 Sep 2026 08:52:14 +0200
Message-ID: <20260912065623.324917986@linuxfoundation.org>
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

From: Nicolin Chen <nicolinc@nvidia.com>

[ Upstream commit 1eb468744ccaafeaee145505d0aa5fd6227bd72f ]

A vEVENT can be reported only from a threaded IRQ context. Change to using
request_threaded_irq to support that.

Link: https://patch.msgid.link/r/f160193980e3b273afbd1d9cfc3e360084c05ba6.1752126748.git.nicolinc@nvidia.com
Acked-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 5acd67ceb38d ("iommu/tegra241-cmdqv: Don't run the error ISR before probe sets up vintfs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index a76839cf571d2..85f851ce8ff1b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -825,8 +825,9 @@ __tegra241_cmdqv_probe(struct arm_smmu_device *smmu, struct resource *res,
 	cmdqv->dev = smmu->impl_dev;
 
 	if (cmdqv->irq > 0) {
-		ret = request_irq(irq, tegra241_cmdqv_isr, 0, "tegra241-cmdqv",
-				  cmdqv);
+		ret = request_threaded_irq(irq, NULL, tegra241_cmdqv_isr,
+					   IRQF_ONESHOT, "tegra241-cmdqv",
+					   cmdqv);
 		if (ret) {
 			dev_err(cmdqv->dev, "failed to request irq (%d): %d\n",
 				cmdqv->irq, ret);
-- 
2.53.0



