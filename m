Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A804973B4;
	Thu, 17 Sep 2026 18:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670584; cv=none; b=kBQ2U7R28E0PUIuluJSqbeVAWg0qLJRbgwWityoVKdd5nDmPICDgk/1Al9K013HSxarsaNbP9VRe/Mazj4C/Y28OvUHFdcjTkCie+Be0Z+o1L8hstTqCWm/a6ORWdBAlZItl0VbTPrDueAN19XtIIbPiSrnnU+DQJHiqSz8fmCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670584; c=relaxed/simple;
	bh=JoPzgX/5y43vbeiEfN4TiBtrSZwT1oKYDd6weMVnHrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Np14wFj7utSz2/mphVrjV66jphqPgasdA9aWzqmQsJA3hREXEJmfN1xqSY3gH2U9+L1fVhaSncK58k5/3NoC1gzgseIGrXfbs9IqX/+2w6drzW2GS7fi48FUH4FiNjVhuYgKfFRk2Xywdkgnm2+GSZuRkJgUh9its3RSWClTm9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HsIeC2AV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HsIeC2AV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4831F000FF;
	Thu, 17 Sep 2026 18:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670582;
	bh=iVNm+/7MqlyqKZ6iwn7/inzyD7Z3GI3nxJUZ19S/bjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HsIeC2AVj4vEs44gAmQ8RbSlNqywziC9RmQ+3I6GAeqa0gSP/R2pb0VAUK8YgYXJX
	 ry9PX5cW0OGWGCrR2p9kSIQ96R600r5lH3ZqNbe9gmqgutcfstSZif+KAMYseVWrYn
	 NJPk8fzaJixS2pkVTIpT4J2U3SV38CSq34dXd2yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0707/1102] ASoC: Intel: SST: Publish the PCI module aliases
Date: Thu, 17 Sep 2026 16:10:50 +0100
Message-ID: <20260917151558.069649432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: hpp.iscas <hppiscas@163.com>

[ Upstream commit d112159df5c6cc5ee6ab91cc32bf6ed29939df38 ]

The legacy SST PCI driver matches Intel Tangier devices using
intel_sst_ids, but its only explicit module alias is "sst". That alias
does not match PCI modalias events when this driver is built as a module.

Publish its PCI table. The independently configurable SOF driver does
not provide aliases for the legacy SST module.

Fixes: f533a035e4da ("ASoC: Intel: mrfld - create separate module for pci part")
Signed-off-by: hpp.iscas <hppiscas@163.com>
Link: https://patch.msgid.link/20260905133133.63661-1-hppiscas@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/atom/sst/sst_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/atom/sst/sst_pci.c b/sound/soc/intel/atom/sst/sst_pci.c
index 296bea33e16ff..745e2e60a1440 100644
--- a/sound/soc/intel/atom/sst/sst_pci.c
+++ b/sound/soc/intel/atom/sst/sst_pci.c
@@ -178,6 +178,7 @@ static const struct pci_device_id intel_sst_ids[] = {
 	{ PCI_DEVICE_DATA(INTEL, SST_TNG, 0) },
 	{ 0, }
 };
+MODULE_DEVICE_TABLE(pci, intel_sst_ids);
 
 static struct pci_driver sst_driver = {
 	.name = SST_DRV_NAME,
-- 
2.53.0



