Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FDB2BAF7;
	Wed, 25 Feb 2026 01:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983104; cv=none; b=j33wpzTnjI0jBZ4ZhqPQg8FDZ0P026qkX/YcTUBIIKLc4CiMZkgFquAq7FhYle4LrUItfjHosk+DB0W+zCIgcI42wKV2QqgTM2FoGx50KXQy9MuVEZLDC8p7yymhTHRJR6vZyQ95KMiaeGKcd+OIV0KQdQ11r7Rku9nR0xal0DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983104; c=relaxed/simple;
	bh=KkB1Ewt5Zc/MrpWgP4Yf9HXP1Y2nV99aDX9PXL2dwpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g//EJBPwlSaEh0os3MzmxLmmTy03JTuxgaNNLpGx7MTcYv78phVPVlQuwSc/H42wG2eAEYvjq5yeqhVJxlF1sCbMwsLIeVsGPEnepwFFd41IzYtRp7LfK09o/xLMFmfvE+JvOgKtyXE4OqlO9NedvdW0kTto9QTrC3PfyuZ73Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0a5JTyXr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0a5JTyXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE54AC116D0;
	Wed, 25 Feb 2026 01:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983103;
	bh=KkB1Ewt5Zc/MrpWgP4Yf9HXP1Y2nV99aDX9PXL2dwpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0a5JTyXrvVFuoQ+G2CpjAd1CyHWfvx1/2f0XO0OrDe5Xm39psJrt5QLlSA/gYrVe+
	 8peEf/cRhVIX4ZeDbnyZ9BfcyGKBue2MPFuaPC2Kh6HcYUrUC80H1vycAwJq/7yp/3
	 T+WUpG9q6UG6dLKS1j/ODUlYzRodeXXWvvACAzUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 265/781] accel/amdxdna: Fix notifier_wq flushing warning
Date: Tue, 24 Feb 2026 17:16:14 -0800
Message-ID: <20260225012406.196100242@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit b36178488d479e9a53bbef2b01280378b5586e60 ]

Create notifier_wq with WQ_MEM_RECLAIM flag to fix the possible warning.

  workqueue: WQ_MEM_RECLAIM amdxdna_js:drm_sched_free_job_work [gpu_sched] is flushing !WQ_MEM_RECLAIM notifier_wq:0x0

Fixes: e486147c912f ("accel/amdxdna: Add BO import and export")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260113173624.256053-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_pci_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/amdxdna/amdxdna_pci_drv.c b/drivers/accel/amdxdna/amdxdna_pci_drv.c
index 1973ab67721be..fcc9be23b3de5 100644
--- a/drivers/accel/amdxdna/amdxdna_pci_drv.c
+++ b/drivers/accel/amdxdna/amdxdna_pci_drv.c
@@ -282,7 +282,7 @@ static int amdxdna_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		fs_reclaim_release(GFP_KERNEL);
 	}
 
-	xdna->notifier_wq = alloc_ordered_workqueue("notifier_wq", 0);
+	xdna->notifier_wq = alloc_ordered_workqueue("notifier_wq", WQ_MEM_RECLAIM);
 	if (!xdna->notifier_wq)
 		return -ENOMEM;
 
-- 
2.51.0



