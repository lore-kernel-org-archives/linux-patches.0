Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D06A369999;
	Wed, 20 May 2026 17:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297984; cv=none; b=QYrTZNHZoZJFwxxpYgxvg+pNsTBYX9Nmuke+tesNgY0NR4N6v5zgym0GfNS72p5w/Mj8+kQHaaFiO+kU7VSGeci2sm5DziZNBH7/A4Dw+cuLTi3A7nPSMH2Ob/iooKVT5yUR2PgIrHgUiIPcsO2nww+8mYT6EqXQvxwy/VFCY4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297984; c=relaxed/simple;
	bh=3bKkWcQVK2h/EtFal/9xMb6NKMdCyguO8Hx1/hONyWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmN31OUD/pKge+CiDYxs9R7YG4APMCTGJf1Ql9dBNw9Qz1SEs13Dzm08rRMzVLeY4UC64XcFn84hXSwZoDPgwQYDQ15DZFc/cQKTDZRA2nw5OQn2It1vjV9oF8urpCZZ7h4dTX4l4YVgywMKwqcuK3nHyaZgoCRDT64UvA4x1G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUuz/A8e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUuz/A8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A392E1F000E9;
	Wed, 20 May 2026 17:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297983;
	bh=heHOKXe6lpGil16lavXXBW+Y16i0DtFmuSFj+LIzpMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NUuz/A8eKGBmDK9QOv7Xsa4b2NoXMSR9yDoWnIyN4HljW5z9YQE2h4ktkkNPWj6Cn
	 HqgmSaoIGEgzP2Z/y7uw5GvN6Kh/0E3nnilrDbZAt1FY+V6rQV+N651tAjd8buQSeu
	 uFaknT1jZXGpcpQkFDgiexLgg4kQ0WVDQyV5/caQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Dadu <alexandru.dadu@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 238/957] drm/imagination: Switch reset_reason fields from enum to u32
Date: Wed, 20 May 2026 18:12:01 +0200
Message-ID: <20260520162139.703362731@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Alexandru Dadu <alexandru.dadu@imgtec.com>

[ Upstream commit d2f83a6cd598bf413f1acf34153bd1d71023fbab ]

Update the reset_reason fwif structure fields from enum to u32 to remove
any ambiguity from the interface (enum is not a fixed size thus is unfit
for the purpose of the data type).

Fixes: a26f067feac1f ("drm/imagination: Add FWIF headers")
Signed-off-by: Alexandru Dadu <alexandru.dadu@imgtec.com>
Reviewed-by: Matt Coster <matt.coster@imgtec.com>
Link: https://patch.msgid.link/20260323-b4-firmware-context-reset-notification-handling-v3-2-1a66049a9a65@imgtec.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imagination/pvr_rogue_fwif.h        | 8 ++++++--
 drivers/gpu/drm/imagination/pvr_rogue_fwif_shared.h | 6 +++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/imagination/pvr_rogue_fwif.h b/drivers/gpu/drm/imagination/pvr_rogue_fwif.h
index 172886be4c820..5d590c4c25663 100644
--- a/drivers/gpu/drm/imagination/pvr_rogue_fwif.h
+++ b/drivers/gpu/drm/imagination/pvr_rogue_fwif.h
@@ -1347,8 +1347,12 @@ struct rogue_fwif_fwccb_cmd_freelists_reconstruction_data {
 struct rogue_fwif_fwccb_cmd_context_reset_data {
 	/* Context affected by the reset */
 	u32 server_common_context_id;
-	/* Reason for reset */
-	enum rogue_context_reset_reason reset_reason;
+	/*
+	 * Reason for reset
+	 * The valid values for reset_reason are the ones from
+	 * enum rogue_context_reset_reason
+	 */
+	u32 reset_reason;
 	/* Data Master affected by the reset */
 	u32 dm;
 	/* Job ref running at the time of reset */
diff --git a/drivers/gpu/drm/imagination/pvr_rogue_fwif_shared.h b/drivers/gpu/drm/imagination/pvr_rogue_fwif_shared.h
index 6c09c15bf9bd8..f95acd5a1f8e8 100644
--- a/drivers/gpu/drm/imagination/pvr_rogue_fwif_shared.h
+++ b/drivers/gpu/drm/imagination/pvr_rogue_fwif_shared.h
@@ -249,7 +249,11 @@ enum rogue_context_reset_reason {
 };
 
 struct rogue_context_reset_reason_data {
-	enum rogue_context_reset_reason reset_reason;
+	/*
+	 * The valid values for reset_reason are the ones from
+	 * enum rogue_context_reset_reason
+	 */
+	u32 reset_reason;
 	u32 reset_ext_job_ref;
 };
 
-- 
2.53.0



