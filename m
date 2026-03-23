Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738BA282F18;
	Mon, 23 Mar 2026 15:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278426; cv=none; b=lT0JJCCRwsPBI/bBdq/E5O/MPHGByHilW61B5fv+0mOD1bFEPv8ze+U6niyAgrvA4eZZaWxkAbXGZkDJ/n2JL6hrvotvIZ8d/+Ys7VkSHvtER7gAjOWvnqQjHhk9OWRcn5RHmdgYY9jaU1TwprfxpcBeGiTs45rVit8BOQJBw04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278426; c=relaxed/simple;
	bh=ndawFQ+Hv+AzD2KN5ABgGpdTBohVQi9bGcQFL3R8QMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWpUtUyDMfIoCNbr1odxGEJ0/+qam2CMZGNd2hV88YUwyX1XHfjAKtjyDymI8z4t7lfgf6+CcfnMZ2/jnA8ni5ty2L9pGgenEP8jKyhn7/foL1S9ds/4SwPQpcnofVdCifXnecOWNISEIKNtTVpjfADVNqyzznCeDSUUbSEe8qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TduWt5tR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TduWt5tR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EADC2BCB3;
	Mon, 23 Mar 2026 15:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278426;
	bh=ndawFQ+Hv+AzD2KN5ABgGpdTBohVQi9bGcQFL3R8QMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TduWt5tRc5WFs+F0MtN7m7ixpRdWxLzlfRBOS93A/ITOZa+CDFQJUVmwQZTjsIBO5
	 vApPGBvDQr6TFqJ/eafxzPIr4aEnEi9LiGLR7CiBE/xeENP6S7BzrFAxZ5ugvM+PyF
	 +5J34z7dQefWfjWtpaPbCucya4kBiAFumWNex+II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	Yihang Li <liyihang9@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 304/567] scsi: hisi_sas: Add time interval between two H2D FIS following soft reset spec
Date: Mon, 23 Mar 2026 14:43:44 +0100
Message-ID: <20260323134541.340993232@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit 3c62791322e42d1afd65acfdb5b3a371bde21ede ]

Spec says at least 5us between two H2D FIS when do soft reset, but be
generous and sleep for about 1ms.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Link: https://lore.kernel.org/r/20241008021822.2617339-11-liyihang9@huawei.com
Reviewed-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 8ddc0c269165 ("scsi: hisi_sas: Fix NULL pointer exception during user_scan()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 3ad58250bf6b2..17189703454a2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1340,6 +1340,7 @@ static int hisi_sas_softreset_ata_disk(struct domain_device *device)
 	}
 
 	if (rc == TMF_RESP_FUNC_COMPLETE) {
+		usleep_range(900, 1000);
 		ata_for_each_link(link, ap, EDGE) {
 			int pmp = sata_srst_pmp(link);
 
-- 
2.51.0



