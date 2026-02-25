Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E046926FA60;
	Wed, 25 Feb 2026 01:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983937; cv=none; b=j1Fu4Zfx0bRu2LkULOrhfNCW0pHpNfxGAwQrm9TnDnvIaVRzm9FvamDHddk9E3dCE39CHxNA8ofZef6YaWNq5SmtvNevPHINId81OaBSLH3xz8ePmEZ2+D/QVgFAChuU3yYI//iuUrui/f/25UC+EXjJ/YlSkEEmgofjxWl++S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983937; c=relaxed/simple;
	bh=MQLaZ0ljgV/kfyXOnoa+bApOEo9pgutdgtBNLd9MPzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dc8Ij5gtj2y4nxdNCKmK6f6/FU/kb/etb35P5OHLULTYgV83DAlftWvcS6IIOg+Dt1s5ITvMm+nUSR/VbazNFhkdBcupkUrOlNEnbJCWvrCv2hvZ3IT8RyNs0hKPw1XGwWQBwLH8obvkVlQ0YIdX8NsNa+W/zzOVQPl4dEzHsEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GGPf4zAW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GGPf4zAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CBBC116D0;
	Wed, 25 Feb 2026 01:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983936;
	bh=MQLaZ0ljgV/kfyXOnoa+bApOEo9pgutdgtBNLd9MPzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GGPf4zAWnpnV14bFxettucSUJwsJNqvSgsT/OcDvl3582q+zwV1dchChmX3y2G0ja
	 wPN8yzcbCPLgvnDbmcEyEIGdiv1i0qxcHz+gjlohYOFie5ARVU5vtlz0itEqawzwIa
	 Bvvib0IB8dlc98FOqfxbEY3361wod+LH+Iaw9erQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 201/641] accel/amdxdna: Fix notifier_wq flushing warning
Date: Tue, 24 Feb 2026 17:18:47 -0800
Message-ID: <20260225012353.843547443@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 569cd703729d3..ccf2d1de558c0 100644
--- a/drivers/accel/amdxdna/amdxdna_pci_drv.c
+++ b/drivers/accel/amdxdna/amdxdna_pci_drv.c
@@ -292,7 +292,7 @@ static int amdxdna_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		fs_reclaim_release(GFP_KERNEL);
 	}
 
-	xdna->notifier_wq = alloc_ordered_workqueue("notifier_wq", 0);
+	xdna->notifier_wq = alloc_ordered_workqueue("notifier_wq", WQ_MEM_RECLAIM);
 	if (!xdna->notifier_wq)
 		return -ENOMEM;
 
-- 
2.51.0



