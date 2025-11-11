Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C574086A;
	Tue, 11 Nov 2025 00:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822474; cv=none; b=b842gpRAInIGRhnbLFL5FmzaPFUSH0BSRHgvIwgnAyzvl5k8ImqamZLVEKEezniKPjIU6aCcAlTT3WXfJqalXv2X6OsP2JghfZL4DnsiHYLJnkinWNIw8UO0h1Ogw3pn8CYiyXH8J/Pwt+q/+SO/au2MppStcwyqEmrpVvF1GrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822474; c=relaxed/simple;
	bh=oZ1R5OwaTr/yeRoM8AJhWGv6xoj2y9YBuNeo2QKr2mM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZhtUII0qAy95O8hXXtC4M09ZSzVyZ2zqgUo7we2LwZSmJUtIdGL9ETgzKLLDPE180JGVbzgnHcN9yNgQZdFLpVJwiMBzipm0srA39WHf5thYshNtzsh/IqlaPbT0/yom1RLoRkXEX7xnNERGeNUQ0Ju7a8tr4xEo4zV5PJGk0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccu8optK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccu8optK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584D2C2BC87;
	Tue, 11 Nov 2025 00:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822474;
	bh=oZ1R5OwaTr/yeRoM8AJhWGv6xoj2y9YBuNeo2QKr2mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ccu8optKY5Ot/sRxgAdhxetBmsGbqQjxpoEpDBYgPt2ARZ53k2I8oGFSh14c1Eksk
	 EU3bw01PVvEBKtFSosEOFVDhNRzoHL+HA56cLKMGMF3fuWlvKfvS+0JAKBda/oWXcS
	 x4/ERUDyBkBeRG7BN79sM1//VOmEkgNeRHpJ+dpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Smith <itistotalbotnet@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/565] drm/amd/pm/powerplay/smumgr: Fix PCIeBootLinkLevel value on Fiji
Date: Tue, 11 Nov 2025 09:38:33 +0900
Message-ID: <20251111004528.204963076@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: John Smith <itistotalbotnet@gmail.com>

[ Upstream commit 07a13f913c291d6ec72ee4fc848d13ecfdc0e705 ]

Previously this was initialized with zero which represented PCIe Gen
1.0 instead of using the
maximum value from the speed table which is the behaviour of all other
smumgr implementations.

Fixes: 18edef19ea44 ("drm/amd/powerplay: implement fw image related smu interface for Fiji.")
Signed-off-by: John Smith <itistotalbotnet@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c52238c9fb414555c68340cd80e487d982c1921c)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/smumgr/fiji_smumgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/smumgr/fiji_smumgr.c b/drivers/gpu/drm/amd/pm/powerplay/smumgr/fiji_smumgr.c
index 5e43ad2b29564..e7e497b166b3e 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/fiji_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/fiji_smumgr.c
@@ -2024,7 +2024,7 @@ static int fiji_init_smc_table(struct pp_hwmgr *hwmgr)
 	table->VoltageResponseTime = 0;
 	table->PhaseResponseTime = 0;
 	table->MemoryThermThrottleEnable = 1;
-	table->PCIeBootLinkLevel = 0;      /* 0:Gen1 1:Gen2 2:Gen3*/
+	table->PCIeBootLinkLevel = (uint8_t) (data->dpm_table.pcie_speed_table.count);
 	table->PCIeGenInterval = 1;
 	table->VRConfig = 0;
 
-- 
2.51.0



