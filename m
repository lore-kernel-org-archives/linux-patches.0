Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93B935973;
	Mon,  6 Jan 2025 15:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176733; cv=none; b=Ue3dC15m49WB2+BWTBN9g5RkxN9a0cPXpMqGaFjb/SxWssX4FhUP2qbUn6WiE2Y0IQXwPSo8RzktdoDDA7vXMhJ3vGOGHQ0xPu3UA+POodKWVlQ11ejQIQxU1JML+2LMjnnYWNATom6/hxZqkAIKyoKtAS+i/zv+JuXwd/UIPIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176733; c=relaxed/simple;
	bh=lkhtm8zEU9fmHlvELZI0iHCHIjwQ4zBkWp8hdAy/bo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmtWIRpsH9o9BRbI8ecmlFdCfZf2hcaEbodPzcAXK56SZH/hIrcN6PQHG6rG1G0O2lW2mnkm0uBWmOZGCjDhxYP9/pPXxCtH9Iz93mI7KEC/Tzm8T8DpZXOrlvLxXf2nFi6qoDGcJD/v+lWWIs8r+NJrh0Kj5jMgKPyTZhM4jd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCqMx9YJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCqMx9YJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E59C4CED2;
	Mon,  6 Jan 2025 15:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176733;
	bh=lkhtm8zEU9fmHlvELZI0iHCHIjwQ4zBkWp8hdAy/bo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gCqMx9YJXLWZaMyTDypk15OmP3eNpX2uTVbKo875zHfZT/Q4JCqPfzhChHwAN3of5
	 LZz0dMTcTjRSE3t13KViBgGBoGhqmiu4RjVLR67Z77TycqwKT2C7Rt/LMzJS/3+rBf
	 Z6kPoMPb0ezK0pHFjeK2V0tZ+h704prvAt8ENX8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Preethi G <preethi.gurusiddalingeswaraswamy@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 14/81] RDMA/bnxt_re: Fix reporting hw_ver in query_device
Date: Mon,  6 Jan 2025 16:15:46 +0100
Message-ID: <20250106151129.976888702@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 7179fe0074a3c962e43a9e51169304c4911989ed ]

Driver currently populates subsystem_device id in the
"hw_ver" field of ib_attr structure in query_device.

Updated to populate PCI revision ID.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Reviewed-by: Preethi G <preethi.gurusiddalingeswaraswamy@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/20241211083931.968831-6-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 01883d67a48e..94c34ba103ea 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -138,7 +138,7 @@ int bnxt_re_query_device(struct ib_device *ibdev,
 
 	ib_attr->vendor_id = rdev->en_dev->pdev->vendor;
 	ib_attr->vendor_part_id = rdev->en_dev->pdev->device;
-	ib_attr->hw_ver = rdev->en_dev->pdev->subsystem_device;
+	ib_attr->hw_ver = rdev->en_dev->pdev->revision;
 	ib_attr->max_qp = dev_attr->max_qp;
 	ib_attr->max_qp_wr = dev_attr->max_qp_wqes;
 	ib_attr->device_cap_flags =
-- 
2.39.5



