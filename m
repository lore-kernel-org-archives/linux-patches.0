Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017463;
	b=E+VmYCGPTOHoXshNQAMrdClQTvu7SaAWn309vf3vZtCUBRFBkZ+VhVGJonmadUVrRzoD
	 /pwbGWyorl2HM+gzIWcDMBIB9JR8C5yrJeAQzncP2lZE9LcmyCM++R0IygCbCC6616QUI
	 +EG19TKbY8qtTzwxA4/Ya7WGDK+OLF8ZJ8Tq/26DIKZpj5GWSgOypqx379BoEEZjQxihJ
	 TafD/PvGG7bulvin04/Pxp92ivO+ufSJV8Tpkjc02XDTQRmcx1+fp9b2em6NCFDB8bLGy
	 BbfYrhAIBKfXZGdiXKKtBR0jzp67YYThBv1Xp5EFvUyG4z5s66u9m9Whnb5T1Bn5EwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e41ul05gDe0zDu9doEDdlqiBBXAxerlG/cLLkiYIeaU=;
	b=dPRFxmLZ14KfGzsd+a3INCEDBwG+9iK9C+8hqQUqchDoBCuCD0tEZjswy7KH9f125EuW
	 KBjC1SDd16e3Kj/3tgwhzTZKFDMkNltZ6WbZPJfCTYNScn9R8A7hqm1N76VerqV2jzVsz
	 YiBZmEzfNnMMrUDiVurHyME2q0iGSSAZvhtwhZ8eBLKxr4+Gzi/Kdsk9zENPEF+uREBzR
	 4y2fyBsXm2wGK+7Ka9HvG63qM8I9IytDVnpdEHCEFzzSms/XBiZuajRUxUcFVoI/Jk8Vs
	 xfKUJ/dadbySGHtLXvLexFDmzrUEDLAbWvu+7Pd76CnKH4g1jLyQr0q6ooUlL00qeww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Af32LL97;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52833606A320;
	Wed, 18 Nov 2026 15:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Af32LL97
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39581F000C7;
	Wed, 18 Nov 2026 15:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017463;
	bh=e41ul05gDe0zDu9doEDdlqiBBXAxerlG/cLLkiYIeaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Af32LL975GpALlLigmGR2CTfUuTH5LwAnm20MaGlo8u3mNb7m7DR0p0P3qsBGCJtv
	 0poMgbjsQf8ZcgPirNbyMP0sIflFNMk8ajNXEtDcUIRGyI1tc/nN5epTkEgY6H6N+8
	 G5mjhgo6T9dR2AO71kmjnj2vFCRixlX2vgSck60w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Chun-Hung Wu <chun-hung.wu@mediatek.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0893/2651] scsi: ufs: core: Always notify POST_CHANGE even on gear switch failure
Date: Wed, 18 Nov 2026 15:35:33 +0100
Message-ID: <20261118150320.015616640@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 6efee14ca0aed33103ea17f4367da173f893442f ]

Previously, POST_CHANGE was only notified on a successful gear switch.
This could leave the host in an inconsistent state if resources were
acquired in PRE_CHANGE (e.g. disabling auto-hibern8) but never released due
to a missing POST_CHANGE.

Fix this by always calling POST_CHANGE regardless of the gear switch
result. On failure, pass dev_req_params = NULL to signal that there is
nothing to apply; hosts that receive NULL simply skip their post work.

Update the affected drivers (ufs-exynos and ufshcd-pci) to guard their
POST_CHANGE logic with a NULL check so they correctly handle the failure
case.

Fixes: f5ca8d0c7a63 ("scsi: ufs: host: mediatek: Disable auto-hibern8 during power mode changes")
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Chun-Hung Wu <chun-hung.wu@mediatek.com>
Link: https://patch.msgid.link/20260914085148.136429-2-peter.wang@mediatek.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c     | 8 ++++++--
 drivers/ufs/host/ufs-exynos.c | 4 +++-
 drivers/ufs/host/ufshcd-pci.c | 3 ++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 490feaeee10b2..9927feec17f51 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4984,8 +4984,12 @@ int ufshcd_change_power_mode(struct ufs_hba *hba,
 
 	ret = ufshcd_dme_change_power_mode(hba, pwr_mode, pmc_policy);
 
-	if (!ret)
-		ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, pwr_mode);
+	/*
+	 * Always notify POST_CHANGE to pair with PRE_CHANGE, even on failure.
+	 * On failure, pass dev_req_params = NULL to indicate nothing to apply.
+	 * POST_CHANGE return value is advisory and does not mask @ret.
+	 */
+	ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, ret ? NULL : pwr_mode);
 
 	return ret;
 }
diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index b2f65c4655251..3bcbc9ebbb283 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1782,7 +1782,9 @@ static int exynos_ufs_pwr_change_notify(struct ufs_hba *hba,
 		ret = exynos_ufs_pre_pwr_mode(hba, dev_req_params);
 		break;
 	case POST_CHANGE:
-		ret = exynos_ufs_post_pwr_mode(hba, dev_req_params);
+		/* NULL when the gear switch failed: nothing to apply */
+		if (dev_req_params)
+			ret = exynos_ufs_post_pwr_mode(hba, dev_req_params);
 		break;
 	}
 
diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 21bb11c724bea..668b57403e626 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -166,7 +166,8 @@ static int ufs_intel_lkf_pwr_change_notify(struct ufs_hba *hba,
 			ufs_intel_set_lanes(hba, 2);
 		break;
 	case POST_CHANGE:
-		if (ufshcd_is_hs_mode(dev_req_params)) {
+		/* NULL when the gear switch failed: nothing to apply */
+		if (dev_req_params && ufshcd_is_hs_mode(dev_req_params)) {
 			u32 peer_granularity;
 
 			usleep_range(1000, 1250);
-- 
2.53.0



