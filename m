Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039F41487F4;
	Tue, 23 Jan 2024 00:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969172; cv=none; b=bXV2UCE9taKP5cNaQs8iYY9JpN6xYecTG5/D/A/0VKX3W9rRBBEQVJEnH4+VOLDJPLkN4zjQVijNkTdsJvL+GqyG17zKMejGz6sBy1vIEviPKAmmZ8ksqk8NpVZqLVwN+7rRobXJWbnHnHuISx7nBtwIKaRsvNaTqMFidKrdmXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969172; c=relaxed/simple;
	bh=0YVmrVTFx4YmZpu23nwpA8SDS0uXI25YUnh/ZBnEUhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obNxo/ZKm1/0XaFa8XZr7HEhy8lRtRRNQM/0huAIoydgpy5CyWBKF8dybdxl4tNHZ8SQ+DkXq29RdZ7fDZ/hxN6RP8WKaNhpHmzO9MpJUBnVhi9ooF8Gwb2PJae85TFKyVRD3CpeH7ZhilshBdIUpcDLnQ80R+JCK1w1rg3DGaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9CJXlUM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9CJXlUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD7BC433F1;
	Tue, 23 Jan 2024 00:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969171;
	bh=0YVmrVTFx4YmZpu23nwpA8SDS0uXI25YUnh/ZBnEUhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9CJXlUMAjljNpPqGhJ7udF9nQeF5jOW2Z5RBkOkMV1iJTEneG/cQVyepQFyE24+B
	 lXwkFuYuU5J5RB9Z0r3LFi65z9iSju17qWfThv911gYFoaYgOeww5n+Cg3aw8m2QL8
	 7oIEj347Id/13kx8vF/rKE8VNpE/jw9lSR/CI/vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	David Guckian <david.guckian@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 054/641] crypto: qat - add NULL pointer check
Date: Mon, 22 Jan 2024 15:49:18 -0800
Message-ID: <20240122235819.759461192@linuxfoundation.org>
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

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit a643212c9f28d09225c3792c316bc4aaf6be4a68 ]

There is a possibility that the function adf_devmgr_pci_to_accel_dev()
might return a NULL pointer.
Add a NULL pointer check in the function rp2srv_show().

Fixes: dbc8876dd873 ("crypto: qat - add rp2svc sysfs attribute")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: David Guckian <david.guckian@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
index 6f0b3629da13..d450dad32c9e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
@@ -215,6 +215,9 @@ static ssize_t rp2srv_show(struct device *dev, struct device_attribute *attr,
 	enum adf_cfg_service_type svc;
 
 	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
 	hw_data = GET_HW_DATA(accel_dev);
 
 	if (accel_dev->sysfs.ring_num == UNSET_RING_NUM)
-- 
2.43.0



