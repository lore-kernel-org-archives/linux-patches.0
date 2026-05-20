Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A16436CE19;
	Wed, 20 May 2026 18:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300452; cv=none; b=lGURVOq0lYBQxpF6QS0xZ0z1VN+SMPNXXdjDta3+/buEpQY2jqxjYIYMzMik/pD/vi2HZdYNVeyA7YIDo74ZNxNQnkD0QVpIQO8gWqIjsZmpDZUcZuSDERfqyWKVxBeVvO6iQDkOo185Nyc8NJw42gIiLI9c8nm3xaixHtUIDmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300452; c=relaxed/simple;
	bh=24sD+amJ9pP4AmyvY2DDQO3feedxCRxeRNS3ymxMEEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qcfng8PEGsvWEdEEFl8q92crdsMuw6ICL/0PEcCvTKXVgb0yZ0IWKlNdXwPyP4jsExUle61cM2bvZGT+vOs7UZkm6qBKWGuOzn7RJIbUUhq2e/+3egSGISwSU3lFQ6YWmrdqhWK6ldUCo9Y9+x4llR+uMHmYZDotEDPEaz07KRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7gZV2E3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7gZV2E3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E056E1F000E9;
	Wed, 20 May 2026 18:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300451;
	bh=VZeeNY53+fpYeOrw3c3fMvEts3dzJTlPxr18WmGdUY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K7gZV2E3YqgRXf3gabgsxtiNR8dK6SXLhV8LCgjpfAuYCGXLNVz0g+uHgVxuF1siG
	 Mdxax7GGhTNuL88kxpPBnwRHjVByODFxCNYpZ0Yef9274JpPrrNsGco/TU3TPoJd1k
	 I3MiUDEXrNnerT4jX8jynw9PXOON7MGyWbIGDwrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 181/666] drm/amd/pm/ci: Fill DW8 fields from SMC
Date: Wed, 20 May 2026 18:16:32 +0200
Message-ID: <20260520162115.124002005@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit baf28ec5795c077406d6f52b8ad39e614153bce6 ]

In ci_populate_dw8() we currently just read a value from the SMU
and then throw it away. Instead of throwing away the value,
we should use it to fill other fields in DW8 (like radeon).

Otherwise the value of the other fiels is just cleared when
we copy this data to the SMU later.

Fixes: 9f4b35411cfe ("drm/amd/powerplay: add CI asics support to smumgr (v3)")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
index 1494143132eb5..aea3ad523cc03 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
@@ -543,12 +543,11 @@ static int ci_populate_dw8(struct pp_hwmgr *hwmgr, uint32_t fuse_table_offset)
 {
 	struct ci_smumgr *smu_data = (struct ci_smumgr *)(hwmgr->smu_backend);
 	const struct ci_pt_defaults *defaults = smu_data->power_tune_defaults;
-	uint32_t temp;
 
 	if (ci_read_smc_sram_dword(hwmgr,
 			fuse_table_offset +
 			offsetof(SMU7_Discrete_PmFuses, TdcWaterfallCtl),
-			(uint32_t *)&temp, SMC_RAM_END))
+			(uint32_t *)&smu_data->power_tune_table.TdcWaterfallCtl, SMC_RAM_END))
 		PP_ASSERT_WITH_CODE(false,
 				"Attempt to read PmFuses.DW6 (SviLoadLineEn) from SMC Failed!",
 				return -EINVAL);
-- 
2.53.0



