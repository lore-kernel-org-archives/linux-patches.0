Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625053;
	b=kjr6d7RWByjqu8mxOYl0FGThTVngGT59qlhC2M6tbh0KARF7NVx/PrdYt4/aPDJvkpvU
	 ik/5iUnlY6J+At5JLsMK2Gl86pXFBQpDy+Z4kml88doDBi6aGfyRazEt0FxpDj+UoqVkX
	 6GAIpjMDIj3/ma28dVJFxGe2V3ys7X1yepk/wypgIcPlBMNLneveztlb2wpzbCwoTwaWN
	 7eQH3BIqYcUzhIWiImghocHr1l/7PlnhSY4pLfxOvD9AxL+aodWVM1Jbg4nSqZHeJ1Jh8
	 asY0v2o9XNekgpz0X5rAdYEUEB+LwjF93UuWuHf6/CYglTpfi8OWbYLE1Z/4VvJJgDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b3qQakLLB0KTfmi4NhdqWxjjmRGcuWLuSBwoUeMnfOg=;
	b=RnoFjlOAlW1nCcn5oMQydkgZ/1DUrzOvPLryPcx5tFuaCCaThQLT4VQAmvOiMlkwFk/+
	 dvHFbF67x3TOAg3KQ3Rlko+Gv81ALO3N+YqXFrwDc3QbV49XMVlpDXLSu6NRVhfAWDWMB
	 LjDbJnmWEDpPCJWzvAVTj1IMlY37Dd/DjQLYi77hY7rg4Gcfr7rU7KctKed9CKt131W/Y
	 Ysta1mttaNzLaK+wd62ys/+yCYDufY4FTOXZ7g5QrZDHYrEDSSuZ9HSIro/kOSMJEESCy
	 lMldgWW6W7/dx/iuEbJVQA1FqRj1qaQr+FwR9YzL2RCkeCDkVR3RQ7tg8SQW6YBc35Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJ4KDLEb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3B8606A321;
	Wed, 25 Nov 2026 16:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJ4KDLEb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468121F000C0;
	Wed, 25 Nov 2026 16:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625052;
	bh=b3qQakLLB0KTfmi4NhdqWxjjmRGcuWLuSBwoUeMnfOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJ4KDLEbcRoKO9p1NNpumJJJd+6zowGgEfJ18nZh8HYCt82Q1cYetY41Mpkf4GfRi
	 PEiOH7Mf8zWWb7jWl5hoBKHxDvu0evZsyHfXpSsvYR78Q3O9jSNPi3tOye4FGYZE2T
	 BZo67pn6ILRRoO+HcAYZe/YSuje3f+521azESCcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 391/816] wifi: ath11k: fix NULL dereference in ahb remove when QMI init incomplete
Date: Wed, 25 Nov 2026 15:32:19 +0100
Message-ID: <20261125143858.252930741@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>

[ Upstream commit 1a7bcf5324c8e2de6512eca5b028b6b283181d3f ]

On WCN6750, if QMI messages never arrive (for example when qrtr_smd
is not ready), WLAN initialization stops before the device is fully
registered. In this case ATH11K_FLAG_QMI_FAIL is not set because no
QMI event handler is executed.

When the driver is removed, ath11k_ahb_remove() still calls
ath11k_core_deinit(), which eventually triggers
ath11k_ce_cleanup_pipes() on uninitialized CE pipes and results in a
NULL pointer dereference in ath11k_hal_srng_access_begin():

  ath11k_hal_srng_access_begin+0x14/0x68 [ath11k]
  ath11k_ce_cleanup_pipes+0x184/0x190 [ath11k]
  ath11k_pcic_stop+0x24/0x38 [ath11k]
  ath11k_core_deinit+0xfc/0x1c0 [ath11k]
  ath11k_ahb_remove+0x38/0xa0 [ath11k_ahb]

Fix this by invoking ath11k_ahb_remove_prepare() before the state
check and skipping ath11k_core_deinit() if ATH11K_FLAG_REGISTERED
is not set, core initialization did not complete and CE pipes may
remain uninitialized, making ath11k_core_deinit() unsafe.

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.2.0.c2-00204-QCAMSLSWPLZ-1

Fixes: 00402f49d26f ("ath11k: Add support for WCN6750 device")
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260806101331.484063-3-miaoqing.pan@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
[ sashal: Changed the ath11k_ahb_power_down(ab, false) call to ath11k_ahb_power_down(ab), since the function takes no second argument here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index b9bf1c5a934cd..e701eadcf1dda 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1310,14 +1310,15 @@ static void ath11k_ahb_remove(struct platform_device *pdev)
 {
 	struct ath11k_base *ab = platform_get_drvdata(pdev);
 
-	if (test_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags)) {
+	ath11k_ahb_remove_prepare(ab);
+
+	if (!test_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags)) {
 		ath11k_ahb_power_down(ab);
 		ath11k_debugfs_soc_destroy(ab);
 		ath11k_qmi_deinit_service(ab);
 		goto qmi_fail;
 	}
 
-	ath11k_ahb_remove_prepare(ab);
 	ath11k_core_deinit(ab);
 
 qmi_fail:
-- 
2.53.0



