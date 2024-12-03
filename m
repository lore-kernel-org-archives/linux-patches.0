Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9611F76DD;
	Tue,  3 Dec 2024 15:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240583; cv=none; b=SqkP6B9rp4QVvuuM9D8KESpKB1jNHm23ajoGqpGJCSTSyecxM4X02YjMJZZAMQxIJqZwUvx/Z1i166xwwbnprlvmbiKfeYrI1vikU83fgnqT/S97Vc3gVAZ+mxUQE11UnZxXDN57wAQ6OSneMZCmJU3xucw+Xx+vrblfhsJb/ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240583; c=relaxed/simple;
	bh=7IPqBk2bwOHmly9nY8+JOJ2jD4bMGPi9rZSCkcEvxeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZC/PpeYu6IGFz3BfzOHITdzs4SwdHkuW3S2CHOSul9ZspD/xxRaAtp8qjQHWbUdkrQbnvGIZd42QDXd9ufLTSh8XMJYHLX3sRj6AgkrbJcaUX+WxQodOZu7spMgymZvg3jXQ1QwwvB7Ozv/8PDsObC/1OoZRvtUlcz2JYxA5yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOg+XS8U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOg+XS8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB565C4CECF;
	Tue,  3 Dec 2024 15:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240583;
	bh=7IPqBk2bwOHmly9nY8+JOJ2jD4bMGPi9rZSCkcEvxeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XOg+XS8UMWfTOFATFgG9vNxQ8VJRaQbj4/xizoDRIwz1VPixmpa6uPqULR/rUSACE
	 016tynYNn53/zJoMHzlnXIyhUTihOZZ7DFipbFQWaalL5+gv38llZdQs/9HPD2MoEM
	 RP6Jj330mAVnFevYA0CfuvP1mmwZoqQJWFeYAZpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 170/826] media: ipu6: remove architecture DMA ops dependency in Kconfig
Date: Tue,  3 Dec 2024 15:38:17 +0100
Message-ID: <20241203144750.364244185@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bingbu Cao <bingbu.cao@intel.com>

[ Upstream commit c8e9120c2065868d97e9e94bceee777e5db08c3e ]

IPU6 driver doesn't override the dma_ops of device now, it doesn't
depends on the ARCH_HAS_DMA_OPS, so remove the dependency in Kconfig.

Fixes: de6c85bf918e ("dma-mapping: clearly mark DMA ops as an architecture feature")
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu6/Kconfig | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/pci/intel/ipu6/Kconfig b/drivers/media/pci/intel/ipu6/Kconfig
index 49e4fb696573f..a4537818a58c0 100644
--- a/drivers/media/pci/intel/ipu6/Kconfig
+++ b/drivers/media/pci/intel/ipu6/Kconfig
@@ -4,12 +4,6 @@ config VIDEO_INTEL_IPU6
 	depends on VIDEO_DEV
 	depends on X86 && X86_64 && HAS_DMA
 	depends on IPU_BRIDGE || !IPU_BRIDGE
-	#
-	# This driver incorrectly tries to override the dma_ops.  It should
-	# never have done that, but for now keep it working on architectures
-	# that use dma ops
-	#
-	depends on ARCH_HAS_DMA_OPS
 	select AUXILIARY_BUS
 	select IOMMU_IOVA
 	select VIDEO_V4L2_SUBDEV_API
-- 
2.43.0



