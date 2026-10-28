Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213818;
	b=VY+UQtVja0oWuP40U13wN9nnP5BsAYadIT+b1cBP6k54z6RjA2JbqvueJFTbPlXNddAB
	 NnxHG9Zoxe6XpWNFZP70WcUOIroGOt10GEX/mSme+M6L3cu825ldOOVGSwQ9I4EnwVR5E
	 qmiz7rvUhAfEb/8BM8wqKrA69/c/sE7WWUwad/Jir9mhxypOuhhBWm9dSdlAy1dMHZVm9
	 ioaUkJfUBv6r/b99ClO4OYq2keRQmlD7j2lTi29oimmApGDpZycajA75qCkBWotI2uY7q
	 O5E9AwCFujHqkenVNF7l9/PrYJ3S0x8xQDFDXNuI+OP1QG6msg4frpxUozS/Ae3Gpfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6k3PxehrfSu3v+beRbDRLql320ui3YUJ5Q4Xw8k1wnE=;
	b=FO/GcHQ+Jjc5UNkwKsU4/cbi4CCcxXhaA5wcCHjxYVDLruKIzpvLhlVBb50gL2Zyt1mq
	 ICK9C/w6VewTJEXh7M7wlQ7U6Xxx8C8GZRRDmNjeUG1B3BXf3Rn8MVIBT7K/x2X9wdiCX
	 3aMJvRZtAIwXW1snqNLEmv7rDndDd7xn8w2flMLxF4Fo1DkuzBrVDBavLO9S97CCMLpuj
	 3e5udOmHNkRlmsrt0D7XKMHkp3HAgdb3ObLdR19h1vH9fZFKbe8Fa7FD2SVfYBDlqbNsR
	 s/Wx8y+F2m30e/vhnHKAu1KiW9Bfl4XB1mNtnSMGtFVty3S5tydt38jiWCVz+gGXX1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DmyPhFA6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C91606A31D;
	Wed, 28 Oct 2026 18:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DmyPhFA6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C222A1F01825;
	Wed, 28 Oct 2026 18:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213818;
	bh=6k3PxehrfSu3v+beRbDRLql320ui3YUJ5Q4Xw8k1wnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DmyPhFA6zWt/VJuJ4Wk7DA36A/tzAutVpOVsjzgBNcIAjVlnQesp/OFV0XjM57x6S
	 W1de5XLvsrZ3xZNT3bDB7VTugdjQxbz4Q/V4aaChyEJ2K60PuSmYXAq6e7YQfJ4ieT
	 mA6Cyuy5EHvvDp1+ct5yQwN7X/F3yjTnfwIYZXhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0641/1887] soc: qcom: icc-bwmon: Fix refcount imbalance seen during bwmon_remove
Date: Wed, 28 Oct 2026 17:45:37 +0100
Message-ID: <20261028170513.998186452@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Sibi Sankar <quic_sibis@quicinc.com>

[ Upstream commit 24086640ab39396eb1a92d1cb1cd2f31b2677c52 ]

The following warning is seen during bwmon_remove due to refcount
imbalance, fix this by releasing the OPPs after use.

Logs:
WARNING: at drivers/opp/core.c:1640 _opp_table_kref_release+0x150/0x158
Hardware name: Qualcomm Technologies, Inc. X1E80100 CRD (DT)
...
Call trace:
_opp_table_kref_release+0x150/0x158
dev_pm_opp_remove_table+0x100/0x1b4
devm_pm_opp_of_table_release+0x10/0x1c
devm_action_release+0x14/0x20
devres_release_all+0xa4/0x104
device_unbind_cleanup+0x18/0x60
device_release_driver_internal+0x1ec/0x228
driver_detach+0x50/0x98
bus_remove_driver+0x6c/0xbc
driver_unregister+0x30/0x60
platform_driver_unregister+0x14/0x20
bwmon_driver_exit+0x18/0x524 [icc_bwmon]
__arm64_sys_delete_module+0x184/0x264
invoke_syscall+0x48/0x118
el0_svc_common.constprop.0+0xc8/0xe8
do_el0_svc+0x20/0x2c
el0_svc+0x34/0xdc
el0t_64_sync_handler+0x13c/0x158
el0t_64_sync+0x190/0x194
--[ end trace 0000000000000000 ]---

Fixes: 0276f69f13e2 ("soc: qcom: icc-bwmon: Set default thresholds dynamically")
Fixes: b9c2ae6cac40 ("soc: qcom: icc-bwmon: Add bandwidth monitoring driver")
Signed-off-by: Sibi Sankar <quic_sibis@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240613164506.982068-1-quic_sibis@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/icc-bwmon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soc/qcom/icc-bwmon.c b/drivers/soc/qcom/icc-bwmon.c
index 7829549993c92..2e0a45cd6921f 100644
--- a/drivers/soc/qcom/icc-bwmon.c
+++ b/drivers/soc/qcom/icc-bwmon.c
@@ -604,11 +604,13 @@ static int bwmon_probe(struct platform_device *pdev)
 	opp = dev_pm_opp_find_bw_floor(dev, &bwmon->max_bw_kbps, 0);
 	if (IS_ERR(opp))
 		return dev_err_probe(dev, PTR_ERR(opp), "failed to find max peak bandwidth\n");
+	dev_pm_opp_put(opp);
 
 	bwmon->min_bw_kbps = 0;
 	opp = dev_pm_opp_find_bw_ceil(dev, &bwmon->min_bw_kbps, 0);
 	if (IS_ERR(opp))
 		return dev_err_probe(dev, PTR_ERR(opp), "failed to find min peak bandwidth\n");
+	dev_pm_opp_put(opp);
 
 	bwmon->dev = dev;
 
-- 
2.53.0



